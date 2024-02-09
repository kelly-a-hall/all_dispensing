####################################################################
# Generate all data sources to be used in the Biologics shiny Apps #
# Updated 19 December 2023                                         #
####################################################################

library("readr")
library("ggplot2")
library("tibble")
library("lubridate")
library("tidyverse")
library("janitor")
library("dplyr")

setwd("R:/Biologics/ShinyApp/shiny_app_data")

#load the latest DOS data (S85) and append the data from 2018
dos_dat0 <-
  read_csv("dos-jul-2018-to-jun-2023.csv") %>%
  mutate(year = as.numeric(substr(MONTH_OF_SUPPLY,1,4)))  %>%
  filter(MONTH_OF_SUPPLY <=201906)

dos_dat <-
  read_csv("dos-jul-2019-to-oct-2023.csv") %>% #upload latest version of DOS here
  mutate(year = as.numeric(substr(MONTH_OF_SUPPLY,1,4))) %>%
  rbind(dos_dat0)


#load item map (updated monthly, same time as DOS)
item_map <-
  read_csv("pbs-item-drug-map.csv") %>%
  mutate(DRUG_NAME = str_to_title(DRUG_NAME, locale = "en")) %>% #exclude where no ATC (i.e., Z, D, S, R) 
  filter(ATC5_Code != "Z" | ATC5_Code != "D" | ATC5_Code != "S" | ATC5_Code != "R") %>%
  mutate(FORM = ifelse(ITEM_CODE %in% "02676W","Oral powder 400 g (Alfare)", FORM)) #has a weird character so needs to be changed 
  

#ATC code map
atc_map <-
  read_csv("atc.csv") %>%
  mutate(medicine_type = str_to_title(medicine_type, locale = "en"), atc1 = str_to_title(atc1, locale = "en")) %>%
  mutate(atc_label = paste0(code, " - ", medicine_type, sep="")) 
  

# combine item map data with DOS (to merge)
# create list of both dataframes
df_list <-
  list(dos_dat, item_map)

# then merge on ITEM_CODE
data0<-df_list %>%
  reduce(inner_join, by='ITEM_CODE')

# create base dataset for All Dispensing App
all_data <- data0 %>%
  select(DRUG_NAME, ITEM_CODE, FORM, MONTH_OF_SUPPLY, PRESCRIPTIONS, PATIENT_CAT, ATC5_Code) %>%
  mutate(new_mnth = paste0(as.character(MONTH_OF_SUPPLY),"01", sep="")) %>%
  mutate(date_mnth = ymd(new_mnth)) %>%
  mutate(PAT_CAT = case_when(PATIENT_CAT %in% c("C0", "C1", "DB", "G1", "G2") ~ "PBS",
                             PATIENT_CAT %in% c("R0", "R1") ~ "RPBS"),
         atc = substr(ATC5_Code, start = 1, stop = 3)) %>%
  select(-c(PATIENT_CAT, ATC5_Code))
  
# data for Tab 1 (By medicine and item code) (exclude ATC)

# per month by item code for all patients (PAT_CAT = All)
all_itemcode_all <- all_data %>%
  select(DRUG_NAME, ITEM_CODE, date_mnth, PRESCRIPTIONS) %>%
  group_by(date_mnth, DRUG_NAME, ITEM_CODE) %>%
  summarise(pres_mnth= sum(PRESCRIPTIONS)/1000) %>%
  mutate(PAT_CAT = "All")

# per month by medicine for all patients (PAT_CAT = All, item_code = All) 
all_med_all <- all_data %>%
  select(DRUG_NAME, date_mnth, PRESCRIPTIONS) %>%
  group_by(date_mnth, DRUG_NAME) %>%
  summarise(pres_mnth= sum(PRESCRIPTIONS)/1000) %>%
  mutate(PAT_CAT = "All", ITEM_CODE = "All")

# per month by item code and patient type (PAT_CAT = PBS OR RPBS)
all_itemcode_patcat <- all_data %>%
  select(DRUG_NAME, date_mnth, ITEM_CODE, PRESCRIPTIONS, PAT_CAT) %>%
  group_by(date_mnth, DRUG_NAME, ITEM_CODE, PAT_CAT) %>%
  summarise(pres_mnth= sum(PRESCRIPTIONS)/1000) 

# per month by medicine and patient type (PAT_CAT = PBS OR RPBS, item_code = All)
all_med_patcat <- all_data %>%
  select(DRUG_NAME, date_mnth, PRESCRIPTIONS, PAT_CAT) %>%
  group_by(date_mnth, DRUG_NAME, PAT_CAT) %>%
  summarise(pres_mnth= sum(PRESCRIPTIONS)/1000)%>%
  mutate(ITEM_CODE = "All")

# combine into a single dataset that can be used for all options of Tab 1
all_tab1 <- rbind(all_itemcode_all, all_med_all, all_itemcode_patcat, all_med_patcat) %>%
  mutate(item_select = ifelse(ITEM_CODE == "All", "total", "all")) # required for plot function 


# dataset for Tab 2 (By ATC and medicine) (exclude item code)

# per month by medicine for all patients (PAT_CAT = All) 
all_medatc_all <- all_data %>%
  select(DRUG_NAME, date_mnth, PRESCRIPTIONS, atc) %>%
  group_by(date_mnth, DRUG_NAME, atc) %>%
  summarise(pres_mnth= sum(PRESCRIPTIONS)/1000) %>%
  mutate(PAT_CAT = "All")

# per month by ATC for all patients  (PAT_CAT = All, DRUG_NAME = All)
all_atc_all <- all_data %>%
  select(date_mnth, PRESCRIPTIONS, atc) %>%
  group_by(date_mnth, atc) %>%
  summarise(pres_mnth= sum(PRESCRIPTIONS)/1000) %>%
  mutate(PAT_CAT = "All", DRUG_NAME = "All")

# per month by medicine and patient type (PAT_CAT = PBS OR RPBS)
all_medatc_patcat <- all_data %>%
  select(DRUG_NAME, date_mnth, PRESCRIPTIONS, PAT_CAT, atc) %>%
  group_by(date_mnth, DRUG_NAME, PAT_CAT, atc) %>%
  summarise(pres_mnth= sum(PRESCRIPTIONS)/1000)

# per month by ATC and patient type (PAT_CAT = PBS OR RPBS, DRUG_NAME = All)
all_atc_patcat <- all_data %>%
  select(atc, date_mnth, PRESCRIPTIONS, PAT_CAT) %>%
  group_by(date_mnth, atc, PAT_CAT) %>%
  summarise(pres_mnth= sum(PRESCRIPTIONS)/1000)%>%
  mutate(DRUG_NAME = "All")

# combine all datasets
all_tab2_nolab <- all_medatc_all %>% 
  rbind(all_atc_all, all_medatc_patcat, all_atc_patcat) %>%
 rename(code = atc)

# combine with ATC map 
all_tab2_list <- list(all_tab2_nolab, atc_map)

# merge on code (to get ATC labels)
all_tab2 <- all_tab2_list %>%
  reduce(inner_join, by='code') %>%
  mutate(drug_select = ifelse(DRUG_NAME == "All", "total", "all")) # required for plot function

# step 1 to derive list for Tab 3 (get list of item codes and drug names)
all_list0 <- all_tab1 %>%
  ungroup() %>%
  select(DRUG_NAME, ITEM_CODE) %>%
  distinct()

# step 2 (get ATC codes)
all_list1 <- all_tab2 %>%
  ungroup() %>%
  select(DRUG_NAME, atc_label) %>%
  distinct()

# combine step 1 and 2 into a list
all_list_list <- list(all_list0,all_list1)

# merge on drug name
all_list <- all_list_list %>%
  reduce(inner_join, by='DRUG_NAME')

# combine with item map to for Form/Strength
all_form_list <- list(all_list, item_map)

# merge on item code and drug name
all_list <- all_form_list %>%
  reduce(inner_join, by=c('ITEM_CODE','DRUG_NAME')) %>%
  select(-c(ATC5_Code))
  

# output for use in the all dispensing app

# data for Tab 1
saveRDS(all_tab1, file = "bymed_data.RDS")

# data for Tab 2
saveRDS(all_tab2, file = "byatc_data.RDS")

# data for Tab 3
saveRDS(all_list, file = "all_list.RDS")
