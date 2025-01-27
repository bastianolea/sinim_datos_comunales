library(tidyverse)
source("funciones.R")

variables <- sinim_obtener_variables()

variables |> distinct(area, subarea) |> print(n=Inf)

variables_educacion <- variables %>%
  filter(area == "03.  EDUCACION MUNICIPAL")

# definit variables a obtener
variables_id <- variables$code[1:10]

# obtener lista con todos los municipios
municipios <- sinim_obtener_municipios_todos()

# definir municipios
municipios_id <- municipios |> 
  slice(1:10) |> 
  pull(id_municipio)

message(paste("obteniendo", length(variables_id), "variables para", length(municipios_id), "municipios"))

# realizar solicitud
datos_sinim <- sinim_obtener_datos(
  years            = c(2018:2023),
  var_codes        = variables_id,
  municipios       = municipios_id,
  parallel_workers = 4
)

datos_sinim

datos_sinim |> 
  distinct(variable, area, subarea)
