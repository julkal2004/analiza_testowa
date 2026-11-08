#fajka przekazuje tabele dane do kolejnej funkcji, select wybiera z tabelki tylko określone kolumny i ogranciza widok do 5 pierwszych wierszy
dane %>%
  select(Title, Runtime, IMDb.Score, Release.Date) %>%
  head(5)

#Tabela zawierająca pierwsze 5 wierszy i wszystkie oryginalne kolumny z wyjątkiem 5 usuniętych (linki, obrazy, plakaty i zwiastuny).
dane %>%
  select(-Netflix.Link, -IMDb.Link, -Image, -Poster, -TMDb.Trailer) %>%
  head(5)

#Tabela z pierwszymi 5 wierszami i pierwszymi 10 kolumnami występującymi w zbiorze w kolejności od lewej do prawej.
dane %>%
  select(1:10) %>%
  head(5)

#Title:Runtime – operator dwukropka :  wybiera ciągły zakres od kolumny Title do kolumny Runtime włącznie na podstawie ich pozycji w tabeli. Wynik: Tabela z pierwszymi 5 wierszami i kolumnami Title, Genre, Tags, Languages, Series.or.Movie, Hidden.Gem.Score, Country.Availability, Runtime.
dane %>%
  select(Title:Runtime) %>%
  head(5)

#starts_with('IMDb') – funkcja pomocnicza dopasowująca wszystkie kolumny, których nazwa zaczyna się od ciągu znaków 'IMDb'. Wynik: Tabela z 10 wierszami zawierająca wyłącznie kolumny IMDb.Score, IMDb.Link oraz IMDb.Votes.
dane %>%
  select(starts_with('IMDb')) %>% 
  head(10)

#ends_with('Score') – funkcja pomocnicza wyciągająca kolumny kończące się słowem 'Score'. Wynik: Tabela z 10 wierszami obejmująca kolumny ocen: Hidden.Gem.Score, IMDb.Score, Rotten.Tomatoes.Score i Metacritic.Score
dane %>%
  select(ends_with('Score')) %>% 
  head(10)

#contains('Date') – funkcja pomocnicza wybierająca kolumny zawierające słowo 'Date' w dowolnym miejscu nazwy. Wynik: Tabela z 10 wierszami zawierająca kolumny dat: Release.Date oraz Netflix.Release.Date.
dane %>%
  select(contains('Date')) %>% 
  head(10)

#matches('^[a-z]{5,6}$') – dopasowuje kolumny przy użyciu wyrażenia regularnego (Regex). Szuka nazw złożonych wyłącznie z 5 lub 6 małych liter. Wynik: Tabela z 10 wierszami zawierająca kolumny spełniające ten wzorzec: Title, Genre, Writer, Actors, Image, Poster.
dane %>%
  select(matches('^[a-z]{5,6}$')) %>% 
  head(10)
#-matches('\\.') – znak - w połączeniu z matches('\\.') odrzuca wszystkie kolumny zawierające w swojej nazwie kropkę. Wynik: Tabela z 10 wierszami zawierająca tylko te kolumny, które nie mają w nazwie znaku kropki (np. Title, Genre, Tags, Languages, Runtime, Director, Writer, Actors, Boxoffice, Summary, Image, Poster).
dane %>%
  select(-matches('\\.')) %>% 
  head(10)

#select(IMDb.Score) – standardowe wyciągnięcie pojedynczej kolumny. Wynik: Ramka danych (tabela/tibble) składająca się z 1 kolumny i 10 wierszy z ocenami IMDb.
dane %>%
  select(IMDb.Score) %>% 
  head(10)

# dane %>%
#   select(IMDb.Score) %>%
#   unlist(use.names = FALSE)

#pull(IMDb.Score) – wyciąga wartości kolumny i przekształca je w jednowymiarową strukturę danych (zamiast tabeli). Wynik: Wektor numeryczny zawierający 10 pierwszych ocen: [1] 7.9 5.8 7.4 7.5 6.7 6.6 6.2 7.6 7.7 8.4.
dane %>%
  pull(IMDb.Score) %>% 
  head(10)

#pull(IMDb.Score, Title) – pierwszy argument wyciąga wartości (oceny), a drugi argument przypisuje im etykiety/nazwy pochodzące z kolumny Title. Wynik: Nazwany wektor numeryczny, w którym każda ocena ma przypisany odpowiadający jej tytuł produkcji (np. pod nagłówkiem Lets Fight Ghost znajduje się wartość 7.9).
dane %>%
  pull(IMDb.Score, Title) %>% 
  head(10)
