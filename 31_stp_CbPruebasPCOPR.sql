USE [ADSReports]
GO
/****** Object:  StoredProcedure [dbo].[stp_CbPruebasPCOPR]    Script Date: 26/03/2020 7:44:31 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_CbPruebasPCOPR] 
as
BEGIN


DECLARE @Warehousedb varchar(50) = (Select p.value from PARAMETERS p where p.name='Warehosedb');
DECLARE @DDSpro varchar(50) = (Select p.value from PARAMETERS p where p.name='ddspro');
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
-- Campos Plan de Pruebas en la tabla ALM-IT
---------------------------------------------
DECLARE @Tsuite NVARCHAR(MAX);
 DECLARE @parambrief2 NVARCHAR(100);
 SET @parambrief2=N'@TEAMPROJECTCOLLECTIONGUID NVARCHAR(50)';
 SET @Tsuite=N'
select 
TP.WorkItemSK as TestPlanWISK
,TestPlanId
,TP.TeamProjectSK
,pJ.ProjectNodeName as ProjectName
,tbTP.RootSuiteId
,TS.TestSuiteId
,TS.SuiteType
,TS.RequirementId
into ##TSuite 
from '+@Warehousedb+'.[dbo].DimTestPlan TP 
inner join '+@Warehousedb+'.[dbo].[DimTeamProject] Pj on tp.TeamProjectSK=Pj.ProjectNodeSK
LEFT join '+@DDSpro+'.[dbo].[tbl_Plan] tbTP ON TP.TestPlanId=tbTP.PlanId
left join '+@Warehousedb+'.[dbo].DimTestSuite TS on (tbTP.RootSuiteId=TS.TestSuiteId or tbTP.RootSuiteId=TS.ParentTestSuiteId)
where StateId IS NULL 
AND Pj.[ProjectNodeType]=0 
and ParentNodeSK=@TEAMPROJECTCOLLECTIONGUID 
order by TestPlanId';

EXEC sp_executesql @Tsuite,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;

 ---------------------------------------------
-- Campos Conjunto de Pruebas
---------------------------------------------
DECLARE @TsuiteConj NVARCHAR(MAX);
 
 SET @TsuiteConj=N'
select  WorkItemSK as WISKConjPrueba
,System_Id as systemidConjPrueba
,System_Title as nombreConjPrueba
,System_State as EstadoConjPrueba
,system_changedBy as modificadoporConjPrueba
,System_Reason as motivoConjPrueba
,System_AssignedTo as asignadoAConjPrueba
,System_CreatedBy as creadoPorConjPrueba
,System_CreatedDate as fechaCreacionConjPrueba
,Microsoft_VSTS_TCM_TestSuiteType as TipoConjPrueba
into ##TSuiteConj
FROM [dbo].[CurrentWorkItemView]
WHERE System_WorkItemType =''Conjunto de pruebas'' 
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and System_Title is not null';

EXEC sp_executesql @TsuiteConj,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;

---------------------------------------------
-- Campos Requerimientos FNF: Funcionales y No Funcionales
---------------------------------------------


DECLARE @TsuiteReq NVARCHAR(MAX);
 SET @TsuiteReq=N'
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
into ##TSuiteReq
FROM [dbo].[CurrentWorkItemView]
WHERE System_WorkItemType =''Requerimiento'' 
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and System_Title is not null';
--Drop table #TSuiteReq

EXEC sp_executesql @TsuiteReq,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
-----------------------
--final
--------------------------
truncate table [tbl_CbPruebas_PCOPR];
INSERT INTO [dbo].[tbl_CbPruebas_PCOPR]
([P_WorkItemSK], [P_Id] ,[P_TeamProjectSK] ,[P_ProjectName] ,[P_IdCOPRaiz] ,[COP_WorkItemSK] ,[COP_Id] ,[COP_Estado] ,[COP_Titulo] ,
[COP_ModificadoPor] ,[COP_Motivo],
[COP_AsignadoA] ,[COP_CreadoPor] ,[COP_FechaCreacion] ,[COP_Tipo] ,[R_WorkItemSK] ,[R_Id] ,
[R_Titulo] ,[R_Estado] ,[R_ModificadoPor] ,[R_Motivo] ,[R_AsignadoA],[R_CreadoPor] ,[R_FechaCreacion] ,[R_Tipo] ,
[R_TipoFuncional] ,[R_TipoModificacionFuncional] ,[R_TipoNoFuncional] ,[R_Prioridad] ,[R_Bloqueado] ,
[R_AutorizacionLiderSis],[R_AutorizacionResponsableNeg])
select distinct ts.TestPlanWISK, ts.TestPlanId, ts.TeamProjectSK, ts.ProjectName, ts.RootSuiteId,tsc.WISKConjPrueba,tsc.systemidConjPrueba,tsc.EstadoConjPrueba,tsc.nombreConjPrueba,
tsc.modificadoporConjPrueba,tsc.motivoConjPrueba,tsc.asignadoAConjPrueba,tsc.creadoPorConjPrueba,tsc.fechaCreacionConjPrueba,tsc.TipoConjPrueba,tsr.WISKReqFNF,tsr.systemidFNF,
tsr.nombreReqFNF,tsr.EstadoReqFNF,tsr.modificadoporReqFNF,tsr.motivoReqFNF,tsr.asignadoAReqFNF,tsr.creadoPorReqFNF,tsr.fechaCreacionReqFNF,tsr.Claro_ALM_TipoRequerimiento,
tsr.Claro_ALM_TipoRequerimientoFuncional,tsr.Claro_ALM_TipoModificacionReqFuncional,tsr.Claro_ALM_TipoRequerimientoNoFuncional,tsr.PrioridadReqFNF,tsr.BloqueadoReqFNF,
tsr.Claro_ALM_AutorizacionLiderSistema,tsr.Claro_ALM_AutorizacionResponsableNegocio
from ##TSuite ts 
left outer join  ##TSuiteConj tsc on ts.TestSuiteId=tsc.systemidConjPrueba
left outer join  ##TSuiteReq tsr on ts.RequirementId=tsr.systemidFNF
order by ts.TestPlanId;

DROP TABLE ##TSuite;
DROP TABLE ##TSuiteConj;
DROP TABLE ##TSuiteReq;

END





