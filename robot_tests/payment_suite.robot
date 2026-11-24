*** Settings ***
Library    Collections
Resource    resources/variables.robot
Resource    resources/keywords.robot

*** Test Cases ***
Happy Path Validation
    Create Session For Payment API
    ${payload}=    Evaluate    {"options": [{"type": "card", "title": "Credit Card", "is_clickable": True, "is_active": True, "credit": 100, "is_default": True, "price_type": "fixed"}]}
    ${response}=    Post Payment Payload    ${payload}    happy
    Should Be Equal As Integers    ${response.status_code}    200

BNPL Blocked
    Create Session For Payment API
    ${payload}=    Evaluate    {"options": [{"type": "bnpl", "title": "Buy Now Pay Later", "is_clickable": False, "is_active": True, "credit": 100, "is_default": False, "price_type": "fixed"}]}
    ${response}=    Post Payment Payload    ${payload}    blocked
    Should Be Equal As Integers    ${response.status_code}    200

Insufficient Credit
    Create Session For Payment API
    ${payload}=    Evaluate    {"options": [{"type": "wallet", "title": "Wallet", "is_clickable": True, "is_active": True, "credit": 0, "is_default": False, "price_type": "fixed"}]}
    ${response}=    Post Payment Payload    ${payload}    insufficient_credit
    Should Be Equal As Integers    ${response.status_code}    200

Inactive Option
    Create Session For Payment API
    ${payload}=    Evaluate    {"options": [{"type": "bank", "title": "Bank Transfer", "is_clickable": True, "is_active": False, "credit": 100, "is_default": False, "price_type": "fixed"}]}
    ${response}=    Post Payment Payload    ${payload}    inactive_option
    Should Be Equal As Integers    ${response.status_code}    200

Default Option
    Create Session For Payment API
    ${payload}=    Evaluate    {"options": [{"type": "card", "title": "Credit Card", "is_clickable": True, "is_active": True, "credit": 100, "is_default": True, "price_type": "fixed"}, {"type": "wallet", "title": "Wallet", "is_clickable": True, "is_active": True, "credit": 50, "is_default": True, "price_type": "dynamic"}]}
    ${response}=    Post Payment Payload    ${payload}    invalid_default
    Should Be Equal As Integers    ${response.status_code}    200

Missing Required Fields
    Create Session For Payment API
    ${payload}=    Evaluate    {"options": [{"type": "card", "title": "Credit Card", "is_clickable": True, "is_active": True, "credit": 100, "is_default": True}]}
    ${response}=    Post Payment Payload    ${payload}    missing_field    expected_status=400
    Should Be Equal As Integers    ${response.status_code}    400

Wrong Data Types
    Create Session For Payment API
    ${payload}=    Evaluate    {"options": [{"type": "card", "title": "Credit Card", "is_clickable": "yes", "is_active": True, "credit": "100", "is_default": True, "price_type": "fixed"}]}
    ${response}=    Post Payment Payload    ${payload}    wrong_type    expected_status=400
    Should Be Equal As Integers    ${response.status_code}    400

HTTP Status Errors
    Create Session For Payment API
    ${payload}=    Evaluate    {"options": [{"type": "card", "title": "Credit Card", "is_clickable": True, "is_active": True, "credit": 100, "is_default": True, "price_type": "fixed"}]}
    ${response}=    Post Payment Payload    ${payload}    server_error    expected_status=500
    Should Be Equal As Integers    ${response.status_code}    500
