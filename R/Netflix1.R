library(tidyverse)
library(dplyr)
library(tidyr)
library(stringr)

#ten fragment danych używam tylko po to, żeby sprawdzić czy poprawny mam kod, jeżeli zadziała to przed wysłaniem do Julki poprawiam go
library(readr)
knitr::opts_chunk$set(echo = TRUE)
download.file("https://raw.githubusercontent.com/kflisikowski/ds/master/netflix-dataset.csv?raw=true", destfile ="dane.csv",mode="wb")
dane<-read.csv(file="dane.csv",encoding ="UTF-8",header=TRUE,sep = ",")
attach(dane)

#Kod przekazuje zbiór (%>%), filtruje tylko filmy (filter), wyszukuje reżysera (str_detect), konwertuje tekst na datę (mutate), usuwa braki dat (drop_na), sortuje chronologicznie (arrange), ogranicza widok do 4 kolumn (select) i pobiera 1 najstarszy wynik (head(1)).
dane %>%
  filter(Series.or.Movie == "Movie") %>%
  filter(str_detect(Director, "Woody Allen")) %>%
  mutate(Release = as.Date(Release.Date, format = "%d/%m/%y")) %>%
  drop_na(Release) %>%
  arrange(Release) %>%
  select(Title, Director, Release.Date, IMDb.Score) %>%
  head(1)
