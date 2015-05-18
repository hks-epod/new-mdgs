setwd("~/new-mdgs")

library(dplyr)
library(tidyr)
library(magrittr)
library(ggplot2)

goals <-
  read.csv("MDG_Export_20150514_231243045.csv", stringsAsFactors = FALSE) %>% 
  tbl_df %>%
  slice(1:40356) %>%                        # Chop off footnotes
  filter(MDG == "Y") %>%                    # Filter out variables that aren't goals
  select(Country,Series,contains("X"))%>%   # Keep only countries, goals, and years
  gather(Year, Value, -(1:2)) %>%           # Make year into a variable (a column)
  spread(Series, Value) %>%                 # Make goals into variables (columns)
  mutate(Country = as.factor(Country)) %>% 
  mutate(Year = extract_numeric(Year))

goal.names <- goals %>% colnames %>% inset(1:2, NA) # Store goal names with punctuation...

colnames(goals) %<>% make.names                     # ...then standardize column titles

plot.country.progress <-
  . %>%
  {
    goal.colname <- colnames(goals)[[.]]
    goal.name <- goal.names[[.]]
    ggplot(goals, aes_string("Year", goal.colname)) %>%
    add(geom_line(aes(color = Country))) %>% 
    add(ggtitle(goal.name)) %>% 
    add(labs(y = goal.name)) %>% 
    add(theme(legend.position = "none")) %>% 
    print
  }

plot.country.progress(3)