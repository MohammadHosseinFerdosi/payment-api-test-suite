import os

import requests

BASE_URL = os.getenv("PAYMENT_API_BASE_URL", "http://127.0.0.1:8000")


def test_health():
    response = requests.get(f"{BASE_URL}/health", timeout=5)
    assert response.status_code == 200


def test_payment_endpoint_returns_happy_payload():
    payload = {
        "options": [
            {
                "type": "card",
                "title": "Credit Card",
                "is_clickable": True,
                "is_active": True,
                "credit": 100,
                "is_default": True,
                "price_type": "fixed",
            }
        ]
    }
    response = requests.post(f"{BASE_URL}/payment/", json=payload, params={"scenario": "happy"}, timeout=5)
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_payment_endpoint_handles_missing_field():
    payload = {
        "options": [
            {
                "type": "card",
                "title": "Credit Card",
                "is_clickable": True,
                "is_active": True,
                "credit": 100,
                "is_default": True,
            }
        ]
    }
    response = requests.post(f"{BASE_URL}/payment/", json=payload, params={"scenario": "missing_field"}, timeout=5)
    assert response.status_code == 400


def test_validate_endpoint_accepts_valid_payload():
    payload = {
        "options": [
            {
                "type": "card",
                "title": "Credit Card",
                "is_clickable": True,
                "is_active": True,
                "credit": 100,
                "is_default": True,
                "price_type": "fixed",
            }
        ]
    }
    response = requests.post(f"{BASE_URL}/validate/", json=payload, timeout=5)
    assert response.status_code == 200
    assert response.json()["valid"] is True


def test_validate_endpoint_rejects_invalid_payload():
    payload = {
        "options": [
            {
                "type": "card",
                "title": "Credit Card",
                "is_clickable": True,
                "is_active": True,
                "credit": 100,
                "is_default": True,
            }
        ]
    }
    response = requests.post(f"{BASE_URL}/validate/", json=payload, timeout=5)
    assert response.status_code == 400
    assert response.json()["valid"] is False
