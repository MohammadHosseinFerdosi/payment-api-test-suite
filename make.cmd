@echo off
setlocal

if "%~1"=="" goto help

if /I "%~1"=="install" (
  python -m pip install --upgrade pip
  python -m pip install -r requirements.txt
  goto :eof
)

if /I "%~1"=="start-mock" (
  python -m uvicorn mock_server.app:app --host 127.0.0.1 --port 8000
  goto :eof
)

if /I "%~1"=="run-tests" (
  python -m pytest -q mock_server/tests
  robot --outputdir reports/robot robot_tests
  goto :eof
)

if /I "%~1"=="run-load" (
  k6 run load_tests/scenarios/happy_path.js
  k6 run load_tests/scenarios/error_scenarios.js
  k6 run load_tests/scenarios/validation.js
  goto :eof
)

if /I "%~1"=="build" (
  docker compose build
  goto :eof
)

if /I "%~1"=="up" (
  docker compose up --build app
  goto :eof
)

if /I "%~1"=="test-docker" (
  docker compose up --build tests
  goto :eof
)

if /I "%~1"=="load-docker" (
  docker compose up --build load
  goto :eof
)

:help
echo Available targets:
echo   install
echo   start-mock
echo   run-tests
echo   run-load
echo   build
echo   up
echo   test-docker
echo   load-docker
