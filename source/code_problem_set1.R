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
bool_impar <- num_uno_cien%%2!=0
num_impares <- num_uno_cien[bool_impar]
bool_par <- !(num_uno_cien %in% num_impares)
num_pares <- num_uno_cien[bool_par]

#2. Importar/exportar bases de datos:
##Encuesta micronegocios DANE:

#2.1. Importar:
mi <- import('input/Módulo de identificación.dta')
ms <- import('input/Módulo de sitio o ubicación.dta')

#2.2. Exportar:
export(mi, "output/Modulo_identificación.rds")
export(ms, "output/Modulo_ubicación.rds")
