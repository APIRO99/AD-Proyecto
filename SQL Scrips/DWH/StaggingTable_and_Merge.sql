USE [RepuestosWebDWH]
GO

--Creamos tabla para log de fact batches
CREATE TABLE FactLog (
	ID_Batch UNIQUEIDENTIFIER DEFAULT(NEWID()),
	FechaEjecucion DATETIME DEFAULT(GETDATE()),
	NuevosRegistros INT,
	CONSTRAINT [PK_FactLog] PRIMARY KEY
	(
		ID_Batch
	)
)
GO

ALTER TABLE Fact.Orden ADD CONSTRAINT [FK_IDBatch] FOREIGN KEY (ID_Batch) 
REFERENCES Factlog(ID_Batch)
go

CREATE SCHEMA [staging]
go

DROP TABLE IF EXISTS [staging].[Orden]
GO

CREATE TABLE [staging].[Orden](
	[SK_Orden]                           [dbo].[UDT_SK] IDENTITY(1,1) NOT NULL,
	[ID_Orden]                           [dbo].[UDT_PK] NULL,
	[IDCotizacion]                       [dbo].[UDT_PK] NULL,
	[status]                             [dbo].[UDT_VarcharCorto] NULL,
	[TipoDocumento]                      [dbo].[UDT_VarcharCorto] NULL,
	[FechaCreacionCotizacion]            [dbo].[UDT_DateTime] NULL,
	[FechaModificacionCotizacion]        [dbo].[UDT_DateTime] NULL,
	[ProcesadoPor]                       [dbo].[UDT_VarcharCorto] NULL,
	[IDAseguradora]                      [dbo].[UDT_Int] NULL,
	[AseguradoraSubsidiaria]             [dbo].[UDT_VarcharCorto] NULL,
	[NumeroReclamo]                      [dbo].[UDT_VarcharCorto] NULL,
	[IDPlantaReparacion]                 [dbo].[UDT_VarcharCorto] NULL,
	[OrdenRealizada]                     [dbo].[UDT_Bit] NULL,
	[CotizacionRealizada]                [dbo].[UDT_Bit] NULL,
	[CotizacionDuplicada]                [dbo].[UDT_Bit] NULL,
	[procurementFolderID]                [dbo].[UDT_VarcharCorto] NULL,
	[DireccionEntrega1]                  [dbo].[UDT_VarcharCorto] NULL,
	[DireccionEntrega2]                  [dbo].[UDT_VarcharCorto] NULL,
	[MarcadoEntrega]                     [dbo].[UDT_Bit] NULL,
	[IDPartner]                          [dbo].[UDT_VarcharCorto] NULL,
	[CodigoPostal]                       [dbo].[UDT_VarcharCorto] NULL,
	[LeidoPorPlantaReparacion]           [dbo].[UDT_Bit] NULL,
	[LeidoPorPlantaReparacionFecha]      [dbo].[UDT_DateTime] NULL,
	[CotizacionReabierta]                [dbo].[UDT_Bit] NULL,
	[EsAseguradora]                      [dbo].[UDT_Bit] NULL,
	[CodigoVerificacion]                 [dbo].[UDT_VarcharCorto] NULL,
	[IDClientePlantaReparacion]          [dbo].[UDT_VarcharCorto] NULL,
	[FechaCreacionRegistro]              [dbo].[UDT_DateTime] NULL,
	[IDRecotizacion]                     [dbo].[UDT_VarcharCorto] NULL,
	[PartnerConfirmado]                  [dbo].[UDT_Bit] NULL,
	[WrittenBy]                          [dbo].[UDT_VarcharCorto] NULL,
	[SeguroValidado]                     [dbo].[UDT_Bit] NULL,
	[FechaCaptura]                       [dbo].[UDT_DateTime] NULL,
	[Ruta]                               [dbo].[UDT_VarcharLargo] NULL,
	[FechaLimiteRuta]                    [dbo].[UDT_VarcharCorto] NULL,
	[TelefonoEntrega]                    [dbo].[UDT_VarcharCorto] NULL,
	[NumLinea]                           [dbo].[UDT_VarcharCorto] NULL,
	[OETipoParte]                        [dbo].[UDT_VarcharCorto] NULL,
	[AltPartNum]                         [dbo].[UDT_VarcharCorto] NULL,
	[AltTipoParte]                       [dbo].[UDT_VarcharCorto] NULL,
	[ciecaTipoParte]                     [dbo].[UDT_VarcharCorto] NULL,
	[partDescripcion]                    [dbo].[UDT_VarcharMediano] NULL,
	[CantidadCotizacionDetalle]          [dbo].[UDT_Int] NULL,
	[PrecioListaOnRO]                    [dbo].[UDT_VarcharCorto] NULL,
	[PrecioNetoOnRO]                     [dbo].[UDT_VarcharCorto] NULL,
	[NecesitadoParaFecha]                [dbo].[UDT_DateTime] NULL,
	[ID_Cliente]                         [dbo].[UDT_PK] NULL,
	[ID_Ciudad]                          [dbo].[UDT_PK] NULL,
	[ID_StatusOrden]                     [dbo].[UDT_PK] NULL,
	[Total_Orden]                        [dbo].[UDT_Decimal12.2] NULL,
	[Fecha_Orden]                        [dbo].[UDT_DateTime] NULL,
	[NumeroOrden]                        [dbo].[UDT_VarcharCorto] NULL,
	[ID_DetalleOrden]                    [dbo].[UDT_PK] NULL,
	[ID_Parte]                           [dbo].[UDT_VarcharCorto] NULL,
	[ID_Descuento]                       [dbo].[UDT_PK] NULL,
	[CantidadDetalleOrden]               [dbo].[UDT_Int] NULL,
	[VehiculoID]                         [dbo].[UDT_PK] NULL,
) ON [PRIMARY]
GO

--Merge para ingresar datos la primera vez		
CREATE PROCEDURE USP_MergeFact
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN
		DECLARE @NuevoGUIDInsert UNIQUEIDENTIFIER = NEWID(), @MaxFechaEjecucion DATETIME, @RowsAffected INT
		
        -- Insert en factlog
		    INSERT INTO FactLog ([ID_Batch], [FechaEjecucion], [NuevosRegistros])
		    VALUES (@NuevoGUIDInsert,@MaxFechaEjecucion,NULL)
		-- Fin insert en factlog
        
		--Query de merge
			MERGE RepuestosWebDWH.Fact.Orden AS T
			USING (
				SELECT
					-- SKS
					[DSCT].[SK_Descuento],
					[VEHC].[SK_Vehiculo],
					[SORD].[SK_StatusOrden],
					[CLNT].[SK_Clientes],
					[PLNT].[SK_Planta],
					[PART].[SK_Partes],
					[ORGN].[SK_Origen],
					[ASEG].[SK_Aseguradora],
					[GEOG].[SK_Geografia],
					-- ATRIBUTOS FECHA
					[F].[DateKey],
					-- ATRIBUTOS LINAJE
	    	        @NuevoGUIDINsert as ID_Batch,
	    	        'ssis' as ID_SourceSystem,
					-- ATRIBUTOS TABLA ORDEN
					[O].[ID_Orden],
					[O].[IDCotizacion],
					[O].[status],
					[O].[TipoDocumento],
					[O].[FechaCreacionCotizacion],
					[O].[FechaModificacionCotizacion],
					[O].[ProcesadoPor],
					[O].[IDAseguradora],
					[O].[AseguradoraSubsidiaria],
					[O].[NumeroReclamo],
					[O].[IDPlantaReparacion],
					[O].[OrdenRealizada],
					[O].[CotizacionRealizada],
					[O].[CotizacionDuplicada],
					[O].[procurementFolderID],
					[O].[DireccionEntrega1],
					[O].[DireccionEntrega2],
					[O].[MarcadoEntrega],
					[O].[IDPartner],
					[O].[CodigoPostal],
					[O].[LeidoPorPlantaReparacion],
					[O].[LeidoPorPlantaReparacionFecha],
					[O].[CotizacionReabierta],
					[O].[EsAseguradora],
					[O].[CodigoVerificacion],
					[O].[IDClientePlantaReparacion],
					[O].[FechaCreacionRegistro],
					[O].[IDRecotizacion],
					[O].[PartnerConfirmado],
					[O].[WrittenBy],
					[O].[SeguroValidado],
					[O].[FechaCaptura],
					[O].[Ruta],
					[O].[FechaLimiteRuta],
					[O].[TelefonoEntrega],
					[O].[NumLinea],
					[O].[OETipoParte],
					[O].[AltPartNum],
					[O].[AltTipoParte],
					[O].[ciecaTipoParte],
					[O].[partDescripcion],
					[O].[CantidadCotizacionDetalle],
					[O].[PrecioListaOnRO],
					[O].[PrecioNetoOnRO],
					[O].[NecesitadoParaFecha],
					[O].[ID_Cliente],
					[O].[ID_Ciudad],
					[O].[ID_StatusOrden],
					[O].[Total_Orden],
					[O].[Fecha_Orden],
					[O].[NumeroOrden],
					[O].[ID_DetalleOrden],
					[O].[ID_Parte],
					[O].[ID_Descuento],
					[O].[CantidadDetalleOrden],
					[O].[VehiculoID]
					FROM [STAGING].[ORDEN] O
						INNER JOIN [Dimension].[Origen]        ORGN    ON ([ORGN].[ID_Orden]            = [O].[ID_Orden])
						LEFT  JOIN [Dimension].[Vehiculo]      VEHC    ON ([VEHC].[VehiculoID]          = [O].[VehiculoID])
						LEFT  JOIN [Dimension].[Descuento]     DSCT    ON ([DSCT].[ID_Descuento]        = [O].[ID_Descuento])
						INNER JOIN [Dimension].[StatusOrden]   SORD    ON ([SORD].[ID_StatusOrden]      = [O].[ID_StatusOrden])
						LEFT  JOIN [Dimension].[Planta]        PLNT    ON ([PLNT].[IDPlantaReparacion]  = [O].[IDPlantaReparacion]  AND [O].Fecha_Orden BETWEEN IIF([PLNT].[FechaInicioValidez] > [O].Fecha_Orden, [O].Fecha_Orden, [PLNT].[FechaInicioValidez]) AND ISNULL([PLNT].[FechaFinValidez], '9999-12-31'))
						LEFT  JOIN [Dimension].[Partes]        PART    ON ([PART].[ID_Parte]            = [O].[ID_Parte]            AND [O].Fecha_Orden BETWEEN IIF([PART].[FechaInicioValidez] > [O].Fecha_Orden, [O].Fecha_Orden, [PART].[FechaInicioValidez]) AND ISNULL([PART].[FechaFinValidez], '9999-12-31'))
						INNER JOIN [Dimension].[Geografia]     GEOG    ON ([GEOG].[Id_Ciudad]           = [O].[ID_Ciudad]           AND [O].Fecha_Orden BETWEEN IIF([GEOG].[FechaInicioValidez] > [O].Fecha_Orden, [O].Fecha_Orden, [GEOG].[FechaInicioValidez]) AND ISNULL([GEOG].[FechaFinValidez], '9999-12-31'))
						LEFT  JOIN [Dimension].[Clientes]      CLNT    ON ([CLNT].[ID_Cliente]          = [O].[ID_Cliente]          AND [O].Fecha_Orden BETWEEN IIF([CLNT].[FechaInicioValidez] > [O].Fecha_Orden, [O].Fecha_Orden, [CLNT].[FechaInicioValidez]) AND ISNULL([CLNT].[FechaFinValidez], '9999-12-31'))
						LEFT  JOIN [Dimension].[Aseguradora]   ASEG    ON ([ASEG].[IDAseguradora]       = [O].[IDAseguradora]       AND [O].Fecha_Orden BETWEEN IIF([ASEG].[FechaInicioValidez] > [O].Fecha_Orden, [O].Fecha_Orden, [ASEG].[FechaInicioValidez]) AND ISNULL([ASEG].[FechaFinValidez], '9999-12-31'))
						
						LEFT JOIN Dimension.Fecha F ON(CAST( (CAST(YEAR(O.Fecha_Orden) AS VARCHAR(4)))+left('0'+CAST(MONTH(O.Fecha_Orden) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(O.Fecha_Orden) AS VARCHAR(4))),2) AS INT)  = F.DateKey)
    	    ) AS SRC ON (SRC.ID_ORDEN = [T].[ID_Orden])
        --Fin query de merge



        --Insertar cuando no existe
		    WHEN NOT MATCHED BY TARGET THEN
		      INSERT (       [SK_Descuento],       [SK_Vehiculo],       [SK_StatusOrden],       [SK_Clientes],       [SK_Planta],       [SK_Partes],       [SK_Origen],       [SK_Aseguradora],       [SK_Geografia],       [DateKey],       [ID_Batch],       [ID_SourceSystem],       [ID_Orden],       [IDCotizacion],       [status],       [TipoDocumento],       [FechaCreacionCotizacion],       [FechaModificacionCotizacion],       [ProcesadoPor],       [IDAseguradora],       [AseguradoraSubsidiaria],       [NumeroReclamo],       [IDPlantaReparacion],       [OrdenRealizada],       [CotizacionRealizada],       [CotizacionDuplicada],       [procurementFolderID],       [DireccionEntrega1],       [DireccionEntrega2],       [MarcadoEntrega],       [IDPartner],       [CodigoPostal],       [LeidoPorPlantaReparacion],       [LeidoPorPlantaReparacionFecha],       [CotizacionReabierta],       [EsAseguradora],       [CodigoVerificacion],       [IDClientePlantaReparacion],       [FechaCreacionRegistro],       [IDRecotizacion],       [PartnerConfirmado],       [WrittenBy],       [SeguroValidado],       [FechaCaptura],       [Ruta],       [FechaLimiteRuta],       [TelefonoEntrega],       [NumLinea],       [OETipoParte],       [AltPartNum],       [AltTipoParte],       [ciecaTipoParte],       [partDescripcion],       [CantidadCotizacionDetalle],       [PrecioListaOnRO],       [PrecioNetoOnRO],       [NecesitadoParaFecha],       [ID_Cliente],       [ID_Ciudad],       [ID_StatusOrden],       [Total_Orden],       [Fecha_Orden],       [NumeroOrden],       [ID_DetalleOrden],       [ID_Parte],       [ID_Descuento],       [CantidadDetalleOrden],       [VehiculoID] )
			  VALUES ( [SRC].[SK_Descuento], [SRC].[SK_Vehiculo], [SRC].[SK_StatusOrden], [SRC].[SK_Clientes], [SRC].[SK_Planta], [SRC].[SK_Partes], [SRC].[SK_Origen], [SRC].[SK_Aseguradora], [SRC].[SK_Geografia], [SRC].[DateKey], [SRC].[ID_Batch], [SRC].[ID_SourceSystem], [SRC].[ID_Orden], [SRC].[IDCotizacion], [SRC].[status], [SRC].[TipoDocumento], [SRC].[FechaCreacionCotizacion], [SRC].[FechaModificacionCotizacion], [SRC].[ProcesadoPor], [SRC].[IDAseguradora], [SRC].[AseguradoraSubsidiaria], [SRC].[NumeroReclamo], [SRC].[IDPlantaReparacion], [SRC].[OrdenRealizada], [SRC].[CotizacionRealizada], [SRC].[CotizacionDuplicada], [SRC].[procurementFolderID], [SRC].[DireccionEntrega1], [SRC].[DireccionEntrega2], [SRC].[MarcadoEntrega], [SRC].[IDPartner], [SRC].[CodigoPostal], [SRC].[LeidoPorPlantaReparacion], [SRC].[LeidoPorPlantaReparacionFecha], [SRC].[CotizacionReabierta], [SRC].[EsAseguradora], [SRC].[CodigoVerificacion], [SRC].[IDClientePlantaReparacion], [SRC].[FechaCreacionRegistro], [SRC].[IDRecotizacion], [SRC].[PartnerConfirmado], [SRC].[WrittenBy], [SRC].[SeguroValidado], [SRC].[FechaCaptura], [SRC].[Ruta], [SRC].[FechaLimiteRuta], [SRC].[TelefonoEntrega], [SRC].[NumLinea], [SRC].[OETipoParte], [SRC].[AltPartNum], [SRC].[AltTipoParte], [SRC].[ciecaTipoParte], [SRC].[partDescripcion], [SRC].[CantidadCotizacionDetalle], [SRC].[PrecioListaOnRO], [SRC].[PrecioNetoOnRO], [SRC].[NecesitadoParaFecha], [SRC].[ID_Cliente], [SRC].[ID_Ciudad], [SRC].[ID_StatusOrden], [SRC].[Total_Orden], [SRC].[Fecha_Orden], [SRC].[NumeroOrden], [SRC].[ID_DetalleOrden], [SRC].[ID_Parte], [SRC].[ID_Descuento], [SRC].[CantidadDetalleOrden], [SRC].[VehiculoID] )
		-- Fin Inserta cuando no existe


		;
		SET @RowsAffected =@@ROWCOUNT

		SELECT @MaxFechaEjecucion=MAX(MaxFechaEjecucion)
		FROM(
			SELECT MAX(Fecha_Orden) as MaxFechaEjecucion
			FROM RepuestosWebDWH.FACT.Orden

		) AS A

		UPDATE FactLog
		SET NuevosRegistros=@RowsAffected, FechaEjecucion = @MaxFechaEjecucion
		WHERE ID_Batch = @NuevoGUIDInsert

		COMMIT
	END TRY
	BEGIN CATCH
		SELECT @@ERROR,'Ocurrio el siguiente error: '+ERROR_MESSAGE()
		IF (@@TRANCOUNT>0)
			ROLLBACK;
	END CATCH

END
GO