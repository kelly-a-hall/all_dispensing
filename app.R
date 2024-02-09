###############################################################
# All Dispensing Dashboard                                    #
# Pull together the Global, UI and Server elements of the app #
# Created by: Kelly Hall                                      # 
# Created on: 30/01/2024                                      #
# Updated on: 30/01/2024                                      #
###############################################################


## Load package libraries, data and functions

source('global.R', local = TRUE)

## Call UI script for each tab
ui <- navbarPage(
 title = "",
  id = "inTabset",
  # include the UI for each tab
  source(file.path("ui", "tab0.R"),  local = TRUE)$value,
  source(file.path("ui", "tab1.R"),  local = TRUE)$value,
  source(file.path("ui", "tab2.R"),  local = TRUE)$value,
  source(file.path("ui", "tab3.R"),  local = TRUE)$value
)


## Call Server script for each tab
server <- function(input, output, session) {
  # Include the logic (server) for each tab
  source(file.path("server", "tab0.R"),  local = TRUE)$value
  source(file.path("server", "tab1.R"),  local = TRUE)$value
  source(file.path("server", "tab2.R"),  local = TRUE)$value
  source(file.path("server", "tab3.R"),  local = TRUE)$value
}

## Run shinyApp
shinyApp(ui = ui, server = server)