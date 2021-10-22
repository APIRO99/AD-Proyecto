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


### Fact
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| DateKey                         |     0    |
| IDCotizacion                    |     0    |
| status                          |     0    |
| TipoDocumento                   |     0    |
| FechaCreacionCotizacion         |     0    |
| FechaModificacionCotizacion     |     0    |
| ProcesadoPor                    |     0    |
| IDAseguradora                   |     0    |
| AseguradoraSubsidiaria          |     0    |
| NumeroReclamo                   |     0    |
| IDPlantaReparacion              |     0    |
| OrdenRealizada                  |     0    |
| CotizacionRealizada             |     0    |
| CotizacionDuplicada             |     0    |
| procurementFolderID             |     0    |
| DireccionEntrega1               |     0    |
| DireccionEntrega2               |     0    |
| MarcadoEntrega                  |     0    |
| IDPartner                       |     0    |
| CodigoPostal                    |     0    |
| LeidoPorPlantaReparacion        |     0    |
| LeidoPorPlantaReparacionFecha   |     0    |
| CotizacionReabierta             |     0    |
| EsAseguradora                   |     0    |
| CodigoVerificacion              |     0    |
| IDClientePlantaReparacion       |     0    |
| FechaCreacionRegistro           |     0    |
| IDRecotizacion                  |     0    |
| PartnerConfirmado               |     0    |
| WrittenBy                       |     0    |
| SeguroValidado                  |     0    |
| FechaCaptura                    |     0    |
| IDOrden                         |     0    |
| Ruta                            |     0    |
| FechaLimiteRuta                 |     0    |
| TelefonoEntrega                 |     0    |
| NumLinea                        |     0    |
| OETipoParte                     |     0    |
| AltPartNum                      |     0    |
| AltTipoParte                    |     0    |
| ciecaTipoParte                  |     0    |
| partDescripcion                 |     0    |
| CantidadCotizacionDetalle       |     0    |
| PrecioListaOnRO                 |     0    |
| PrecioNetoOnRO                  |     0    |
| NecesitadoParaFecha             |     0    |
| VehiculoIDCotizacionDetalle     |     0    |
| FechaCreacion                   |     0    |
| FechaModificacion               |     0    |
| UsuarioCreacion                 |     0    |
| UsuarioModificacion             |     0    |
| ID_Batch                        |     0    |
| ID_SourceSystem                 |     0    |
| ID_Orden                        |     0    |
| ID_Cliente                      |     0    |
| ID_Ciudad                       |     0    |
| ID_StatusOrden                  |     0    |
| Total_Orden                     |     0    |
| Fecha_Orden                     |     0    |
| NumeroOrden                     |     0    |
| ID_DetalleOrden                 |     0    |
| ID_Parte                        |     0    |
| ID_Descuento                    |     0    |
| CantidadDetalleOrden            |     0    |
| VehiculoIDDetalleOrden          |     0    |



### StatusOrden
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| ID_Batch                        |     0    |
| ID_SourceSystem                 |     0    |
| PrimerNombre                    |     0    |

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
| Marca                           |     0    |
| Modelo                          |     0    |
| SubModelo                       |     0    |
| Estilo                          |     1    |
| FechaCreacionVeh                |     0    |
| ID_Batch                        |     0    |
| ID_SourceSystem                 |     0    |

### Aseguradora
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| IDAseguradora                   |     0    |
| NombreAseguradora               |     2    |
| RowCreatedDate                  |     0    |
| Activa                          |     2    |
| ID_Batch                        |     0    |
| ID_SourceSystem                 |     0    |

### Planta  
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| CompanyNombre                   |     2    |
| Direccion                       |     1    |
| Direccion2                      |     1    |
| Ciudad                          |     2    |
| Estado                          |     1    |
| CodigoPostal                    |     2    |
| Pais                            |     0    |
| TelefonoAlmacen                 |     1    |
| FaxAlmacen                      |     1    |
| CorreoContacto                  |     1    |
| NombreContacto                  |     1    |
| TelefonoContacto                |     1    |
| TituloTrabajo                   |     0    |
| AlmacenKeystone                 |     0    |
| IDPredio                        |     0    |
| LocalizadorCotizacion           |     0    |
| FechaAgregado                   |     1    |
| IDEmpresa                       |     0    |
| ValidacionSeguro                |     1    |
| Activo                          |     2    |
| CreadoPor                       |     1    |
| ActualizadoPor                  |     1    |
| UltimaFechaActualizacion        |     1    |
| ID_Batch                        |     0    |
| ID_SourceSystem                 |     0    |

### Descuento
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| ID_Descuento                    |     0    |
| NombreDescuento                 |     1    |
| PorcentajeDescuento             |     1    |
	

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
| ID_Parte                        |     0    |
| NombreParte                     |     0    |
| DescripcionParte                |     0    |
| PrecioParte                     |     0    |
| ID_Categoria                    |     0    |
| NombreCategoria                 |     0    |
| DescripcionCategoria            |     0    |
| ID_Linea                        |     0    |
| NombreLinea                     |     0    |
| DescripcionLinea                |     2    |

### Origen
| Atributo                        | Tipo SCD |
|          -------------          | :------: |
| Origen                          |     0    |
| ID_Batch                        |     0    |
| ID_SourceSystem                 |     0    |

### Fecha