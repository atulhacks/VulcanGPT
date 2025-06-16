#!/bin/bash

echo
echo "==============================================="
echo "           Vulcan GPT Installer"
echo "==============================================="
echo


if ! command -v python3 &> /dev/null; then
    echo "[ERROR] Python 3 is not installed or not in PATH."
    echo "Please install Python 3.8 or higher."
    echo
    exit 1
fi


echo "Creating virtual environment..."

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    python -m venv venv
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to create virtual environment."
        echo "Please make sure you have venv module installed."
        echo "You can install it with: pip install virtualenv"
        echo
        exit 1
    fi

    ACTIVATE_PATH="venv/Scripts/activate"
else

    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to create virtual environment."
        echo "Please make sure you have venv module installed."
        echo "You can install it with: pip3 install virtualenv"
        echo
        exit 1
    fi
    ACTIVATE_PATH="venv/bin/activate"
fi


echo "Activating virtual environment..."
if [ -f "$ACTIVATE_PATH" ]; then
    source "$ACTIVATE_PATH"
else
    echo "[WARNING] Could not activate virtual environment. Continuing with system Python."
fi


echo "Installing dependencies..."
if [ -f "requirements.txt" ]; then
    echo "Installing from requirements.txt..."
    

    echo "Installing basic dependencies..."
    pip install openai colorama pwinput python-dotenv rich requests cryptography
    

    echo "Installing llama-cpp-python (this may take a while)..."
    pip install llama-cpp-python --verbose
    if [ $? -ne 0 ]; then
        echo "[WARNING] Failed to install llama-cpp-python. Local models will not be available."
        echo "You can try installing it manually later with: pip install llama-cpp-python"
    fi
    

    echo "Installing huggingface-hub..."
    pip install huggingface-hub
    

    echo "Installing all dependencies from requirements.txt..."
    pip install -r requirements.txt
    

    echo "Verifying installation..."
    python -c "
import pkg_resources
import sys
required = {'openai', 'colorama', 'pwinput', 'python-dotenv', 'rich', 'requests', 'cryptography', 'huggingface_hub'}
missing = required - {pkg.key for pkg in pkg_resources.working_set}
if missing:
    print(f'[WARNING] Some required packages are missing: {missing}')
    sys.exit(1)
else:
    print('All core dependencies are installed successfully!')
"
else
    echo "requirements.txt not found, installing basic dependencies..."
    pip install openai colorama pwinput python-dotenv rich requests cryptography
fi

echo "Creating models directory..."
mkdir -p models


echo "Creating prompts directory..."
mkdir -p prompts

echo
echo "==============================================="
echo "Installation complete!"
echo
echo "To start Vulcan GPT, run:"
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    echo "  source venv/Scripts/activate"
else
    echo "  source venv/bin/activate"
fi
echo "  python VulcanGPT.py"
echo
echo "On first run, you will be prompted to enter your API key."
echo "==============================================="
echo
