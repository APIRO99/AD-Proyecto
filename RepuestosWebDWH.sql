DECLARE @EliminarDB BIT = 1;

--Eliminar BDD si ya existe y si @EliminarDB = 1
	if (((select COUNT(1) from sys.databases where name = 'RepuestosWebDWH')>0) AND (@EliminarDB = 1))
	begin
		EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'RepuestosWebDWH'
		use [master];
		ALTER DATABASE [RepuestosWebDWH] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE [RepuestosWebDWH]
		print 'RepuestosWebDWH ha sido eliminada'
	end
-- END

-- Crea DB y la selecciona
	CREATE DATABASE RepuestosWebDWH
	USE RepuestosWebDWH
	exec sp_changedbowner 'sa'
	GO
-- END


--User Defined Type
	--Enteros
		CREATE TYPE [UDT_SK] FROM INT --Tipo para SK entero: Surrogate Key
		CREATE TYPE [UDT_PK] FROM INT --Tipo para PK entero

	--Cadenas
		CREATE TYPE [UDT_VarcharLargo] FROM VARCHAR(600) --Tipo para cadenas largas
		CREATE TYPE [UDT_VarcharMediano] FROM VARCHAR(300) --Tipo para cadenas medianas
		CREATE TYPE [UDT_VarcharCorto] FROM VARCHAR(100) --Tipo para cadenas cortas
		CREATE TYPE [UDT_UnCaracter] FROM CHAR(1) --Tipo para char

	--Decimal
		CREATE TYPE [UDT_Decimal12.2] FROM DECIMAL(12,2) --Tipo Decimal 6,2
		CREATE TYPE [UDT_Decimal6.2] FROM DECIMAL(6,2) --Tipo Decimal 6,2
		CREATE TYPE [UDT_Decimal5.2] FROM DECIMAL(5,2) --Tipo Decimal 5,2
		CREATE TYPE [UDT_Decimal2.2] FROM DECIMAL(2,2) --Tipo Decimal 2,2

	--Fechas
		CREATE TYPE [UDT_DateTime] FROM DATETIME
	GO
--END

--Schemas para separar objetos
	CREATE SCHEMA Fact
	GO
	CREATE SCHEMA Dimension
	GO
--END


--------------------------------------------------------------------------------------------
-------------------------------MODELADO CONCEPTUAL------------------------------------------
--------------------------------------------------------------------------------------------
	--Tablas Dimensiones
		--DIMENSION FECHA
		CREATE TABLE Dimension.Fecha (
			DateKey [UDT_PK] PRIMARY KEY,
			--Columnas SCD Tipo 2
			[FechaInicioValidez] [UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] [UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion [UDT_DateTime] NULL DEFAULT(GETDATE()),
			UsuarioCreacion [UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			FechaModificacion [UDT_DateTime] NULL,
			UsuarioModificacion [UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch UNIQUEIDENTIFIER NULL,
			ID_SourceSystem VARCHAR(20)	
		)

		--DIMENSION Geografia
		CREATE TABLE Dimension.Geografia (
			SK_Geografia [UDT_SK] PRIMARY KEY IDENTITY,
			--Columnas SCD Tipo 2
			[FechaInicioValidez] [UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] [UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion [UDT_DateTime] NULL DEFAULT(GETDATE()),
			UsuarioCreacion [UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			FechaModificacion [UDT_DateTime] NULL,
			UsuarioModificacion [UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch UNIQUEIDENTIFIER NULL,
			ID_SourceSystem VARCHAR(20)	
		)

		--DIMENSION Clientes
		CREATE TABLE Dimension.Clientes (
			SK_Clientes [UDT_SK] PRIMARY KEY IDENTITY,
			--Columnas SCD Tipo 2
			[FechaInicioValidez] [UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] [UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion [UDT_DateTime] NULL DEFAULT(GETDATE()),
			UsuarioCreacion [UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			FechaModificacion [UDT_DateTime] NULL,
			UsuarioModificacion [UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch UNIQUEIDENTIFIER NULL,
			ID_SourceSystem VARCHAR(20)	
		)

		--DIMENSION Partes
		CREATE TABLE Dimension.Partes (
			SK_Partes [UDT_SK] PRIMARY KEY IDENTITY,
			--Columnas SCD Tipo 2
			[FechaInicioValidez] [UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] [UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion [UDT_DateTime] NULL DEFAULT(GETDATE()),
			UsuarioCreacion [UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			FechaModificacion [UDT_DateTime] NULL,
			UsuarioModificacion [UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch UNIQUEIDENTIFIER NULL,
			ID_SourceSystem VARCHAR(20)	
		)

		--DIMENSION Aseguradora
		CREATE TABLE Dimension.Aseguradora (
			SK_Aseguradora [UDT_SK] PRIMARY KEY IDENTITY,
			[IDAseguradora] [UDT_PK] IDENTITY(1,1) NOT NULL,
			[NombreAseguradora] [UDT_VarcharMediano] NULL,
			[RowCreatedDate] [UDT_DateTime] NULL,
			[Activa] [bit] NULL,
			--Columnas SCD Tipo 2
			[FechaInicioValidez] [UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] [UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion [UDT_DateTime] NULL DEFAULT(GETDATE()),
			UsuarioCreacion [UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			FechaModificacion [UDT_DateTime] NULL,
			UsuarioModificacion [UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch UNIQUEIDENTIFIER NULL,
			ID_SourceSystem VARCHAR(20)	
		)

		CREATE TABLE Dimension.Vehiculo (
			SK_Vehiculo [UDT_SK] PRIMARY KEY IDENTITY,
			[VehiculoID] [int] IDENTITY(1,1) NOT NULL,
			[VIN_Patron] [UDT_VarcharCorto] NOT NULL,
			[Anio] [smallint] NOT NULL,
			[Marca] [UDT_VarcharCorto] NOT NULL,
			[Modelo] [UDT_VarcharCorto] NOT NULL,
			[SubModelo] [UDT_VarcharCorto] NOT NULL,
			[Estilo] [UDT_VarcharMediano] NOT NULL,
			[FechaCreacionVeh] [datetime] NULL,
			--Columnas SCD Tipo 2
			[FechaInicioValidez] [UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] [UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion [UDT_DateTime] NULL DEFAULT(GETDATE()),
			UsuarioCreacion [UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			FechaModificacion [UDT_DateTime] NULL,
			UsuarioModificacion [UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch UNIQUEIDENTIFIER NULL,
			ID_SourceSystem VARCHAR(20)	
		)

		CREATE TABLE Dimension.Descuento (
			SK_Descuento [UDT_SK] PRIMARY KEY IDENTITY,
			[ID_Descuento] [int] IDENTITY(1,1) NOT NULL,
			[NombreDescuento] [UDT_VarcharMediano] NOT NULL,
			[PorcentajeDescuento] [UDT_Decimal2.2] NOT NULL,
			--Columnas SCD Tipo 2
			[FechaInicioValidez] [UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] [UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion [UDT_DateTime] NULL DEFAULT(GETDATE()),
			UsuarioCreacion [UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			FechaModificacion [UDT_DateTime] NULL,
			UsuarioModificacion [UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch UNIQUEIDENTIFIER NULL,
			ID_SourceSystem VARCHAR(20)	
		)

		CREATE TABLE Dimension.Planta (
			SK_Planta [UDT_SK] PRIMARY KEY IDENTITY,
			[IDPlantaReparacion] [UDT_VarcharCorto] NOT NULL,
			[CompanyNombre] [UDT_VarcharCorto] NOT NULL,
			[Direccion] [UDT_VarcharCorto] NOT NULL,
			[Direccion2] [UDT_VarcharCorto] NULL,
			[Ciudad] [UDT_VarcharCorto] NOT NULL,
			[Estado] [UDT_VarcharCorto] NOT NULL,
			[CodigoPostal] [UDT_VarcharCorto] NOT NULL,
			[Pais] [UDT_VarcharCorto] NULL,
			[TelefonoAlmacen] [UDT_VarcharCorto] NULL,
			[FaxAlmacen] [UDT_VarcharCorto] NULL,
			[CorreoContacto] [UDT_VarcharCorto] NULL,
			[NombreContacto] [UDT_VarcharCorto] NULL,
			[TelefonoContacto] [UDT_VarcharCorto] NULL,
			[TituloTrabajo] [UDT_VarcharCorto] NULL,
			[AlmacenKeystone] [UDT_VarcharCorto] NULL,
			[IDPredio] [UDT_VarcharCorto] NULL,
			[LocalizadorCotizacion] [UDT_VarcharCorto] NULL,
			[FechaAgregado] [datetime] NULL,
			[IDEmpresa] [UDT_VarcharCorto] NOT NULL,
			[ValidacionSeguro] [bit] NULL,
			[Activo] [bit] NULL,
			[CreadoPor] [UDT_VarcharCorto] NULL,
			[ActualizadoPor] [UDT_VarcharCorto] NULL,
			[UltimaFechaActualizacion] [datetime] NULL,
			--Columnas SCD Tipo 2
			[FechaInicioValidez] [UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] [UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion [UDT_DateTime] NULL DEFAULT(GETDATE()),
			UsuarioCreacion [UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			FechaModificacion [UDT_DateTime] NULL,
			UsuarioModificacion [UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch UNIQUEIDENTIFIER NULL,
			ID_SourceSystem VARCHAR(20)	
		)

		CREATE TABLE Dimension.StatusOrden (
			SK_StatusOrden [UDT_SK] PRIMARY KEY IDENTITY,
			[ID_StatusOrden] [int] IDENTITY(1,1) NOT NULL,
			[NombreStatus] [UDT_VarcharCorto] NOT NULL,
			--Columnas SCD Tipo 2
			[FechaInicioValidez] [UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] [UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion [UDT_DateTime] NULL DEFAULT(GETDATE()),
			UsuarioCreacion [UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			FechaModificacion [UDT_DateTime] NULL,
			UsuarioModificacion [UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch UNIQUEIDENTIFIER NULL,
			ID_SourceSystem VARCHAR(20)	
		)

		CREATE TABLE Dimension.Origen (
			SK_Origen [UDT_SK] PRIMARY KEY IDENTITY,
			[Origen] VARCHAR(20),
			ID_Orden [UDT_PK],
			--Columnas SCD Tipo 2
			[FechaInicioValidez] [UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] [UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion [UDT_DateTime] NULL DEFAULT(GETDATE()),
			UsuarioCreacion [UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			FechaModificacion [UDT_DateTime] NULL,
			UsuarioModificacion [UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch UNIQUEIDENTIFIER NULL,
			ID_SourceSystem VARCHAR(20)	
		)

	--END Dimensiones

	--Tabla Fact
		CREATE TABLE Fact.Orden (
			SK_Orden [UDT_SK] PRIMARY KEY IDENTITY,
			SK_Geografia [UDT_SK] REFERENCES Dimension.Geografia(SK_Geografia),
			SK_Clientes [UDT_SK] REFERENCES Dimension.Clientes(SK_Clientes),
			SK_Partes [UDT_SK] REFERENCES Dimension.Partes(SK_Partes),
			SK_Aseguradora [UDT_SK] REFERENCES Dimension.Aseguradora(SK_Aseguradora),
			SK_Vehiculo [UDT_SK] REFERENCES Dimension.Vehiculo(SK_Vehiculo),
			SK_Descuento [UDT_SK] REFERENCES Dimension.Descuento(SK_Descuento),
			SK_Planta [UDT_SK] REFERENCES Dimension.Planta(SK_Planta),
			SK_StatusOrden [UDT_SK] REFERENCES Dimension.StatusOrden(SK_StatusOrden),
			SK_Origen [UDT_SK] REFERENCES Dimension.Origen(SK_Origen),
			DateKey INT REFERENCES Dimension.Fecha(DateKey),
			[IDCotizacion] [int] NOT NULL,
			[status] [varchar](50) NULL,
			[TipoDocumento] [varchar](50) NULL,
			[FechaCreacionCotizacion] [datetime] NULL,
			[FechaModificacionCotizacion] [datetime] NULL,
			[ProcesadoPor] [varchar](50) NULL,
			[IDAseguradora] [int] NULL,
			[AseguradoraSubsidiaria] [varchar](80) NULL,
			[NumeroReclamo] [varchar](50) NULL,
			[IDPlantaReparacion] [varchar](50) NULL,
			[OrdenRealizada] [bit] NULL,
			[CotizacionRealizada] [bit] NULL,
			[CotizacionDuplicada] [bit] NULL,
			[procurementFolderID] [varchar](50) NULL,
			[DireccionEntrega1] [varchar](50) NULL,
			[DireccionEntrega2] [varchar](50) NULL,
			[MarcadoEntrega] [bit] NULL,
			[IDPartner] [varchar](50) NULL,
			[CodigoPostal] [varchar](10) NULL,
			[LeidoPorPlantaReparacion] [bit] NOT NULL,
			[LeidoPorPlantaReparacionFecha] [datetime] NULL,
			[CotizacionReabierta] [bit] NOT NULL,
			[EsAseguradora] [bit] NULL,
			[CodigoVerificacion] [varchar](50) NULL,
			[IDClientePlantaReparacion] [varchar](50) NULL,
			[FechaCreacionRegistro] [datetime] NOT NULL,
			[IDRecotizacion] [varchar](100) NULL,
			[PartnerConfirmado] [bit] NOT NULL,
			[WrittenBy] [varchar](80) NULL,
			[SeguroValidado] [bit] NOT NULL,
			[FechaCaptura] [datetime] NULL,
			[IDOrden] [int] NULL,
			[Ruta] [varchar](500) NULL,
			[FechaLimiteRuta] [varchar](50) NULL,
			[TelefonoEntrega] [varchar](15) NULL,
			[NumLinea] [varchar](50) NOT NULL,
			[ID_Parte] [varchar](50) NOT NULL,
			[OETipoParte] [varchar](10) NULL,
			[AltPartNum] [varchar](45) NULL,
			[AltTipoParte] [varchar](45) NULL,
			[ciecaTipoParte] [varchar](45) NULL,
			[partDescripcion] [varchar](255) NULL,
			[Cantidad] [int] NULL,
			[PrecioListaOnRO] [varchar](10) NULL,
			[PrecioNetoOnRO] [varchar](10) NULL,
			[NecesitadoParaFecha] [datetime] NULL,
			[VehiculoID] [int] NULL,
			--Columnas Auditoria
			FechaCreacion [UDT_DateTime] NULL DEFAULT(GETDATE()),
			UsuarioCreacion [UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			FechaModificacion [UDT_DateTime] NULL,
			UsuarioModificacion [UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch UNIQUEIDENTIFIER NULL,
			ID_SourceSystem VARCHAR(50)
		)
		GO
	
	--END Fact

	--Metadata

		EXEC sys.sp_addextendedproperty 
  	   @name = N'Desnormalizacion', 
  	   @value = N'La dimension geografia provee una vista desnormalizada, integrar� Pa�s, Region y Ciudad, dejando todo en una �nica dimensi�n para un modelo estrella', 
  	   @level0type = N'SCHEMA', 
  	   @level0name = N'Dimension', 
  	   @level1type = N'TABLE', 
  	   @level1name = N'Geografia';
		GO

		EXEC sys.sp_addextendedproperty 
  	   @name = N'Desnormalizacion', 
  	   @value = N'La dimension clientes tendr� informaci�n de los clientes en una sola dimensi�n para un modelo estrella', 
  	   @level0type = N'SCHEMA', 
  	   @level0name = N'Dimension', 
  	   @level1type = N'TABLE', 
  	   @level1name = N'Clientes';
		GO

		EXEC sys.sp_addextendedproperty 
  	   @name = N'Desnormalizacion', 
  	   @value = N'La dimension partes tendr� informaci�n las tablas de Partes, Linea y Categoria en una sola dimensi�n para un modelo estrella', 
  	   @level0type = N'SCHEMA', 
  	   @level0name = N'Dimension', 
  	   @level1type = N'TABLE', 
  	   @level1name = N'Partes';
		GO

		EXEC sys.sp_addextendedproperty 
  	   @name = N'Desnormalizacion', 
  	   @value = N'La dimension fecha es generada de forma automatica y no tiene datos origen, se puede regenerar enviando un rango de fechas al stored procedure USP_FillDimDate', 
  	   @level0type = N'SCHEMA', 
  	   @level0name = N'Dimension', 
  	   @level1type = N'TABLE', 
  	   @level1name = N'Fecha';
		GO

		EXEC sys.sp_addextendedproperty 
  	   @name = N'Desnormalizacion', 
  	   @value = N'La tabla de hechos es una union proveniente de las tablas de Orden, detalle orden, Descuento, statusOrden', 
  	   @level0type = N'SCHEMA', 
  	   @level0name = N'Fact', 
  	   @level1type = N'TABLE', 
  	   @level1name = N'Orden';
		GO

	--END Metadata

--------------------------------------------------------------------------------------------
---------------------------------MODELADO LOGICO--------------------------------------------
--------------------------------------------------------------------------------------------
--Transformaci�n en modelo l�gico (mas detalles)

--Fact
	ALTER TABLE Fact.Orden ADD ID_Orden [UDT_PK]
	ALTER TABLE Fact.Orden ADD ID_Cliente [UDT_PK]
	ALTER TABLE Fact.Orden ADD ID_Ciudad [UDT_PK]
	ALTER TABLE Fact.Orden ADD ID_Partes [UDT_VarcharCorto]
	ALTER TABLE Fact.Orden ADD ID_DetalleOrden [UDT_PK]
	ALTER TABLE Fact.Orden ADD Total_Orden [UDT_Decimal12.2]
	ALTER TABLE Fact.Orden ADD CantidadOrden INT
	ALTER TABLE Fact.Orden ADD StatusOrden [UDT_VarcharMediano]
	ALTER TABLE Fact.Orden ADD Fecha_Orden DATETIME



--DimFecha	
	ALTER TABLE Dimension.Fecha ADD [Date] DATE NOT NULL
  ALTER TABLE Dimension.Fecha ADD [Day] TINYINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [DaySuffix] CHAR(2) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [Weekday] TINYINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [WeekDayName] VARCHAR(10) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [WeekDayName_Short] CHAR(3) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [WeekDayName_FirstLetter] CHAR(1) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [DOWInMonth] TINYINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [DayOfYear] SMALLINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [WeekOfMonth] TINYINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [WeekOfYear] TINYINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [Month] TINYINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [MonthName] VARCHAR(10) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [MonthName_Short] CHAR(3) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [MonthName_FirstLetter] CHAR(1) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [Quarter] TINYINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [QuarterName] VARCHAR(6) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [Year] INT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [MMYYYY] CHAR(6) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [MonthYear] CHAR(7) NOT NULL
  ALTER TABLE Dimension.Fecha ADD IsWeekend BIT NOT NULL

--DimGeografia
	ALTER TABLE Dimension.Geografia ADD ID_Pais [UDT_PK]
	ALTER TABLE Dimension.Geografia ADD ID_Region [UDT_PK]
	ALTER TABLE Dimension.Geografia ADD ID_Ciudad [UDT_PK]
	ALTER TABLE Dimension.Geografia ADD NombrePais [UDT_VarcharMediano]
	ALTER TABLE Dimension.Geografia ADD NombreRegion [UDT_VarcharMediano]
	ALTER TABLE Dimension.Geografia ADD NombreCiudad [UDT_VarcharMediano]
	ALTER TABLE Dimension.Geografia ADD CodigoPostal INT
	

--DimClientes
	ALTER TABLE Dimension.Clientes ADD ID_Cliente [UDT_PK]
	ALTER TABLE Dimension.Clientes ADD PrimerNombre [UDT_VarcharMediano]
	ALTER TABLE Dimension.Clientes  ADD SegeundoNombre [UDT_VarcharMediano]
	ALTER TABLE Dimension.Clientes  ADD PrimerApellido [UDT_VarcharMediano]
	ALTER TABLE Dimension.Clientes  ADD SegundoApellido [UDT_VarcharMediano]
	ALTER TABLE Dimension.Clientes  ADD Genero [UDT_UnCaracter]
	ALTER TABLE Dimension.Clientes  ADD CorreoCliente [UDT_VarcharMediano]
	ALTER TABLE Dimension.Clientes  ADD Nacimiento DATETIME NOT NULL
	ALTER TABLE Dimension.Clientes ALTER COLUMN Nacimiento DATETIME NULL;

--DimPartes
	ALTER TABLE Dimension.Partes ADD ID_Partes [UDT_VarcharCorto]
	ALTER TABLE Dimension.Partes ADD ID_Linea [UDT_PK]
	ALTER TABLE Dimension.Partes ADD ID_Categoria [UDT_PK]
	ALTER TABLE Dimension.Partes ADD NombrePartes [UDT_VarcharMediano]
	ALTER TABLE Dimension.Partes ADD NombreLinea [UDT_VarcharMediano]
	ALTER TABLE Dimension.Partes ADD NombreCategoria [UDT_VarcharMediano]

	--DimAseguradora


--Indices Columnares
	CREATE NONCLUSTERED COLUMNSTORE INDEX [NCCS-Ordenes] ON [Fact].[Orden] (
	  [Total_Orden], [CantidadOrden]
	) WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0)
	GO


--------------------------------------------------------------------------------------------
-----------------------CORRER CREATE de USP_FillDimDate PRIMERO!!!--------------------------
--------------------------------------------------------------------------------------------

	DECLARE @FechaMaxima DATETIME=DATEADD(YEAR,2,GETDATE())
	--Fecha
	IF ISNULL((SELECT MAX(Date) FROM Dimension.Fecha),'1900-01-01')<@FechaMaxima
	begin
		EXEC USP_FillDimDate @CurrentDate = '2016-01-01', 
							 @EndDate     = @FechaMaxima
	end
	SELECT * FROM Dimension.Fecha