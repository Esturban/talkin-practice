#Establish the runtime options for:

# - model explanation analysis
options(
  parallelMap.default.mode        = "socket",
  parallelMap.default.cpus        = 4,
  parallelMap.default.show.info   = FALSE
)
#Load the dependencies
require(dplyr)
require(magrittr)
require(purrr)
require(tidyr)
require(lubridate)
require(modelStudio)

#Load all of the data tables into a list object
ds <- list.files(path = "data",
                 pattern = "*.csv",
                 full.names = T)
all_tables <- sapply(ds, readr::read_csv, show_col_types = F)

names(all_tables) <-
  gsub("olist_|_dataset|.csv|data\\/", "", names(all_tables))

#Load the initial runtime scripts for data preparation
sapply(list.files("src", "*.R", full.names = T), source, globalenv())
