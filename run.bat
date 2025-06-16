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
    echo Virtual environment not found at %VENV_PATH%. Running installer first...
    
    if exist "%VULCAN_DIR%\install.bat" (
        cd "%VULCAN_DIR%" && call install.bat
        if errorlevel 1 (
            echo Installation failed. Please check the error messages above.
            pause
            exit /b 1
        )
    ) else (
        echo Error: Installer script not found at %VULCAN_DIR%\install.bat
        pause
        exit /b 1
    )
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
        echo If you're experiencing issues, try reinstalling with: install.bat
    )
    
    call "%VENV_PATH%\Scripts\deactivate.bat"
) else (
    echo Error: Could not find activation script at %VENV_PATH%\Scripts\activate.bat
    echo Try running the installer again with: install.bat
    pause
    exit /b 1
)
