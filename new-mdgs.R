library(dplyr)
library(tidyr)
library(magrittr)
library(ggplot2)

data <- 
  read.csv("MDG_Export_20150514_231243045.csv", stringsAsFactors = FALSE) %>% 
  tbl_df %>%
  slice(1:40356) %>%
  filter(MDG %>% equals("Y")) %>%
  select(-MDG,-contains("Footnotes"),-contains("Type")) %>% 
  gather(Year, Value, 5:30) %>% 
  mutate(Year = extract_numeric(Year))
#TODO: spread() on Value

data %>%
  filter(SeriesCode %>% equals("605")) %>% 
  ggplot(aes(Year, Value)) %>%
  add(geom_line(aes(color=CountryCode))) %>% 
  print