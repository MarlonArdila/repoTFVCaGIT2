USE [ADSReports]
GO

/****** Object:  StoredProcedure [dbo].[stp_InfomeRLPFechasModificadas]    Script Date: 02/04/2020 12:23:07 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--/****** Object:  StoredProcedure [dbo].[stp_InfomeGeneralGE]    Script Date: 06/28/2017 3:53:49 AM ******/

CREATE PROCEDURE [dbo].[stp_InfomeRLPFechasModificadas] 
as
BEGIN

-------------------------------------
--Calcula el ID de la colección
-------------------------------------
DECLARE @TEAMPROJECTCOLLECTIONGUID NVARCHAR(50) =
(select ProjectNodeSK from [dbo].[DimTeamProject] 
 where ProjectNodeName='DDSPro')


-------------------------------------
--Obtenemos la información actual de los elementos BRIEF
-------------------------------------
SELECT WorkItemSK, System_Id, System_WorkItemType
into #InfoBriefs
FROM 
CurrentWorkItemView 
WHERE System_WorkItemType='BRIEF'
AND TeamProjectCollectionSK = @TEAMPROJECTCOLLECTIONGUID


-------------------------------------
--Obtenemos los elementos hijos asociados a los Brief
-------------------------------------
SELECT ib.System_Id, flcwi.TargetWorkitemSK 
into #BriefChilds
FROM 
[dbo].[vFactLinkedCurrentWorkItem] flcwi
INNER JOIN #InfoBriefs ib
ON flcwi.SourceWorkItemSK = ib.WorkItemSK;

-------------------------------------
--Obtenemos la información que se necesita de los elementos RLP con respecto a las diferentes fecha 
--planeadas de despliegue encontradas.
-------------------------------------
WITH LineasProducto_CTE(BriefID,LineaID,CollectionID)
AS
(
SELECT bc.System_Id as BriefID, dwi.System_Id as LineaID, dwi.TeamProjectCollectionSK as CollectionID 
FROM DimWorkItem dwi
INNER JOIN #BriefChilds bc
ON dwi.WorkItemSK = bc.TargetWorkitemSK
WHERE dwi.System_WorkItemType = 'Requerimiento por Linea Producto'
)
SELECT MAX(LineasProducto_CTE.BriefID) as Brief_Id,	 
	   dwi.TeamProjectCollectionSK as Collection_Id,  
	   dwi.System_Id as LineaProducto_Id,  	
	   dwi.Claro_ALM_FechaPlaneadaDespliegue as FechaPlaneadaDespliegue, 
	   dwi.Claro_ALM_CausalCambioFechaPlaneada as CausalCambioFechaPlaneada,   	   
	   COUNT(*) OVER (PARTITION BY dwi.System_Id) AS conteo,
	   MAX(dwi.System_ChangedDate) as FechaCambio,
	   EsFechaMaxima = CASE
	    WHEN MAX(dwi.System_ChangedDate) = (SELECT MAX(dwi2.System_ChangedDate) 
											FROM DimWorkItem dwi2 
											WHERE dwi2.System_Id = dwi.System_Id 
												  AND dwi2.TeamProjectCollectionSK = dwi.TeamProjectCollectionSK)
												  THEN 1
		ELSE 0
	   END
INTO  #InfoLineasProductoFPD
FROM DimWorkItem  dwi	   
INNER JOIN LineasProducto_CTE
ON LineasProducto_CTE.LineaID = dwi.System_Id AND LineasProducto_CTE.CollectionID = dwi.TeamProjectCollectionSK
WHERE dwi.Claro_ALM_FechaPlaneadaDespliegue IS NOT NULL
GROUP BY dwi.Claro_ALM_FechaPlaneadaDespliegue, dwi.Claro_ALM_CausalCambioFechaPlaneada,dwi.System_Id,dwi.TeamProjectCollectionSK

-------------------------------------
--Se junta la información actual de la linea de producto junto a la información pasada de cada uno de los registros
--con una fecha planeada de despliegue.
-------------------------------------

SELECT 
ifpd.Brief_Id as Brief_Id,
cwi.Claro_ALM_Fase as Fase,
ifpd.LineaProducto_Id as LineaProducto_Id,
cwi.Claro_ALM_LineaProducto as LineaProducto,
cwi.Claro_ALM_GerenciaDesarrollo as GerenciaResponsable,
ifpd.FechaPlaneadaDespliegue as FechaPlaneadaDespliegue,
ifpd.CausalCambioFechaPlaneada as CausalCambioFechaPlaneada,
ifpd.FechaCambio as FechaCambio,
FechaRealDespliegue = CASE
						WHEN ifpd.EsFechaMaxima = 1 THEN cwi.Claro_ALM_FechaDespliegue
						ELSE NULL
					  END,
CausalCambioFechaReal = CASE
						 WHEN ifpd.EsFechaMaxima = 1 THEN cwi.Claro_ALM_CausalCambioFechaReal
						 ELSE NULL
					    END,
ValidacionFechaRealDespliegue = CASE
		WHEN ifpd.EsFechaMaxima = 0 OR cwi.Claro_ALM_FechaDespliegue IS NULL THEN NULL
		WHEN ifpd.EsFechaMaxima = 1 AND ifpd.FechaPlaneadaDespliegue = cwi.Claro_ALM_FechaDespliegue AND cwi.Claro_ALM_CausalCambioFechaReal = 'No Aplica' THEN 'SI'
		WHEN ifpd.EsFechaMaxima = 1 AND ifpd.FechaPlaneadaDespliegue > cwi.Claro_ALM_FechaDespliegue AND cwi.Claro_ALM_CausalCambioFechaReal = 'No Aplica' THEN 'SI'
		WHEN ifpd.EsFechaMaxima = 1 AND ifpd.FechaPlaneadaDespliegue < cwi.Claro_ALM_FechaDespliegue AND cwi.Claro_ALM_CausalCambioFechaReal = 'No Aplica' THEN 'NO'
		WHEN ifpd.EsFechaMaxima = 1 AND ifpd.FechaPlaneadaDespliegue = cwi.Claro_ALM_FechaDespliegue AND cwi.Claro_ALM_CausalCambioFechaReal <> 'No Aplica' THEN 'NO'
		WHEN ifpd.EsFechaMaxima = 1 AND ifpd.FechaPlaneadaDespliegue > cwi.Claro_ALM_FechaDespliegue AND cwi.Claro_ALM_CausalCambioFechaReal <> 'No Aplica' THEN 'NO'
		WHEN ifpd.EsFechaMaxima = 1 AND ifpd.FechaPlaneadaDespliegue < cwi.Claro_ALM_FechaDespliegue AND cwi.Claro_ALM_CausalCambioFechaReal <> 'No Aplica' THEN 'SI'
	   END,
ifpd.conteo as conteo
INTO #InfoLineasProducto
FROM #InfoLineasProductoFPD ifpd
INNER JOIN CurrentWorkItemView cwi
ON cwi.System_Id = ifpd.LineaProducto_Id AND cwi.TeamProjectCollectionSK = ifpd.Collection_Id
ORDER BY Brief_Id, Fase, FechaCambio, LineaProducto_Id

-------------------------------------
--Eliminamos los registros que no son necesarios en el informe
-------------------------------------
SELECT 
*
into #InfoInforme
FROM #InfoLineasProducto
WHERE conteo > 1
UNION
SELECT *
FROM #InfoLineasProducto
WHERE (conteo = 1
AND ValidacionFechaRealDespliegue  = 'NO') 
OR (conteo = 1 AND CausalCambioFechaReal <> 'No Aplica' AND ValidacionFechaRealDespliegue ='SI')

truncate table InformeRLPFechasModificadas;
INSERT INTO InformeRLPFechasModificadas(
	[Brief_Id],
	[Fase],
	[LineaProducto_Id],
	[LineaProducto],
	[GerenciaResponsable],
	[FechaPlaneadaDespliegue],
	[CausalCambioFechaPlaneada],
	[FechaRealDespliegue],
	[CausalCambioFechaReal],
	[ValidacionFechaRealDespliegue]
)
select 
Brief_Id,
Fase,
LineaProducto_Id,
LineaProducto,
GerenciaResponsable,
FechaPlaneadaDespliegue,
CausalCambioFechaPlaneada,
FechaRealDespliegue,
CausalCambioFechaReal,
ValidacionFechaRealDespliegue
FROM 
#InfoInforme


END





GO

