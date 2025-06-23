@echo off
echo.
echo ===============================================
echo           Vulcan GPT Launcher
echo ===============================================
echo.

set SCRIPT_DIR=%~dp0
set VULCAN_DIR=%SCRIPT_DIR%Vulcan-GPT
set VENV_PATH=%SCRIPT_DIR%venv

echo Checking and creating required directories...
if not exist "%SCRIPT_DIR%Vulcan-GPT" mkdir "%SCRIPT_DIR%Vulcan-GPT"
if not exist "%SCRIPT_DIR%Vulcan-GPT\img" mkdir "%SCRIPT_DIR%Vulcan-GPT\img"
if not exist "%SCRIPT_DIR%Vulcan-GPT\prompts" mkdir "%SCRIPT_DIR%Vulcan-GPT\prompts"
if not exist "%SCRIPT_DIR%Vulcan-GPT\models" mkdir "%SCRIPT_DIR%Vulcan-GPT\models"

echo Vulcan GPT directory: %VULCAN_DIR%
echo Virtual environment: %VENV_PATH%

if not exist "%VENV_PATH%" (
    echo Virtual environment not found at %VENV_PATH%. Creating it now...
    
    :: Create virtual environment
    python -m venv "%VENV_PATH%"
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment.
        echo Please make sure you have venv module installed.
        echo You can install it with: pip install virtualenv
        echo.
        pause
        exit /b 1
    )
    
    :: Activate virtual environment
    call "%VENV_PATH%\Scripts\activate.bat"
    
    :: Install dependencies
    echo Installing dependencies...
    if exist "%VULCAN_DIR%\requirements.txt" (
        echo Installing from requirements.txt...
        
        echo Installing basic dependencies...
        pip install openai colorama pwinput python-dotenv rich requests cryptography setuptools
        
        echo Installing huggingface-hub...
        pip install huggingface-hub
        
        echo Installing all dependencies from requirements.txt...
        pip install -r "%VULCAN_DIR%\requirements.txt"
        
        :: Install llama-cpp-python
        echo Installing llama-cpp-python (this may take a while)...
        pip install llama-cpp-python --verbose
        if errorlevel 1 (
            echo [WARNING] Failed to install llama-cpp-python. Local models will not be available.
            echo You can try installing it manually later with: pip install llama-cpp-python
            
            :: Try alternative installation method
            echo Attempting alternative installation method: CPU-only build...
            set CMAKE_ARGS=-DLLAMA_CUBLAS=OFF
            pip install --force-reinstall --no-cache-dir llama-cpp-python --verbose
            
            if errorlevel 1 (
                echo [WARNING] Alternative installation method also failed.
                echo Local models will not be available until llama-cpp-python is installed.
            )
        )
        
        echo Verifying installation...
        python -c "import pkg_resources; import sys; required = {'openai', 'colorama', 'pwinput', 'python-dotenv', 'rich', 'requests', 'cryptography', 'huggingface_hub'}; missing = required - {pkg.key for pkg in pkg_resources.working_set}; print(f'[WARNING] Some required packages are missing: {missing}') if missing else print('All core dependencies are installed successfully!')"
    ) else (
        echo requirements.txt not found, installing basic dependencies...
        pip install openai colorama pwinput python-dotenv rich requests cryptography
    )
    
    :: Deactivate virtual environment
    call "%VENV_PATH%\Scripts\deactivate.bat"
)

if not exist "%VULCAN_DIR%\models" (
    echo Creating models directory for local models...
    mkdir "%VULCAN_DIR%\models"
)

if not exist "%VULCAN_DIR%\.vulcan" (
    echo Creating .vulcan configuration file...
    type nul > "%VULCAN_DIR%\.vulcan"
)

if not exist "%VULCAN_DIR%\.vulcan_key" (
    echo Note: Security files will be created on first run.
)

echo Activating virtual environment and starting Vulcan GPT...
if exist "%VENV_PATH%\Scripts\activate.bat" (
    call "%VENV_PATH%\Scripts\activate.bat"
    
    if exist "%VENV_PATH%\Scripts\python.exe" (
        echo Using Python directly from virtual environment
        
        cd "%VULCAN_DIR%"
        
        echo Running with: %VENV_PATH%\Scripts\python.exe
        "%VENV_PATH%\Scripts\python.exe" VulcanGPT.py
    ) else (
        echo Using Python from activated environment
        
        cd "%VULCAN_DIR%"
        
        python VulcanGPT.py
    )
    
    set EXIT_CODE=%errorlevel%
    if %EXIT_CODE% neq 0 (
        echo Vulcan GPT exited with code %EXIT_CODE%
        echo If you're experiencing issues, try running this script again to reinstall.
    )
    
    call "%VENV_PATH%\Scripts\deactivate.bat"
) else (
    echo Error: Could not find activation script at %VENV_PATH%\Scripts\activate.bat
    echo Try running this script again to reinstall.
    pause
    exit /b 1
)
