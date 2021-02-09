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
# having trouble downloading the data? Download it directly from here: https://github.com/rfordatascience/tidytuesday/tree/master/data/2020/2020-01-28

# tasks -------------------------------------------------------------------

# use tree_dat for the following questions:

# 1. Check if there are any duplicate tree_id rows
length(unique(tree_dat$tree_id))
# # 192987 matches number of rows in data set- no duplicates

# 2. how many trees of each species are there?
tree_dat %>% 
  group_by(species) %>% 
  summarise(num_trees = n())

# 3. how old is the oldest tree in the data set, in years? 
tree_dat %>% 
  summarise(first_tree = time_length(today() - first(date), "years"))

# 4. how many trees are planted by year?
tree_dat %>% 
  mutate(year = year(date)) %>% 
  group_by(year) %>% 
  summarise(num_planted = n())
 
# 5. How many are planted by decade?
tree_dat %>% 
  mutate(year = year(date)) %>% 
  mutate(decade = floor(year/10) *10) %>% 
  group_by(decade) %>% 
  summarise(num_planted = n())

# OR:

floor_decade <- function(value){ return(value - value %% 10) } # I found this on stackoverflow

tree_dat %>% 
  mutate(decade = floor_decade(year(date))) %>% 
  group_by(decade) %>% 
  summarise(num_planted = n())
