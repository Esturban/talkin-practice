require(dplyr)
require(magrittr)
require(purrr)
require(tidyr)
require(lubridate)
#Exploratory Data Analysis
ds <- list.files(path = "data",
                 pattern = "*.csv",
                 full.names = T)
all_tables <- sapply(ds, readr::read_csv, show_col_types = F)
names(all_tables) <-
  gsub("olist_|_dataset|.csv|data\\/", "", names(all_tables))

