USE [ADSReports]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetFechasDespliegueRealFases]    Script Date: 26/03/2020 7:50:16 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[fn_GetFechasDespliegueRealFases]
(
	 @TEAMPROJECTCOLLECTIONGUID AS INT
)
RETURNS @FechasDespliegueRealFases TABLE 
(
 BriefId int NULL,
 Fase int NULL,
 Claro_ALM_FechaDespliegueRealFase DATETIME NULL
)
AS
BEGIN 

INSERT @FechasDespliegueRealFases
SELECT BriefID,CAST(REPLACE(Fase,'Claro_ALM_FechaDespliegueRealFase','') AS INT) as Fase,Claro_ALM_FechaDespliegueRealFase
FROM(
	SELECT BriefID,Fase,Claro_ALM_FechaDespliegueRealFase
	FROM
		(SELECT 
				System_Id as BriefID,
				Claro_ALM_FechaDespliegueRealFase1,
				Claro_ALM_FechaDespliegueRealFase2,
				Claro_ALM_FechaDespliegueRealFase3,
				Claro_ALM_FechaDespliegueRealFase4,
				Claro_ALM_FechaDespliegueRealFase5,
				Claro_ALM_FechaDespliegueRealFase6,
				Claro_ALM_FechaDespliegueRealFase7,
				Claro_ALM_FechaDespliegueRealFase8,
				Claro_ALM_FechaDespliegueRealFase9,
				Claro_ALM_FechaDespliegueRealFase10,
				Claro_ALM_FechaDespliegueRealFase11,
				Claro_ALM_FechaDespliegueRealFase12,
				Claro_ALM_FechaDespliegueRealFase13,
				Claro_ALM_FechaDespliegueRealFase14,
				Claro_ALM_FechaDespliegueRealFase15,
				Claro_ALM_FechaDespliegueRealFase16,
				Claro_ALM_FechaDespliegueRealFase17,
				Claro_ALM_FechaDespliegueRealFase18,
				Claro_ALM_FechaDespliegueRealFase19,
				Claro_ALM_FechaDespliegueRealFase20
		FROM [ads_Warehouse].[dbo].[CurrentWorkItemView]
		WHERE System_WorkItemType='BRIEF'
		AND TeamProjectCollectionSK =@TEAMPROJECTCOLLECTIONGUID) p
		UNPIVOT
			(Claro_ALM_FechaDespliegueRealFase 
				FOR FASE IN
						(Claro_ALM_FechaDespliegueRealFase1,
						Claro_ALM_FechaDespliegueRealFase2,
						Claro_ALM_FechaDespliegueRealFase3,
						Claro_ALM_FechaDespliegueRealFase4,
						Claro_ALM_FechaDespliegueRealFase5,
						Claro_ALM_FechaDespliegueRealFase6,
						Claro_ALM_FechaDespliegueRealFase7,
						Claro_ALM_FechaDespliegueRealFase8,
						Claro_ALM_FechaDespliegueRealFase9,
						Claro_ALM_FechaDespliegueRealFase10,
						Claro_ALM_FechaDespliegueRealFase11,
						Claro_ALM_FechaDespliegueRealFase12,
						Claro_ALM_FechaDespliegueRealFase13,
						Claro_ALM_FechaDespliegueRealFase14,
						Claro_ALM_FechaDespliegueRealFase15,
						Claro_ALM_FechaDespliegueRealFase16,
						Claro_ALM_FechaDespliegueRealFase17,
						Claro_ALM_FechaDespliegueRealFase18,
						Claro_ALM_FechaDespliegueRealFase19,
						Claro_ALM_FechaDespliegueRealFase20)
		) AS unpvt) 
	AS fechasRealDespliegue
	

RETURN
END






