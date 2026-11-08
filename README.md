# analiza_testowa
Zajecia 25.10.26

## 1. Konfiguracja i workflow zespołowy (Git & GitHub) — [2 pkt]

Aby uzyskać maksymalną liczbę punktów za pracę zespołową i uniknąć błędu kasowania historii, przyjmijcie ścisły workflow Git:

* **Inicjalizacja repozytorium:** Jedna osoba tworzy publiczne repozytorium na GitHubie z plikami `.gitignore` (skonfigurowanym dla R) oraz `README.md`.
* **Struktura gałęzi (Branching):** Brak bezpośrednich commitów do gałęzi `main`. Utwórzcie gałęzie funkcjonalne (np. `feature/data-wrangling`, `feature/visualizations`, `feature/statistical-tests`).
* **Przepływ zmian (PR & Code Review):** Wprowadzajcie zmiany poprzez Pull Requesty. Każdy PR powinien być przejrzany i zaakceptowany przez co najmniej jednego innego członka zespołu przed scaleniem (`merge`).
* **Zasada bezpiecznej pracy z R-Markdown:** Na gałęziach roboczych commitujcie wyłącznie plik `.Rmd` oraz skrypty. Plik wyjściowy (HTML/PDF) generujcie i scalajcie na samym końcu na gałęzi `main`, aby zapobiec konfliktom w plikach binarnych/HTML.
* **Historia commitów:** Przypisujcie przejrzyste komunikaty commitów (np. `feat: add chi-square test for Walc and romantic`, `style: formatting knitr tables`).

---

## 2. Architektura dokumentu R-Markdown i estetyka — [3 pkt]

Struktura wizualna i techniczna dokumentu powinna być czytelna i profesjonalna:

* **Nagłówek YAML:** Włączcie interaktywny spis treści, numerację sekcji oraz ukrywanie kodu z możliwością podglądu.
```yaml
---
title: "Analiza wpływu spożycia alkoholu na wyniki w nauce studentów"
author: "Nazwa Zespołu / Imiona i Nazwiska"
date: "`r Sys.Date()`"
output:
  html_document:
    theme: flatly
    highlight: tango
    toc: true
    toc_float: true
    number_sections: true
    code_folding: show
---

```


* **Ustawienia globalne knitr:** Na początku pliku umieśćcie chunk konfiguracyjny, wyłączający ostrzeżenia i komunikaty w gotowym raporcie:
```r
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE, fig.align = "center", fig.width = 8, fig.height = 5)
library(tidyverse)
library(kableExtra)
library(ggcorrplot)
library(car)

```


```

```


* **Formatowanie tabel:** Wyniki analiz opisowych i testów prezentujcie za pomocą `knitr::kable()` dopasowanego stylistycznie przez `kableExtra::kable_styling()`.

---

## 3. Plan treści raportu (Krok po kroku)

### Sekcja 1: Wprowadzenie i hipotezy badawcze

* **Opis danych:** Opis zbioru *Student Alcohol Consumption* (pochodzącego z dwóch kursów: matematyki `student-mat.csv` oraz języka portugalskiego `student-por.csv`).
* **Cel analizy:** Zbadanie czynników społeczno-demograficznych i naukowych wpływających na spożycie alkoholu oraz ocena wpływu alkoholu na końcowe wyniki w nauce (`G3`).
* **Hipotezy badawcze:**
* **H1:** Istnieje istotna statystycznie ujemna korelacja między spożyciem alkoholu w weekendy (`Walc`) a oceną końcową (`G3`).
* **H2:** Studenci mieszkający w miastach (`address = 'U'`) lub posiadający większą swobodę po zajęciach (`goout`) wykazują wyższe spożycie alkoholu.
* **H3:** Sytuacja rodzinna (wykształcenie rodziców `Medu`/`Fedu`, jakość relacji `famrel`) różnicuje poziom absencji (`absences`).



---

### Sekcja 2: Data Cleansing & Wrangling — [3 pkt]

* **Import i scalenie danych:** Wczytanie zbiorów `student-mat.csv` oraz `student-por.csv`. Opcjonalne połączenie danych z dodaniem zmiennej identyfikującej przedmiot.
* **Weryfikacja spójności:** Sprawdzenie braku danych (`sum(is.na(data))`), usunięcie duplikatów.
* **Konwersja typów zmiennych:** Zamiana zmiennych tekstowych na kategoryczne (`factor`) oraz przypisanie etykiet (np. `sex`: 'F' -> 'Kobieta', 'M' -> 'Mężczyzna'; `Dalc`/`Walc`: 1 -> 'Bardzo niskie', ..., 5 -> 'Bardzo wysokie').
* **Inżynieria cech (Feature Engineering):**
* `Alkohol_Tot` = średnia lub ważona suma z `Dalc` (spożycie w tygodniu) i `Walc` (spożycie w weekendy).
* `G_Avg` = średnia ocen ze wszystkich okresów `(G1 + G2 + G3) / 3`.
* `Alkohol_Kat` = zmienna dyskretna dzieląca uczniów na grupy: "Niskie spożycie" vs "Wysokie spożycie".



---

### Sekcja 3: Analiza Opisowa — [4 pkt]

* **Charakterystyka próby:** Liczbowe podsumowanie podstawowych zmiennych (wiek, płeć, miejsce zamieszkania, wielkość rodziny).
* **Miary położenia i rozproszenia:** Obliczenie średniej, mediany, odchylenia standardowego, IQR oraz skośności dla zmiennych ciągłych (`G3`, `absences`, `age`).
* **Tabele krzyżowe:**
* Zestawienie `Walc` (spożycie w weekendy) w podziale na płeć (`sex`).
* Zestawienie `Dalc` w podziale na czas poświęcany na naukę (`studytime`).
* Wyliczenie udziałów procentowych w obrębie podgrup.



---

### Sekcja 4: Wizualizacja Danych — [4 pkt]

Wykorzystajcie spójną paletę kolorystyczną (np. `scale_fill_viridis_d()` lub `scale_color_brewer()`) oraz czytelne etykiety (`labs()`).

1. **Rozkład spożycia alkoholu:** Wykresy słupkowe porównujące `Dalc` i `Walc` w rozbiciu na płeć.
2. **Wpływ alkoholu na wyniki:** Wykresy pudełkowe (boxploty) przedstawiające ocenę końcową `G3` w zależności od kategorii `Walc` oraz `Dalc`.
3. **Relacja absencji z ocenami:** Wykres punktowy z szumem (`geom_jitter()`) oraz nałożoną linią trendu regresji (`geom_smooth(method = "lm")`) relacji między `absences` a `G3`.
4. **Macierz korelacji:** Heatmapa korelacji Pearsona/Spearmana dla zmiennych numerycznych (`G1`, `G2`, `G3`, `absences`, `studytime`, `Dalc`, `Walc`, `famrel`, `freetime`, `goout`).

---

### Sekcja 5: Wnioskowanie Statystyczne — [4 pkt]

Wykonajcie minimum 3 różne testy statystyczne wraz ze weryfikacją założeń:

* **Test 1: Test $\chi^2$ (Chi-kwadrat) niezależności**
* *Pytanie:* Czy poziom spożycia alkoholu w weekendy (`Walc_kat`) zależy od płci (`sex`) lub przebywania w związku (`romantic`)?
* *Analiza:* Weryfikacja założeń o minimalnej liczebności oczekiwanej w komórkach tabeli.


* **Test 2: Test t-Studenta dla prób niezależnych (lub test Manna-Whitneya)**
* *Pytanie:* Czy studenci o niskim spożyciu alkoholu osiągają istotnie wyższe oceny końcowe (`G3`) niż studenci o wysokim spożyciu?
* *Weryfikacja założeń:* Test Shapiro-Wilka (normalność rozkładu w grupach) oraz test Levene'a (jednorodność wariancji). W przypadku braku normalności – użycie testu Manna-Whitneya (Wilcoxona).


* **Test 3: Jednoczynnikowa analiza wariancji (ANOVA) / Test Kruskala-Wallisa**
* *Pytanie:* Czy średnia liczba absencji (`absences`) różni się w zależności od poziomu wykształcenia matki (`Medu`) lub wyjść ze znajomymi (`goout`)?
* *Analiza post-hoc:* Test Tukeya lub HSD Dunn-Bonferroni dla identyfikacji konkretnych różnic międzygrupowych.


* **Model Regresji Liniowej (Wielorakiej)**
* *Model:* $G3 = \beta_0 + \beta_1 \cdot studytime + \beta_2 \cdot failures + \beta_3 \cdot absences + \beta_4 \cdot Walc + \varepsilon$.
* *Interpretacja:* Ocena istotności poszczególnych zmiennych ($p$-value), dopasowanie modelu ($R^2$, Skorygowany $R^2$) oraz analiza reszt.



---

### Sekcja 6: Podsumowanie i wnioski końcowe

* **Weryfikacja hipotez:** Synteza uzyskanych wyników i jednoznaczne odniesienie się do hipotez H1, H2, H3.
* **Wnioski aplikacyjne:** Praktyczne rekomendacje na podstawie wyników (np. identyfikacja czynników ryzyka spadek wyników w nauce).
* **Ograniczenia projektu:** Omówienie specyfiki próby, błędów samoopisu (Self-reporting bias przy pytaniach o alkohol) oraz potencjalnych kierunków dalszych badań.

---

## 4. Macierz punktacji i kontrola wymagań

| Sekcja / Kryterium | Cel | Kluczowe elementy do sprawdzenia przed oddaniem |
| --- | --- | --- |
| **Praca zespołowa (0-2 pkt)** | 2 pkt | Historia commitów od każdego członka, brak kasowania branchy, brak błędów w merge. |
| **Estetyka i R-Markdown (0-3 pkt)** | 3 pkt | Działający YAML, spójny szablon CSS/theme, brak surowego wyjścia R (`warning=F`, `message=F`), sformatowane tabele. |
| **Data Cleansing (0-3 pkt)** | 3 pkt | Czyszczenie danych, zmiana typów na `factor`, stworzenie nowych zmiennych syntetycznych (`Alkohol_Tot`, `G_Avg`). |
| **Wizualizacja danych (0-4 pkt)** | 4 pkt | Estetyczne wykresy w `ggplot2`, poprawne etykiety, palety kolorów, heatmapa korelacji, wykresy pudełkowe i rozrzutu. |
| **Analiza opisowa (0-4 pkt)** | 4 pkt | Tabela statystyk zbiorczych, miary położenia/rozproszenia, tabele dwudzielne z procentami. |
| **Wnioskowanie statystyczne (0-4 pkt)** | 4 pkt | Minimum 2-3 testy statystyczne, weryfikacja założeń (Shapiro-Wilk, Levene), model regresji liniowej z interpretacją. |
| **Razem** | **20 pkt** | **Wymagane minimum do zaliczenia: 10 punktów.** |
