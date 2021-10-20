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