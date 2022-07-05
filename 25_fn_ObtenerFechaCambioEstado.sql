USE [ADSReports]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ObtenerFechaCambioEstado]    Script Date: 26/03/2020 7:53:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================

-- Description:	Permite obtener la ultima fecha de cambio a un estado especifico de un Work Item
-- =============================================
CREATE FUNCTION [dbo].[fn_ObtenerFechaCambioEstado]  
(
	@TeamProjectCollectionSK AS INT,
	@System_Id AS INT,
	@State_Name AS NVARCHAR(256)
)
RETURNS DATETIME
AS
BEGIN

	-- Declare the return variable here
	DECLARE @stateChanged_date AS DATETIME

	--SET @stateChanged_date = 
	SET @stateChanged_date=(SELECT MAX(NextChangedDate) 
	                    FROM( 
							  SELECT System_Id, System_State as PreviousState, System_ChangedDate, 
															   LEAD(System_State,1,NULL) OVER(ORDER BY System_ChangedDate) as NextState,
															   LEAD(System_ChangedDate,1,NULL) OVER(ORDER BY System_ChangedDate) as NextChangedDate
														FROM [ads_Warehouse].[dbo].DimWorkItem dwi
														WHERE TeamProjectCollectionSK = @TeamProjectCollectionSK and System_Id = @System_Id 
														) as CambioEstados
						WHERE NextState = @State_Name and PreviousState <> NextState);



	-- Return the result of the function
	RETURN @stateChanged_date
END


