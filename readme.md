## Datos SINIM

Obtención y procesamiento de datos en lote desde el [Sistema de Información Municipal (SINIM)](https://datos.sinim.gov.cl) de la Subsecretaría de Desarrollo Regional y Administrativo (Subdere).

El objetivo es poder obtener múltiples variables para múltiples comunas, o bien, todos los datos del sistema, de forma reproducible y automatizada. Para esto se dispone el script `obtener_datos_api.R`, que permite obtener datos para las variables que se indiquen, para una o varias municipalidades.

### Scripts
El script `obtener_datos_api.R` muestra cómo obtener 10 variables para 10 comunas, y puede modificarse para obtener los datos que se necesiten.

### Funciones
`sinim_obtener_variables()` obtiene una tabla con todas las variables disponibles, la cual puede filtrarse para extraer los códigos de variables (`code`) que se desean obtener.
`sinim_obtener_municipios()` obtiene una con todos los municipios del sistema, ya sea para obtener el id interno de cada municipio, o el código único territorial (CUT) de cada uno.

`sinim_obtener_datos()` permite entregarle años, variables y municipios, y realiza la obtención de los datos. Pueden entregarse años, variables y municipios simultáneos, de modo que es posible extraer múltiples variables de múltiples municipios en una sola expresión.

### Datos
En la carpeta `datos` se encuentra un archivo formato Arrow (`.parquet`) que contiene los datos de todas las variables, para todas las comunas, para los años 2022 y 2023.

----

El código de obtención de los datos fue desarrollado por [Rony Rodríguez-Ramírez](https://gist.github.com/RRMaximiliano/ee65369679047baea7093af43d2434e6), en base al paquete de R [{sinimR}](https://github.com/robsalasco/sinimr).
