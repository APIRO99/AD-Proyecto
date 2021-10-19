USE [RepuestosWebDWH]
GO

create schema [staging]
go

--#region [Factlog]
    --Creamos tabla para log de fact batches
    CREATE TABLE FactLog (
        ID_Batch UNIQUEIDENTIFIER DEFAULT(NEWID()),
        FechaEjecucion DATETIME DEFAULT(GETDATE()),
        NuevosRegistros INT,
        CONSTRAINT [PK_FactLog] PRIMARY KEY ( ID_Batch )
    )
    GO

    --Agregamos FK
    ALTER TABLE Fact.Orden ADD CONSTRAINT [FK_IDBatch] FOREIGN KEY (ID_Batch) 
    REFERENCES Factlog(ID_Batch)
    go

--#endregion

-- #region [Crea tabla de staging]
    DROP TABLE IF EXISTS [staging].[Orden]
    GO

    CREATE TABLE [staging].[Orden](
    	[SK_Orden] [dbo].[UDT_SK] IDENTITY(1,1) NOT NULL,
    	[ID_Partes] [dbo].[UDT_PK] NULL,
    	[Id_Ciudad] [dbo].[UDT_PK] NULL,
    	[ID_Cliente] [dbo].[UDT_PK] NULL,
    	[DateKey] [int] NULL,
    	[ID_Batch] [uniqueidentifier] NULL,
    	[ID_SourceSystem] [varchar](20) NULL,
    	[ID_Orden] [dbo].[UDT_PK] NULL,
    	[Total_Orden] [dbo].[UDT_Decimal12.2] NULL,
    	[Fecha_Orden] [dbo].[UDT_DateTime] NULL,
    	[ID_StatusOrden] [dbo].[UDT_PK] NULL,
    	[NombreStatus] [dbo].[UDT_VarcharCorto] NULL,
    	[ID_Descuento] [dbo].[UDT_PK] NULL,
    	[NombreDescuento] [dbo].[UDT_VarcharMediano] NULL,
    	[PorcentajeDescuento] [dbo].[UDT_Decimal2.2] NULL,
    	[ID_DetalleOrden] [dbo].[UDT_PK] NULL,
    	[Cantidad] [int] NULL,
    ) ON [PRIMARY]
    GO
--#endregion

--#region [llena tabla de staging]
    --Query para llenar datos en Staging
    /*
    SELECT 
        [O].[ID_Orden],
        [O].[Total_Orden],
        [O].[Fecha_Orden],
    	[O].[ID_Ciudad],
    	[O].[ID_Cliente],
        [SO].[ID_StatusOrden],
        [SO].[NombreStatus],
        [D].[ID_Descuento],
        [D].[NombreDescuento],
        [D].[PorcentajeDescuento],
        [DO].[ID_DetalleOrden],
        [DO].[Cantidad],
    	[DO].[ID_Partes]
    FROM DBO.Orden O
         INNER JOIN DBO.DETALLE_ORDEN DO ON O.ID_Orden = DO.ID_Orden
    	 INNER JOIN DBO.DESCUENTO D ON D.ID_Descuento = DO.ID_Descuento
    	 INNER JOIN DBO.STATUSORDEN SO ON SO.ID_StatusOrden = O.ID_StatusOrden
    WHERE ((FechaOrden>?)
    GO
    */
--#endregion


--Script de SP para MERGE
CREATE PROCEDURE USP_MergeFact
as
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN
		    DECLARE @NuevoGUIDInsert UNIQUEIDENTIFIER = NEWID(), @MaxFechaEjecucion DATETIME = GETDATE(), @RowsAffected INT

        -- Insert en factlog
		    INSERT INTO FactLog ([ID_Batch], [FechaEjecucion], [NuevosRegistros])
		    VALUES (@NuevoGUIDInsert,@MaxFechaEjecucion,NULL)
		-- Fin insert en factlog

        --Query de merge
		    MERGE [FACT].[ORDEN] AS FO
		    USING (
                SELECT
	                [PRT].[SK_Partes],
	                [GEO].[SK_Geografia],
	                [CLT].[SK_Clientes],
	                [F].[DateKey],
	                @NuevoGUIDINsert as ID_Batch,
	                'ssis' as ID_SourceSystem,
	                [O].[ID_Orden],
	                [O].[Total_Orden],
	                [O].[Fecha_Orden],
	                [O].[ID_StatusOrden],
	                [O].[NombreStatus],
	                [O].[ID_Descuento],
	                [O].[NombreDescuento],
	                [O].[PorcentajeDescuento],
	                [O].[ID_DetalleOrden],
	                [O].[Cantidad]
            		FROM [STAGING].[ORDEN] O
						INNER JOIN [Dimension].[Geografia] GEO ON (O.Id_Ciudad = GEO.ID_Ciudad and O.Fecha_Orden BETWEEN GEO.FechaInicioValidez AND ISNULL(GEO.FechaFinValidez, '9999-12-31'))
						INNER JOIN [Dimension].[Clientes] CLT ON (O.ID_Cliente = CLT.ID_Cliente and O.Fecha_Orden BETWEEN CLT.FechaInicioValidez AND ISNULL(CLT.FechaFinValidez, '9999-12-31'))
						INNER JOIN [Dimension].[Partes] PRT ON (O.ID_Partes = PRT.ID_Partes and O.Fecha_Orden BETWEEN PRT.FechaInicioValidez AND ISNULL(PRT.FechaFinValidez, '9999-12-31'))
							
						LEFT JOIN Dimension.Fecha F ON(CAST( (CAST(YEAR(O.Fecha_Orden) AS VARCHAR(4)))+left('0'+CAST(MONTH(O.Fecha_Orden) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(O.Fecha_Orden) AS VARCHAR(4))),2) AS INT)  = F.DateKey)
            ) AS SRC ON (SRC.ID_ORDEN = FO.ID_Orden)
        --Fin query de merge
        
        --Insertar cuando no existe
		    WHEN NOT MATCHED BY TARGET THEN
		    INSERT ([SK_Partes], [SK_Geografia], [SK_Clientes], [DateKey], [ID_Batch], [ID_SourceSystem], [ID_Orden], [Total_Orden], [Fecha_Orden], [ID_StatusOrden], [NombreStatus], [ID_Descuento], [NombreDescuento], [PorcentajeDescuento], [ID_DetalleOrden], [Cantidad])
		    VALUES (SRC.[SK_Partes], SRC.[SK_Geografia], SRC.[SK_Clientes], SRC.[DateKey], SRC.[ID_Batch], SRC.[ID_SourceSystem], SRC.[ID_Orden], SRC.[Total_Orden], SRC.[Fecha_Orden], SRC.[ID_StatusOrden], SRC.[NombreStatus], SRC.[ID_Descuento], SRC.[NombreDescuento], SRC.[PorcentajeDescuento], SRC.[ID_DetalleOrden], SRC.[Cantidad]);-- Fin Insertar cuando no existe
		-- Fin Inserta cuando no existe

        SET @RowsAffected =@@ROWCOUNT

		-- Obtiene la ultima fecha de ejecucion
		    /*
		    SELECT @MaxFechaEjecucion=MAX(MaxFechaEjecucion)
		    FROM(
		    	SELECT MAX(Fecha_Orden) as MaxFechaEjecucion
		    	FROM FACT.Orden
		    	UNION
		    	SELECT MAX(FechaModificacionSource)  as MaxFechaEjecucion
		    	FROM FACT.Orden
		    )AS A
		    */
		-- Fin obtiene la ultima fecha de ejecucion

        -- Update FactLog con FechaEjecucion y NuevosRegistros
		    UPDATE FactLog
		    SET NuevosRegistros=@RowsAffected, FechaEjecucion = @MaxFechaEjecucion
		    WHERE ID_Batch = @NuevoGUIDInsert
        -- Fin Update FactLog con FechaEjecucion y NuevosRegistros

		COMMIT
	END TRY
	BEGIN CATCH
		SELECT @@ERROR,'Ocurrio el siguiente error: '+ERROR_MESSAGE()
		IF (@@TRANCOUNT>0)
			ROLLBACK;
	END CATCH

END
go

/*
--Test de SCD
USE Admisiones
go

INSERT INTO dbo.Orden ([ID_Candidato], [ID_Carrera], [ID_Descuento], [FechaPrueba], [Precio], [Nota])
values (1,1,1,getdate(),200.00,90)
go

insert into dbo.Orden_Detalle( [ID_Orden], [ID_Materia], [NotaArea])
values (@@IDENTITY,1,90)

select *
from	Admisiones_DWH.Fact.Orden e inner join
		Admisiones_DWH.Dimension.Candidato c on e.SK_Candidato = c.SK_Candidato
where	c.ID_Candidato = 1
*/

