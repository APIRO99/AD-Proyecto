USE [RepuestosWebDWH]
GO

--Creamos tabla para log de fact batches
CREATE TABLE FactLog
(
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

create schema [staging]
go

DROP TABLE IF EXISTS [staging].[Orden]
GO

CREATE TABLE [staging].[Orden](
				ID_Orden INT NULL,
				ID_Parte varchar(50) null,
				ID_Ciudad INT NULL,
				ID_Cliente INT NULL,
				ID_DetalleOrden INT NULL,
				ID_StatusOrden INT NULL,
				Total_Orden [decimal](12, 2) NULL,
				CantidadOrden INT NULL,
				StatusOrden [varchar](100) NULL,
				FechaOrden DATETIME

) ON [PRIMARY]

--select para el ssis--
--Select ID_Parte from staging.Orden

--Select O.ID_Orden,
--		O.ID_Ciudad as ID_Geografia,
--		O.ID_Ciudad,
--		O.ID_Cliente,
--		DO.ID_Parte,
--		DO.ID_DetalleOrden,
--		SO.ID_StatusOrden,
--		DO.Cantidad as CanitdadOrden,
--		SO.NombreStatus as StatusOrden,
--		O.Fecha_Orden,
--		O.Total_Orden
--		from RepuestosWeb.dbo.Orden O
--		INNER JOIN RepuestosWeb.dbo.Detalle_orden DO ON(O.ID_Orden = DO.ID_Orden)
--		INNER JOIN RepuestosWeb.dbo.StatusOrden SO ON(SO.ID_StatusOrden = O.ID_StatusOrden)
--		WHERE (Fecha_Orden>?);
--select para el ssis--

--Merge para ingresar datos la primera vez		
CREATE PROCEDURE USP_MergeFact
as
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN
		DECLARE @NuevoGUIDInsert UNIQUEIDENTIFIER = NEWID(), @MaxFechaEjecucion DATETIME, @RowsAffected INT
		
		INSERT INTO RepuestosWebDWH.dbo.FactLog ([ID_Batch], [FechaEjecucion], [NuevosRegistros])
		VALUES (@NuevoGUIDInsert,NULL,NULL)
		
		MERGE RepuestosWebDWH.Fact.Orden AS T
		USING (

			SELECT [SK_Geografia], [SK_Clientes], [SK_Partes], [DateKey], [ID_Orden], p.[ID_Partes], R.[ID_Cliente],  r.[ID_Ciudad] AS ID_Geografia ,[ID_DetalleOrden], [ID_StatusOrden], [Total_Orden] , [CantidadOrden], [StatusOrden], [FechaOrden] , getdate() as FechaCreacion, 'ETL' as UsuarioCreacion, NULL as FechaModificacion, NULL as UsuarioModificacion, @NuevoGUIDINsert as ID_Batch, 'ssis' as ID_SourceSystem
			FROM [staging].Orden R

			INNER JOIN Dimension.Clientes CA ON (CA.Id_Cliente = R.Id_Cliente)
			INNER JOIN Dimension.Geografia G ON (R.ID_Ciudad = G.id_ciudad)
			INNER JOIN Dimension.Partes P ON (P.ID_Partes = r.[ID_Parte] )			
			LEFT JOIN Dimension.Fecha F ON(CAST( (CAST(YEAR(R.FechaOrden) AS VARCHAR(4)))+left('0'+CAST(MONTH(R.FechaOrden) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(R.FechaOrden) AS VARCHAR(4))),2) AS INT)  = F.DateKey)) AS S ON (S.ID_Orden = T.ID_Orden)
		WHEN NOT MATCHED BY TARGET THEN --No existe en Fact
		INSERT ([SK_Geografia],     [SK_Clientes],   [SK_Partes],   [DateKey],   [ID_Orden],  [ID_Cliente] ,         ID_Ciudad,   [ID_Partes],  [ID_DetalleOrden],    [ID_StatusOrden],   [Total_Orden],   [CantidadOrden],   [StatusOrden],     [Fecha_Orden],     [FechaCreacion],     [UsuarioCreacion],     [FechaModificacion],  [UsuarioModificacion], [ID_Batch], [ID_SourceSystem])
		VALUES (S.[SK_Geografia], S.[SK_Clientes], S.[SK_Partes], S.[DateKey], S.[ID_Orden], S.[ID_Cliente], S.[ID_Geografia] , s.[ID_Partes], S.[ID_DetalleOrden], S.[ID_StatusOrden], S.[Total_Orden], S.[CantidadOrden], S.[StatusOrden],      S.FechaOrden,   S.[FechaCreacion],   S.[UsuarioCreacion],   S.[FechaModificacion], S.[UsuarioModificacion], S.[ID_Batch], S.[ID_SourceSystem]);

		SET @RowsAffected =@@ROWCOUNT

		SELECT @MaxFechaEjecucion=MAX(MaxFechaEjecucion)
		FROM(
			SELECT MAX(Fecha_Orden) as MaxFechaEjecucion
			FROM RepuestosWebDWH.FACT.Orden

		)AS A

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
go


--Drop Merge y crear procedure para la segunda vez en adelante
Drop Procedure USP_MergeFact;


CREATE PROCEDURE USP_MergeFact
as
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN
		DECLARE @NuevoGUIDInsert UNIQUEIDENTIFIER = NEWID(), @MaxFechaEjecucion DATETIME, @RowsAffected INT
		
		INSERT INTO RepuestosWebDWH.dbo.FactLog ([ID_Batch], [FechaEjecucion], [NuevosRegistros])
		VALUES (@NuevoGUIDInsert,NULL,NULL)
		
		MERGE RepuestosWebDWH.Fact.Orden AS T
		USING (

			SELECT [SK_Geografia], [SK_Clientes], [SK_Partes], [DateKey], [ID_Orden], p.[ID_Partes], R.[ID_Cliente],  r.[ID_Ciudad] AS ID_Geografia ,[ID_DetalleOrden], [ID_StatusOrden], [Total_Orden] , [CantidadOrden], [StatusOrden], [FechaOrden] , getdate() as FechaCreacion, 'ETL' as UsuarioCreacion, NULL as FechaModificacion, NULL as UsuarioModificacion, Null as ID_Batch, 'ssis' as ID_SourceSystem
			FROM [staging].Orden R

			INNER JOIN Dimension.Clientes CA ON(CA.Id_Cliente = R.Id_Cliente and
													R.FechaOrden BETWEEN CA.FechaInicioValidez AND ISNULL(CA.FechaFinValidez, '9999-12-31'))
			INNER JOIN Dimension.Geografia G ON (R.ID_Ciudad = G.id_ciudad and
													R.FechaOrden BETWEEN G.FechaInicioValidez AND ISNULL(G.FechaFinValidez, '9999-12-31'))
			INNER JOIN Dimension.Partes P ON (P.ID_Partes = r.[ID_Parte] and
													R.FechaOrden BETWEEN P.FechaInicioValidez AND ISNULL(P.FechaFinValidez, '9999-12-31'))
			
			LEFT JOIN Dimension.Fecha F ON(CAST( (CAST(YEAR(R.FechaOrden) AS VARCHAR(4)))+left('0'+CAST(MONTH(R.FechaOrden) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(R.FechaOrden) AS VARCHAR(4))),2) AS INT)  = F.DateKey)
			) AS S ON (S.ID_Orden = T.ID_Orden)
		WHEN NOT MATCHED BY TARGET THEN --No existe en Fact
		INSERT ([SK_Geografia],     [SK_Clientes],   [SK_Partes],   [DateKey],   [ID_Orden],  [ID_Cliente] ,         ID_Ciudad,   [ID_Partes],  [ID_DetalleOrden],    [ID_StatusOrden],   [Total_Orden],   [CantidadOrden],   [StatusOrden],     [Fecha_Orden],     [FechaCreacion],     [UsuarioCreacion],     [FechaModificacion],  [UsuarioModificacion], [ID_Batch], [ID_SourceSystem])
		VALUES (S.[SK_Geografia], S.[SK_Clientes], S.[SK_Partes], S.[DateKey], S.[ID_Orden], S.[ID_Cliente], S.[ID_Geografia] , s.[ID_Partes], S.[ID_DetalleOrden], S.[ID_StatusOrden], S.[Total_Orden], S.[CantidadOrden], S.[StatusOrden],      S.FechaOrden,   S.[FechaCreacion],   S.[UsuarioCreacion],   S.[FechaModificacion], S.[UsuarioModificacion], S.[ID_Batch], S.[ID_SourceSystem]);

		SET @RowsAffected =@@ROWCOUNT

		SELECT @MaxFechaEjecucion=MAX(MaxFechaEjecucion)
		FROM(
			SELECT MAX(Fecha_Orden) as MaxFechaEjecucion
			FROM RepuestosWebDWH.FACT.Orden

		)AS A

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
go


