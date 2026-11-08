dane %>%
  filter(Series.or.Movie == "Movie") %>%
  mutate(
    Year = Release.Date %>% str_extract("\\d{4}$") %>% as.numeric(),
    Decade = floor(Year / 10) * 10
  ) %>%
  drop_na(Decade) %>%
  group_by(Decade) %>%
  summarize(
    count = n(),
    avg_imdb_score = mean(IMDb.Score, na.rm = TRUE) %>% round(2)
  ) %>%
  arrange(Decade)
