# Lesson 4: Data wrangling and manipulation with tidyverse
# Created by: Caitlin Allen Akselrud
# Contact: caitlin.allen_akselrud@noaa.gov
# Created: 2020-12-18
# Modified: 2021-01-18


# packages ----------------------------------------------------------------

library(tidyverse)
library(lubridate)
library(here)
# install.packages('tidytuesdayR')
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

# are there any columns common to both data sets?
unique(caribou_ind$animal_id)
unique(caribou_loc$animal_id)

# it's hard to tell whether these overlap or not at a glance. 
# check out the data transformation cheat sheet (https://rstudio.com/resources/cheatsheets/)
# what functions might be useful in determining whether all animal_id are present in individuals and locations

setdiff(x = unique(caribou_ind$animal_id), y = unique(caribou_loc$animal_id)) 
setdiff(x = unique(caribou_loc$animal_id), y = unique(caribou_ind$animal_id)) 

anti_join(x = unique(caribou_ind$animal_id), y = unique(caribou_loc$animal_id)) 
anti_join(x = unique(caribou_loc$animal_id), y = unique(caribou_ind$animal_id)) 
# did you get an error?
# "no applicable method for 'anti_join' applied to an object of class "character"
# what do you think this means?

# another way of checking the same thing:
setequal(caribou_ind$animal_id, caribou_loc$animal_id)

# looks like the two data sets overlap- let's put them together

# * join two data sets ----------------------------------------------------

# if we want to use all the rows from both, use full_join

full_join(caribou_ind, caribou_loc)
# it automatically detects overlapping columns

# you can also specify a column or set of columns to join on
full_join(caribou_ind, caribou_loc, by = 'animal_id')
# what happens to study site?

caribou_dat <- full_join(caribou_ind, caribou_loc)


# * * multiple simple joins -----------------------------------------------

# band_members is a built-in data set in tidyverse:
band_members
band_instruments

# join all rows in both data sets:
full_join(x = band_members, y = band_instruments)

# join only rows with matching information
inner_join(x = band_members, y = band_instruments)

# keep all of x, and join matches from y
left_join(x = band_members, y = band_instruments)

# keep all of y, and join matches from x
right_join(x = band_members, y = band_instruments)

# depending how you join your data sets, you may get NA's for missing values
# # you can check where those will occur
# check what in x has a match in y
semi_join(x = band_members, y = band_instruments)
semi_join(x = band_instruments, y = band_members)

# check what rows in x do NOT have a match in y
anti_join(x = band_members, y = band_instruments)
anti_join(x = band_instruments, y = band_members)


# * summarize data --------------------------------------------------------
# check out the hikes data set
hikes
hike_wta <- hikes$hike_data
hike_wta

# summarize
summarise(hike_wta, mean_hike_gain = mean(gain))
summarise(hike_wta, mean_hike_gain = mean(gain, na.rm = TRUE))
# uh-oh. what is going on here? check your data.
str(hike_wta)
# all the columns are listed as characters rather than numeric values!
# don't panic. try this:
hike_wta <- type_convert(hike_wta)
# this nifty function is part of tidyverse with the read-in set of functions, readr

# let's try again:
summarise(hike_wta, mean_hike_gain = mean(gain))
# summarize multiple things
summarise(hike_wta, mean_hike_gain = mean(gain), sd_gain = sd(gain))

summarise(hike_wta, mean_hike_gain = mean(gain), sd_gain = sd(gain),
          mean_highpt = mean(highpoint), sd_highpt = sd(highpoint))

# there are a bunch of functions you can use within summarise
# see page 2 of the data manipulation cheat sheet in R

# how many of a thing?
count(hike_wta, location)

# * group data ------------------------------------------------------------
hikes_loc <- group_by(hike_wta, location)

summarise(hikes_loc, mean_hike_gain = mean(gain))

hikes_rating <- group_by(hike_wta, rating)

count(hikes_rating)
View(count(hikes_rating))

# you can also un-group using: ungroup()

# * manipulate data -------------------------------------------------------

# * * manipulate rows -----------------------------------------------------

# filter your data based on some criteria:
filter(hike_wta, rating > 4.5)
filter(hike_wta, rating > 4.5, rating < 4.8)
filter(hike_wta, highpoint < 1000, rating > 4.5)

# IMPORTANT NOTE ON FILTER:
# I usually use dplyr::filter, which means, use the filter function from the dplyr package (tidyverse)
# this is because there is also a filter function in the stats package
# having both functions with the same name can lead to errors.
?filter

# you can arrange rows in order (a -> z, low -> high, TRUE -> FALSE)
arrange(hike_wta, name)
# desc() function allows you to arrange in reverse order
arrange(hike_wta, desc(name)) 

# pull out all the unique hikes
distinct(hike_wta, name)
# total rows of hike_wta is 1958, but distinct shows 1923, meaning there are 35 duplicates

# skeptical? check to make sure that's right!
# we can check this using the unique() function we learned before:
unique(hike_wta$name)
# that's long, so let's just check to see if the length of unique values is the same:
length(unique(hike_wta$name))
# 1923 rows- that checks out!

# It is really important to check your work AS YOU GO!

# * * manipulate columns ----------------------------------------------------

# get a vector from a data set
pull(hike_wta, gain)

# pull specific columns from your data into a new table
select(hike_wta, name, length, gain, highpoint)

# or, use select and - to remove columns from a data set
select(hike_wta, -location, -features, - description)


# * * * mutate functions --------------------------------------------------

# the mutate functions are allow you to create new columns
# it is the bread an butter of initial data manipulation and analysis

mutate(hike_wta, strenousness = gain*highpoint)
mutate(hike_wta, strenousness = gain*highpoint,
       rank = min_rank(strenousness))

# pipes -------------------------------------------------------------------
# the shortcut for a pipe is ctrl + shift + m to create: %>% 

hike_wta %>%   #start with the data set
  mutate(strenousness = gain*highpoint) # add the strenousness column
  # NOTE: since we started with the data set, we don't have to include it within the mutate() function
 
hike_wta %>%   
  mutate(strenousness = gain*highpoint) %>%
  mutate(rank = min_rank(strenousness)) %>% # then rank strenousness
  arrange(rank) #then arrange by rank (least to most strenuous)
  
# add a grouping:
hike_wta %>%   
  mutate(strenousness = gain*highpoint) %>%
  mutate(rank = min_rank(strenousness)) %>%
  arrange(rank) %>% 
  group_by(location) %>% 
  summarise(loc_rank = mean(rank)) %>% 
  arrange(loc_rank)

# CHECK as you go. You can highlight code up until the %>% to check progress

  
# times and dates ---------------------------------------------------------
# let's go back to the caribou data set:

caribou_loc

# info by year
caribou_loc %>% 
  mutate(year = year(timestamp)) #look, here is our friendly mutate() function!

# info by month
caribou_loc %>% 
  mutate(year = year(timestamp),
         month = month(timestamp)) 

# over how many weeks was each animal observed?
caribou_loc %>% 
  group_by(animal_id) %>% # get individual animal data
  summarise(first_time = first(timestamp), last_time = last(timestamp)) %>% # pull out the first and last time observed
  mutate(weeks = difftime(last_time, first_time, units = "weeks")) # get the difference between those times, in weeks

# difftime can sometimes be finnickey, so you can also try time_length:
caribou_loc %>% 
  group_by(animal_id) %>% # get individual animal data
  summarise(first_time = first(timestamp), last_time = last(timestamp)) %>% # pull out the first and last time observed
  mutate(weeks = time_length(last_time - first_time, "weeks")) # get the difference between those times, in weeks


# observations during daylight hours (assume 6 am to 6 pm)
caribou_loc %>% 
  mutate(hour = hour(timestamp)) %>%   # extract the hour of the day from timestamp
  dplyr::filter(hour >= 6, hour <= 18) # keep only rows between specified hours


# strings -----------------------------------------------------------------

# let's look at our hiking data:
hike_wta

# length of hikes is a string because it's a phrase. 
# let's split that:
hike_wta %>% 
  mutate(hike_length = str_split(length, " "))
# uh-oh. now you have a list within your tibble. what to do?
# tip: you know how to look at lists using the $
#       assign a variable name, then explore that new list
#       eg:
        x <- hike_wta %>% 
          mutate(hike_length = str_split(length, " "))
        x
        x$hike_length

# you can unnest a list within a tibble using the unnest() functions
hike_wta %>% 
  mutate(hike_length = str_split(length, " ")) %>% 
  unnest_wider(hike_length)
# that looks messy. what can we do?

hike_wta %>% 
  mutate(hike_length = str_split(length, " "))%>% 
  unnest_wider(hike_length) %>% 
  rename(length_mi = ...1, 
         units = ...2, 
         trip_type = ...3) %>% 
  select(-...4)
# it took a few more steps than we might have thought, but we got there!

# * regular expressions (regex) -------------------------------------------

# we can also try to do this using regular expressions.
# look at the chart on the cheat sheet to see if you can find which pattern might help

# here are 4 ways I did it that didn't work. [It cuts off at the decimal point]
hike_wta %>% 
  mutate(hike_length = str_extract(length, "\\d"))

hike_wta %>% 
  mutate(hike_length = str_extract(length, "\\S"))

hike_wta %>% 
  mutate(hike_length = str_extract(length, "[:graph:]"))

hike_wta %>% 
  mutate(hike_length = str_extract(length, "[^ ]"))

# here's what finally worked:
hike_wta %>% 
  mutate(hike_length = str_extract(length, "\\d+\\.?\\d*"))
# One or more digits (\\d+), optional period (\\.?), zero or more digits (\\d*)
# how did I figure this out?
#   Google.
# regex expressions are hard. don't be afraid to ask for help!

