# Lesson 4: Data wrangling and manipulation with tidyverse
# Created by: Caitlin Allen Akselrud
# Contact: caitlin.allen_akselrud@noaa.gov
# Created: 2020-12-18
# Modified: 2021-01-18


# packages ----------------------------------------------------------------

library(tidyverse)

install.packages('tidytuesdayR')
library(tidytuesdayR)

# directories --------------------------------------------------------------------

source(here("functions", "file_folders.R"))


# download data --------------------------------------------------------------------
caribou <- tidytuesdayR::tt_load('2020-06-23')

hikes <- tidytuesdayR::tt_load('2020-11-24')


# look at your data -------------------------------------------------------

caribou
mode(caribou)

# use the $ to access components of a list

caribou$individuals
caribou$locations

# there are 2 separate data sets here

caribou_ind <- caribou$individuals
caribou_loc <- caribou$locations

# what info is included in each data set?
# use str() function to see the column names of each data set:

str(caribou_ind)
str(caribou_loc)


# data manipulation -------------------------------------------------------

# suggestions for things we could do with these two data sets?


