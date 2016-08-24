library(tidyr)
library(dplyr)


###############################
#### limpieza de peces SAM ###
##############################

data(abnt)

datosp <- read.csv("~/GitHub/QRoo/Datos/SAM_PecesTransecto.csv", sep=";") %>%
  mutate(Talla = as.numeric(as.character(Talla)),
         Abundancia = as.numeric(as.character(Abundancia)))%>%
  mutate(id = paste(Dia, Mes, Ano, Sitio, Transecto)) %>%
  filter(!GeneroEspecie == " cabrilla bicolor")

datosp2 <- datosp %>%
  select(id, Genero, Especie, GeneroEspecie, Talla, Abundancia) %>%
  complete(id, nesting(Genero, Especie, GeneroEspecie), fill = list(Talla = NA, Abundancia = 0))

peces <- datosp %>%
  select(-GeneroEspecie, -Talla, -Abundancia, -Genero, -Especie) %>%
  group_by(id, Dia, Mes, Ano, Estado, Comunidad, Sitio, Latitud, Longitud, Habitat, Zonificacion, TipoProteccion, ANP, BuzoMonitor, HoraInicial, HoraFinal, ProfundidadInicial, ProfundidadFinal, Temperatura, Visibilidad, Corriente, Transecto) %>%
  summarize(N=n()) %>%
  select(-N) %>%
  left_join(datosp2, by ="id") %>%
  left_join(abnt, by = "GeneroEspecie") %>%
  mutate(a = as.numeric(as.character(a)),
         b = as.numeric(as.character(b)),
         NT = as.numeric(as.character(NT))) %>%
  as.data.frame()

peces$Sitio = as.character(peces$Sitio)
peces$Sitio[peces$Sitio == "ZRP40 Cañones Sur "] = "ZRP40 Cañones Sur"
peces$Sitio[peces$Sitio == "ZRP40 Cañones Sur (Control)  "] = "ZRP40 Cañones Sur (Control)"
peces$Sitio = as.factor(peces$Sitio)


save(peces, file = "Datos/PecesSAM.RData")

#############################################


######################################
#### limpieza de invertwbrados SAM ###
######################################

datosi <- read.csv("~/GitHub/QRoo/Datos/SAM_InvertebradosTransecto.csv", sep=";") %>%
  mutate(Abundancia = as.numeric(as.character(Abundancia)))%>%
  mutate(id = paste(Dia, Mes, Ano, Sitio, Transecto)) %>%
  filter(!GeneroEspecie == " ")

datosi2 <- datosi %>%
  select(id, Genero, Especie, GeneroEspecie, Abundancia) %>%
  complete(id, nesting(Genero, Especie, GeneroEspecie), fill = list(Abundancia = 0))

invertebrados <- datosi %>%
  select(-GeneroEspecie, -Abundancia, -Genero, -Especie) %>%
  group_by(id, Dia, Mes, Ano, Estado, Comunidad, Sitio, Latitud, Longitud, Habitat, Zonificacion, TipoProteccion, ANP, BuzoMonitor, HoraInicial, HoraFinal, ProfundidadInicial, ProfundidadFinal, Temperatura, Visibilidad, Transecto) %>%
  summarize(N=n()) %>%
  select(-N) %>%
  left_join(datosi2, by ="id")

save(invertebrados, file = "InvertebradosSAM.RData")

############################################
