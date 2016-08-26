MPAreport_html <- function(peces, invertebrados, comunidad, reserva, control) {
  
  library(rmarkdown)
  
  title <- paste("Análisis para", reserva, "en la comunidad pesquera", comunidad, sep = " ")
  
  render(input = "ReporteSAM.Rmd",
         params = list(title = title,
                       peces = peces,
                       invertebrados = invertebrados,
                       comunidad = comunidad,
                       reserva = reserva,
                       control = control
         ),
         output_file = paste('/Reporte', comunidad, reserva, '.html', sep=''),
         output_dir = getwd()
  )
}

library(MPAtools)

load("Datos/PecesSAM.RData")
load("Datos/InvertebradosSAM.RData")

Comunidad <- c("Maria Elena",
              "Maria Elena",
              "Maria Elena",
              "Punta Herrero",
              "Punta Herrero",
              "Punta Herrero",
              "Banco Chinchorro",
              "Banco Chinchorro",
              "Banco Chinchorro")
Reserva <- c("Cabezo",
            "El Gallinero",
            "Punta Loria",
            "Anegado de Chal",
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
  
  MPAreport_html(peces, invertebrados, comunidad, reserva, control)
  
}


function (data, reserve = NULL, control = NULL, error.bars = F) 
{
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  if (is.null(reserve) | is.null(control)) {
    stop("You must specify reserve and control sites")
  }
  colnames(data) <- c("Ano", "Zonificacion", "Sitio", "Transecto", 
                      "Indicador")
  data <- data %>% filter(Sitio == reserve | Sitio == control) %>% 
    group_by(Ano, Sitio) %>% mutate(SD = sd(Indicador, na.rm = T), 
                                    Indicator = mean(Indicador, na.rm = T))
  p <- ggplot(data, aes(x = Ano, y = Indicator, color = Zonificacion, 
                        pch = Sitio)) + geom_point() + geom_line() + theme_bw() + 
    scale_color_brewer(palette = "Set1")
  if (error.bars) {
    p <- p + geom_errorbar(aes(ymin = Indicator - SD, ymax = Indicator + 
                                 SD), width = 0.2)
  }
  p
}








