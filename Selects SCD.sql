-- Selects SCD

-- FACT Ordenes



-- DIMENSION CLIENTES
SELECT
	CLIENT.ID_Cliente,
	CLIENT.PrimerNombre,
	CLIENT.SegundoNombre,
	CLIENT.PrimerApellido,
	CLIENT.SegundoApellido,
	CLIENT.Genero,
	CLIENT.Correo_Electronico,
	CLIENT.FechaNacimiento,
	CLIENT.Direccion
FROM dbo.Clientes AS CLIENT

-- DIMENSION STATUSORDEN
SELECT 
	SO.ID_StatusOrden,
	SO.NombreStatus
FROM DBO.StatusOrden AS SO


-- DIMENSION VEHICULO
SELECT 
	VEHICULO.VehiculoID,
	VEHICULO.VIN_Patron,
	VEHICULO.Anio,
	VEHICULO.Marca,
	VEHICULO.Modelo,
	VEHICULO.SubModelo,
	VEHICULO.Estilo,
	VEHICULO.FechaCreacion AS FechaCreacionVeh
FROM DBO.Vehiculo as VEHICULO

-- DIMENSION Aseguradora
SELECT
	ASEGURADORA.IDAseguradora,
	ASEGURADORA.NombreAseguradora,
	ASEGURADORA.RowCreatedDate,
	ASEGURADORA.Activa
FROM DBO.Aseguradoras as ASEGURADORA

-- DIMENSION Planta
SELECT
	PLANTA.IDPlantaReparacion,
	PLANTA.CompanyNombre,
	PLANTA.Direccion,
	PLANTA.Direccion2,
    PLANTA.Ciudad,
    PLANTA.Estado,
    PLANTA.CodigoPostal,
    PLANTA.Pais,
    PLANTA.TelefonoAlmacen,
    PLANTA.FaxAlmacen,
    PLANTA.CorreoContacto,
    PLANTA.NombreContacto,
    PLANTA.TelefonoContacto,
    PLANTA.TituloTrabajo,
    PLANTA.AlmacenKeystone,
    PLANTA.IDPredio,
    PLANTA.LocalizadorCotizacion,
    PLANTA.FechaAgregado,
    PLANTA.IDEmpresa,
    PLANTA.ValidacionSeguro,
    PLANTA.Activo,
    PLANTA.CreadoPor,
    PLANTA.ActualizadoPor,
    PLANTA.UltimaFechaActualizacion
FROM DBO.PlantaReparacion AS PLANTA

-- DIMENSION Origen
SELECT
	ORDEN.ID_Orden,
	CASE
		WHEN (COTIZACION.IDOrden is not null and ORDEN.ID_Cliente is null) THEN 'Aseguradora'
		WHEN (COTIZACION.IDOrden is null and ORDEN.ID_Cliente is not null) THEN 'Cliente Registrado'
		WHEN (COTIZACION.IDOrden is null and COTIZACION.IDOrden is null) THEN 'invitado'
		ELSE  'NA'
	END AS Origen
FROM Orden ORDEN
	left join Cotizacion COTIZACION ON COTIZACION.IDOrden = ORDEN.ID_Orden
	left join Clientes CLIENTES ON ORDEN.ID_Cliente = CLIENTES.ID_Cliente

-- DIMENSION PARTES
SELECT 
	PT.ID_Parte AS ID_Parte,
	PT.Nombre AS NombreParte,
	PT.Descripcion AS DescripcionParte,
	PT.Precio AS PrecioParte,
	CAT.ID_Categoria AS ID_Categoria,
	CAT.Nombre AS NombreCategoria,
	CAT.Descripcion AS DescripcionCategoria,
	LN.ID_Linea AS ID_Linea,
	LN.Nombre AS NombreLinea,
	LN.Descripcion AS DescripcionLinea
FROM 
	RepuestosWeb.dbo.Partes AS PT
	INNER JOIN RepuestosWeb.dbo.Categoria AS CAT  ON PT.ID_Categoria = CAT.ID_Categoria
	INNER JOIN RepuestosWeb.dbo.Linea AS LN  ON CAT.ID_Linea = LN.ID_Linea
-- DIMENSION DESCUENTO
SELECT 
	DISCOUNT.ID_Descuento,
	DISCOUNT.NombreDescuento,
	DISCOUNT.PorcentajeDescuento
FROM
dbo.Descuento AS DISCOUNT
-- DIMENSION GEOGRAFIA 
SELECT 
	COUNTRY.ID_Pais AS ID_Pais,
	COUNTRY.Nombre AS NombrePais,
	REG.ID_Region AS ID_Region,
	REG.Nombre AS NombreRegion,
	CITY.ID_Ciudad AS ID_Ciudad,
	CITY.Nombre AS NombreCiudad,
	CITY.CodigoPostal AS CodigoPostal
FROM
dbo.Ciudad AS CITY
INNER JOIN dbo.Region AS REG ON CITY.ID_Region = REG.ID_Region
INNER JOIN dbo.Pais AS COUNTRY ON REG.ID_Pais = COUNTRY.ID_Pais