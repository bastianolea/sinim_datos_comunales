library(tidyverse)
source("funciones.R")

variables <- sinim_obtener_variables()

# ver todas las variables disponibles
# variables |> distinct(area, subarea) |> print(n=Inf)

# definir variables a obtener
variables_id <- variables |> 
  # slice(1:10) |> 
  pull(code)

# obtener lista con todos los municipios
municipios <- sinim_obtener_municipios()

# definir municipios
municipios_id <- municipios |> 
  # slice(1:10) |> 
  pull(id_municipio)

message(paste("obteniendo", length(variables_id), "variables para", length(municipios_id), "municipios"))

# realizar solicitud
datos_sinim <- sinim_obtener_datos(
  years            = c(2022:2023),
  var_codes        = variables_id,
  municipios       = municipios_id,
  parallel_workers = 8
)
# 1.2 horas para 2 años de todas las variables * municipios

datos_sinim

datos_sinim |> 
  distinct(variable, area, subarea)

datos_sinim |> 
  distinct(municipio)


# guardar ----
# datos_sinim |> readr::write_csv2("datos/sinim_2022_2023.csv")

datos_sinim |> arrow::write_parquet("datos/sinim_2022_2023.parquet")
