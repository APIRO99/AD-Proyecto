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