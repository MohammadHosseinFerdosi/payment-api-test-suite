*** Settings ***
Resource    ../apis/payment_api.robot
Resource    ../apis/validation_api.robot

*** Test Cases ***
Insufficient Credit
    Create Session For Payment API
    ${response}=    Post Payment Payload    {"options": [{"type": "wallet", "title": "Wallet", "is_clickable": true, "is_active": true, "credit": 0, "is_default": false, "price_type": "fixed"}]}    insufficient_credit
    Should Be Equal As Integers    ${response.status_code}    200

Inactive Option
    Create Session For Payment API
    ${response}=    Post Payment Payload    {"options": [{"type": "bank", "title": "Bank Transfer", "is_clickable": true, "is_active": false, "credit": 100, "is_default": false, "price_type": "fixed"}]}    inactive_option
    Should Be Equal As Integers    ${response.status_code}    200

Default Option
    Create Session For Payment API
    ${response}=    Post Payment Payload    {"options": [{"type": "card", "title": "Credit Card", "is_clickable": true, "is_active": true, "credit": 100, "is_default": true, "price_type": "fixed"}, {"type": "wallet", "title": "Wallet", "is_clickable": true, "is_active": true, "credit": 50, "is_default": true, "price_type": "dynamic"}]}    invalid_default
    Should Be Equal As Integers    ${response.status_code}    200
