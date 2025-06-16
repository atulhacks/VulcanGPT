@echo off
echo.
echo ===============================================
echo           Vulcan GPT Installer
echo ===============================================
echo.


python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in PATH.
    echo Please install Python 3.8 or higher from https://www.python.org/downloads/
    echo and make sure to check "Add Python to PATH" during installation.
    echo.
    pause
    exit /b 1
)


echo Creating virtual environment...
python -m venv venv
if %errorlevel% neq 0 (
    echo [ERROR] Failed to create virtual environment.
    echo Please make sure you have venv module installed.
    echo.
    pause
    exit /b 1
)


echo Activating virtual environment...
call venv\Scripts\activate.bat


echo Installing dependencies...
if exist requirements.txt (
    echo Installing from requirements.txt...
    

    echo Installing basic dependencies...
    pip install openai colorama pwinput python-dotenv rich requests cryptography
    

    echo Installing llama-cpp-python (this may take a while)...
    pip install llama-cpp-python --verbose
    if %errorlevel% neq 0 (
        echo [WARNING] Failed to install llama-cpp-python. Local models will not be available.
        echo You can try installing it manually later with: pip install llama-cpp-python
    )
    

    echo Installing huggingface-hub...
    pip install huggingface-hub
    

    echo Installing all dependencies from requirements.txt...
    pip install -r requirements.txt
    

    echo Verifying installation...
    python -c "import pkg_resources; import sys; required = {'openai', 'colorama', 'pwinput', 'python-dotenv', 'rich', 'requests', 'cryptography', 'huggingface_hub'}; missing = required - {pkg.key for pkg in pkg_resources.working_set}; print('All core dependencies are installed successfully!' if not missing else f'[WARNING] Some required packages are missing: {missing}'); sys.exit(1 if missing else 0)"
    if %errorlevel% neq 0 (
        echo [WARNING] Some dependencies may be missing. You might encounter issues when running the application.
    ) else (
        echo All dependencies installed successfully!
    )
) else (
    echo requirements.txt not found, installing basic dependencies...
    pip install openai colorama pwinput python-dotenv rich requests cryptography
)


echo Creating models directory...
mkdir models 2>nul


echo Creating prompts directory...
mkdir prompts 2>nul

echo.
echo ===============================================
echo Installation complete!
echo.
echo To start Vulcan GPT, run:
echo   venv\Scripts\activate.bat
echo   python VulcanGPT.py
echo.
echo On first run, you will be prompted to enter your API key.
echo ===============================================
echo.

pause
