library(tidyverse)
library(naniar)
library(psych)
library(misty)
library(nhanesA)
library(purrr)

# ETAP 1

#zmiana nazw zmiennych
dane_wybrane <- dane%>%
  select(
    # Identyfikator i demografia
    id = SEQN,
    wiek = RIDAGEYR,
    plec = RIAGENDR,
    pochodzenie_etniczne = RIDRETH3,
    wyksztalcenie = DMDEDUC2,
    stan_cywilny = DMDMARTZ,
    wskaznik_dochodow = INDFMPIR,
    status_badania_mec = RIDSTATR,
    
    # Zdrowie i metabolizm
    bmi = BMXBMI,
    cholesterol_total = LBXTC,
    cholesterol_hdl = LBDHDD,
    hba1c_pct = LBXGH,
    glukoza_na_czczo = LBXGLU,
    nadcisnienie_diagnoza = BPQ020,
    wysoki_cholesterol_diagnoza = BPQ080,
    cukrzyca_diagnoza = DIQ010,
    
    # Sen
    sen_robocze_h = SLD012,
    sen_weekend_h = SLD013,
    zasypianie_robocze = SLQ300,
    budzenie_robocze = SLQ310,
    zasypianie_weekend = SLQ320,
    budzenie_weekend = SLQ330,
    
    # Praca
    status_pracy = OCD150,
    godziny_pracy = OCQ180,
    praca_pelny_etat = OCQ210,
    
    # Samopoczucie / PHQ-9
    phq_01 = DPQ010,
    phq_02 = DPQ020,
    phq_03 = DPQ030,
    phq_04 = DPQ040,
    phq_05 = DPQ050,
    phq_06 = DPQ060,
    phq_07 = DPQ070,
    phq_08 = DPQ080,
    phq_09 = DPQ090,
    trudnosci_przez_objawy = DPQ100
  )

# Sprawdzenie liczby braków - po wybraniu konkretnych zmiennych mamy 152407 (spadek z ~53,4% do ~36,5%, co jest 
# również spowodowane wybraniem zmiennych dla węższych grup)
sum(is.na(dane_wybrane))

# kontrola które zmienne "generują" najwięcej braków - na wykresie widać wyraźnie że zmienna praca_pelny_etet ma
# ok. 10 tys. braków danych
dane_wybrane%>%
  gg_miss_var()

# wyrzucenie zmiennej praca_pelny_etat z powodu prawie 90% NA oraz znikomej przydatnosci dla późniejszych analiz
dane_do_zmian <- dane_wybrane%>%
  select(-praca_pelny_etat)

# xxxxxxxxxxxxxxxxxxxxxxxxxxx

# ETAP 2

# Kolejny krok to weryfikacja typów danych w poszczególnych zmiennych
glimpse(dane_do_zmian)

# Wybór unikalnych (unique) wartości z każdej kolumny, które są factorem albo characterem i zmiana tych wartości na 
# character dzięki czemu można je sortować alfabetycznie
dane_do_zmian%>%
  select(where(is.factor), where(is.character), -starts_with("zasypianie_robocze"), -starts_with( "budzenie_robocze"), -starts_with("zasypianie_weekend"), -starts_with("budzenie_weekend"))%>%
  lapply(function(x) sort(unique(as.character(x)), na.last = T))

