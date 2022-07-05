USE [ADSReports]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetNumerosFases]    Script Date: 26/03/2020 7:51:04 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[fn_GetNumerosFases]
(
	 @TEAMPROJECTCOLLECTIONGUID AS INT
)
RETURNS @NumerosFases TABLE 
(
 BriefId int NULL,
 Fase int NULL,
 Claro_ALM_NumeroFase int NULL
)
AS
BEGIN 

INSERT @NumerosFases
SELECT BriefID,CAST(REPLACE(Fase,'Claro_ALM_NumeroFase','') AS INT) as Fase,Claro_ALM_NumeroFase
FROM(
	SELECT BriefID,Fase,Claro_ALM_NumeroFase
	FROM
		(SELECT 
				System_Id as BriefID,
				Claro_ALM_NumeroFase1,
				Claro_ALM_NumeroFase2,
				Claro_ALM_NumeroFase3,
				Claro_ALM_NumeroFase4,
				Claro_ALM_NumeroFase5,
				Claro_ALM_NumeroFase6,
				Claro_ALM_NumeroFase7,
				Claro_ALM_NumeroFase8,
				Claro_ALM_NumeroFase9,
				Claro_ALM_NumeroFase10,
				Claro_ALM_NumeroFase11,
				Claro_ALM_NumeroFase12,
				Claro_ALM_NumeroFase13,
				Claro_ALM_NumeroFase14,
				Claro_ALM_NumeroFase15,
				Claro_ALM_NumeroFase16,
				Claro_ALM_NumeroFase17,
				Claro_ALM_NumeroFase18,
				Claro_ALM_NumeroFase19,
				Claro_ALM_NumeroFase20
		FROM [ads_Warehouse].[dbo].[CurrentWorkItemView]
		WHERE System_WorkItemType='BRIEF'
		AND TeamProjectCollectionSK =@TEAMPROJECTCOLLECTIONGUID) p
		UNPIVOT
			(Claro_ALM_NumeroFase 
				FOR FASE IN
						(Claro_ALM_NumeroFase1,
						Claro_ALM_NumeroFase2,
						Claro_ALM_NumeroFase3,
						Claro_ALM_NumeroFase4,
						Claro_ALM_NumeroFase5,
						Claro_ALM_NumeroFase6,
						Claro_ALM_NumeroFase7,
						Claro_ALM_NumeroFase8,
						Claro_ALM_NumeroFase9,
						Claro_ALM_NumeroFase10,
						Claro_ALM_NumeroFase11,
						Claro_ALM_NumeroFase12,
						Claro_ALM_NumeroFase13,
						Claro_ALM_NumeroFase14,
						Claro_ALM_NumeroFase15,
						Claro_ALM_NumeroFase16,
						Claro_ALM_NumeroFase17,
						Claro_ALM_NumeroFase18,
						Claro_ALM_NumeroFase19,
						Claro_ALM_NumeroFase20)
		) AS unpvt) 
	AS numerosFases

	

RETURN
END






