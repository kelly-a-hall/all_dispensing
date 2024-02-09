###########################################
# All Dispensing Dashboard                # 
# Server script for tab 4: Item code list #
# Created by: Kelly Hall                  # 
# Created on: 30/01/2024                  #
# Updated on: 30/01/2024                   #
###########################################

output$title <- renderUI(HTML("<h2>All PBS Medicines Dispensing</h2>"))

observeEvent(input$gototab1, {
  updateTabsetPanel(session, "inTabset",
                    selected = "tab1")
})

output$desc1 <- renderUI(HTML("<br><p>Search by medicine to display dispensing by item code.</p>"))

observeEvent(input$gototab2, {
  updateTabsetPanel(session, "inTabset",
                    selected = "tab2")
})

output$desc2 <- renderUI(HTML("<br><p>Search by ATC 3 code to display dispensing by medicine.</p>"))

# observeEvent(input$gototab3, {
#   updateTabsetPanel(session, "inTabset",
#                     selected = "tab3")
# })
# 
# output$desc3 <- renderUI(HTML("<br><p>Search by biological medicine to display dispensing by indication.</p>"))

observeEvent(input$gototab4, {
  updateTabsetPanel(session, "inTabset",
                    selected = "tab4")
})

output$desc4 <- renderUI(HTML("<br><p>Search the list of all medicines and associated item codes, ATC 3 code and form/strength.</p>"))

output$intro <- renderUI(HTML("<h3>About this dashboard</h3>
                              <p>This dashboard allows researchers to visualise  
                              trends in medicines dispensed by the Pharmaceutial Benefits Scheme (PBS).</p>
                              <p>Data has been sourced from the <a href=https://www.pbs.gov.au/info/statistics/dos-and-dop/dos-and-dop>PBS Section 85 Date of Supply monthly report</a> 
                              and the <a href=https://www.pbs.gov.au/info/statistics/dos-and-dop/dos-and-dop>PBS item drug map</a><sup>1</sup>.</p> 
                              <p>Created by the 
                              <a href=https://https://www.unisa.edu.au/research/qumprc/>
                              Quality Use of Medicines and Pharmacy Research Centre, University of South Australia</a>.</p>
                              <hr>
                              <p><small><sup>1</sup>Pharmaceutical Benefits Scheme and Repatriation Pharmaceutical Benefits Scheme Section 85 Supply Data, 
                              Australian Government Department of Health and Aged Care, <a href = https://www.pbs.gov.au>www.pbs.gov.au</a>.</small></p>"))



