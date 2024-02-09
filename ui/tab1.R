#################################################
# All Dispensing Dashboard                      # 
# UI script for tab1: By Biologic and Item code #
# Created by: Kelly Hall                        # 
# Created on: 30/01/2024                        #
# Updated on: 30/01/2024                         #
#################################################

# Define UI for to plot dispensing for each medicine by item code or all combined (Tab 1) ----

tabPanel("By medicine and item code",  # Tab label
         value = "tab1",               # Tab name
           # Sidebar layout with input and output definitions ----
           sidebarLayout(
             
             # Sidebar panel for inputs ----
             sidebarPanel(   
               # Input: Selector for drug name ---- ***START WITH JUST ALL FOR EACH Medicine
               selectInput(inputId = "DRUG_NAME",    # drop down selector list; name of selection
                           label = "Select medicine",  # label that appears above the drop down
                           choices = medlist),  # data source (input on Global.R)
               
               radioButtons("which_item", "Display:",   # first radio selector; name of selection
                            c("All item codes" = "all",   # options that display and the name that is applied
                              "Total dispensing for the medicine" = "total")),
               
               radioButtons("which_pat", "Patient category:",  #second radio selector
                            c("All" = "All",
                              "PBS only" = "PBS",
                              "RPBS only" = "RPBS")),
               width = 2
             ),
             
             mainPanel(htmlOutput("caption1"),     # label that appears above the plot
                       # Output: Plot of the requested medicine against dispensing ----
                       plotlyOutput("lineplot1"),   # plot
                       DT::DTOutput("table1"),      # table
                       htmlOutput("note1")          # note below table
                       
             )
           )
           
         )
