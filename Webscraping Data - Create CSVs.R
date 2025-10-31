library(tidyverse)
require(rvest)
# Weekly Shōnen Jump
link <- "https://en.wikipedia.org/wiki/Weekly_Sh%C5%8Dnen_Jump"
jumpLink <- read_html(link)

# Current Series
# There are currently 23 manga titles present in Weekly Shōnen Jump.
current_series <- html_elements(jumpLink, "table.wikitable") %>% 
  .[[1]] %>% 
  html_table()
str(current_series)
# Cleaning Tasks: remove Japanese titles within () , split $Premiered into $Month and $Year , remove $Ref.
current_series_cleaned <- current_series %>% 
  mutate(
    Title = gsub("\\s*\\([^)]*\\)", "", `Series title`),
    Premiered = gsub("\\[.\\]", "", Premiered)
  ) %>% 
  rename(Author = `Author(s)`) %>% 
  select(Title, Author, Premiered)
# COMPLETED !

circulation_figures <- html_elements(jumpLink, "table.wikitable") %>% 
  .[[3]] %>% 
  html_table()
str(circulation_figures)
# Cleaning Tasks: forfeit data after year 2007 , remove references in [] , remove all commas and Yen dollar signs , rename money-related variables to include "yen" , convert Year to date , convert all money-related variables to numeric
circulation_figures_cleaned <- circulation_figures %>% 
  slice_head(n = 35) %>% 
  mutate(
    across(everything(), ~ gsub("\\[[^]]*\\]", "", .)),
    across(where(is.character), ~ gsub("[,¥￥]", "", .))
  ) %>% 
  rename(
    Year = `Year / Period`,
    Units_Sold = `Magazine sales`,
    Revenue_Yen = `Sales revenue (est.)`,
    Price_Yen = `Issue price`
  ) %>% 
  mutate(
    across(c(Units_Sold, Revenue_Yen, Price_Yen), as.numeric)
  )

highest_series <- html_elements(jumpLink, "table.wikitable") %>% 
  .[[4]] %>% 
  html_table()
