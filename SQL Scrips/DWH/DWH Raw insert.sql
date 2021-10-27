--PLanta
USE [RepuestosWebDWH]
GO

INSERT INTO [Dimension].[Planta]
           ([IDPlantaReparacion]
           ,[CompanyNombre]
           ,[Direccion]
           ,[Direccion2]
           ,[Ciudad]
           ,[Estado]
           ,[CodigoPostal]
           ,[Pais]
           ,[TelefonoAlmacen]
           ,[FaxAlmacen]
           ,[CorreoContacto]
           ,[NombreContacto]
           ,[TelefonoContacto]
           ,[TituloTrabajo]
           ,[AlmacenKeystone]
           ,[IDPredio]
           ,[LocalizadorCotizacion]
           ,[FechaAgregado]
           ,[IDEmpresa]
           ,[ValidacionSeguro]
           ,[Activo]
           ,[CreadoPor]
           ,[ActualizadoPor]
           ,[UltimaFechaActualizacion]
           ,[FechaInicioValidez]
           ,[FechaFinValidez]
           ,[FechaCreacion]
           ,[FechaModificacion]
           ,[UsuarioCreacion]
           ,[UsuarioModificacion]
           ,[ID_Batch]
           ,[ID_SourceSystem])
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
    PLANTA.UltimaFechaActualizacion,
	GETDATE(),
	Null,
	GETDATE(),
	Null,
	'ETL',
	Null,
	UNIQUEIDENTIFIER = NEWID(),
	'ssis'

FROM RepuestosWeb.DBO.PlantaReparacion AS PLANTA
GO


-- select * from RepuestosWebDWH.Dimension.Planta

--Geografia
USE [RepuestosWebDWH]
GO

INSERT INTO [Dimension].[Geografia]
           ([FechaInicioValidez]
           ,[FechaFinValidez]
           ,[FechaCreacion]
           ,[FechaModificacion]
           ,[UsuarioCreacion]
           ,[UsuarioModificacion]
           ,[ID_Batch]
           ,[ID_SourceSystem]
           ,[ID_Pais]
           ,[NombrePais]
           ,[ID_Region]
           ,[NombreRegion]
           ,[ID_Ciudad]
           ,[NombreCiudad]
           ,[CodigoPostal])
SELECT
	GETDATE(),
	Null,
	GETDATE(),
	Null,
	'ETL',
	Null,
	UNIQUEIDENTIFIER = NEWID(),
	'ssis',
	COUNTRY.ID_Pais AS ID_Pais,
	COUNTRY.Nombre AS NombrePais,
	REG.ID_Region AS ID_Region,
	REG.Nombre AS NombreRegion,
	CITY.ID_Ciudad AS ID_Ciudad,
	CITY.Nombre AS NombreCiudad,
	CITY.CodigoPostal AS CodigoPostal
FROM
RepuestosWeb.dbo.Ciudad AS CITY
INNER JOIN RepuestosWeb.dbo.Region AS REG ON CITY.ID_Region = REG.ID_Region
INNER JOIN RepuestosWeb.dbo.Pais AS COUNTRY ON REG.ID_Pais = COUNTRY.ID_Pais
GO
--Clientes
USE [RepuestosWebDWH]
GO

INSERT INTO [Dimension].[Clientes]
           ([FechaInicioValidez]
           ,[FechaFinValidez]
           ,[FechaCreacion]
           ,[FechaModificacion]
           ,[UsuarioCreacion]
           ,[UsuarioModificacion]
           ,[ID_Batch]
           ,[ID_SourceSystem]
           ,[ID_Cliente]
           ,[PrimerNombre]
           ,[SegeundoNombre]
           ,[PrimerApellido]
           ,[SegundoApellido]
           ,[Genero]
           ,[CorreoCliente]
           ,[Nacimiento]
           ,[Direccion])
     SELECT
	 GETDATE(),
	Null,
	GETDATE(),
	Null,
	'ETL',
	Null,
	UNIQUEIDENTIFIER = NEWID(),
	'ssis',
	CLIENT.ID_Cliente,
	CLIENT.PrimerNombre,
	CLIENT.SegundoNombre,
	CLIENT.PrimerApellido,
	CLIENT.SegundoApellido,
	CLIENT.Genero,
	CLIENT.Correo_Electronico,
	CLIENT.FechaNacimiento,
	CLIENT.Direccion
FROM RepuestosWeb.DBO.Clientes AS CLIENT
GO


-- select * from RepuestosWebDWH.Dimension.Clientes
--Status Orden
INSERT INTO [Dimension].[StatusOrden]
           ([ID_StatusOrden]
           ,[NombreStatus]
           ,[FechaCreacion]
           ,[FechaModificacion]
           ,[UsuarioCreacion]
           ,[UsuarioModificacion]
           ,[ID_Batch]
           ,[ID_SourceSystem])
     
SELECT 
	SO.ID_StatusOrden,
	SO.NombreStatus,
	GETDATE(),
	Null,
	'ETL',
	Null,
	UNIQUEIDENTIFIER = NEWID(),
	'ssis'
FROM RepuestosWeb.DBO.StatusOrden AS SO

GO

-- select * from RepuestosWebDWH.Dimension.StatusOrden

--Vehiculo
INSERT INTO [Dimension].[Vehiculo]
           ([VehiculoID]
           ,[VIN_Patron]
           ,[Anio]
           ,[Marca]
           ,[Modelo]
           ,[SubModelo]
           ,[Estilo]
           ,[FechaCreacionVeh]
           ,[FechaCreacion]
           ,[FechaModificacion]
           ,[UsuarioCreacion]
           ,[UsuarioModificacion]
           ,[ID_Batch]
           ,[ID_SourceSystem])
SELECT 
	VEHICULO.VehiculoID,
	VEHICULO.VIN_Patron,
	VEHICULO.Anio,
	VEHICULO.Marca,
	VEHICULO.Modelo,
	VEHICULO.SubModelo,
	VEHICULO.Estilo,
	VEHICULO.FechaCreacion,
	GETDATE(),
	Null,
	'ETL',
	Null,
	UNIQUEIDENTIFIER = NEWID(),
	'ssis'
FROM RepuestosWeb.DBO.Vehiculo as VEHICULO
GO

-- select * from RepuestosWebDWH.Dimension.Vehiculo

--Aseguradora
USE [RepuestosWebDWH]
GO

INSERT INTO [Dimension].[Aseguradora]
           ([IDAseguradora]
           ,[NombreAseguradora]
           ,[RowCreatedDate]
           ,[Activa]
           ,[FechaInicioValidez]
           ,[FechaFinValidez]
           ,[FechaCreacion]
           ,[FechaModificacion]
           ,[UsuarioCreacion]
           ,[UsuarioModificacion]
           ,[ID_Batch]
           ,[ID_SourceSystem])
SELECT
	ASEGURADORA.IDAseguradora,
	ASEGURADORA.NombreAseguradora,
	ASEGURADORA.RowCreatedDate,
	ASEGURADORA.Activa,
	GETDATE(),
	Null,
	GETDATE(),
	Null,
	'ETL',
	Null,
	UNIQUEIDENTIFIER = NEWID(),
	'ssis'
FROM RepuestosWeb.DBO.Aseguradoras as ASEGURADORA
GO

--Partes
INSERT INTO [Dimension].[Partes]
           ([FechaInicioValidez]
           ,[FechaFinValidez]
           ,[FechaCreacion]
           ,[FechaModificacion]
           ,[UsuarioCreacion]
           ,[UsuarioModificacion]
           ,[ID_Batch]
           ,[ID_SourceSystem]
           ,[ID_Parte]
           ,[NombreParte]
           ,[DescripcionParte]
           ,[PrecioParte]
           ,[ID_Categoria]
           ,[NombreCategoria]
           ,[DescripcionCategoria]
           ,[ID_Linea]
           ,[NombreLinea]
           ,[DescripcionLinea])
 SELECT 
 GETDATE(),
	Null,
	GETDATE(),
	Null,
	'ETL',
	Null,
	UNIQUEIDENTIFIER = NEWID(),
	'ssis',
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
GO

--Descuentos

INSERT INTO [Dimension].[Descuento]
           ([ID_Descuento]
           ,[NombreDescuento]
           ,[PorcentajeDescuento]
           ,[FechaCreacion]
           ,[FechaModificacion]
           ,[UsuarioCreacion]
           ,[UsuarioModificacion]
           ,[ID_Batch]
           ,[ID_SourceSystem])
SELECT 
	DISCOUNT.ID_Descuento,
	DISCOUNT.NombreDescuento,
	DISCOUNT.PorcentajeDescuento,
	GETDATE(),
	Null,
	'ETL',
	Null,
	UNIQUEIDENTIFIER = NEWID(),
	'ssis'
FROM
RepuestosWeb.dbo.Descuento AS DISCOUNT
GO

--Origen
USE [RepuestosWebDWH]
GO

INSERT INTO [Dimension].[Origen]
           ([ID_Orden]
           ,[Origen]
           ,[FechaCreacion]
           ,[FechaModificacion]
           ,[UsuarioCreacion]
           ,[UsuarioModificacion]
           ,[ID_Batch]
           ,[ID_SourceSystem])
SELECT
	ORDEN.ID_Orden,
	CASE
		WHEN (COTIZACION.IDOrden is not null and ORDEN.ID_Cliente is null) THEN 'Aseguradora'
		WHEN (COTIZACION.IDOrden is null and ORDEN.ID_Cliente is not null) THEN 'Cliente Registrado'
		WHEN (COTIZACION.IDOrden is null and COTIZACION.IDOrden is null) THEN 'invitado'
		ELSE  'NA'
	END AS Origen,
	GETDATE(),
	Null,
	'ETL',
	Null,
	UNIQUEIDENTIFIER = NEWID(),
	'ssis'
FROM RepuestosWeb.dbo.Orden ORDEN
	left join RepuestosWeb.dbo.Cotizacion COTIZACION ON COTIZACION.IDOrden = ORDEN.ID_Orden
	left join RepuestosWeb.dbo.Clientes CLIENTES ON ORDEN.ID_Cliente = CLIENTES.ID_Cliente

GO