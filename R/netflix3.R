
library(dplyr)
library(lubridate)

wynik_zad_3 <- dane %>%
  # Konwersja kolumn do typu Date. 
  # Używamy funkcji parse_date_time, która automatycznie rozpozna różne formaty (np. mm/dd/yyyy lub yyyy-mm-dd)
  mutate(
    Data_Premiery = parse_date_time(Release.Date, orders = c("mdy", "dmy", "ymd")),
    Data_Netflix = parse_date_time(Netflix.Release.Date, orders = c("mdy", "dmy", "ymd")),
    Rok_Premiery = year(Data_Premiery)
  ) %>%
  # Filtrujemy filmy z lat 2019-2020
  filter(Rok_Premiery %in% c(2019, 2020)) %>%
  # Obliczamy różnicę czasu w dniach
  mutate(
    Czas_Do_Netflixa = as.numeric(difftime(Data_Netflix, Data_Premiery, units = "days"))
  ) %>%
  # Zwracamy średnią, pomijając ewentualne braki danych (NA)
  summarise(
    Sredni_Czas_Dni = mean(Czas_Do_Netflixa, na.rm = TRUE)
  )

print(wynik_zad_3)