install.packages("nhanesA")
library(nhanesA)
library(plyr)
library(dplyr)
library(purrr)

#Jeżeli któryś z pakietów nie będzie działał, należy skorzystać z tego co poniżej (ale najpewniej bedzie dobrze)
#remove.packages()
#install.packages()

#packageVesrion("nhanesA")

tabele <- c(
  "DEMO_L",                    # demografia, wagi próby
  "BMX_L",                     # pomiary ciała (BMI)
  "HDL_L", "TCHOL_L",          # cholesterol
  "BPQ_L", "MCQ_L",            # ciśnienie, choroby przewlekłe
  "DIQ_L", "GHB_L", "GLU_L",   # cukrzyca
  "SLQ_L",                     # sen
  "OCQ_L",                     # praca
  "DPQ_L", "HSQ_L"             # samopoczucie
)

#Zmień rok i dodaj może ze trzy okresy jeszcze
tabele <- c(
  "DEMO_L",                    # demografia, wagi próby
  "BMX_L",                     # pomiary ciała (BMI)
  "HDL_L", "TCHOL_L",          # cholesterol
  "BPQ_L", "MCQ_L",            # ciśnienie, choroby przewlekłe
  "DIQ_L", "GHB_L", "GLU_L",   # cukrzyca
  "SLQ_L",                     # sen
  "OCQ_L",                     # praca
  "DPQ_L", "HSQ_L"             # samopoczucie
)

#Stworzenie listy, w której nadajemy nazwy obiektom w "tabele"

lista <- map(set_names(tabele), nhanes)

#Usuwanie wag dla wszystkich zmiennych poza DEMO_L i HDL_L, żeby przy łączeniu nie powstały zdublowane kolumny

lista <- imap(lista, \(d, nazwa){
  if (nazwa %in% c("DEMO_L", "HDL_L")) d 
      else select(d, -starts_with("WT"))
})

dane <- reduce(lista, left_join, by = "SEQN")
saveRDS(dane, "data/nhanes_2021_2023_raw.rds")
