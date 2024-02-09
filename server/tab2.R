####################################
# All Dispensing Dashboard         # 
# Server script for tab 2: By ATC  #
# Created by: Kelly Hall           # 
# Created on: 24/08/2023           #
# Updated on: 28/08/2023           #
####################################
  
  # Define server logic for dispensing by ATC code and medicine (Tab 2)  ----

  output$caption2 <- renderText({
    if (input$which_item2 == "all" & input$which_pat2 == "All") {
      paste("<h2>All dispensing for", input$atc_label,"</h2><h3>By medicine</h3>")
    } else if (input$which_item2=="all" & input$which_pat2 == "PBS") {
      paste("<h2>Dispensing for", input$atc_label,"</h2><h3>By medicine (PBS only)</h3>")
    } else if (input$which_item2=="all" & input$which_pat2 == "RPBS") {
      paste("<h2>Dispensing for", input$atc_label,"</h2><h3>By medicine (RPBS only)</h3>")
    }
    else if (input$which_item2=="total" & input$which_pat2 == "All") {
      paste("<h2>All dispensing for", input$atc_label,"</h2><h3>All medicines combined</h3>")
    }
    else if (input$which_item2=="total" & input$which_pat2 == "PBS") {
      paste("<h2>Dispensing for", input$atc_label,"</h2><h3>All medicines combined (PBS only)</h3>")
    }
    else if (input$which_item2=="total" & input$which_pat2 == "RPBS") {
      paste("<h2>Dispensing for", input$atc_label,"</h2><h3>All mediciness combined (RPBS only)</h3>")
    }
  })
  
output$lineplot2 <- renderPlot({
    draw_plotB(input$atc_label, input$which_pat2, input$which_item2) })
  
  
  target_list2 <-reactive({
    filter(list, atc_label == input$atc_label) %>%
      select(c("ITEM_CODE", "DRUG_NAME", "FORM"))
  })
  
  output$table2 <- renderDT(target_list2(), 
                            colnames = c("Item code", "Medicine", "Form/Strength"),
                            rownames = FALSE,
                            options = list(
                              searching = FALSE
                            ))
  
  output$note2 <- renderUI(HTML("<hr><p><b>Note:</b> <a href=https://www.pbs.gov.au/info/statistics/dos-and-dop/dos-and-dop>
Only includes medicines dispensed under the PBS General Schedule (Section 85)</a></p>"))
#  })
  