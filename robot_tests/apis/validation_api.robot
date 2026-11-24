*** Settings ***
Resource    ../resources/variables.robot
Resource    ../resources/keywords.robot

*** Keywords ***
Validate Payload
    [Arguments]    ${payload}
    ${response}=    Post Validation Payload    ${payload}
    RETURN    ${response}
