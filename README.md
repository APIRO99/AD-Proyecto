# Proyecto Analisis de Datos
* Se opto por un modelo de estrella para nuestro DWH

## Dimensiones y Fact
![Diagrama de Dimensiones](/utils/DiagramaDimensiones.png)
Dimensiones creadas dentro de nuestro DWH con sus respectivas tablas. A la izquierda se encuentra la dimension que se genera y a la derecha las tablas que la conforman
* **Fact**: Orden + Detalle_Orden + Cotizacion + CotizacionDetalle
* **StatusOrden**: StatusOrden
* **Clientes**: Clientes
* **Vehiculo**: Vehiculo
* **Aseguradora**: Aseguradoras
* **Planta**: PlantaReparacion
* **Descuento**: Descuento
* **Geografia**: Ciudad + Region + Pais
* **Partes**: Partes + Categoria + Linea
* **Origen**
* **Fecha**


## SCD
#### Diccionario de Tipos
* 0 => No deberia cambiar
* 1 => Puede cambiar pero el cambio es descartado
* 2 => Atributo Historico



### StatusOrden --DEV:PASS
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| ID_Batch                        |     1    |
| ID_SourceSystem                 |     1    |
| PrimerNombre                    |     1    |

### Clientes
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| ID_Batch                        |     0    |
| ID_SourceSystem                 |     0    |
| PrimerNombre                    |     1    |
| SegeundoNombre                  |     1    |
| PrimerApellido                  |     1    |
| SegundoApellido                 |     1    |
| Genero                          |     1    |
| CorreoCliente                   |     1    |
| Nacimiento                      |     0    |
| Direccion                       |     2    |

### Vehiculo
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| VIN_Patron                      |     0    |
| Anio                            |     0    |
| Marca                           |     1    |
| Modelo                          |     1    |
| SubModelo                       |     1    |
| Estilo                          |     1    |
| FechaCreacionVeh                |     0    |
| ID_Batch                        |     1    |
| ID_SourceSystem                 |     1    |

### Aseguradora
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| NombreAseguradora               |     2    |
| RowCreatedDate                  |     1    |
| Activa                          |     2    |
| ID_Batch                        |     1    |
| ID_SourceSystem                 |     1    |

### Planta  
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| CompanyNombre                   |     2    |
| Direccion                       |     1    |
| Direccion2                      |     1    |
| Ciudad                          |     2    |
| Estado                          |     1    |
| CodigoPostal                    |     2    |
| Pais                            |     1    |
| TelefonoAlmacen                 |     1    |
| FaxAlmacen                      |     1    |
| CorreoContacto                  |     1    |
| NombreContacto                  |     1    |
| TelefonoContacto                |     1    |
| TituloTrabajo                   |     1    |
| AlmacenKeystone                 |     1    |
| IDPredio                        |     1    |
| LocalizadorCotizacion           |     1    |
| FechaAgregado                   |     1    |
| IDEmpresa                       |     1    |
| ValidacionSeguro                |     1    |
| Activo                          |     2    |
| CreadoPor                       |     1    |
| ActualizadoPor                  |     1    |
| UltimaFechaActualizacion        |     1    |
| ID_Batch                        |     1    |
| ID_SourceSystem                 |     1    |

### Descuento
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| NombreDescuento                 |     1    |
| PorcentajeDescuento             |     1    |
| ID_Batch                        |     1    |
| ID_SourceSystem                 |     1    |
	

### Geografia
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| ID_Pais                         |     1    |
| NombrePais                      |     1    |
| ID_Region                       |     1    |
| NombreRegion                    |     1    |
| ID_Ciudad                       |     1    |
| NombreCiudad                    |     1    |
| CodigoPostal                    |     2    |

### Partes
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| NombreParte                     |     2    |
| DescripcionParte                |     1    |
| PrecioParte                     |     2    |
| ID_Categoria                    |     1    |
| NombreCategoria                 |     2    |
| DescripcionCategoria            |     1    |
| ID_Linea                        |     1    |
| NombreLinea                     |     2    |
| DescripcionLinea                |     1    |

### Origen
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| Origen                          |     1    |
| ID_Batch                        |     1    |
| ID_SourceSystem                 |     1    |

### Fecha
### Cubo
El cubo  de tipo Olap utilizado posee los siguientes caracteristicas

* 10 dimensiones 

* 1 Table de hechos

 * Las dimesniones Partes, Geografia y Vehciulo poseen una jerarquia 
   * Fecha: Anio -> Quarter- > Mes
   * Geografia:  Ciudad -> Pais -> Region
   * Vehciulo -> Anio -> Marca -> Modelo
 
* Posee varios Measure Groups:
   * El promedio de la ventas "Sum{Toatal Orden)" dividido el el numero total de ordenes "Count(ID_Orden)
   * El total de cotizaciones e calcula por medio de [Measures].[Cantidad Cotizacion Detalle]*[Measures].[Precio Parte] que equivale a la cantidad de partes vendiadas por cotizacion multiplicado por el precio de las mismas
   * El total de partes, que se optiene por medio de [Measures].[Cantidad Detalle Orden - Orden]*[Measures].[Precio Parte] que represnta el total de partes vendidas en cada orden por el precio de dichas partes 
   * El promedio de ventas, cotizacion y Partes vendidas, cada promedio se optiene uttilizando los totales mencionados y dividiendolos por el valor total de ordenes y o cotizaciones dadas.

* El cubo tambien posee los siguientes KPI:

  * Prodcutos_Orden, el cual es calculado mediante [Measures].[Cantidad Detalle Orden - Orden]/[Measures].[Orden Count] que representa la cantidad de partes pedidas dividio el numero total de ordenes dandonoes una idea de el promedio de partes por orden este tiene una vlaor esperado de 3 partes por orden promedio
 
  * Existen 3 KPI que representa el promedio de ventas/cotizacion/parte vendidas vs el total de ordenes estos todos son calculados por medio de [Measures].* Total de cada tipo/[Measures].[Promedio *de cada tipo(ventas cotizaciones partes)] 
