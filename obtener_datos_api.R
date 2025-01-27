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

# revisar variables
datos_sinim |> 
  distinct(variable, area, subarea)

# revisiar municipios
datos_sinim |> 
  distinct(municipio, municipio_name)

datos_sinim |> distinct(unit)  

# agregar códigos únicos territoriales
datos_sinim_2 <- datos_sinim |> 
  left_join(municipios |> select(id_municipio, cut_comuna = idLegal),
            by = join_by(municipio == id_municipio))

# limpieza
datos_sinim_3 <- datos_sinim_2 |> 
  # sacar columnas irrelevantes
  select(-class_type, -col_info) |> 
  # reordenar columnas de municipio
  select(-municipio) |> 
  rename(municipio = municipio_name) |> 
  relocate(municipio, cut_comuna, contains("year"), .before = var_code) |> 
  # limpiar variables
  mutate(unit = str_trim(unit)) |> 
  # convertir cifras a numérico
  mutate(value = parse_number(value, locale = locale(decimal_mark = ",", grouping_mark = ".")))

# renombrar
datos_sinim_4 <- datos_sinim_3 |> 
  rename(año_id = sinim_year_code,
         año = user_year,
         variable_id = var_code,
         variable_desc = description,
         unidad = unit,
         valor = value)
  
# guardar ----
datos_sinim_4 |> arrow::write_parquet("datos/sinim_2022_2023.parquet")
