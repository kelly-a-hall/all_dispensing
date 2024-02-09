######################################
# All Dispensing Dashboard           # 
# UI script for tab4: Item code list #
# Created by: Kelly Hall             # 
# Created on: 30/01/2024             #
# Updated on: 30/01/2024              #
######################################

tabPanel("Overview",
         sidebarLayout(
           sidebarPanel(
             htmlOutput("intro")
           ),
           
           mainPanel(htmlOutput("title"),
                     actionButton('gototab1', 'By medicine and item code'),
                     htmlOutput("desc1"),
                     actionButton('gototab2', 'By ATC code'),
                     htmlOutput("desc2"),
                     #actionButton('gototab3', 'By medicine and indication'),
                     #htmlOutput("desc3"),
                     actionButton('gototab4', 'List'),
                     htmlOutput("desc4")
                     
           )
           
         )


)



