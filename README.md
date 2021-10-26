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