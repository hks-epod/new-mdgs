library(dplyr)
library(tidyr)
library(magrittr)
library(ggplot2)

data <- 
  read.csv("MDG_Export_20150514_231243045.csv", stringsAsFactors = FALSE) %>% 
  tbl_df %>%
  slice(1:40356) %>%
  filter(MDG == "Y")

data$SeriesCode %<>%
  factor(labels = data$Series[1:80])

data$CountryCode %<>%
  factor(labels = unique(data$Country))

data %<>%
  select(-Series,-Country,-MDG,-contains("Footnotes"),-contains("Type")) %>% 
  gather(Year, Value, 3:28) %>% 
  mutate(Year = extract_numeric(Year))
#TODO: spread() on Value

data %>%
  filter(SeriesCode == "Mobile-cellular subscriptions per 100 inhabitants") %>% 
  ggplot(aes(Year, Value)) +
    geom_line(aes(color=CountryCode))