USE [ADSReports]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetEstadosFases]    Script Date: 26/03/2020 7:48:47 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[fn_GetEstadosFases]
(
	 @TEAMPROJECTCOLLECTIONGUID AS INT
)
RETURNS @EstadosFases TABLE 
(
 BriefId int NULL,
 Fase int NULL,
 Claro_ALM_EstadoFase VARCHAR(30) NULL
)
AS
BEGIN 


INSERT @EstadosFases
SELECT BriefID,CAST(REPLACE(Fase,'Claro_ALM_EstadoFase','') AS INT) as Fase,Claro_ALM_EstadoFase
FROM(
	SELECT BriefID,Fase,Claro_ALM_EstadoFase
	FROM
		(SELECT 
				System_Id as BriefID,
				Claro_ALM_EstadoFase1,
				Claro_ALM_EstadoFase2,
				Claro_ALM_EstadoFase3,
				Claro_ALM_EstadoFase4,
				Claro_ALM_EstadoFase5,
				Claro_ALM_EstadoFase6,
				Claro_ALM_EstadoFase7,
				Claro_ALM_EstadoFase8,
				Claro_ALM_EstadoFase9,
				Claro_ALM_EstadoFase10,
				Claro_ALM_EstadoFase11,
				Claro_ALM_EstadoFase12,
				Claro_ALM_EstadoFase13,
				Claro_ALM_EstadoFase14,
				Claro_ALM_EstadoFase15,
				Claro_ALM_EstadoFase16,
				Claro_ALM_EstadoFase17,
				Claro_ALM_EstadoFase18,
				Claro_ALM_EstadoFase19,
				Claro_ALM_EstadoFase20
		FROM [ads_Warehouse].[dbo].[CurrentWorkItemView]
		WHERE System_WorkItemType='BRIEF'
		AND TeamProjectCollectionSK =@TEAMPROJECTCOLLECTIONGUID) p
		UNPIVOT
			(Claro_ALM_EstadoFase 
				FOR FASE IN
						(Claro_ALM_EstadoFase1,
						Claro_ALM_EstadoFase2,
						Claro_ALM_EstadoFase3,
						Claro_ALM_EstadoFase4,
						Claro_ALM_EstadoFase5,
						Claro_ALM_EstadoFase6,
						Claro_ALM_EstadoFase7,
						Claro_ALM_EstadoFase8,
						Claro_ALM_EstadoFase9,
						Claro_ALM_EstadoFase10,
						Claro_ALM_EstadoFase11,
						Claro_ALM_EstadoFase12,
						Claro_ALM_EstadoFase13,
						Claro_ALM_EstadoFase14,
						Claro_ALM_EstadoFase15,
						Claro_ALM_EstadoFase16,
						Claro_ALM_EstadoFase17,
						Claro_ALM_EstadoFase18,
						Claro_ALM_EstadoFase19,
						Claro_ALM_EstadoFase20)
		) AS unpvt) 
	AS estadosFases
	

RETURN
END






