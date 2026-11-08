
dane %>%
  filter(
    str_detect(Genre, "Comedy"),
    str_detect(Languages, "Polish")
  ) %>%
  arrange(desc(IMDb.Score)) %>%
  select(Title, Genre, Languages, IMDb.Score) %>%
  head(3)