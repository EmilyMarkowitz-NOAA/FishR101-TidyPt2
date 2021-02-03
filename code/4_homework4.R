# homework 4: Data wrangling and manipulation with tidyverse
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
tree_dat <- trees$sf_trees
tree_loc <- trees$Street_Tree_Map

# tasks -------------------------------------------------------------------

# Use tree_dat for the following questions:

# 1. Check if there are any duplicate tree_id rows

# 2. How many trees of each species are there?

# 3. How old is the oldest tree in the data set, in years? 

# 4. How many trees are planted by year?

# 5. How many are planted by decade?
# The below function might be helpful to you for determining the decade. In this case you'll use it in the dplyr::mutate() function. 

floor_decade <- function(value){ return(value - value %% 10) } # I found this on stackoverflow

