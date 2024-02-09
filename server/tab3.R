###########################################
# All Dispensing Dashboard                # 
# Server script for tab 3: Item code list #
# Created by: Kelly Hall                  # 
# Created on: 2/02/24                     #
# Updated on: 2/02/24                     #
###########################################

# Server logic for list of all item codes, medicines, ATC codes (Tab 3)
output$table = DT::renderDataTable(
      list,
      colnames = c("Item code", "Medicine", "Form/Strength", "ATC 3 Code"),
      rownames = FALSE,
      selection = 'none'
    )


