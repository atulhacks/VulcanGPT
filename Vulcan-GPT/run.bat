@echo off
echo.
echo ===============================================
echo           Vulcan GPT Launcher
echo ===============================================
echo.

:: Set the path to the virtual environment
set VENV_PATH=C:\Users\user\Documents\Project\P15\venv

:: Check if virtual environment exists
if not exist "%VENV_PATH%" (
    echo Virtual environment not found at %VENV_PATH%. Running installer first...
    call install.bat
    if errorlevel 1 (
        echo Installation failed. Please check the error messages above.
        pause
        exit /b 1
    )
)

echo Using virtual environment at: %VENV_PATH%

:: Ensure models directory exists
if not exist models (
    echo Creating models directory for local models...
    mkdir models
)

:: Activate virtual environment and run the application
echo Activating virtual environment and starting Vulcan GPT...
if exist "%VENV_PATH%\Scripts\activate.bat" (
    :: First try to activate the virtual environment
    call "%VENV_PATH%\Scripts\activate.bat"
    
    :: Check if Python exists in the virtual environment
    if exist "%VENV_PATH%\Scripts\python.exe" (
        echo Using Python directly from virtual environment
        
        :: Run the application with the specific Python interpreter
        "%VENV_PATH%\Scripts\python.exe" VulcanGPT.py
    ) else (
        :: Fallback to using the activated environment's Python
        echo Using Python from activated environment
        python VulcanGPT.py
    )
    
    :: Capture exit code
    set EXIT_CODE=%errorlevel%
    if %EXIT_CODE% neq 0 (
        echo Vulcan GPT exited with code %EXIT_CODE%
        echo If you're experiencing issues, try reinstalling with: install.bat
    )
    
    :: Deactivate virtual environment when done
    call "%VENV_PATH%\Scripts\deactivate.bat"
) else (
    echo Error: Could not find activation script at %VENV_PATH%\Scripts\activate.bat
    echo Try running the installer again with: install.bat
    pause
    exit /b 1
)
