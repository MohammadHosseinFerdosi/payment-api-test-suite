# User Guide

## 1. Prerequisites
Before running the suite, make sure you have:
- Python 3.8+ installed
- pip available
- Docker Desktop or a compatible Docker Engine (optional, for containerized execution)

## 2. Running the suite locally
1. Install Python dependencies:
   ```bash
   python -m pip install -r requirements.txt
   ```
2. Start the mock server:
   ```bash
   python -m uvicorn mock_server.app:app --host 127.0.0.1 --port 8000
   ```
3. Run the pytest-based mock API tests:
   ```bash
   python -m pytest -q mock_server/tests
   ```
4. Run the Robot Framework business-rule suite:
   ```bash
   robot --outputdir reports/robot robot_tests/payment_suite.robot
   ```
5. Run the k6 load tests:
   ```bash
   .\tools\k6\k6-v0.49.0-windows-amd64\k6.exe run load_tests/scenarios/happy_path.js
   ```

## 3. Running the suite with Docker
The repository includes a Docker Compose workflow for containerized execution.

Start the API container:
```bash
docker compose up --build app
```

Run the automated tests in a container:
```bash
docker compose up --build tests
```

Run the load test in a container:
```bash
docker compose up --build load
```

## 4. Expected results
- Pytest should report 5 passing tests for the mock server endpoints.
- Robot Framework should report 8 passing tests for the payment-business scenarios.
- k6 should report successful checks and low failure rates for the load scripts.

## 5. Interpreting results
- Robot reports are written to [reports/robot](../reports/robot).
- Pytest output is printed to the terminal.
- k6 results are emitted to the terminal and can be redirected to files if needed.

## 6. Troubleshooting
- If the API does not start, verify that port 8000 is free.
- If tests fail, confirm that the mock server is reachable at `/health`.
- If Docker is not available, use the local Python workflow instead.
- If the k6 binary is missing, use the bundled binary in [tools/k6](../tools/k6) or install it separately.
