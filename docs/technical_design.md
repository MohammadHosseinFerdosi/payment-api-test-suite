# Technical Design

## Overview
This repository contains a container-ready checkout payment API test harness built around a lightweight FastAPI mock service, Robot Framework automation, and k6 performance tests. The mock server exposes `/payment/` for scenario-based responses and `/validate/` for payload validation.

## Architecture
- Mock server: FastAPI application in [mock_server/app.py](../mock_server/app.py)
- OpenAPI contract: [mock_server/openapi.yaml](../mock_server/openapi.yaml)
- Automated API tests: [robot_tests/payment_suite.robot](../robot_tests/payment_suite.robot)
- Load tests: [load_tests/scenarios/happy_path.js](../load_tests/scenarios/happy_path.js), [load_tests/scenarios/error_scenarios.js](../load_tests/scenarios/error_scenarios.js), and [load_tests/scenarios/validation.js](../load_tests/scenarios/validation.js)
- Containerization: [Dockerfile](../Dockerfile) and [docker-compose.yml](../docker-compose.yml)
- Test data: [robot_tests/testdata/valid_payloads.json](../robot_tests/testdata/valid_payloads.json) and [robot_tests/testdata/invalid_payloads.json](../robot_tests/testdata/invalid_payloads.json)

## Components
### 1. Mock API Service
The FastAPI service validates incoming payloads, returns scenario-based responses, and serves health and validation endpoints.

Key behaviors:
- Accepts a `scenario` query parameter for business-rule simulation.
- Supports happy path and negative scenarios like blocked BNPL, insufficient credit, inactive options, invalid defaults, and server errors.
- Returns structured JSON responses and standard HTTP statuses.

### 2. Automation Layer
Robot Framework is used for contract and workflow validation. The main suite covers:
- Happy path execution
- BNPL blocking behavior
- Insufficient credit handling
- Inactive option handling
- Default-option rule validation
- Missing-field validation
- Wrong-type validation
- Server-error handling

### 3. Performance Layer
k6 scripts exercise the mock API under load and validate latency/error thresholds. The current scripts focus on:
- Happy-path traffic
- Error-scenario traffic
- Validation endpoint traffic

### 4. Containerization
Docker Compose provides a simple way to run the API and the associated test stacks without requiring a local interpreter setup.

Services:
- `app`: hosts the mock API
- `tests`: runs pytest and Robot Framework tests
- `load`: runs the k6 load test

## Business Rules
- R1: JSON schema validation for the `options` structure.
- R2: Clickability enforcement via `is_clickable=true`.
- R3: Type validation for value fields such as booleans and integers.
- R4: Options array validation with at least one entry.
- R5: Eligibility rules where an option is considered valid only when `is_active=true` and `credit>0`.
- R6: Exactly one default option should be allowed for eligible options.
- R7: Price type enum validation using `fixed` or `dynamic`.

## Validation Approach
- Unit tests verify core endpoint behavior with pytest.
- Integration-style Robot tests validate API behavior for the business scenarios.
- Load tests validate response time and error-rate thresholds.
- Docker-based execution ensures portability across environments.

## Notes and Limitations
- The mock service is intentionally lightweight and focuses on business-rule validation rather than full payment processing.
- The current implementation is designed for deterministic interview/demo scenarios rather than production-grade payment orchestration.
