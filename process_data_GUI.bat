@echo off
echo Activating virtual environment...
call ".venv\Scripts\activate.bat"

echo Running main.py...
python main.py

echo.
echo Process completed. Press any key to exit.
pause > nul