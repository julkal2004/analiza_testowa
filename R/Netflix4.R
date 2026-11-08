
#Kod przekazuje dane (%>%), filtruje polskojęzyczne produkcje (filter + str_detect), usuwa braki danych (drop_na), rozdziela tagi po przecinkach na osobne wiersze (separate_rows), zlicza i sortuje je malejąco (count) oraz pobiera 10 najpopularniejszych (head(10)).
dane %>%
  filter(str_detect(Languages, "Polish")) %>%
  drop_na(Tags) %>%
  separate_rows(Tags, sep = ",\\s*") %>%
  count(Tags, sort = TRUE) %>%
  head(10)