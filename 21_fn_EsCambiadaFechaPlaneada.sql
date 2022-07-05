USE [ADSReports]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_EsCambiadaFechaPlaneada]    Script Date: 26/03/2020 7:52:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Erick Leonardo Saenz Pardo
-- Create date: 10-01-2019
-- Description:	Funcion que permite averiguar si se ha cambiado la fecha planeada de despliegue
--				en un RLP a un valor mayor al inicialmente registrado.
-- =============================================
CREATE FUNCTION [dbo].[fn_EsCambiadaFechaPlaneada]
(
	@TeamProjectCollectionSK AS INT,
	@LineaProducto_Id AS INT
)
RETURNS BIT
AS
BEGIN
	-- Declare the return variable here
	DECLARE  @Result BIT,
	         @FechaMinima DATETIME,
			 @FechaMaxima  DATETIME
	-- Add the T-SQL statements to compute the return value here



SET @FechaMinima=(SELECT
							dwi.Claro_ALM_FechaPlaneadaDespliegue
							FROM [ads_Warehouse].[dbo].DimWorkItem dwi
							WHERE dwi.System_Id = @LineaProducto_Id
							AND dwi.TeamProjectCollectionSK = @TeamProjectCollectionSK 
							AND dwi.Claro_ALM_FechaPlaneadaDespliegue IS NOT NULL
							AND dwi.System_ChangedDate = (SELECT MIN(dwi2.System_ChangedDate) 
														  FROM [ads_Warehouse].[dbo].DimWorkItem dwi2 
														  WHERE dwi2.System_Id = dwi.System_Id 
																AND dwi2.TeamProjectCollectionSK = dwi.TeamProjectCollectionSK
																AND dwi2.Claro_ALM_FechaPlaneadaDespliegue IS NOT NULL));



																 
	SET @FechaMaxima =(SELECT 
						dwi.Claro_ALM_FechaPlaneadaDespliegue
						FROM [ads_Warehouse].[dbo].DimWorkItem dwi
						WHERE dwi.System_Id = @LineaProducto_Id 
						AND dwi.TeamProjectCollectionSK = @TeamProjectCollectionSK 
						AND dwi.Claro_ALM_FechaPlaneadaDespliegue IS NOT NULL
						AND dwi.System_ChangedDate = (SELECT MAX(dwi2.System_ChangedDate) 
													  FROM [ads_Warehouse].[dbo].DimWorkItem dwi2 
													  WHERE dwi2.System_Id = dwi.System_Id 
															AND dwi2.TeamProjectCollectionSK = dwi.TeamProjectCollectionSK
															AND dwi2.Claro_ALM_FechaPlaneadaDespliegue IS NOT NULL));

		
	IF @FechaMinima IS NULL
		SET @Result = 0
	ELSE
		BEGIN 	
			IF @FechaMaxima > @FechaMinima
				SET @Result = 1
			ELSE
				SET @Result = 0
		END 
	
	-- Return the result of the function
	RETURN (@Result)
END


