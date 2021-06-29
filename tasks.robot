*** Settings ***
Documentation   Certificate level II
Library    RPA.Browser.Selenium
Library    RPA.HTTP
Library    RPA.Tables
Library    RPA.PDF
# Test only
Library    RPA.core.notebook

*** Variables ***
${CSV_FILE_URL}=  https://robotsparebinindustries.com/orders.csv
${URL}=    https://robotsparebinindustries.com/#/robot-order

*** Keywords ***
Open the robot order website
    Open Available Browser    ${URL}


*** Keywords ***
Get orders
    ${csv_file}=    Download    ${CSV_FILE_URL}    overwrite=True
    ${csv_table}=    Read table from CSV    orders.csv
    [Return]    ${csv_table}


*** Keywords ***
Close the annoying modal
    Click Button    css:#root > div > div.modal > div > div > div > div > div > button.btn.btn-dark

*** Keywords ***
Fill the form
    [Arguments]     ${row}
    Select From List By Index    //*[@id="head"]    ${row}[Head]
    Select Radio Button    body    ${row}[Body]
    Input Text    xpath=//div[@id='root']/div/div/div/div/form/div[3]/input   ${row}[Legs]
    Input Text    id:address    ${row}[Address]

*** Keywords ***
Preview the robot
    Click Button    id:preview

*** Keywords ***
Submit the order
    Wait Until Keyword Succeeds    3x    0.5 sec   Wait for recipe

*** Keywords ***
Wait for recipe
    Click Button    css:button[id="order"]
    Page Should Contain Element    id:receipt

*** Keywords ***
Store the receipt as a PDF file
    [Arguments]   ${order_number}
    ${pdf_path}=    Set Variable  ${OUTPUT_DIR}${/}${order_number}.pdf
    ${recipe_html}=     Get Element Attribute    id:receipt  outerHTML
    Html To Pdf    ${recipe_html}    ${pdf_path}
    [Return]    ${pdf_path}

*** Keywords ***
Take a screenshot of the robot
    [Arguments]  ${order_number}
    ${screenshot_path}=     Set Variable    ${OUTPUT_DIR}${/}${order_number}.png
    Capture Element Screenshot    id:robot-preview-image    ${screenshot_path}
    [Return]    ${screenshot_path}

*** Keywords ***
Embed the robot screenshot to the receipt PDF file
    [Arguments]  ${screenshot}    ${pdf}
    ${screenshot_list}=  Create List  
    ...     ${screenshot}
    Log     ${screenshot_list}
    Open Pdf     ${pdf}
    Add Files To Pdf    ${screenshot_list}  ${pdf}  append=True
    Close Pdf

*** Keywords ***
Go to order another robot
    Click Button    id:order-another

*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Open the robot order website
    ${orders}=    Get orders
    FOR    ${row}    IN    @{orders}
        Close the annoying modal
        Fill the form    ${row}
        Preview the robot
        Submit the order
        ${pdf}=    Store the receipt as a PDF file    ${row}[Order number]
        ${screenshot}=    Take a screenshot of the robot    ${row}[Order number]
        Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}
        Go to order another robot
    END
    #Create a ZIP file of the receipts

