#!/bin/bash

echo
echo "==============================================="
echo "           Vulcan GPT Launcher"
echo "==============================================="
echo

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
VULCAN_DIR="$SCRIPT_DIR/Vulcan-GPT"
VENV_PATH="$SCRIPT_DIR/venv"

echo "Checking and creating required directories..."
mkdir -p "$SCRIPT_DIR/Vulcan-GPT"
mkdir -p "$SCRIPT_DIR/Vulcan-GPT/img"
mkdir -p "$SCRIPT_DIR/Vulcan-GPT/prompts"
mkdir -p "$SCRIPT_DIR/Vulcan-GPT/models"

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    VENV_PATH_UNIX=$(echo "$VENV_PATH" | sed 's/\\/\//g')
    VULCAN_DIR_UNIX=$(echo "$VULCAN_DIR" | sed 's/\\/\//g')
else
    VENV_PATH_UNIX="$VENV_PATH"
    VULCAN_DIR_UNIX="$VULCAN_DIR"
fi

echo "Vulcan GPT directory: $VULCAN_DIR_UNIX"
echo "Virtual environment: $VENV_PATH_UNIX"

if [ ! -d "$VENV_PATH_UNIX" ]; then
    echo "Virtual environment not found at $VENV_PATH_UNIX. Running installer first..."
    
    if [ -f "$VULCAN_DIR_UNIX/install.sh" ]; then
        cd "$VULCAN_DIR_UNIX" && bash ./install.sh
        if [ $? -ne 0 ]; then
            echo "Installation failed. Please check the error messages above."
            exit 1
        fi
    else
        echo "Error: Installer script not found at $VULCAN_DIR_UNIX/install.sh"
        exit 1
    fi
fi

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    ACTIVATE_PATH="$VENV_PATH_UNIX/Scripts/activate"
else
    ACTIVATE_PATH="$VENV_PATH_UNIX/bin/activate"
fi

if [ ! -d "$VULCAN_DIR_UNIX/models" ]; then
    echo "Creating models directory for local models..."
    mkdir -p "$VULCAN_DIR_UNIX/models"
fi

if [ ! -f "$VULCAN_DIR_UNIX/.vulcan" ]; then
    echo "Creating .vulcan configuration file..."
    touch "$VULCAN_DIR_UNIX/.vulcan"
fi

if [ ! -f "$VULCAN_DIR_UNIX/.vulcan_key" ] || [ ! -f "$VULCAN_DIR_UNIX/.vulcan_salt" ]; then
    echo "Note: Security files will be created on first run."
fi

echo "Activating virtual environment and starting Vulcan GPT..."
if [ -f "$ACTIVATE_PATH" ]; then
    source "$ACTIVATE_PATH"

    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        if [[ -n "$VIRTUAL_ENV" ]]; then
            echo "Virtual environment is active: $VIRTUAL_ENV"
        else
            echo "Warning: Virtual environment might not be properly activated."
            echo "Continuing anyway, but this may cause issues."
        fi
        
        PYTHON_CMD="$VENV_PATH_UNIX/Scripts/python.exe"
    else
        if command -v python3 &> /dev/null; then
            PYTHON_PATH=$(which python3)
            if [[ "$PYTHON_PATH" == *"venv"* ]]; then
                echo "Using Python from virtual environment: $PYTHON_PATH"
                PYTHON_CMD="$PYTHON_PATH"
            else
                echo "Using direct path to Python in virtual environment"
                PYTHON_CMD="$VENV_PATH_UNIX/bin/python3"
            fi
        else
            echo "Using direct path to Python in virtual environment"
            PYTHON_CMD="$VENV_PATH_UNIX/bin/python"
        fi
    fi
    
    cd "$VULCAN_DIR_UNIX"
    
    echo "Running with: $PYTHON_CMD"
    "$PYTHON_CMD" VulcanGPT.py
    
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "Vulcan GPT exited with code $EXIT_CODE"
        echo "If you're experiencing issues, try reinstalling with: ./install.sh"
    fi
else
    echo "Error: Could not find activation script at $ACTIVATE_PATH"
    echo "Try running the installer again with: ./install.sh"
    exit 1
fi
