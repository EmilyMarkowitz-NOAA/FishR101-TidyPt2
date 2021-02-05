# Homework 4: Data wrangling and manipulation with tidyverse
# Created by: 
# Contact: 
# Created: 
# Modified: 


# packages ----------------------------------------------------------------
library(tidyverse)
library(lubridate)
library(tidytuesdayR)

# data --------------------------------------------------------------------

trees <- tidytuesdayR::tt_load('2020-01-28') 
trees
# you may ignore the parsing failures warning for this homework.

tree_dat <- trees$sf_trees

# tasks -------------------------------------------------------------------

## use tree_dat for the following questions:

# 1. Check if there are any duplicate tree_id rows

# 2. how many trees of each species are there?

# 3. how old is the oldest tree in the data set, in years? 

# 4. how many trees are planted by year?

# 5. How many are planted by decade?
