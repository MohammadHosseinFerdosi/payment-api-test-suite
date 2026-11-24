# Checkout Payment API Automation Suite

This project delivers a lightweight mock payment API, an API automation suite built with Robot Framework, and load tests written in k6.

## Features
- FastAPI-based mock server for `/payment/` and `/validate/`
- OpenAPI documentation served from `/docs`
- Robot Framework coverage for happy path, business rules, and negative scenarios
- k6 load tests with thresholds for latency, error rate, and validation success
- GitHub Actions workflow for CI

## Setup
1. Ensure Python 3.8+ is installed.
2. Install dependencies:
   ```bash
   python -m pip install -r requirements.txt
   ```
3. Start the mock server:
   ```bash
   python -m uvicorn mock_server.app:app --host 127.0.0.1 --port 8000
   ```
4. Open http://127.0.0.1:8000/docs for the Swagger UI.

## Mock server configuration
The server accepts a query parameter named `scenario`:
- `happy`
- `blocked`
- `insufficient_credit`
- `inactive_option`
- `invalid_default`
- `missing_field`
- `wrong_type`
- `server_error`

You can also set `PAYMENT_MOCK_SCENARIO` as an environment variable.

## Running tests locally
If you are using Windows PowerShell and do not have GNU make installed, use the bundled wrapper script:
```powershell
./make.cmd install
./make.cmd start-mock
./make.cmd run-tests
./make.cmd run-load
```

- Unit tests:
  ```bash
  python -m pytest -q mock_server/tests
  ```
- Robot tests:
  ```bash
  robot --outputdir reports/robot robot_tests
  ```
- k6 load tests:
  ```bash
  k6 run load_tests/scenarios/happy_path.js
  k6 run load_tests/scenarios/error_scenarios.js
  k6 run load_tests/scenarios/validation.js
  ```

## Docker workflow
Docker Desktop or a compatible Docker Engine is required.

Run the stack with Docker Compose:
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

## CI pipeline
The GitHub Actions workflow starts the mock server, runs Robot tests, executes k6 scripts, and publishes reports as workflow artifacts.

## Test data strategy
Payloads are stored under [robot_tests/testdata](robot_tests/testdata) and can be reused for regression scenarios.

## Assumptions and limitations
- The mock server is intentionally lightweight and focuses on business-rule validation rather than full payment processing.
- The k6 scripts use the local mock server on `127.0.0.1:8000`.

## Troubleshooting
- If the mock server fails to start, verify that port 8000 is available.
- If Robot tests fail, confirm the server is running and reachable at `/health`.
- If k6 is not installed, install it before running the load scripts.
