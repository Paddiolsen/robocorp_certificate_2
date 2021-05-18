*** Settings ***
Documentation   Certificate level II
Library    RPA.Browser.Selenium
Library    RPA.HTTP
Library    RPA.Tables

# Test only
Library    RPA.core.notebook


*** Variables ***
${CSV_FILE_URL}=  https://robotsparebinindustries.com/orders.csv
${URL}=    https://robotsparebinindustries.com

*** Keywords ***
Open the robot order website
    Open Available Browser    ${URL}


*** Keywords ***
Get orders
    ${csv_file}=    Download    ${CSV_FILE_URL}    overwrite=True
    ${csv_table}=    Read table from CSV    ${csv_file}
    [Return]    ${csv_table}[body]


*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Open the robot order website
    ${orders}=    Get orders
    FOR    ${row}    IN    @{orders}
        Notebook Print    ${row}
        #Close the annoying modal
        #Fill the form    ${row}
        #Preview the robot
        #Submit the order
        #${pdf}=    Store the receipt as a PDF file    ${row}[Order number]
        #${screenshot}=    Take a screenshot of the robot    ${row}[Order number]
        #Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}
        #Go to order another robot
    END
    #Create a ZIP file of the receipts

