# Vulcan GPT - Local Models Guide

This guide explains how to set up and use local LLM models with Vulcan GPT.

## Prerequisites

To use local models, you need:

1. Python 3.8 or higher
2. At least 2GB of RAM (more for larger models)
3. The `llama-cpp-python` package installed

## Installing llama-cpp-python

The `llama-cpp-python` package requires compilation and may be challenging to install on some systems. We've provided specialized installation scripts to help with this process.

### Windows

1. Run the `install_llama_cpp.bat` script:
   ```
   install_llama_cpp.bat
   ```

2. Follow the on-screen instructions. The script will:
   - Check if Python is installed
   - Create or use an existing virtual environment
   - Install required build tools
   - Try multiple methods to install llama-cpp-python
   - Verify the installation

3. If the installation fails, you may need to install Visual C++ Build Tools:
   - Download from: https://visualstudio.microsoft.com/visual-cpp-build-tools/
   - During installation, select "Desktop development with C++"

### Linux/macOS

1. Run the `install_llama_cpp.sh` script:
   ```
   chmod +x install_llama_cpp.sh
   ./install_llama_cpp.sh
   ```

2. Follow the on-screen instructions. The script will:
   - Check if Python is installed
   - Create or use an existing virtual environment
   - Install required build tools
   - Try multiple methods to install llama-cpp-python
   - Verify the installation

3. If the installation fails:
   - On macOS: Install Xcode Command Line Tools with `xcode-select --install`
   - On Linux: Install build dependencies with `sudo apt-get install build-essential cmake` (Ubuntu/Debian) or `sudo yum install gcc gcc-c++ cmake` (CentOS/RHEL)

## Using Local Models

Once `llama-cpp-python` is installed, you can use local models in Vulcan GPT:

1. Start Vulcan GPT:
   ```
   python VulcanGPT.py
   ```

2. From the main menu, select `[L]` for Local Models

3. You'll see the Local Models Management menu with these options:
   - `[D]` Download model from URL
   - `[H]` Download model from HuggingFace
   - `[I]` Install Default Model (recommended for beginners)
   - `[L]` Load model
   - `[U]` Unload model
   - `[T]` Test model
   - `[C]` Chat with local model

### Installing a Default Model (Recommended)

For beginners, we recommend using the "Install Default Model" option:

1. Select `[I]` from the Local Models menu
2. Choose one of the pre-selected models:
   - TinyLlama-1.1B-Chat (600MB) - Works on any device, even with limited resources
   - Phi-2 (1.7GB) - Good balance of size and quality
   - Llama-2-7B-Chat (4GB) - Better quality for systems with more RAM

### Downloading Models from HuggingFace

To download a specific model from HuggingFace:

1. Select `[H]` from the Local Models menu
2. Enter the repository ID (e.g., `TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF`)
3. Enter the filename (e.g., `tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf`)

### Loading and Using a Model

1. Select `[L]` from the Local Models menu
2. Enter the model number to load
3. Optionally specify context size and number of threads
4. Once loaded, you can:
   - Test the model with `[T]`
   - Chat with the model using `[C]`

## Troubleshooting

If you encounter issues loading models:

1. **Memory Issues**: Try a smaller model like TinyLlama-1.1B
2. **Loading Failures**: Try loading with smaller context size and fewer threads
3. **Installation Problems**: Reinstall llama-cpp-python using the provided scripts
4. **Model Format**: Ensure you're using GGUF format models (recommended)

## Recommended Models

For the best experience, we recommend these models:

- **Low-end devices (2-4GB RAM)**:
  - TinyLlama-1.1B-Chat (600MB)
  - Phi-2 (1.7GB)

- **Mid-range devices (8GB RAM)**:
  - Llama-2-7B-Chat (4GB)
  - Mistral-7B-Instruct (4GB)

- **High-end devices (16GB+ RAM)**:
  - Llama-2-13B-Chat (8GB)
  - Mixtral-8x7B-Instruct (12GB)

All these models are available in GGUF format from TheBloke on HuggingFace.
