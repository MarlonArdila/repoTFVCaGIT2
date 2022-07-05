USE [ADSReports]
GO
/****** Object:  StoredProcedure [dbo].[stp_CbPruebasRCAP]    Script Date: 26/03/2020 7:45:08 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_CbPruebasRCAP] 
as
BEGIN

DECLARE @Warehousedb varchar(50) = (Select p.value from PARAMETERS p where p.name='Warehosedb');
-------------------------------------
--Calcula el sk para la collecion de wis
-------------------------------------
Declare @querycollectionguid NVARCHAR(500);
Declare @Params nvarchar(50);
SET  @Params=N'@varresul NVARCHAR(50) OUTPUT';
DECLARE @TEAMPROJECTCOLLECTIONGUID NVARCHAR(50);

SET @querycollectionguid=N'
(select @varresul=ProjectNodeSK from '+@Warehousedb+'.[dbo].[DimTeamProject] 
 where ProjectNodeName=''DDSPro'')';

Exec sp_executesql @querycollectionguid,@Params,@varresul = @TEAMPROJECTCOLLECTIONGUID output;

---------------------------------------------
-- Campos Requerimientos FNF: Funcionales y No Funcionales
---------------------------------------------
DECLARE @reqFnF NVARCHAR(MAX);
 DECLARE @parambrief2 NVARCHAR(100);
 SET @parambrief2=N'@TEAMPROJECTCOLLECTIONGUID NVARCHAR(50)';
 SET  @reqFnF=N'
select  WorkItemSK as WISKReqFNF
,System_Id as systemidFNF
,System_Title as nombreReqFNF
,System_State as EstadoReqFNF
,system_changedBy as modificadoporReqFNF
,System_Reason as motivoReqFNF
,System_AssignedTo as asignadoAReqFNF
,System_CreatedBy as creadoPorReqFNF
,System_CreatedDate as fechaCreacionReqFNF
,Claro_ALM_TipoRequerimiento
,Claro_ALM_TipoRequerimientoFuncional
,Claro_ALM_TipoModificacionReqFuncional
,Claro_ALM_TipoRequerimientoNoFuncional
,Microsoft_VSTS_Common_Priority as PrioridadReqFNF
,Microsoft_VSTS_CMMI_Blocked as BloqueadoReqFNF
,Claro_ALM_AutorizacionLiderSistema
,Claro_ALM_AutorizacionResponsableNegocio
INTO ##Requerimiento
FROM [dbo].[CurrentWorkItemView]
WHERE System_WorkItemType =''Requerimiento'' 
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and System_Title is not null';

EXEC sp_executesql @reqFnF,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;

---------------------------------------------
-- Campos Casos de prueba
---------------------------------------------

DECLARE @tcase NVARCHAR(MAX);
 
 SET  @tcase=N'
select  WorkItemSK as WISKCasoPrueba
,System_Id as systemidCasoPrueba
,System_Title as nombreCasoPrueba
,System_State as EstadoCasoPrueba
,system_changedBy as modificadoporCasoPrueba
,System_Reason as motivoCasoPrueba
,Microsoft_VSTS_Common_ResolvedReason  as motivoResolucionDefecto
,System_AssignedTo as asignadoACasoPrueba
,System_CreatedBy as creadoPorCasoPrueba
,System_CreatedDate as fechaCreacionCasoPrueba
,Microsoft_VSTS_Common_Priority as PrioridadCasoPrueba
,Microsoft_VSTS_TCM_AutomationStatus as EstadoAutomatCasoPrueba
,Claro_ALM_Planeado
,Claro_ALM_EsTestStandar
INTO ##Caso
FROM [dbo].[CurrentWorkItemView]
WHERE System_WorkItemType =  ''Caso de Prueba'' 
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and System_Title is not null';
--drop table #Caso

EXEC sp_executesql @tcase,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;

---------------------------------------------
--Deja una sola relación posible entre dos objetos
--corrige problema en que creen más de una relación entre
--un brief y una línea de producto
--------------------------------------------

DECLARE @vFactLinkedCurrentWorkItem NVARCHAR(MAX);
 
 SET  @vFactLinkedCurrentWorkItem=N'
select a.SourceWorkItemSK,a.TargetWorkitemSK
into ##vFactLinkedCurrentWorkItem 
from '+@Warehousedb+'.[dbo].[vFactLinkedCurrentWorkItem] as a
group by  a.SourceWorkItemSK,a.TargetWorkitemSK
order by 1';

EXEC sp_executesql @vFactLinkedCurrentWorkItem;
----------------------
--Requerimientos y Casos
--------------------------
select r.*, link.TargetWorkitemSK
into #PlanConjLinks --DROP TABLE  #ContrLinks
from ##Requerimiento r left join ##vFactLinkedCurrentWorkItem link
on r.WISKReqFNF=link.SourceWorkItemSK
order by r.systemidFNF;



-----------------------
--final
--------------------------
truncate table [tbl_CbPruebas_RCAP];
INSERT INTO [dbo].[tbl_CbPruebas_RCAP]
([R_WorkItemSK],
[R_Id],
[R_Titulo],
[R_Estado],
[CAP_WorkItemSK],
[CAP_Id],
[CAP_Titulo],
[CAP_Estado])
--Vista tecnica 1.Planes, Conjuntos,Casos de Prueba
select linksPConj.WISKReqFNF,linksPConj.systemidFNF,linksPConj.nombreReqFNF,linksPConj.EstadoReqFNF, c.WISKCasoPrueba,c.systemidCasoPrueba,c.nombreCasoPrueba,c.EstadoCasoPrueba
from #PlanConjLinks linksPConj left join ##Caso c
on linksPConj.TargetWorkitemSK=c.WISKCasoPrueba
order by linksPConj.systemidFNF;

DROP TABLE ##Caso;
DROP TABLE ##vFactLinkedCurrentWorkItem;
DROP TABLE ##Requerimiento;

END







