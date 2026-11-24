*** Settings ***
Resource    ../apis/payment_api.robot
Resource    ../apis/validation_api.robot

*** Test Cases ***
Happy Path Validation
    Create Session For Payment API
    ${payload}=    Evaluate    json.load(open('robot_tests/testdata/valid_payloads.json'))['happy']    json
    ${response}=    Post Payment Payload    ${payload}    happy
    Should Be Equal As Integers    ${response.status_code}    200

BNPL Blocked
    Create Session For Payment API
    ${payload}=    Evaluate    json.load(open('robot_tests/testdata/valid_payloads.json'))['blocked']    json
    ${response}=    Post Payment Payload    ${payload}    blocked
    Should Be Equal As Integers    ${response.status_code}    200
