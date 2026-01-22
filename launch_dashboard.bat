@echo off
REM Launch the HDF5 Flight Data Dashboard
REM Double-click this file to start the dashboard

echo.
echo ===============================================
echo   HDF5 Flight Data Dashboard Launcher
echo ===============================================
echo.

cd /d "%~dp0"

REM Activate virtual environment
echo Activating virtual environment...
call .venv\Scripts\activate.bat

REM Launch Streamlit dashboard
echo.
echo Starting dashboard...
echo.
echo The dashboard will open in your browser at:
echo http://localhost:8501
echo.
echo Press Ctrl+C to stop the dashboard
echo.

streamlit run dashboard.py

pause
