@echo off
echo.
echo ===============================================
echo      Vulcan GPT - llama-cpp-python Installer
echo ===============================================
echo.

:: Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in PATH.
    echo Please install Python 3.8 or higher from https://www.python.org/downloads/
    echo and make sure to check "Add Python to PATH" during installation.
    echo.
    pause
    exit /b 1
)

:: Set the path to the virtual environment
set VENV_PATH=C:\Users\user\Documents\Project\P15\venv

:: Check if virtual environment exists
if not exist "%VENV_PATH%" (
    echo [WARNING] Virtual environment not found at %VENV_PATH%. Creating a new one...
    python -m venv "%VENV_PATH%"
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to create virtual environment.
        echo Please make sure you have venv module installed.
        echo.
        pause
        exit /b 1
    )
)

echo Using virtual environment at: %VENV_PATH%

:: Activate virtual environment
echo Activating virtual environment...
call "%VENV_PATH%\Scripts\activate.bat"

:: Determine Python and Pip paths
if exist "%VENV_PATH%\Scripts\python.exe" (
    echo Using Python directly from virtual environment
    set PYTHON_CMD=%VENV_PATH%\Scripts\python.exe
    set PIP_CMD=%VENV_PATH%\Scripts\pip.exe
) else (
    echo Using Python from activated environment
    set PYTHON_CMD=python
    set PIP_CMD=pip
)

echo Using Python: %PYTHON_CMD%
echo Using Pip: %PIP_CMD%

:: Install required build tools
echo Checking for required build tools...
%PIP_CMD% install setuptools wheel

:: Install llama-cpp-python with verbose output
echo.
echo ===============================================
echo Installing llama-cpp-python (this may take several minutes)...
echo ===============================================
echo.
echo This installation requires Microsoft Visual C++ Build Tools.
echo If installation fails, please install Visual C++ Build Tools from:
echo https://visualstudio.microsoft.com/visual-cpp-build-tools/
echo.
echo Select "Desktop development with C++" during installation.
echo.
echo Press any key to continue with installation...
pause > nul

:: Try different installation methods
echo Attempting installation method 1: Standard install with verbose output...
%PIP_CMD% install --force-reinstall --no-cache-dir llama-cpp-python --verbose

if %errorlevel% neq 0 (
    echo.
    echo First installation method failed. Trying method 2: CPU-only build...
    echo.
    
    :: Set environment variable for CPU-only build
    set CMAKE_ARGS=-DLLAMA_CUBLAS=OFF
    %PIP_CMD% install --force-reinstall --no-cache-dir llama-cpp-python --verbose
    
    if %errorlevel% neq 0 (
        echo.
        echo Second installation method failed. Trying method 3: Using pip with specific version...
        echo.
        
        %PIP_CMD% install --force-reinstall --no-cache-dir llama-cpp-python==0.2.11 --verbose
        
        if %errorlevel% neq 0 (
            echo.
            echo [ERROR] All installation methods failed.
            echo.
            echo Possible solutions:
            echo 1. Install Visual C++ Build Tools from:
            echo    https://visualstudio.microsoft.com/visual-cpp-build-tools/
            echo 2. Try installing a pre-built wheel:
            echo    %PIP_CMD% install https://github.com/abetlen/llama-cpp-python/releases/download/v0.2.11/llama_cpp_python-0.2.11-cp310-cp310-win_amd64.whl
            echo    (Replace cp310 with your Python version, e.g., cp39 for Python 3.9)
            echo.
            pause
            exit /b 1
        )
    )
)

:: Verify installation
echo.
echo Verifying installation...
%PYTHON_CMD% -c "import llama_cpp; print(f'llama-cpp-python installed successfully! Version: {llama_cpp.__version__}')"

if %errorlevel% neq 0 (
    echo [ERROR] Verification failed. llama-cpp-python may not be installed correctly.
    echo.
    pause
    exit /b 1
)

echo.
echo ===============================================
echo Installation complete!
echo.
echo You can now use local models in Vulcan GPT.
echo ===============================================
echo.

pause
