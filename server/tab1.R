######################################################
# All Dispensing Dashboard                           # 
# Server script for tab 1: By Biologic and Item code #
# Created by: Kelly Hall                             # 
# Created on: 30/01/2024                            #
# Updated on: 30/01/2024                             #
######################################################

# Define server logic to plot dispensing for each medicine by item code or all combined (Tab 1) ----
# There are three inputs: DRUG_NAME is the medicine selected from the drop down; which_item is Display option (all item codes or total dispensing); which_pat is the Patient category (All, PBS only, RPBS only) 
output$caption1 <- renderText({
    if (input$which_item == "all" & input$which_pat == "All") {
      paste("<h2>All dispensing for", input$DRUG_NAME,"</h2><h3>By item code</h3>") # this is the text that is displayed above the plot
    } else if (input$which_item=="all" & input$which_pat == "PBS") {
      paste("<h2>Dispensing for", input$DRUG_NAME,"</h2><h3>By item code (PBS only)</h3>")
    } else if (input$which_item=="all" & input$which_pat == "RPBS") {
      paste("<h2>Dispensing for", input$DRUG_NAME,"</h2><h3>By item code (RPBS only)</h3>")
    }
  else if (input$which_item=="total" & input$which_pat == "All") {
      paste("<h2>All dispensing for", input$DRUG_NAME,"</h2><h3>All item codes combined</h3>")
  }
  else if (input$which_item=="total" & input$which_pat == "PBS") {
    paste("<h2>Dispensing for", input$DRUG_NAME,"</h2><h3>All item codes combined (PBS only)</h3>")
  }
  else if (input$which_item=="total" & input$which_pat == "RPBS") {
    paste("<h2>Dispensing for", input$DRUG_NAME,"</h2><h3>All item codes combined (RPBS only)</h3>")
  }
  })

# Calls the plot function from global and uses the three inputs to determine what to display
output$lineplot1 <- renderPlotly({
       draw_plotA(input$DRUG_NAME, input$which_pat, input$which_item) })
  
# Calls the list to display below the plot   
target_list1 <-reactive({
    filter(list, DRUG_NAME == input$DRUG_NAME) %>%
      select(c("ITEM_CODE", "FORM", "atc_label"))
   })
   
output$table1 <- renderDT(target_list1(), 
                            colnames = c("Item code", "Form/Strength", "ATC 3 code"),
                            rownames = FALSE,
                            options = list(
                             searching = FALSE
                           ))

# Note that displays below the list  
output$note1 <- renderUI(HTML("<hr><p><b>Note:</b> <a href=https://www.pbs.gov.au/info/statistics/dos-and-dop/dos-and-dop>
Only includes medicines dispensed under the PBS General Schedule (Section 85)</a></p>"))


