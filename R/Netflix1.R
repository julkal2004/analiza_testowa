
#Kod przekazuje zbiór (%>%), filtruje tylko filmy (filter), wyszukuje reżysera (str_detect), konwertuje tekst na datę (mutate), usuwa braki dat (drop_na), sortuje chronologicznie (arrange), ogranicza widok do 4 kolumn (select) i pobiera 1 najstarszy wynik (head(1)).
dane %>%
  filter(Series.or.Movie == "Movie") %>%
  filter(str_detect(Director, "Woody Allen")) %>%
  mutate(Release = as.Date(Release.Date, format = "%m/%d/%y")) %>%
  drop_na(Release) %>%
  arrange(Release) %>%
  select(Title, Director, Release.Date, IMDb.Score) %>%
  head(1)
