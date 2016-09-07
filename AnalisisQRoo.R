
library(MPAtools)

load("Datos/PecesSAM.RData")

load("Datos/InvertebradosSAM.RData")

invertebrados <- dplyr::filter(invertebrados, !GeneroEspecie == "Pterois volitans")

invertebrados$Zonificacion[invertebrados$Sitio == "El Faro (Control)"] = "Pesca"

Comunidad <- c("Maria Elena",
              "Maria Elena",
              "Maria Elena",
              "Punta Herrero",
              "Punta Herrero",
              "Banco Chinchorro",
              "Banco Chinchorro",
              "Banco Chinchorro")
Reserva <- c("Cabezo",
            "El Gallinero",
            "Punta Loria",
            "El Faro",
            "Manchon",
            "Zona Nucleo Cayo Norte",
            "ZRP40 Cañones Norte",
            "ZRP40 Cañones Sur")
Control <- paste(Reserva, "(Control)", sep = " ")


for (i in 1:length(Comunidad)){
  
  comunidad <- Comunidad[i]
  reserva <- Reserva[i]
  control <- Control[i]
  
  print(i)
  
  MPAreport_html(peces, invertebrados, comunidad, reserva, control)
  
}








