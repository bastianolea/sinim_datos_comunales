library(dplyr)
library(readxl)
library(purrr)
library(janitor)
library(tidyr)
library(stringr)

# lista con nombres de comunas
cut_comunas <- read.csv2("comunas_chile_cut.csv") |> 
  mutate(cut_comuna = as.character(cut_comuna))

# vector con nombres de archivos descargados desde plataforma de sinim, una sola variable por archivo, puede ser un año o varios (para tapar datos faltantes)
archivos <- dir("datos_corregidos")

# loop por cada archivo descargado de sinim
datos_sinim <- map(archivos, ~{
  message(.x)
  
  # cargar archivo
  archivo <- paste0("datos_corregidos/", .x) |>
    read_excel()
  
  # obtener el nombre de la variable desde una de las celdas
  nombre_variable <- archivo[3][[1]][1]
  
  # limpiar archivos y pivotar a long
  archivo_1 <- archivo |> 
    row_to_names(2) |> 
    clean_names() |> 
    select(-municipio) |> 
    pivot_longer(cols = starts_with("x"), names_to = "año", values_to = "valor") |> 
    mutate(año = str_remove(año, "x"),
           valor = as.numeric(valor))
  
  # rellenar datos faltantes con años anteriores
  archivo_2 <- archivo_1 |> 
    fill(valor, .direction = "updown") |> 
    group_by(codigo) |> 
    slice_max(año) |> 
    ungroup()
  
  # agregar nombres de comunas
  archivo_3 <- archivo_2 |> 
    left_join(cut_comunas, by = c("codigo" = "cut_comuna")) |> 
    mutate(variable = nombre_variable)
  
  return(archivo_3)
})
# retorna una lista

# volver a obtener nombres de variables
variables_lista <- datos_sinim |> 
  map(~select(.x, variable) |> pull() |> unique()) |> 
  unlist()

# nombrar la lista
names(datos_sinim) <- variables_lista

datos_sinim

# guardar
saveRDS(datos_sinim, "datos_sinim.rds", compress = F)
