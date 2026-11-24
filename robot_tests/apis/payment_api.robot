*** Settings ***
Resource    ../resources/variables.robot
Resource    ../resources/keywords.robot

*** Keywords ***
Get Payment Options
    [Arguments]    ${scenario}=happy
    ${response}=    Post Payment Payload    ${payload}    ${scenario}
    RETURN    ${response}
