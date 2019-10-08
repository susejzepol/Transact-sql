-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- CREADO POR:  Jesus Lopez Mesia 
-- FECHA:       05-10-2019
-- ARTÍCULO:    Usando WITH CHECK OPTION sobre una vista.
-- CONTACTO:    https://www.linkedin.com/in/susejzepol/
-------------------------------------------------------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Paso 1:  A continuación, se crea una vista que contiene en su definición el operador de conjunto
--          UNION ALL.

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[view_SalesOrderHeader_v1]') AND type = 'V')
BEGIN
    DROP VIEW [dbo].[view_SalesOrderHeader_v1]
END
GO

CREATE VIEW view_SalesOrderHeader_v1
AS
--> Temp_2001]
SELECT 
    [2001].SalesOrderNumber
    ,[2001].ResellerKey
    ,[2001].EmployeeID
    ,[2001].OrderDate
    ,[2001].ShipDate
    ,[2001].PaymentType
FROM [dbo].[Temp_2001] AS [2001]
WHERE [2001].[PaymentType] = 2

UNION ALL

--> Temp_2002]
SELECT 
    [2002].SalesOrderNumber
    ,[2002].ResellerKey
    ,[2002].EmployeeID
    ,[2002].OrderDate
    ,[2002].ShipDate
    ,[2002].PaymentType
FROM [dbo].[Temp_2002] AS [2002]
WHERE [2002].[PaymentType] = 2

GO

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Paso 2:  Al intentar insertar un registro a través de la vista obtendremos un mensaje de error.
--          Debido a que, la vista usa el operador UNION ALL, que es considerado un derivación sobre
--          las columnas de la vista.

INSERT [dbo].[view_SalesOrderHeader_v1]
VALUES
(
 'SOXXX10', 684 ,286,'2001-01-01','2001-01-01',1
)
GO

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Paso 3:  Para lograr que la vista cumpla con la definición de una vista actualizable
--          cambiamos su definición. Para esto, retiramos la cláusula UNION ALL.

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[view_SalesOrderHeader_v1]') AND type = 'V')
BEGIN
    DROP VIEW [dbo].[view_SalesOrderHeader_v1]
END
GO

CREATE VIEW view_SalesOrderHeader_v1
AS
--> Temp_2001]
SELECT 
    [2001].SalesOrderNumber
    ,[2001].ResellerKey
    ,[2001].EmployeeID
    ,[2001].OrderDate
    ,[2001].ShipDate
    ,[2001].PaymentType
FROM [dbo].[Temp_2001] AS [2001]
WHERE [2001].[PaymentType] = 2

GO

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Paso 4:  Ahora que la vista cumple con los requisitos de una vista actualizable se
--          logrará insertar el registro.

INSERT [dbo].[view_SalesOrderHeader_v1]
VALUES
(
 'SOXXX10', 684 ,286,'2001-01-01','2001-01-01',1
)
GO

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Paso 5: Sin embargo, el registro que acabamos de insertar no es devuelto por la vista.
--         Debido a que, esta filtra el valor "2" para el campo "PaymentType".

--> Buscamos el registro en la vista (No existen datos)
SELECT * FROM [dbo].[view_SalesOrderHeader_v1]
WHERE SalesOrderNumber = 'SOXXX10'

--> Buscamos el registro en la vista (Existen datos)
SELECT * FROM [dbo].[Temp_2001]
WHERE SalesOrderNumber = 'SOXXX10'

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Paso 6: Para controlar los datos que insertamos y/o modificamos a través de la vista, usamos la cláusula
--         WITH CHECK OPTION. Con esto, nos aseguramos que los registros que se modifiquen cumplan 
--         con la condición WHERE de su definición.

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[view_SalesOrderHeader_v1]') AND type = 'V')
BEGIN
    DROP VIEW [dbo].[view_SalesOrderHeader_v1]
END
GO

CREATE VIEW view_SalesOrderHeader_v1
AS
--> Temp_2001]
SELECT 
    [2001].SalesOrderNumber
    ,[2001].ResellerKey
    ,[2001].EmployeeID
    ,[2001].OrderDate
    ,[2001].ShipDate
    ,[2001].PaymentType
FROM [dbo].[Temp_2001] AS [2001]
WHERE [2001].[PaymentType] = 2
WITH CHECK OPTION
GO

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Paso 7: Cuando se intenta ingresar el registro anterior obtendremos un error, el cual nos indica
--         que, el valor que estamos tratando de insertar no cumple con la definición de la vista.

INSERT [dbo].[view_SalesOrderHeader_v1]
VALUES
(
 'SOXXX10', 684 ,286,'2001-01-01','2001-01-01',1
)
GO

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Paso 8: WITH CHECK OPTION también se hereda a través de vistas. A continuación, se crea una vista
--         usando la primera que contiene esta cláusula.

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[view_SalesOrderHeader_v2]') AND type = 'V')
BEGIN
    DROP VIEW [dbo].[view_SalesOrderHeader_v2]
END
GO
CREATE VIEW view_SalesOrderHeader_v2
AS
SELECT * FROM [dbo].[view_SalesOrderHeader_v1]
GO

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Paso 9: Por último, cuando intentamos modificar un registro utilizando la nueva vista
--         obtendremos el mismo mensaje de error que en el paso 7.

UPDATE dbo.view_SalesOrderHeader_v2
SET
    PaymentType = 1
WHERE SalesOrderNumber = 'SO43683'


