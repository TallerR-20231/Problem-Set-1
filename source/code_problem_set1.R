####PROBLEM SET 1####
##update: 3/6/2023, 13:40
##Integrantes:
  #Nicolas Lozano - 202021428
  #Samuel Gutierrez - 202111674

## Versión de r: 4.2.2

#Limpiar todo
rm(list = ls())

#PacMan y Librerias
install.packages("pacman")
install.packages("tidyverse")
require(pacman)

p_load(dplyr,
       tidyr,
       tibble,
       data.table,
       tidyverse,
       rio,
       skimr,
       janitor) 


#1. Vectores:
num_uno_cien = 1:100

#Crear Vector Solo Impares
bool_impar <- num_uno_cien%%2!=0
num_impares <- num_uno_cien[bool_impar]

#Crear Vector Solo Pares
bool_par <- !(num_uno_cien %in% num_impares)
num_pares <- num_uno_cien[bool_par]

#2. Importar/exportar bases de datos:
##Encuesta micronegocios DANE:

#2.1. Importar BD:
mi <- import("input/Modulo de identificacion.dta")
ms <- import("input/Modulo de sitio o ubicacion.dta")

#2.2. Exportar BD:
export(mi, "output/Modulo_identificacion.rds")
export(ms, "output/Modulo_ubicacion.rds")

#3. Generar variables
##Variable sobre identificacion:
mi$bussiness_type <- ifelse(mi$GRUPOS4 == "01", "Agricultura", 
                            ifelse(mi$GRUPOS4 == "02", "Industria Manufacturera",
                            ifelse(mi$GRUPOS4 == "03", "Comercio", 
                            ifelse(mi$GRUPOS4 == "04", "Servicios", NA))))

## Variable sobre ubicacion
ms$local <- ifelse(ms$P3053 == 6 | ms$P3053 == 7, 1, NA)
  
#4. Eliminar filas columnas de un conjunto de datos
#Dejar solo observaciones de industria manufacturera.
mi <- subset(mi, mi$GRUPOS4 == "02")

#Seleccionar variables de objeto ubicacion:
ms <- select(ms, DIRECTORIO, SECUENCIA_P, SECUENCIA_ENCUESTA, P3054, P469,
             COD_DEPTO, F_EXP)

#Seleccionar variables de objeto identificacion:
mi <- select(mi, DIRECTORIO, SECUENCIA_P, SECUENCIA_ENCUESTA, P35, P241, P3032_1,
             P3032_2, P3032_3, P3033, P3034, bussiness_type)

#5. Juntar ambas bases de datos:
bd_total <- inner_join(mi, ms, 
                       by=c("DIRECTORIO", "SECUENCIA_P", "SECUENCIA_ENCUESTA"))

#6. Estadisticas descriptivas conjunto de datos:

#Tablas:

##a. Estadisticas descriptivas de los meses en el Negocio
bd_total %>% select(P3034) %>% summary()

##b. Estadisticas descriptivas de los meses en el negocio, la edad del propietario
##Segun el numero de trabajadores remunerados
bd_total %>% 
group_by(P3032_1) %>% 
summarise(promedio_meses = mean(P3034, na.rm = T),
          mediana_meses = median(P3034, na.rm = T),
          promedio_edad=mean(P241, na.rm = T),
          mediana_edad = median(P241, na.rm = T))

##c. Estadisticas descriptivas del numero de meses en el negocio y el numero
##de trabajadores remunerados segun el sexo.
bd_total %>% 
  group_by(P35) %>% 
  summarise(promedio_meses = mean(P3034, na.rm = T),
            mediana_meses = median(P3034, na.rm = T),
            promedio_trabajadores=mean(P3032_1, na.rm = T),
            mediana_trabajadores = median(P3032_1, na.rm = T)) %>%
  pivot_longer(cols = ends_with(c("meses","trabajadores")),  
               names_to = "variable", 
               values_to = "value")

##d. Estadisticas descriptivas numero de de trabajadores remunerados segun 
##visibilidad al publico
bd_total %>% 
  group_by(P469) %>% 
  summarise(promedio_trabajadores = mean(P3032_1, na.rm = T),
            mediana_trabajadores = median(P3032_1, na.rm = T)) %>%
  pivot_longer(cols = ends_with(c("trabajadores")),  
               names_to = "variable", 
               values_to = "value")

#Graficas:
