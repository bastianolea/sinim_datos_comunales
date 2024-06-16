library(purrr)

# los archivos descargados de sinim vienen en un formato excel medio raro,
# así que hay que abrirlos con excel y guardarlos, de lo contrario usar este comando para arreglarlos con libreOffice

archivos <- dir("datos")

map(archivos, ~system(paste0("/Applications/LibreOffice.app/Contents/MacOS/soffice  --headless --convert-to xls --outdir datos_corregidos datos/", .x)))
