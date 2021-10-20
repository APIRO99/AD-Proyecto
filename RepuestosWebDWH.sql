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
	GO
	USE RepuestosWebDWH
	exec sp_changedbowner 'sa'
	GO
-- END


--User Defined Type
	--Enteros
		CREATE TYPE [UDT_SK] FROM INT --Tipo para SK entero: Surrogate Key
		CREATE TYPE [UDT_PK] FROM INT --Tipo para PK entero
		CREATE TYPE [UDT_SmallInt] from SMALLINT
		CREATE TYPE [UDT_Int] from INT

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
		CREATE TYPE [UDT_Date] FROM DATE

	--Bool
		CREATE TYPE [UDT_Bit] FROM BIT
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
			DateKey 							[UDT_PK] PRIMARY KEY,
			--Columnas SCD Tipo 2
			[FechaInicioValidez]  				[UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] 					[UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion 						[UDT_DateTime] NULL DEFAULT(GETDATE()),
			FechaModificacion 					[UDT_DateTime] NULL,
			UsuarioCreacion 					[UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			UsuarioModificacion 				[UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch 							UNIQUEIDENTIFIER NULL,
			ID_SourceSystem 					VARCHAR(20)	
		)
		GO

		--DIMENSION Geografia
		CREATE TABLE Dimension.Geografia (
			SK_Geografia 						[UDT_SK] PRIMARY KEY IDENTITY,
			--Columnas SCD Tipo 2
			[FechaInicioValidez]  				[UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] 					[UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion 						[UDT_DateTime] NULL DEFAULT(GETDATE()),
			FechaModificacion 					[UDT_DateTime] NULL,
			UsuarioCreacion 					[UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			UsuarioModificacion 				[UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch 							UNIQUEIDENTIFIER NULL,
			ID_SourceSystem 					VARCHAR(20)	
		)
		GO

		--DIMENSION Clientes
		CREATE TABLE Dimension.Clientes (
			SK_Clientes 						[UDT_SK] PRIMARY KEY IDENTITY,
			--Columnas SCD Tipo 2
			[FechaInicioValidez]  				[UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] 					[UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion 						[UDT_DateTime] NULL DEFAULT(GETDATE()),
			FechaModificacion 					[UDT_DateTime] NULL,
			UsuarioCreacion 					[UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			UsuarioModificacion 				[UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch 							UNIQUEIDENTIFIER NULL,
			ID_SourceSystem 					VARCHAR(20)	
		)
		GO

		--DIMENSION Partes
		CREATE TABLE Dimension.Partes (
			SK_Partes							[UDT_SK] PRIMARY KEY IDENTITY,
			--Columnas SCD Tipo 2
			[FechaInicioValidez]  				[UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] 					[UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion 						[UDT_DateTime] NULL DEFAULT(GETDATE()),
			FechaModificacion 					[UDT_DateTime] NULL,
			UsuarioCreacion 					[UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			UsuarioModificacion 				[UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch 							UNIQUEIDENTIFIER NULL,
			ID_SourceSystem 					VARCHAR(20)	
		)
		GO

		--DIMENSION Aseguradora
		CREATE TABLE Dimension.Aseguradora (
			SK_Aseguradora 						[UDT_SK] PRIMARY KEY IDENTITY,
			[IDAseguradora] 					[UDT_PK] NOT NULL,
			[NombreAseguradora] 				[UDT_VarcharCorto] NULL,
			[RowCreatedDate] 					[UDT_DateTime] NULL,
			[Activa] 							[UDT_Bit] NULL,
			--Columnas SCD Tipo 2
			[FechaInicioValidez]  				[UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] 					[UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion 						[UDT_DateTime] NULL DEFAULT(GETDATE()),
			FechaModificacion 					[UDT_DateTime] NULL,
			UsuarioCreacion 					[UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			UsuarioModificacion 				[UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch 							UNIQUEIDENTIFIER NULL,
			ID_SourceSystem 					VARCHAR(20)	
		)
		GO

		CREATE TABLE Dimension.Vehiculo (
			SK_Vehiculo 						[UDT_SK] PRIMARY KEY IDENTITY,
			[VehiculoID]						[UDT_PK] NOT NULL,
			[VIN_Patron] 						[UDT_VarcharCorto] NOT NULL,
			[Anio] 								[UDT_SmallInt] NOT NULL,
			[Marca] 							[UDT_VarcharCorto] NOT NULL,
			[Modelo] 							[UDT_VarcharCorto] NOT NULL,
			[SubModelo] 						[UDT_VarcharCorto] NOT NULL,
			[Estilo] 							[UDT_VarcharMediano] NOT NULL,
			[FechaCreacionVeh] 					[UDT_DateTime] NULL,
			--Columnas SCD Tipo 2
			-- [FechaInicioValidez] 			[UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			-- [FechaFinValidez]				[UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion 						[UDT_DateTime] NULL DEFAULT(GETDATE()),
			FechaModificacion 					[UDT_DateTime] NULL,
			UsuarioCreacion 					[UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			UsuarioModificacion 				[UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch 							UNIQUEIDENTIFIER NULL,
			ID_SourceSystem 					VARCHAR(20)	
		)
		GO

		CREATE TABLE Dimension.Descuento (
			SK_Descuento 						[UDT_SK] PRIMARY KEY IDENTITY,
			[ID_Descuento] 						[UDT_PK] NOT NULL,
			[NombreDescuento] 					[UDT_VarcharMediano] NOT NULL,
			[PorcentajeDescuento]				[UDT_Decimal2.2] NOT NULL,
			--Columnas SCD Tipo 2
			[FechaInicioValidez]  				[UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] 					[UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion 						[UDT_DateTime] NULL DEFAULT(GETDATE()),
			FechaModificacion 					[UDT_DateTime] NULL,
			UsuarioCreacion 					[UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			UsuarioModificacion 				[UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch 							UNIQUEIDENTIFIER NULL,
			ID_SourceSystem 					VARCHAR(20)	
		)
		GO

		CREATE TABLE Dimension.Planta (
			SK_Planta 							[UDT_SK] PRIMARY KEY IDENTITY,
			[IDPlantaReparacion] 				[UDT_VarcharCorto] NOT NULL,
			[CompanyNombre] 					[UDT_VarcharCorto] NOT NULL,
			[Direccion] 						[UDT_VarcharCorto] NOT NULL,
			[Direccion2] 						[UDT_VarcharCorto] NULL,
			[Ciudad] 							[UDT_VarcharCorto] NOT NULL,
			[Estado] 							[UDT_VarcharCorto] NOT NULL,
			[CodigoPostal] 						[UDT_VarcharCorto] NOT NULL,
			[Pais] 								[UDT_VarcharCorto] NULL,
			[TelefonoAlmacen] 					[UDT_VarcharCorto] NULL,
			[FaxAlmacen] 						[UDT_VarcharCorto] NULL,
			[CorreoContacto] 					[UDT_VarcharCorto] NULL,
			[NombreContacto] 					[UDT_VarcharCorto] NULL,
			[TelefonoContacto] 					[UDT_VarcharCorto] NULL,
			[TituloTrabajo] 					[UDT_VarcharCorto] NULL,
			[AlmacenKeystone] 					[UDT_VarcharCorto] NULL,
			[IDPredio] 							[UDT_VarcharCorto] NULL,
			[LocalizadorCotizacion] 			[UDT_VarcharCorto] NULL,
			[FechaAgregado] 					[UDT_DateTime] NULL,
			[IDEmpresa] 						[UDT_VarcharCorto] NOT NULL,
			[ValidacionSeguro] 					[UDT_Bit] NULL,
			[Activo] 							[UDT_Bit] NULL,
			[CreadoPor] 						[UDT_VarcharCorto] NULL,
			[ActualizadoPor] 					[UDT_VarcharCorto] NULL,
			[UltimaFechaActualizacion] 			[UDT_DateTime] NULL,
			--Columnas SCD Tipo 2
			[FechaInicioValidez]  				[UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] 					[UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion 						[UDT_DateTime] NULL DEFAULT(GETDATE()),
			FechaModificacion 					[UDT_DateTime] NULL,
			UsuarioCreacion 					[UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			UsuarioModificacion 				[UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch 							UNIQUEIDENTIFIER NULL,
			ID_SourceSystem 					VARCHAR(20)	
		)
		GO

		CREATE TABLE Dimension.StatusOrden (
			SK_StatusOrden 						[UDT_SK] PRIMARY KEY IDENTITY,
			[ID_StatusOrden] 					[UDT_PK] NOT NULL,
			[NombreStatus] 						[UDT_VarcharCorto] NOT NULL,
			--Columnas SCD Tipo 2
			[FechaInicioValidez]  				[UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			[FechaFinValidez] 					[UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion 						[UDT_DateTime] NULL DEFAULT(GETDATE()),
			FechaModificacion 					[UDT_DateTime] NULL,
			UsuarioCreacion 					[UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			UsuarioModificacion 				[UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch 							UNIQUEIDENTIFIER NULL,
			ID_SourceSystem 					VARCHAR(20)	
		)
		GO

		CREATE TABLE Dimension.Origen (
			SK_Origen 							[UDT_SK] PRIMARY KEY IDENTITY,
			ID_Orden 							[UDT_PK],
			[Origen] 							[UDT_VarcharCorto],
			--Columnas SCD Tipo 2
			-- [FechaInicioValidez]  			[UDT_DateTime] NOT NULL DEFAULT(GETDATE()),
			-- [FechaFinValidez] 				[UDT_DateTime] NULL,
			--Columnas Auditoria
			FechaCreacion 						[UDT_DateTime] NULL DEFAULT(GETDATE()),
			FechaModificacion 					[UDT_DateTime] NULL,
			UsuarioCreacion 					[UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			UsuarioModificacion 				[UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch 							UNIQUEIDENTIFIER NULL,
			ID_SourceSystem 					VARCHAR(20)	
		)
		GO

	--END Dimensiones

	--Tabla Fact
		CREATE TABLE Fact.Orden (
			SK_Orden							[UDT_SK] PRIMARY KEY IDENTITY,
			SK_Geografia						[UDT_SK] REFERENCES Dimension.Geografia(SK_Geografia),
			SK_Clientes							[UDT_SK] REFERENCES Dimension.Clientes(SK_Clientes),
			SK_Partes							[UDT_SK] REFERENCES Dimension.Partes(SK_Partes),
			SK_Aseguradora						[UDT_SK] REFERENCES Dimension.Aseguradora(SK_Aseguradora),
			SK_Vehiculo							[UDT_SK] REFERENCES Dimension.Vehiculo(SK_Vehiculo),
			SK_Descuento						[UDT_SK] REFERENCES Dimension.Descuento(SK_Descuento),
			SK_Planta							[UDT_SK] REFERENCES Dimension.Planta(SK_Planta),
			SK_StatusOrden						[UDT_SK] REFERENCES Dimension.StatusOrden(SK_StatusOrden),
			SK_Origen							[UDT_SK] REFERENCES Dimension.Origen(SK_Origen),
			DateKey 							[UDT_SK] REFERENCES Dimension.Fecha(DateKey),
			[IDCotizacion]						[UDT_PK] NOT NULL,
			[status]							[UDT_VarcharCorto] NULL,
			[TipoDocumento]						[UDT_VarcharCorto] NULL,
			[FechaCreacionCotizacion]			[UDT_DateTime] NULL,
			[FechaModificacionCotizacion]		[UDT_DateTime] NULL,
			[ProcesadoPor]						[UDT_VarcharCorto] NULL,
			[IDAseguradora]						[UDT_Int] NULL,
			[AseguradoraSubsidiaria]			[UDT_VarcharCorto] NULL,
			[NumeroReclamo]						[UDT_VarcharCorto] NULL,
			[IDPlantaReparacion]				[UDT_VarcharCorto] NULL,
			[OrdenRealizada]					[UDT_Bit] NULL,
			[CotizacionRealizada]				[UDT_Bit] NULL,
			[CotizacionDuplicada]				[UDT_Bit] NULL,
			[procurementFolderID]				[UDT_VarcharCorto] NULL,
			[DireccionEntrega1]					[UDT_VarcharCorto] NULL,
			[DireccionEntrega2]					[UDT_VarcharCorto] NULL,
			[MarcadoEntrega]					[UDT_Bit] NULL,
			[IDPartner]							[UDT_VarcharCorto] NULL,
			[CodigoPostal]						[UDT_VarcharCorto] NULL,
			[LeidoPorPlantaReparacion]			[UDT_Bit] NOT NULL,
			[LeidoPorPlantaReparacionFecha]		[UDT_DateTime] NULL,
			[CotizacionReabierta]				[UDT_Bit] NOT NULL,
			[EsAseguradora]						[UDT_Bit] NULL,
			[CodigoVerificacion]				[UDT_VarcharCorto] NULL,
			[IDClientePlantaReparacion]			[UDT_VarcharCorto] NULL,
			[FechaCreacionRegistro]				[UDT_DateTime] NOT NULL,
			[IDRecotizacion]					[UDT_VarcharCorto] NULL,
			[PartnerConfirmado]					[UDT_Bit] NOT NULL,
			[WrittenBy]							[UDT_VarcharCorto] NULL,
			[SeguroValidado]					[UDT_Bit] NOT NULL,
			[FechaCaptura]						[UDT_DateTime] NULL,
			[IDOrden]							[UDT_Int] NULL,
			[Ruta]								[UDT_VarcharLargo] NULL,
			[FechaLimiteRuta]					[UDT_VarcharCorto] NULL,
			[TelefonoEntrega]					[UDT_VarcharCorto] NULL,
			[NumLinea]							[UDT_VarcharCorto] NOT NULL,
			[OETipoParte]						[UDT_VarcharCorto] NULL,
			[AltPartNum]						[UDT_VarcharCorto] NULL,
			[AltTipoParte]						[UDT_VarcharCorto] NULL,
			[ciecaTipoParte]					[UDT_VarcharCorto] NULL,
			[partDescripcion]					[UDT_VarcharMediano] NULL,
			[CantidadCotizacionDetalle]			[UDT_Int] NULL,
			[PrecioListaOnRO]					[UDT_VarcharCorto] NULL,
			[PrecioNetoOnRO]					[UDT_VarcharCorto] NULL,
			[NecesitadoParaFecha]				[UDT_DateTime] NULL,
			[VehiculoIDCotizacionDetalle]		[UDT_Int] NULL,
			--Columnas Auditoria
			FechaCreacion 						[UDT_DateTime] NULL DEFAULT(GETDATE()),
			FechaModificacion 					[UDT_DateTime] NULL,
			UsuarioCreacion 					[UDT_VarcharCorto] NULL DEFAULT(SUSER_NAME()),
			UsuarioModificacion 				[UDT_VarcharCorto] NULL,
			--Columnas Linaje
			ID_Batch 							UNIQUEIDENTIFIER NULL,
			ID_SourceSystem 					VARCHAR(20)	
		)
		GO
	
	--END Fact

	--Metadata
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
  	   @value = N'La dimension Origen tendra informacion de los del origen de las ordens, esta sera extraida de las tablas Aseguradora y Clientes. Estara en una sola dimension para un modelo estrella', 
  	   @level0type = N'SCHEMA', 
  	   @level0name = N'Dimension', 
  	   @level1type = N'TABLE', 
  	   @level1name = N'Origen';
		GO

		EXEC sys.sp_addextendedproperty 
  	   @name = N'Desnormalizacion', 
  	   @value = N'La dimension Aseguradora tendra informacion de las aseguradoras en una sola dimension para un modelo estrella', 
  	   @level0type = N'SCHEMA', 
  	   @level0name = N'Dimension', 
  	   @level1type = N'TABLE', 
  	   @level1name = N'Aseguradora';
		GO

		EXEC sys.sp_addextendedproperty 
  	   @name = N'Desnormalizacion', 
  	   @value = N'La dimension geografia provee una vista desnormalizada, integrara Pais, Region y Ciudad, dejando todo en una unica dimension para un modelo estrella', 
  	   @level0type = N'SCHEMA', 
  	   @level0name = N'Dimension', 
  	   @level1type = N'TABLE', 
  	   @level1name = N'Geografia';
		GO

		EXEC sys.sp_addextendedproperty 
  	   @name = N'Desnormalizacion', 
  	   @value = N'La dimension clientes tendra informacion de los clientes en una sola dimension para un modelo estrella', 
  	   @level0type = N'SCHEMA', 
  	   @level0name = N'Dimension', 
  	   @level1type = N'TABLE', 
  	   @level1name = N'Clientes';
		GO

		EXEC sys.sp_addextendedproperty 
  	   @name = N'Desnormalizacion', 
  	   @value = N'La dimension StatusOrden tendra informacion de los estados de las ordenes en una sola dimension para un modelo estrella', 
  	   @level0type = N'SCHEMA', 
  	   @level0name = N'Dimension', 
  	   @level1type = N'TABLE', 
  	   @level1name = N'StatusOrden';
		GO

		EXEC sys.sp_addextendedproperty 
  	   @name = N'Desnormalizacion', 
  	   @value = N'La dimension descuento tendra informacion de los Descuentos en una sola dimension para un modelo estrella', 
  	   @level0type = N'SCHEMA', 
  	   @level0name = N'Dimension', 
  	   @level1type = N'TABLE', 
  	   @level1name = N'Descuento';
		GO

		EXEC sys.sp_addextendedproperty 
  	   @name = N'Desnormalizacion', 
  	   @value = N'La dimension partes tendra informacion las tablas de Partes, Linea y Categoria en una sola dimension para un modelo estrella', 
  	   @level0type = N'SCHEMA', 
  	   @level0name = N'Dimension', 
  	   @level1type = N'TABLE', 
  	   @level1name = N'Partes';
		GO

		EXEC sys.sp_addextendedproperty 
  	   @name = N'Desnormalizacion', 
  	   @value = N'La dimension vehiculo tendra informacion de los vehiculos en una sola dimension para un modelo estrella', 
  	   @level0type = N'SCHEMA', 
  	   @level0name = N'Dimension', 
  	   @level1type = N'TABLE', 
  	   @level1name = N'Vehiculo';
		GO

		EXEC sys.sp_addextendedproperty 
  	   @name = N'Desnormalizacion', 
  	   @value = N'La dimension planta tendra informacion de las Plantas de Reparacion en una sola dimension para un modelo estrella', 
  	   @level0type = N'SCHEMA', 
  	   @level0name = N'Dimension', 
  	   @level1type = N'TABLE', 
  	   @level1name = N'Planta';
		GO

		EXEC sys.sp_addextendedproperty 
  	   @name = N'Desnormalizacion', 
  	   @value = N'La tabla de hechos es una union proveniente de las tablas de Orden, detalle orden, Cotizacion y CotizacionDetalle', 
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
		ALTER TABLE Fact.Orden ADD ID_Orden 						[UDT_PK]
		ALTER TABLE Fact.Orden ADD ID_Cliente 						[UDT_PK]
		ALTER TABLE Fact.Orden ADD ID_Ciudad 						[UDT_PK]
		ALTER TABLE Fact.Orden ADD ID_StatusOrden					[UDT_PK]
		ALTER TABLE Fact.Orden ADD Total_Orden 						[UDT_Decimal12.2]
		ALTER TABLE Fact.Orden ADD Fecha_Orden 						[UDT_DateTime]
		ALTER TABLE Fact.Orden ADD NumeroOrden						[UDT_VarcharCorto]

		ALTER TABLE Fact.Orden ADD ID_DetalleOrden 					[UDT_PK]
		ALTER TABLE Fact.Orden ADD ID_Parte 						[UDT_VarcharCorto]
		ALTER TABLE Fact.Orden ADD ID_Descuento 					[UDT_PK]
		ALTER TABLE Fact.Orden ADD CantidadDetalleOrden				[UDT_Int]
		ALTER TABLE Fact.Orden ADD VehiculoIDDetalleOrden			[UDT_PK]
	--END FACT

	--Dimension.Fecha
		ALTER TABLE Dimension.Fecha ADD [Date] 						DATE NOT NULL
	  	ALTER TABLE Dimension.Fecha ADD [Day] 						TINYINT NOT NULL
		ALTER TABLE Dimension.Fecha ADD [DaySuffix] 				CHAR(2) NOT NULL
		ALTER TABLE Dimension.Fecha ADD [Weekday] 					TINYINT NOT NULL
		ALTER TABLE Dimension.Fecha ADD [WeekDayName] 				VARCHAR(10) NOT NULL
		ALTER TABLE Dimension.Fecha ADD [WeekDayName_Short] 		CHAR(3) NOT NULL
		ALTER TABLE Dimension.Fecha ADD [WeekDayName_FirstLetter] 	CHAR(1) NOT NULL
		ALTER TABLE Dimension.Fecha ADD [DOWInMonth] 				TINYINT NOT NULL
		ALTER TABLE Dimension.Fecha ADD [DayOfYear] 				SMALLINT NOT NULL
		ALTER TABLE Dimension.Fecha ADD [WeekOfMonth] 				TINYINT NOT NULL
		ALTER TABLE Dimension.Fecha ADD [WeekOfYear] 				TINYINT NOT NULL
		ALTER TABLE Dimension.Fecha ADD [Month] 					TINYINT NOT NULL
		ALTER TABLE Dimension.Fecha ADD [MonthName] 				VARCHAR(10) NOT NULL
		ALTER TABLE Dimension.Fecha ADD [MonthName_Short] 			CHAR(3) NOT NULL
		ALTER TABLE Dimension.Fecha ADD [MonthName_FirstLetter] 	CHAR(1) NOT NULL
		ALTER TABLE Dimension.Fecha ADD [Quarter] 					TINYINT NOT NULL
		ALTER TABLE Dimension.Fecha ADD [QuarterName] 				VARCHAR(6) NOT NULL
		ALTER TABLE Dimension.Fecha ADD [Year] 						INT NOT NULL
		ALTER TABLE Dimension.Fecha ADD [MMYYYY] 					CHAR(6) NOT NULL
		ALTER TABLE Dimension.Fecha ADD [MonthYear] 				CHAR(7) NOT NULL
	  	ALTER TABLE Dimension.Fecha ADD IsWeekend 					BIT NOT NULL
	--END Dimension.Fecha

	--Dimension.Geografia
		ALTER TABLE Dimension.Geografia ADD ID_Pais 				[UDT_PK]
		ALTER TABLE Dimension.Geografia ADD NombrePais 				[UDT_VarcharCorto]

		ALTER TABLE Dimension.Geografia ADD ID_Region 				[UDT_PK]
		ALTER TABLE Dimension.Geografia ADD NombreRegion 			[UDT_VarcharCorto]
	
		ALTER TABLE Dimension.Geografia ADD ID_Ciudad 				[UDT_PK]
		ALTER TABLE Dimension.Geografia ADD NombreCiudad 			[UDT_VarcharCorto]
		ALTER TABLE Dimension.Geografia ADD CodigoPostal 			[UDT_VarcharCorto]
	--END Dimension.Geografia
	
	--Dimension.Clientes
		ALTER TABLE Dimension.Clientes ADD ID_Cliente 				[UDT_PK]
		ALTER TABLE Dimension.Clientes ADD PrimerNombre 			[UDT_VarcharCorto]
		ALTER TABLE Dimension.Clientes ADD SegeundoNombre 			[UDT_VarcharCorto]
		ALTER TABLE Dimension.Clientes ADD PrimerApellido 			[UDT_VarcharCorto]
		ALTER TABLE Dimension.Clientes ADD SegundoApellido			[UDT_VarcharCorto]
		ALTER TABLE Dimension.Clientes ADD Genero 					[UDT_UnCaracter]
		ALTER TABLE Dimension.Clientes ADD CorreoCliente 			[UDT_VarcharCorto]
		ALTER TABLE Dimension.Clientes ADD Nacimiento 				[UDT_DateTime] NULL
		ALTER TABLE Dimension.Clientes ADD Direccion 				[UDT_VarcharLargo] NULL
	--END Dimension.Clientes

	--Dimension.Partes
		ALTER TABLE Dimension.Partes ADD ID_Parte 					[UDT_VarcharCorto]
		ALTER TABLE Dimension.Partes ADD NombreParte 				[UDT_VarcharMediano]
		ALTER TABLE Dimension.Partes ADD DescripcionParte			[UDT_VarcharLargo]
		ALTER TABLE Dimension.Partes ADD PrecioParte				[UDT_Decimal12.2]

		ALTER TABLE Dimension.Partes ADD ID_Categoria				[UDT_PK]
		ALTER TABLE Dimension.Partes ADD NombreCategoria			[UDT_VarcharMediano]
		ALTER TABLE Dimension.Partes ADD DescripcionCategoria		[UDT_VarcharMediano]

		ALTER TABLE Dimension.Partes ADD ID_Linea 					[UDT_PK]
		ALTER TABLE Dimension.Partes ADD NombreLinea				[UDT_VarcharMediano]
		ALTER TABLE Dimension.Partes ADD DescripcionLinea			[UDT_VarcharMediano]
	--END Dimension.Partes



--Indices Columnares
	CREATE NONCLUSTERED COLUMNSTORE INDEX [NCCS-Ordenes] ON [Fact].[Orden] (
	  [Total_Orden], [CantidadDetalleOrden]
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