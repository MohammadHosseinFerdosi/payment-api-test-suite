*** Settings ***
Resource    ../apis/payment_api.robot
Resource    ../apis/validation_api.robot

*** Test Cases ***
Missing Required Fields
    Create Session For Payment API
    ${response}=    Post Payment Payload    {"options": [{"type": "card", "title": "Credit Card", "is_clickable": true, "is_active": true, "credit": 100, "is_default": true}]}    missing_field
    Should Be Equal As Integers    ${response.status_code}    400

Wrong Data Types
    Create Session For Payment API
    ${response}=    Post Payment Payload    {"options": [{"type": "card", "title": "Credit Card", "is_clickable": "yes", "is_active": true, "credit": "100", "is_default": true, "price_type": "fixed"}]}    wrong_type
    Should Be Equal As Integers    ${response.status_code}    400

HTTP Status Errors
    Create Session For Payment API
    ${response}=    Post Payment Payload    {"options": [{"type": "card", "title": "Credit Card", "is_clickable": true, "is_active": true, "credit": 100, "is_default": true, "price_type": "fixed"}]}    server_error
    Should Be Equal As Integers    ${response.status_code}    500
