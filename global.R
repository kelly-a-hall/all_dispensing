##############################################
# All Dispensing Dashboard                   #
# Load package libraries, data and functions #
# Created by: Kelly Hall                     # 
# Created on: 30/01/2024                     #
# Updated on: 9/02/2024                     #
##############################################

## Load package libraries
library(shiny)
library(tidyverse)
library(DT)
library(labelled)
library(plotly)

## Load data

# Tab 1
app_data1 <- readRDS("data/bymed_data.RDS") 

medlist <- sort(unique(app_data1$DRUG_NAME)) # extract list of medicines for drop down list

# Tab 2
app_data2 <- readRDS("data/byatc_data.RDS")

atclist <- sort(unique(app_data2$atc_label)) # extract list of ATC codes for drop down list

# Tab 4
list <- readRDS("data/all_list.RDS") %>%
  select(c(ITEM_CODE, DRUG_NAME, FORM, atc_label))

## Plot functions 

# By medicine and item code (Tab 1)

draw_plotA <- function(drug_to_filter_by, pat_to_filter_by, item_to_filter_by) {
  
  filtered_drug <- app_data1 %>% # filter to correct data
    filter(DRUG_NAME == !!drug_to_filter_by, PAT_CAT == !!pat_to_filter_by, item_select == !!item_to_filter_by) %>%
    rename(Date = date_mnth, Dispensing = pres_mnth, Item_Code = ITEM_CODE) # rename so that hover over have readable labels
  
  ggplot(filtered_drug, aes(x = Date, y = Dispensing, col = Item_Code)) + # generate line plot
    geom_point(size = 1, alpha = 0.75) +
    geom_line()+
    labs(
      x = "Time",
      y = "Dispensing (thousands)",
      col = "Item codes"
    ) +
    theme_bw() + theme(text = element_text(size = 14), legend.text = element_text(size = 12))
}


# By ATC code and medicine (Tab 2)

draw_plotB <- function(atc_to_filter_by, pat_to_filter_by, med_to_filter_by) {
  
  filtered_atc <- app_data2 %>%
    filter(atc_label == !!atc_to_filter_by, PAT_CAT == !!pat_to_filter_by, drug_select == !!med_to_filter_by)
  
  ggplot(filtered_atc, aes(x = date_mnth, y = pres_mnth,  col = DRUG_NAME)) +
    geom_point(size = 1, alpha = 0.75) +
    geom_line()+
    labs(
      x = "Time",
      y = "Dispensing (thousands)",
      col = "Medicines"
    ) +
    theme_bw() + theme(text = element_text(size = 20))
}


