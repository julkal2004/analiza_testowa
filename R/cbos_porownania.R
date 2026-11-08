# --- Zadanie 7 ---

# 1. Porównanie odpowiedzi dla wsi i największych miast
tabela_wies_miasto <- cbos %>%
  # Filtrujemy tylko dwie interesujące nas kategorie miejscowości
  filter(miejscowosc %in% c("wieś", "miasto 500 000 i więcej")) %>%
  filter(!is.na(kierunek)) %>% # Odrzucamy braki danych dla czystości odsetków
  count(miejscowosc, kierunek) %>%
  group_by(miejscowosc) %>%
  mutate(procent = 100 * n / sum(n))

print(tabela_wies_miasto)

# 2. Sprawdzenie liczebności całkowitej w obu grupach
liczebnosc_grup <- tabela_wies_miasto %>%
  summarise(suma_respondentow = sum(n))

print(liczebnosc_grup)

# --- Zadanie 8 ---

# 1. Tabela liczności odpowiedzi na pytanie o prognozę (ogółem)
tabela_prognoza_ogolem <- cbos %>%
  filter(!is.na(prognoza)) %>%
  count(prognoza, sort = TRUE)

print("Prognoza - ogółem:")
print(tabela_prognoza_ogolem)

# 2. Ograniczenie do pesymistów (oceniających teraźniejszość "W złym")
tabela_prognoza_pesymisci <- cbos %>%
  filter(kierunek == "W złym") %>%
  filter(!is.na(prognoza)) %>%
  count(prognoza, sort = TRUE) %>%
  mutate(procent = 100 * n / sum(n))

print("Prognoza - tylko oceniający sytuację 'W złym':")
print(tabela_prognoza_pesymisci)
