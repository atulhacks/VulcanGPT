# -*- coding: utf-8 -*-
import os
import sys
import time
import json
import shutil
import threading
import requests
from pathlib import Path
from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from rich.progress import (
    Progress,
    BarColumn,
    TextColumn,
    DownloadColumn,
    TransferSpeedColumn,
    TimeRemainingColumn,
)


class LocalModelManager:
    """Manages local LLM models for offline use."""

    def __init__(self, ui):
        self.ui = ui
        self.models_dir = "models"
        self.available_models = {}
        self.current_model = None
        self.model_instance = None

        if not os.path.exists(self.models_dir):
            os.makedirs(self.models_dir)

        self._scan_models()

    def _scan_models(self):
        """Scan the models directory for available models."""
        self.available_models = {}

        if not os.path.exists(self.models_dir):
            return

        model_extensions = [".bin", ".gguf", ".ggml"]

        for file in os.listdir(self.models_dir):
            file_path = os.path.join(self.models_dir, file)
            if os.path.isfile(file_path) and any(
                file.endswith(ext) for ext in model_extensions
            ):
                model_name = os.path.splitext(file)[0]
                model_size = os.path.getsize(file_path)

                metadata_path = os.path.join(self.models_dir, f"{model_name}.json")
                metadata = {}

                if os.path.exists(metadata_path):
                    try:
                        with open(metadata_path, "r") as f:
                            metadata = json.load(f)
                    except:
                        pass

                self.available_models[model_name] = {
                    "path": file_path,
                    "size": model_size,
                    "format": os.path.splitext(file)[1][1:],
                    "metadata": metadata,
                }

    def get_available_models(self):
        """Return a list of available models."""
        self._scan_models()
        return self.available_models

    def get_model_info(self, model_name):
        """Return information about a model."""
        return self.available_models.get(model_name)

    def download_model(self, model_url, model_name=None):
        """Download a model from a URL."""
        if not model_name:

            model_name = os.path.basename(model_url).split("?")[0]
            model_name = os.path.splitext(model_name)[0]

        target_path = os.path.join(
            self.models_dir, os.path.basename(model_url).split("?")[0]
        )

        if os.path.exists(target_path):
            self.ui.display_message(
                "Model Download",
                f"Model file already exists at {target_path}. Overwrite?",
                "yellow",
            )
            if self.ui.get_input("Overwrite? (y/n)").lower() not in ["y", "yes"]:
                return False

        try:
            with Progress(
                TextColumn("[bold blue]{task.description}"),
                BarColumn(),
                DownloadColumn(),
                TransferSpeedColumn(),
                TimeRemainingColumn(),
                console=self.ui.console,
            ) as progress:
                task = progress.add_task(f"Downloading {model_name}", total=None)

                response = requests.get(model_url, stream=True, timeout=30)
                response.raise_for_status()

                total_size = int(response.headers.get("content-length", 0))
                if total_size:
                    progress.update(task, total=total_size)

                with open(target_path, "wb") as f:
                    for chunk in response.iter_content(chunk_size=8192):
                        if chunk:
                            f.write(chunk)
                            progress.update(task, advance=len(chunk))

            metadata = {
                "name": model_name,
                "url": model_url,
                "downloaded_at": time.strftime("%Y-%m-%d %H:%M:%S"),
                "size": os.path.getsize(target_path),
            }

            metadata_path = os.path.join(self.models_dir, f"{model_name}.json")
            with open(metadata_path, "w") as f:
                json.dump(metadata, f, indent=2)

            self.ui.display_message(
                "Model Download",
                f"Model downloaded successfully to {target_path}",
                "green",
            )

            self._scan_models()
            return True

        except Exception as e:
            self.ui.display_message(
                "Download Error", f"Failed to download model: {str(e)}", "red"
            )

            if os.path.exists(target_path):
                os.remove(target_path)

            return False

    def download_from_huggingface(self, repo_id, filename):
        """Download a model from HuggingFace."""
        if not repo_id or not filename:
            self.ui.display_message(
                "HuggingFace Download",
                "Repository ID and filename cannot be empty.",
                "red",
            )
            return False

        try:

            try:
                from huggingface_hub import hf_hub_download
            except ImportError:
                self.ui.display_message(
                    "HuggingFace Download",
                    "The huggingface_hub package is required for this feature. Please install it with 'pip install huggingface_hub'.",
                    "red",
                )
                return False

            self.ui.console.print(
                f"[magenta]Downloading {filename} from {repo_id}...[/magenta]"
            )

            try:

                downloaded_path = hf_hub_download(
                    repo_id=repo_id, filename=filename, cache_dir=self.models_dir
                )
            except Exception as e:

                error_msg = str(e)
                if "404" in error_msg:
                    self.ui.display_message(
                        "HuggingFace Download Error",
                        f"Model not found: {repo_id}/{filename}. Please check the repository ID and filename.",
                        "red",
                    )
                elif "401" in error_msg or "403" in error_msg:
                    self.ui.display_message(
                        "HuggingFace Download Error",
                        "Authentication error. You may need to set a HuggingFace token for private models.",
                        "red",
                    )
                else:
                    self.ui.display_message(
                        "HuggingFace Download Error",
                        f"Failed to download: {error_msg}",
                        "red",
                    )
                return False

            target_path = os.path.join(self.models_dir, os.path.basename(filename))
            shutil.copy(downloaded_path, target_path)

            model_name = os.path.splitext(os.path.basename(filename))[0]
            metadata = {
                "name": model_name,
                "repo_id": repo_id,
                "filename": filename,
                "downloaded_at": time.strftime("%Y-%m-%d %H:%M:%S"),
                "size": os.path.getsize(target_path),
            }

            metadata_path = os.path.join(self.models_dir, f"{model_name}.json")
            with open(metadata_path, "w") as f:
                json.dump(metadata, f, indent=2)

            self.ui.display_message(
                "HuggingFace Download",
                f"Model downloaded successfully to {target_path}",
                "green",
            )

            self._scan_models()
            return True

        except Exception as e:
            self.ui.display_message(
                "Download Error",
                f"Failed to download model from HuggingFace: {str(e)}",
                "red",
            )
            return False

    def load_model(self, model_name, context_size=2048, threads=4):
        """Load a model for inference."""
        if model_name not in self.available_models:
            self.ui.display_message(
                "Model Loading", f"Model '{model_name}' not found.", "red"
            )
            return False

        model_info = self.available_models[model_name]
        model_path = model_info["path"]

        if not os.path.exists(model_path):
            self.ui.display_message(
                "Model Loading Error",
                f"Model file not found at {model_path}. Please check if the file exists.",
                "red",
            )
            return False

        file_size_mb = os.path.getsize(model_path) / (1024 * 1024)
        if file_size_mb < 1:
            self.ui.display_message(
                "Model Loading Warning",
                f"Model file is very small ({file_size_mb:.2f} MB). This may not be a valid model file.",
                "yellow",
            )

        try:

            try:
                from llama_cpp import Llama
            except ImportError:
                self.ui.display_message(
                    "Model Loading",
                    "The llama-cpp-python package is required for local models. Please install it with 'pip install llama-cpp-python'.",
                    "red",
                )

                if sys.platform == "win32":
                    self.ui.display_message(
                        "Installation Help",
                        "On Windows, you may need to install Visual C++ Build Tools first.\n"
                        "Visit: https://visualstudio.microsoft.com/visual-cpp-build-tools/\n\n"
                        "Then install with: pip install llama-cpp-python --verbose",
                        "yellow",
                    )
                elif sys.platform == "darwin":
                    self.ui.display_message(
                        "Installation Help",
                        "On macOS, you may need to install command-line tools first:\n"
                        "Run: xcode-select --install\n\n"
                        "Then install with: pip install llama-cpp-python --verbose",
                        "yellow",
                    )
                elif sys.platform.startswith("linux"):
                    self.ui.display_message(
                        "Installation Help",
                        "On Linux, you may need to install build tools first:\n"
                        "Run: sudo apt-get install build-essential\n\n"
                        "Then install with: pip install llama-cpp-python --verbose",
                        "yellow",
                    )

                return False

            self.ui.console.print(
                f"[magenta]Loading model {model_name} ({file_size_mb:.2f} MB)...[/magenta]"
            )

            try:
                import psutil

                available_memory_mb = psutil.virtual_memory().available / (1024 * 1024)
                if available_memory_mb < file_size_mb * 1.5:
                    self.ui.display_message(
                        "Memory Warning",
                        f"Available memory ({available_memory_mb:.2f} MB) may be insufficient for this model ({file_size_mb:.2f} MB).\n"
                        "Loading may fail or system may become unresponsive.",
                        "yellow",
                    )
            except ImportError:

                pass

            with Progress(
                TextColumn("[bold blue]{task.description}"),
                BarColumn(),
                console=self.ui.console,
            ) as progress:
                task = progress.add_task("Loading model", total=100)

                def load_model_thread():
                    try:

                        self.ui.console.print(
                            "[cyan]Attempting to load model with specified parameters...[/cyan]"
                        )
                        self.model_instance = Llama(
                            model_path=model_path, n_ctx=context_size, n_threads=threads
                        )
                    except Exception as e:
                        self.ui.console.print(
                            f"[yellow]First attempt failed: {str(e)}[/yellow]"
                        )
                        self.ui.console.print(
                            "[cyan]Trying with reduced context size...[/cyan]"
                        )

                        try:

                            self.model_instance = Llama(
                                model_path=model_path, n_ctx=1024, n_threads=threads
                            )
                        except Exception as e2:
                            self.ui.console.print(
                                f"[yellow]Second attempt failed: {str(e2)}[/yellow]"
                            )
                            self.ui.console.print(
                                "[cyan]Trying with minimum parameters...[/cyan]"
                            )

                            try:

                                self.model_instance = Llama(
                                    model_path=model_path, n_ctx=512, n_threads=1
                                )
                            except Exception as e3:
                                self.ui.display_message(
                                    "Model Loading Error",
                                    f"All loading attempts failed:\n"
                                    f"1. {str(e)}\n"
                                    f"2. {str(e2)}\n"
                                    f"3. {str(e3)}\n\n"
                                    f"Please check if the model file is valid and compatible with llama-cpp-python.",
                                    "red",
                                )
                                self.model_instance = None

                thread = threading.Thread(target=load_model_thread)
                thread.start()

                while thread.is_alive():
                    progress.update(task, advance=1)
                    if progress.tasks[0].completed >= 99:
                        progress.update(task, completed=99)
                    time.sleep(0.1)

                progress.update(task, completed=100)

            if self.model_instance:
                self.current_model = model_name
                self.ui.display_message(
                    "Model Loading",
                    f"Model '{model_name}' loaded successfully.",
                    "green",
                )
                return True
            else:

                self.ui.display_message(
                    "Troubleshooting Tips",
                    "1. Try a smaller model (like TinyLlama-1.1B)\n"
                    "2. Make sure you have enough RAM (at least 1.5x model size)\n"
                    "3. Check if the model format is compatible (GGUF is recommended)\n"
                    "4. Try reinstalling llama-cpp-python with: pip install --force-reinstall llama-cpp-python",
                    "yellow",
                )
                return False

        except Exception as e:
            self.ui.display_message(
                "Model Loading Error",
                f"Failed to load model: {str(e)}\n\n"
                "This could be due to:\n"
                "1. Insufficient memory\n"
                "2. Incompatible model format\n"
                "3. Issues with llama-cpp-python installation",
                "red",
            )
            return False

    def unload_model(self):
        """Unload the current model."""
        if not self.current_model or not self.model_instance:
            return True

        try:
            self.model_instance = None
            self.current_model = None

            import gc

            gc.collect()

            self.ui.display_message(
                "Model Unloaded", "Model unloaded successfully.", "green"
            )
            return True

        except Exception as e:
            self.ui.display_message(
                "Model Unload Error", f"Failed to unload model: {str(e)}", "red"
            )
            return False

    def generate(self, prompt, max_tokens=256, temperature=0.7, top_p=0.9):
        """Generate text from the current model."""
        if not self.current_model or not self.model_instance:
            self.ui.display_message(
                "Generation Error", "No model is currently loaded.", "red"
            )
            return None

        try:

            output = self.model_instance(
                prompt, max_tokens=max_tokens, temperature=temperature, top_p=top_p
            )

            return output["choices"][0]["text"]

        except Exception as e:
            self.ui.display_message(
                "Generation Error", f"Failed to generate text: {str(e)}", "red"
            )
            return None

    def generate_stream(self, prompt, max_tokens=256, temperature=0.7, top_p=0.9):
        """Generate text from the current model with streaming."""
        if not self.current_model or not self.model_instance:
            self.ui.display_message(
                "Generation Error", "No model is currently loaded.", "red"
            )
            return None

        try:

            for chunk in self.model_instance(
                prompt,
                max_tokens=max_tokens,
                temperature=temperature,
                top_p=top_p,
                stream=True,
            ):
                yield chunk["choices"][0]["text"]

        except Exception as e:
            self.ui.display_message(
                "Generation Error", f"Failed to generate text: {str(e)}", "red"
            )
            yield f"Error: {str(e)}"


class LlamaCppModel:
    """Wrapper for llama.cpp models."""

    def __init__(self, model_path, context_size=2048, threads=4):
        self.model_path = model_path
        self.context_size = context_size
        self.threads = threads
        self.model = None

    def load(self):
        """Load the model."""
        try:
            from llama_cpp import Llama

            self.model = Llama(
                model_path=self.model_path,
                n_ctx=self.context_size,
                n_threads=self.threads,
            )
            return True
        except Exception as e:
            print(f"Error loading model: {str(e)}")
            return False

    def generate(self, prompt, max_tokens=256, temperature=0.7, top_p=0.9):
        """Generate text from the model."""
        if not self.model:
            if not self.load():
                return None

        try:
            output = self.model(
                prompt, max_tokens=max_tokens, temperature=temperature, top_p=top_p
            )

            return output["choices"][0]["text"]
        except Exception as e:
            print(f"Error generating text: {str(e)}")
            return None

    def generate_stream(self, prompt, max_tokens=256, temperature=0.7, top_p=0.9):
        """Generate text from the model with streaming."""
        if not self.model:
            if not self.load():
                yield "Error: Model not loaded"
                return

        try:
            for chunk in self.model(
                prompt,
                max_tokens=max_tokens,
                temperature=temperature,
                top_p=top_p,
                stream=True,
            ):
                yield chunk["choices"][0]["text"]
        except Exception as e:
            yield f"Error: {str(e)}"

    def unload(self):
        """Unload the model."""
        self.model = None

        import gc

        gc.collect()

        return True
