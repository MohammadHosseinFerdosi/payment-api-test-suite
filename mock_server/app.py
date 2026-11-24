import os
from typing import Any

from fastapi import FastAPI, HTTPException, Query, Request
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
from jsonschema import Draft7Validator

app = FastAPI(title="Checkout Payment Mock API", version="1.0.0")


class PaymentOption(BaseModel):
    type: str = Field(..., min_length=1)
    title: str = Field(..., min_length=1)
    is_clickable: bool
    is_active: bool
    credit: int
    is_default: bool
    price_type: str


class PaymentPayload(BaseModel):
    options: list[PaymentOption]


SCHEMA = {
    "type": "object",
    "required": ["options"],
    "properties": {
        "options": {
            "type": "array",
            "minItems": 1,
            "items": {
                "type": "object",
                "required": ["type", "title", "is_clickable", "is_active", "credit", "is_default", "price_type"],
                "properties": {
                    "type": {"type": "string"},
                    "title": {"type": "string"},
                    "is_clickable": {"type": "boolean"},
                    "is_active": {"type": "boolean"},
                    "credit": {"type": "integer"},
                    "is_default": {"type": "boolean"},
                    "price_type": {"enum": ["fixed", "dynamic"]},
                },
            },
        }
    },
}

VALIDATOR = Draft7Validator(SCHEMA)


def build_response(scenario: str | None = None) -> tuple[int, dict[str, Any]]:
    scenario = scenario or os.getenv("PAYMENT_MOCK_SCENARIO", "happy")
    if scenario == "happy":
        return 200, {
            "status": "ok",
            "payment_methods": [
                {
                    "type": "card",
                    "title": "Credit Card",
                    "is_clickable": True,
                    "is_active": True,
                    "credit": 100,
                    "is_default": True,
                    "price_type": "fixed",
                },
                {
                    "type": "wallet",
                    "title": "Wallet",
                    "is_clickable": True,
                    "is_active": True,
                    "credit": 50,
                    "is_default": False,
                    "price_type": "dynamic",
                },
            ],
        }
    if scenario == "blocked":
        return 200, {
            "status": "ok",
            "payment_methods": [
                {
                    "type": "bnpl",
                    "title": "Buy Now Pay Later",
                    "is_clickable": False,
                    "is_active": True,
                    "credit": 100,
                    "is_default": False,
                    "price_type": "fixed",
                }
            ],
        }
    if scenario == "insufficient_credit":
        return 200, {
            "status": "ok",
            "payment_methods": [
                {
                    "type": "wallet",
                    "title": "Wallet",
                    "is_clickable": True,
                    "is_active": True,
                    "credit": 0,
                    "is_default": False,
                    "price_type": "fixed",
                }
            ],
        }
    if scenario == "inactive_option":
        return 200, {
            "status": "ok",
            "payment_methods": [
                {
                    "type": "bank",
                    "title": "Bank Transfer",
                    "is_clickable": True,
                    "is_active": False,
                    "credit": 100,
                    "is_default": False,
                    "price_type": "fixed",
                }
            ],
        }
    if scenario == "invalid_default":
        return 200, {
            "status": "ok",
            "payment_methods": [
                {
                    "type": "card",
                    "title": "Credit Card",
                    "is_clickable": True,
                    "is_active": True,
                    "credit": 100,
                    "is_default": True,
                    "price_type": "fixed",
                },
                {
                    "type": "wallet",
                    "title": "Wallet",
                    "is_clickable": True,
                    "is_active": True,
                    "credit": 50,
                    "is_default": True,
                    "price_type": "dynamic",
                },
            ],
        }
    if scenario == "missing_field":
        return 400, {"detail": "Missing required field"}
    if scenario == "wrong_type":
        return 400, {"detail": "Wrong data type"}
    if scenario == "server_error":
        return 500, {"detail": "Internal server error"}
    return 200, {
        "status": "ok",
        "payment_methods": [],
    }


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/payment/")
def payment(payload: dict[str, Any], request: Request, scenario: str | None = Query(default=None)) -> JSONResponse:
    if payload.get("options") is None:
        raise HTTPException(status_code=400, detail="Missing required field")

    try:
        if isinstance(payload, dict):
            payload_model = PaymentPayload.model_validate(payload)
        else:
            payload_model = PaymentPayload.model_validate(payload)
    except Exception as exc:  # pragma: no cover - defensive
        raise HTTPException(status_code=400, detail=str(exc)) from exc

    errors = sorted(VALIDATOR.iter_errors(payload), key=lambda e: e.path)
    if errors:
        raise HTTPException(status_code=400, detail="Schema validation failed")

    status_code, body = build_response(scenario)
    return JSONResponse(status_code=status_code, content=body)


@app.post("/validate/")
def validate(payload: dict[str, Any]) -> JSONResponse:
    try:
        PaymentPayload.model_validate(payload)
    except Exception as exc:
        return JSONResponse(status_code=400, content={"valid": False, "detail": str(exc)})
    return JSONResponse(status_code=200, content={"valid": True})

