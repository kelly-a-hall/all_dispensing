##############################
# All Dispensing Dashboard   # 
# UI script for tab2: By ATC #
# Created by: Kelly Hall     # 
# Created on: 30/01/2024     #
# Updated on: 30/01/2024     #
##############################

# Define UI for dispensing by ATC code and medicine (Tab 2) ----
tabPanel("By ATC code and medicine",
         value = "tab2",
         # Sidebar layout with input and output definitions ----
         sidebarLayout(
           
           # Sidebar panel for inputs ----
           sidebarPanel(
             # Input: Selector for drug name ---- ***START WITH JUST ALL FOR EACH DRUG NAME
             selectInput(inputId = "atc_label",
                         label = "Select ATC code",
                         choices = atclist),
             
             radioButtons("which_item2", "Display:",
                          c("All medicines" = "all",
                            "Total dispensing for the ATC code" = "total")),
             
             radioButtons("which_pat2", "Patient category:",
                          c("All" = "All",
                            "PBS only" = "PBS",
                            "RPBS only" = "RPBS")),
             width = 2
           ),
           
           mainPanel(htmlOutput("caption2"),
                     # Output: Plot of the requested drug against prescriptions ----
                     plotOutput("lineplot2"),
                     htmlOutput("note2")
                     
           )
         )
         
)
