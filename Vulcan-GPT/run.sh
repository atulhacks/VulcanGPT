#!/bin/bash

echo
echo "==============================================="
echo "           Vulcan GPT Launcher"
echo "==============================================="
echo

# Set the path to the virtual environment
VENV_PATH="C:/Users/user/Documents/Project/P15/venv"
# Convert Windows path to Unix-style for bash
VENV_PATH_UNIX=$(echo "$VENV_PATH" | sed 's/\\/\//g' | sed 's/C:/\/c/g')

# Check if virtual environment exists
if [ ! -d "$VENV_PATH_UNIX" ]; then
    echo "Virtual environment not found at $VENV_PATH_UNIX. Running installer first..."
    bash ./install.sh
    if [ $? -ne 0 ]; then
        echo "Installation failed. Please check the error messages above."
        exit 1
    fi
fi

# Determine the activation path based on OS
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    ACTIVATE_PATH="$VENV_PATH_UNIX/Scripts/activate"
else
    ACTIVATE_PATH="$VENV_PATH_UNIX/bin/activate"
fi

# Ensure models directory exists
if [ ! -d "models" ]; then
    echo "Creating models directory for local models..."
    mkdir -p models
fi

echo "Using virtual environment at: $VENV_PATH_UNIX"

# Activate virtual environment and run the application
echo "Activating virtual environment and starting Vulcan GPT..."
if [ -f "$ACTIVATE_PATH" ]; then
    source "$ACTIVATE_PATH"
    
    # Verify Python is activated from venv - different approach for Windows/Git Bash
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # For Git Bash on Windows, we can't rely on 'which python'
        # Instead, check if VIRTUAL_ENV is set
        if [[ -n "$VIRTUAL_ENV" ]]; then
            echo "Virtual environment is active: $VIRTUAL_ENV"
        else
            echo "Warning: Virtual environment might not be properly activated."
            echo "Continuing anyway, but this may cause issues."
        fi
        
        # Use Python from venv directly
        PYTHON_CMD="$VENV_PATH_UNIX/Scripts/python.exe"
    else
        # For Linux/Mac, we can use which python or direct path
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
    
    # Run the application with the specific Python interpreter
    echo "Running with: $PYTHON_CMD"
    "$PYTHON_CMD" VulcanGPT.py
    
    # Capture exit code
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
