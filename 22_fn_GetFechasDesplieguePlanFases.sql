USE [ADSReports]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetFechasDesplieguePlanFases]    Script Date: 26/03/2020 7:49:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[fn_GetFechasDesplieguePlanFases]
(
	 @TEAMPROJECTCOLLECTIONGUID AS INT
)
RETURNS @FechasDesplieguePlanFases TABLE 
(
 BriefId int NULL,
 Fase int NULL,
 Claro_ALM_FechaDesplieguePlanFase DATETIME NULL
)
AS
BEGIN 


INSERT @FechasDesplieguePlanFases
SELECT BriefID,CAST(REPLACE(Fase,'Claro_ALM_FechaDesplieguePlanFase','') AS INT) as Fase,Claro_ALM_FechaDesplieguePlanFase
FROM(
	SELECT BriefID,Fase,Claro_ALM_FechaDesplieguePlanFase
	FROM
		(SELECT 
				System_Id as BriefID,
				Claro_ALM_FechaDesplieguePlanFase1,
				Claro_ALM_FechaDesplieguePlanFase2,
				Claro_ALM_FechaDesplieguePlanFase3,
				Claro_ALM_FechaDesplieguePlanFase4,
				Claro_ALM_FechaDesplieguePlanFase5,
				Claro_ALM_FechaDesplieguePlanFase6,
				Claro_ALM_FechaDesplieguePlanFase7,
				Claro_ALM_FechaDesplieguePlanFase8,
				Claro_ALM_FechaDesplieguePlanFase9,
				Claro_ALM_FechaDesplieguePlanFase10,
				Claro_ALM_FechaDesplieguePlanFase11,
				Claro_ALM_FechaDesplieguePlanFase12,
				Claro_ALM_FechaDesplieguePlanFase13,
				Claro_ALM_FechaDesplieguePlanFase14,
				Claro_ALM_FechaDesplieguePlanFase15,
				Claro_ALM_FechaDesplieguePlanFase16,
				Claro_ALM_FechaDesplieguePlanFase17,
				Claro_ALM_FechaDesplieguePlanFase18,
				Claro_ALM_FechaDesplieguePlanFase19,
				Claro_ALM_FechaDesplieguePlanFase20
		FROM [ads_Warehouse].[dbo].[CurrentWorkItemView]
		WHERE System_WorkItemType='BRIEF'
		AND TeamProjectCollectionSK =@TEAMPROJECTCOLLECTIONGUID) p
		UNPIVOT
			(Claro_ALM_FechaDesplieguePlanFase 
				FOR FASE IN
						(Claro_ALM_FechaDesplieguePlanFase1,
						Claro_ALM_FechaDesplieguePlanFase2,
						Claro_ALM_FechaDesplieguePlanFase3,
						Claro_ALM_FechaDesplieguePlanFase4,
						Claro_ALM_FechaDesplieguePlanFase5,
						Claro_ALM_FechaDesplieguePlanFase6,
						Claro_ALM_FechaDesplieguePlanFase7,
						Claro_ALM_FechaDesplieguePlanFase8,
						Claro_ALM_FechaDesplieguePlanFase9,
						Claro_ALM_FechaDesplieguePlanFase10,
						Claro_ALM_FechaDesplieguePlanFase11,
						Claro_ALM_FechaDesplieguePlanFase12,
						Claro_ALM_FechaDesplieguePlanFase13,
						Claro_ALM_FechaDesplieguePlanFase14,
						Claro_ALM_FechaDesplieguePlanFase15,
						Claro_ALM_FechaDesplieguePlanFase16,
						Claro_ALM_FechaDesplieguePlanFase17,
						Claro_ALM_FechaDesplieguePlanFase18,
						Claro_ALM_FechaDesplieguePlanFase19,
						Claro_ALM_FechaDesplieguePlanFase20)
		) AS unpvt) 
	AS fechasPlanDespliegue

RETURN
END






