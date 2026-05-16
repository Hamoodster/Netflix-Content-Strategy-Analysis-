install.packages("tidyverse")
install.packages("lubridate")

library(tidyverse)
library(lubridate)

#data print preview
netflix <- read.csv("netflix_titles.csv", stringsAsFactors = FALSE)

glimpse(netflix)
summary(netflix)

#cleaning data
netflix[netflix == ""] <- NA

netflix$date_added <- mdy(trimws(netflix$date_added))

netflix$year_added <- year(netflix$date_added)

#split between movies and tv shows with %
type_counts <- netflix %>%
count(type) %>%
mutate(percent = round(n / sum(n) * 100, 1))
print(type_counts)

#netflix content breakdown
yearly_content <- netflix %>%
filter(!is.na(year_added)) %>%
count(year_added, type)
print(yearly_content)

#top 10 most common genres accross titles
top_genres <- netflix %>%
separate_rows(listed_in, sep = ",") %>%
mutate(genre = trimws(listed_in)) %>%
count(genre, sort = TRUE) %>%
head(10)
print(top_genres)

#top 10 countries producting content
top_countries <- netflix %>%
separate_rows(country, sep = ",") %>%
mutate(country = trimws(country)) %>%
filter(!is.na(country)) %>%
count(country, sort = TRUE) %>%
head(10)
print(top_countries)

#common ratings accross titles
ratings <- netflix %>%
filter(!is.na(rating)) %>%
count(rating, sort = TRUE)
print(ratings)

#final
write.csv(type_counts, "type_counts.csv", row.names = FALSE)
write.csv(yearly_content, "yearly_content.csv", row.names = FALSE)
write.csv(top_genres, "top_genres.csv", row.names = FALSE)
write.csv(top_countries, "top_countries.csv", row.names = FALSE)
write.csv(ratings, "ratings.csv", row.names = FALSE)