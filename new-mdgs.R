setwd("~/new-mdgs")

library(dplyr)
library(tidyr)
library(magrittr)
library(ggplot2)

goals <- 
  read.csv("MDG_Export_20150514_231243045.csv", stringsAsFactors = FALSE) %>% 
  tbl_df %>%
  slice(1:40356) %>%                      # Exclude footnotes
  filter(MDG %>% equals("Y")) %>%
  select(Country,Series,contains("X"))%>% # Years are named "X1990" etc.
  gather(Year, Value, -(1:2)) %>% 
  spread(Series, Value) %>% 
  mutate(Year = extract_numeric(Year))

goals %>%
  ggplot(aes(Year, `Fixed-telephone subscriptions per 100 inhabitants`)) %>%
  add(geom_line(aes(color=Country))) %>% 
  add(ggtitle('Fixed-telephone subscriptions per 100 inhabitants')) %>% 
  add(theme(legend.position="none")) %>% 
  print