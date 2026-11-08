
# --- Zadanie 5 ---

# 1. Sprawdzenie liczby obserwacji i braków
dim(cbos) # Pokazuje liczbę wierszy (respondentów) i kolumn
colSums(is.na(cbos)) # Pokazuje liczbę braków danych (NA) dla każdej ze zmiennych

# 2. Tabela liczności i odsetków dla zmiennej 'plec'
tabela_plec <- cbos %>%
  filter(!is.na(plec)) %>% # Odrzucamy braki systemowe
  count(plec) %>%
  mutate(procent = 100 * n / sum(n))

print(tabela_plec)

# 3. Tabela liczności i odsetków dla zmiennej 'miejscowosc'
tabela_miejscowosc <- cbos %>%
  filter(!is.na(miejscowosc)) %>% # Odrzucamy braki systemowe
  count(miejscowosc) %>%
  mutate(procent = 100 * n / sum(n))

print(tabela_miejscowosc)

# Aby podać dokładny mianownik dla płci i miejscowości (liczbę niebrakujących odpowiedzi):
sum(tabela_plec$n)
sum(tabela_miejscowosc$n)

# --- Zadanie 6 ---

# 1. Odsetki dla całej próby (uwzględniające "Trudno powiedzieć" i "Odmowa odpowiedzi")
tabela_kierunek_ogolna <- cbos %>%
  filter(!is.na(kierunek)) %>% 
  count(kierunek) %>%
  mutate(procent = 100 * n / sum(n))

print("Rozkład dla całej próby:")
print(tabela_kierunek_ogolna)
# Z tej tabeli odczytasz, która odpowiedź była najczęstsza (najwyższa wartość 'n').

# 2. Udział odpowiedzi tylko wśród osób ZDECYDOWANYCH
tabela_kierunek_zdecydowani <- cbos %>%
  # UWAGA: Jeśli etykiety w danych są dłuższe, zmień poniższe stringi na dokładne nazwy,
  # np. c("Zmierza w dobrym kierunku", "Zmierza w złym kierunku")
  filter(kierunek %in% c("W dobrym", "W złym")) %>% 
  count(kierunek) %>%
  mutate(procent = 100 * n / sum(n))

print("Rozkład tylko dla zdecydowanych (W dobrym / W złym):")
print(tabela_kierunek_zdecydowani)