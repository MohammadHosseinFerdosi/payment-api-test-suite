*** Settings ***
Library    Collections
Library    RequestsLibrary

*** Keywords ***
Create Session For Payment API
    Create Session    payment_api    ${BASE_URL}    timeout=10

Post Payment Payload
    [Arguments]    ${payload}    ${scenario}=happy    ${expected_status}=200
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    payment_api    ${PAYMENT_ENDPOINT}    json=${payload}    params=scenario=${scenario}    headers=${headers}    expected_status=${expected_status}
    RETURN    ${response}

Post Validation Payload
    [Arguments]    ${payload}    ${expected_status}=200
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    payment_api    ${VALIDATE_ENDPOINT}    json=${payload}    headers=${headers}    expected_status=${expected_status}
    RETURN    ${response}
