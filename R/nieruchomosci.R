# R/nieruchomosci.R
# OSOBA A: zadania 1-4 (nieruchomości, New Taipei)
# Skrypt uruchamia się od początku: pakiety -> odczyt danych -> zadania.
# Pakiety (jeśli brakuje): install.packages(c("dplyr", "tidyr", "haven"))
library(dplyr)
library(tidyr)

# --- Odczyt danych (tak samo jak w instrukcji) --------------------------------
adres_nieruchomosci <- paste0(
  "https://raw.githubusercontent.com/kflisikowsky/pandas_exercises/",
  "62863036107888c0c7273c40e8d309a43f4da3a9/data/models/real_estate.csv"
)
raw_nier <- read.csv(adres_nieruchomosci, check.names = FALSE)
stopifnot(nrow(raw_nier) == 414, ncol(raw_nier) == 7)

nier <- raw_nier
names(nier) <- c("id", "wiek_lat", "metro_m", "sklepy", "lat", "lon",
                 "cena_10k_twd_ping")

# =============================================================================
# ZADANIE 1 - najpierw sprawdź tabelę
# =============================================================================
cat("\n===== ZADANIE 1 =====\n")
cat("Wymiary (wiersze, kolumny):", dim(nier), "\n\n")

cat("Struktura i typy danych:\n")
str(nier)

cat("\nLiczba braków w kolumnach:\n")
print(colSums(is.na(nier)))

cat("\nPodstawowe statystyki:\n")
print(summary(nier))

cat("\nCzy id jest unikatowe?\n")
cat("anyDuplicated(id) =", anyDuplicated(nier$id),
    "(0 = brak duplikatów); unikatowych id:", n_distinct(nier$id),
    "z", nrow(nier), "\n")

cat("\nZmienne liczbowe, których nie interpretujemy jako zwykłych miar ilościowych:\n",
    "- id: tylko numer porządkowy rekordu (średnia czy mediana nie mają sensu),\n",
    "- lat, lon: współrzędne geograficzne, czyli położenie, a nie ilość\n",
    "  (średnia z nich nie opisuje żadnej cechy nieruchomości).\n", sep = "")

# =============================================================================
# ZADANIE 2 - przelicz cenę i sprawdź jej rozkład
# =============================================================================
cat("\n===== ZADANIE 2 =====\n")
nier <- nier %>%
  mutate(cena_twd_m2 = cena_10k_twd_ping * 10000 / 3.3)

cena_stat <- nier %>%
  summarise(
    minimum  = min(cena_twd_m2),
    mediana  = median(cena_twd_m2),
    srednia  = mean(cena_twd_m2),
    maksimum = max(cena_twd_m2)
  )
cat("Cena za m2 (TWD/m2):\n")
print(cena_stat)

cat("\nPięć nieruchomości o najwyższej cenie jednostkowej:\n")
top5 <- nier %>%
  arrange(desc(cena_twd_m2)) %>%
  select(id, cena_twd_m2, wiek_lat, metro_m, sklepy) %>%
  slice_head(n = 5)
print(top5)

cat(sprintf(
  paste0("\nŚrednia (%.0f TWD/m2) jest %s od mediany (%.0f TWD/m2). ",
         "Gdy średnia > mediana, rozkład jest prawostronnie skośny: ",
         "kilka drogich obserwacji podciąga średnią w górę. ",
         "To cena jednostkowa za m2, a nie wartość całego lokalu.\n"),
  cena_stat$srednia,
  ifelse(cena_stat$srednia > cena_stat$mediana, "wyższa", "niższa lub równa"),
  cena_stat$mediana))

# =============================================================================
# ZADANIE 3 - ile obserwacji jest blisko metra?
# =============================================================================
cat("\n===== ZADANIE 3 =====\n")
nier <- nier %>% mutate(blisko_metra = metro_m <= 500)

blisko <- nier %>%
  group_by(blisko_metra) %>%
  summarise(
    liczba        = n(),
    odsetek       = round(100 * n() / nrow(nier), 1),
    mediana_ceny  = round(median(cena_twd_m2), 0),
    .groups = "drop"
  )
print(blisko)

b_tak <- blisko %>% filter(blisko_metra)
b_nie <- blisko %>% filter(!blisko_metra)

cat(sprintf(
  paste0("\nWniosek: do 500 m od stacji MRT jest %d nieruchomości (%.1f%% z %d ",
         "rekordów); mediana ceny wynosi tam %.0f TWD/m2, wobec %.0f TWD/m2 ",
         "powyżej 500 m. To porównanie opisowe, nie dowód przyczynowości.\n"),
  b_tak$liczba, b_tak$odsetek, nrow(nier),
  b_tak$mediana_ceny, b_nie$mediana_ceny))

# =============================================================================
# ZADANIE 4 - wiek, odległość i sklepy
# =============================================================================
cat("\n===== ZADANIE 4 =====\n")
nier <- nier %>% mutate(
  strefa = cut(metro_m, c(-Inf, 500, 1500, Inf),
               labels = c("do 500 m", "500–1500 m", "ponad 1500 m"))
)

podsumuj_strefy <- function(dane) {
  dane %>%
    group_by(strefa) %>%
    summarise(
      liczba          = n(),
      mediana_ceny    = round(median(cena_twd_m2), 0),
      mediana_wieku   = median(wiek_lat),
      srednia_sklepow = round(mean(sklepy), 2),
      .groups = "drop"
    )
}

cat("Wszystkie budynki:\n")
strefy_wszystkie <- podsumuj_strefy(nier)
print(strefy_wszystkie)

cat("\nBudynki w wieku najwyżej 20 lat:\n")
strefy_mlode <- podsumuj_strefy(nier %>% filter(wiek_lat <= 20))
print(strefy_mlode)

ranking <- function(tab) {
  tab %>% arrange(desc(mediana_ceny)) %>% pull(strefa) %>% as.character()
}
rank_wszystkie <- ranking(strefy_wszystkie)
rank_mlode     <- ranking(strefy_mlode)

cat("\nRanking median cen (od najwyższej), wszystkie budynki:",
    paste(rank_wszystkie, collapse = " > "), "\n")
cat("Ranking median cen (od najwyższej), budynki <= 20 lat:  ",
    paste(rank_mlode, collapse = " > "), "\n")
cat("Czy ranking jest taki sam?",
    ifelse(identical(rank_wszystkie, rank_mlode), "TAK", "NIE"), "\n")

cat("\nDlaczego porównania mogą się różnić: strefy różnią się nie tylko ",
    "odległością od metra, ale też strukturą wieku budynków i liczbą sklepów. ",
    "Wiek wpływa na cenę, więc w porównaniu wszystkich budynków część różnicy ",
    "między strefami wynika z różnego wieku zabudowy. Ograniczenie do budynków ",
    "do 20 lat porównuje obiekty bardziej podobne pod względem wieku, ale ",
    "zmniejsza liczebności grup, więc wyniki są mniej stabilne.\n", sep = "")

# =============================================================================
# Gotowe wnioski do wnioski.md
# =============================================================================
cat("\n===== WNIOSKI (do wklejenia do wnioski.md) =====\n")
cat(sprintf(
  paste0("- Cena jednostkowa: mediana %.0f TWD/m2, średnia %.0f TWD/m2 ",
         "(n = %d); średnia %s od mediany.\n"),
  cena_stat$mediana, cena_stat$srednia, nrow(nier),
  ifelse(cena_stat$srednia > cena_stat$mediana, "wyższa", "niższa")))
cat(sprintf(
  paste0("- Do 500 m od MRT: %d obserwacji (%.1f%% z %d), mediana %.0f TWD/m2 ",
         "vs %.0f TWD/m2 powyżej 500 m (porównanie opisowe, nie przyczynowe).\n"),
  b_tak$liczba, b_tak$odsetek, nrow(nier),
  b_tak$mediana_ceny, b_nie$mediana_ceny))
cat(sprintf(
  "- Ranking median cen stref: wszystkie budynki: %s; budynki <= 20 lat: %s.\n",
  paste(rank_wszystkie, collapse = " > "),
  paste(rank_mlode, collapse = " > ")))
