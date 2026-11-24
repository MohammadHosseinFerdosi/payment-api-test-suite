PYTHON ?= python

install:
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install -r requirements.txt

start-mock:
	$(PYTHON) -m uvicorn mock_server.app:app --host 127.0.0.1 --port 8000

run-tests:
	$(PYTHON) -m pytest -q mock_server/tests
	robot --outputdir reports/robot robot_tests

run-load:
	k6 run load_tests/scenarios/happy_path.js
	k6 run load_tests/scenarios/error_scenarios.js
	k6 run load_tests/scenarios/validation.js

build:
	docker compose build

up:
	docker compose up --build app

test-docker:
	docker compose up --build tests

load-docker:
	docker compose up --build load
