library(tidyverse)
library(naniar)
library(psych)
library(misty)
install.packages("misty")

dane <- nhanes_2021_2023_raw

#patrzymy ile mamy braków danych
sum(is.na(nhanes_2021_2023_raw))

#to samo ale z naniar
n_miss(dane)

#To super przydatne do raportów, żeby było ładnie - dzięki temu w zrenderowanym (!) raporcie będzie na żywo zmieniane jakieś rzeczey
Liczba braków danych to `r n_miss(dane)`

#procent braków danych we wszystkich danych
pct_miss(dane)

#wizualizacja na temat 
dane%>%
  select(101:125)%>%
  gg_miss_var()

#mcar czyli missing completly at random - ogólnie troche nie działa ale trzeba przekodować bo na danych nominalnych nie działa
na.test(dane)

#wizualizacja shadowmapy - waże i przydatne!
dane%>%
  select(1:30)%>%
  vis_miss(warn_large_data = F)

#pokazujemy braki dla jakiegoś factora
dane%>%
  select(1:30)%>%
  gg_miss_fct(fct= RIDEXPRG)

#W raporcie uwzględnić wyjaśnienie dlaczego skorzystaliśmy z takiej metody imputacji braków danych