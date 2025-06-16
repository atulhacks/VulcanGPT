#!/bin/bash

echo
echo "==============================================="
echo "     Vulcan GPT - llama-cpp-python Installer"
echo "==============================================="
echo


if ! command -v python3 &> /dev/null; then
    echo "[ERROR] Python 3 is not installed or not in PATH."
    echo "Please install Python 3.8 or higher."
    echo
    exit 1
fi


VENV_PATH="C:/Users/user/Documents/Project/P15/venv"

VENV_PATH_UNIX=$(echo "$VENV_PATH" | sed 's/\\/\//g' | sed 's/C:/\/c/g')


if [ ! -d "$VENV_PATH_UNIX" ]; then
    echo "[WARNING] Virtual environment not found at $VENV_PATH_UNIX. Creating a new one..."
    

    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        python -m venv "$VENV_PATH_UNIX"
        if [ $? -ne 0 ]; then
            echo "[ERROR] Failed to create virtual environment."
            echo "Please make sure you have venv module installed."
            echo "You can install it with: pip install virtualenv"
            echo
            exit 1
        fi

        ACTIVATE_PATH="$VENV_PATH_UNIX/Scripts/activate"
    else

        python3 -m venv "$VENV_PATH_UNIX"
        if [ $? -ne 0 ]; then
            echo "[ERROR] Failed to create virtual environment."
            echo "Please make sure you have venv module installed."
            echo "You can install it with: pip3 install virtualenv"
            echo
            exit 1
        fi
        ACTIVATE_PATH="$VENV_PATH_UNIX/bin/activate"
    fi
else

    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        ACTIVATE_PATH="$VENV_PATH_UNIX/Scripts/activate"
    else
        ACTIVATE_PATH="$VENV_PATH_UNIX/bin/activate"
    fi
fi

echo "Using virtual environment at: $VENV_PATH_UNIX"


echo "Activating virtual environment..."
if [ -f "$ACTIVATE_PATH" ]; then
    source "$ACTIVATE_PATH"

    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then

        if [ -f "$VENV_PATH_UNIX/Scripts/python.exe" ]; then
            PYTHON_CMD="$VENV_PATH_UNIX/Scripts/python.exe"
            PIP_CMD="$VENV_PATH_UNIX/Scripts/pip.exe"
        else
            PYTHON_CMD="python"
            PIP_CMD="pip"
        fi
    else

        if [ -f "$VENV_PATH_UNIX/bin/python3" ]; then
            PYTHON_CMD="$VENV_PATH_UNIX/bin/python3"
            PIP_CMD="$VENV_PATH_UNIX/bin/pip3"
        elif [ -f "$VENV_PATH_UNIX/bin/python" ]; then
            PYTHON_CMD="$VENV_PATH_UNIX/bin/python"
            PIP_CMD="$VENV_PATH_UNIX/bin/pip"
        else
            PYTHON_CMD="python3"
            PIP_CMD="pip3"
        fi
    fi
    
    echo "Using Python: $PYTHON_CMD"
    echo "Using Pip: $PIP_CMD"
else
    echo "[WARNING] Could not activate virtual environment. Continuing with system Python."
    

    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
        PIP_CMD="pip3"
    else
        PYTHON_CMD="python"
        PIP_CMD="pip"
    fi
fi


echo "Checking for required build tools..."
$PIP_CMD install setuptools wheel


if [[ "$OSTYPE" == "darwin"* ]]; then

    echo
    echo "==============================================="
    echo "Installing llama-cpp-python on macOS"
    echo "==============================================="
    echo
    echo "This installation requires Xcode Command Line Tools."
    echo "If installation fails, please install them with:"
    echo "xcode-select --install"
    echo
    

    if command -v brew &> /dev/null; then
        echo "Homebrew detected. You might want to install dependencies with:"
        echo "brew install cmake"
    fi
    
    read -p "Press Enter to continue with installation..."
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then

    echo
    echo "==============================================="
    echo "Installing llama-cpp-python on Linux"
    echo "==============================================="
    echo
    echo "This installation requires build tools."
    echo "If installation fails, please install them with:"
    echo "sudo apt-get install build-essential cmake"
    echo "or"
    echo "sudo yum install gcc gcc-c++ cmake"
    echo
    
    read -p "Press Enter to continue with installation..."
    
else

    echo
    echo "==============================================="
    echo "Installing llama-cpp-python"
    echo "==============================================="
    echo
    
    read -p "Press Enter to continue with installation..."
fi


echo "Attempting installation method 1: Standard install with verbose output..."
$PIP_CMD install --force-reinstall --no-cache-dir llama-cpp-python --verbose

if [ $? -ne 0 ]; then
    echo
    echo "First installation method failed. Trying method 2: CPU-only build..."
    echo
    

    export CMAKE_ARGS="-DLLAMA_CUBLAS=OFF"
    $PIP_CMD install --force-reinstall --no-cache-dir llama-cpp-python --verbose
    
    if [ $? -ne 0 ]; then
        echo
        echo "Second installation method failed. Trying method 3: Using pip with specific version..."
        echo
        
        $PIP_CMD install --force-reinstall --no-cache-dir llama-cpp-python==0.2.11 --verbose
        
        if [ $? -ne 0 ]; then
            echo
            echo "[ERROR] All installation methods failed."
            echo
            
            if [[ "$OSTYPE" == "darwin"* ]]; then

                echo "Possible solutions for macOS:"
                echo "1. Install Xcode Command Line Tools: xcode-select --install"
                echo "2. Install dependencies with Homebrew: brew install cmake"
                echo "3. Try with specific compiler flags:"
                echo "   CFLAGS=\"-stdlib=libc++\" pip install llama-cpp-python --verbose"
            elif [[ "$OSTYPE" == "linux-gnu"* ]]; then

                echo "Possible solutions for Linux:"
                echo "1. Install build dependencies:"
                echo "   For Debian/Ubuntu: sudo apt-get install build-essential cmake"
                echo "   For CentOS/RHEL: sudo yum install gcc gcc-c++ cmake"
                echo "2. Try with specific compiler flags:"
                echo "   CFLAGS=\"-march=native\" pip install llama-cpp-python --verbose"
            else

                echo "Possible solutions:"
                echo "1. Install required build tools for your system"
                echo "2. Try installing from source:"
                echo "   git clone https://github.com/abetlen/llama-cpp-python"
                echo "   cd llama-cpp-python"
                echo "   pip install -e ."
            fi
            
            echo
            exit 1
        fi
    fi
fi


echo
echo "Verifying installation..."
$PYTHON_CMD -c "import llama_cpp; print(f'llama-cpp-python installed successfully! Version: {llama_cpp.__version__}')"

if [ $? -ne 0 ]; then
    echo "[ERROR] Verification failed. llama-cpp-python may not be installed correctly."
    echo
    exit 1
fi

echo
echo "==============================================="
echo "Installation complete!"
echo
echo "You can now use local models in Vulcan GPT."
echo "==============================================="
echo
