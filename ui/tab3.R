######################################
# All Dispensing Dashboard           # 
# UI script for tab3: Item code list #
# Created by: Kelly Hall             # 
# Created on: 2/02/2024              #
# Updated on: 2/02/2024              #
######################################

# UI for list of all item codes, medicines, ATC codes (Tab 3)

tabPanel("List",
  value = "tab3",
  mainPanel(htmlOutput("caption")),
  DT::dataTableOutput("table")
)
