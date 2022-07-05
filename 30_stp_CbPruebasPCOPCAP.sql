USE [ADSReports]
GO
/****** Object:  StoredProcedure [dbo].[stp_CbPruebasPCOPCAP]    Script Date: 26/03/2020 7:43:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_CbPruebasPCOPCAP] 
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
DECLARE @fieldsTp NVARCHAR(MAX);
 DECLARE @parambrief2 NVARCHAR(100);
 SET @parambrief2=N'@TEAMPROJECTCOLLECTIONGUID NVARCHAR(50)';
 SET @fieldsTp=N'
select 
TP.WorkItemSK as TestPlanWISK
,TestPlanId
,TP.TeamProjectSK
--,SUBSTRING(Pj.[ProjectNodeName],CHARINDEX(''}'', Pj.[ProjectNodeName])+2,(CHARINDEX(''('', Pj.[ProjectNodeName])-CHARINDEX(''}'', Pj.[ProjectNodeName]))-3) as ProjectName
,Pj.[ProjectNodeName] as ProjectName
,TP.System_CreatedDate
,TP.Claro_ALM_DisenadoFecha
,tbTP.RootSuiteId
,TS.TestSuiteId
,TS.SuiteType
,TS.RequirementId
into ##TSuite 
from '+@Warehousedb+'.[dbo].DimTestPlan TP 
inner join '+@Warehousedb+'.[dbo].[DimTeamProject] Pj on tp.TeamProjectSK=Pj.ProjectNodeSK
LEFT join '+@DDSpro+'.[dbo].[tbl_Plan] tbTP ON TP.TestPlanId=tbTP.PlanId
left join '+@Warehousedb+'.[dbo].DimTestSuite TS on (tbTP.RootSuiteId=TS.TestSuiteId or tbTP.RootSuiteId=TS.ParentTestSuiteId)--selecciona conjunto de pruebas raiz y conjuntos asociados al plan
where StateId IS NULL 
AND Pj.[ProjectNodeType]=0 --Proyectos es 0 Colecciones es 1
and ParentNodeSK=@TEAMPROJECTCOLLECTIONGUID 
order by TestPlanId';
EXEC sp_executesql @fieldsTp,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;

 ---------------------------------------------
-- Campos Conjunto de Pruebas
---------------------------------------------
DECLARE @conjuntoP NVARCHAR(MAX);
 
 SET @conjuntoP=N'
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
FROM '+@Warehousedb+'.[dbo].[CurrentWorkItemView]
WHERE System_WorkItemType =''Conjunto de pruebas'' 
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and System_Title is not null';

EXEC sp_executesql @conjuntoP,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
---------------------------------------------
-- Campos Caso de prueba
---------------------------------------------
DECLARE @testCase NVARCHAR(MAX);
 
 SET @testCase=N'
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
FROM '+@Warehousedb+'.[dbo].[CurrentWorkItemView]
WHERE System_WorkItemType =  ''Caso de Prueba'' 
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and System_Title is not null';

EXEC sp_executesql @testCase,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
----------------------
--Planes, Conjuntos y Casos
--------------------------
SELECT distinct ts.TestPlanWISK,ts.TestPlanId,ts.TeamProjectSK,ts.ProjectName, ts.System_CreatedDate, ts.Claro_ALM_DisenadoFecha,
ts.RootSuiteId,ts.TestSuiteId, ts.SuiteType,tse.TestCaseId
into #PlanConjCaso
FROM ##TSuite ts left join Ads_DDSPro.dbo.tbl_SuiteEntry tse on ts.TestSuiteId=tse.SuiteId
order by ts.TestPlanId;

---------------------------------------------
-- Campos Resultados de ejecuciones de Casos de prueba
---------------------------------------------
--select ROW_NUMBER() OVER (PARTITION BY r.TestCaseId, r.TestSuiteId, r.TestPlanId ORDER BY r.resultdate DESC) AS ORDEN, r.ResultOutcome as Outcome, ResultTestCaseId as TestCaseId,r.TestPlanId,r.resultdate
--INTO #ResultTS 
--	FROM [dbo].TestResultView r
--	WHERE  NOT r.TestCaseId IS NULL AND ResultTeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID AND NOT r.TestSuiteId IS NULL
--	order by r.TestCaseId, r.TestPlanId,r.resultdate

DECLARE @ResultTS NVARCHAR(MAX);
 
 SET @ResultTS=N'	
select r.TestPlanId,r.TestSuiteId, r.TestCaseId,r.resultdate,r.ResultOutcome  as Outcome
INTO ##ResultTS 
from '+@Warehousedb+'.[dbo].TestResultView r 
WHERE  NOT r.TestCaseId IS NULL AND ResultTeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID AND NOT r.TestSuiteId IS NULL
and r.ResultDate= (select max(r1.resultdate) 
											from '+@Warehousedb+'.[dbo].TestResultView r1 
											where r1.TestPlanId=r.TestPlanId and r1.TestSuiteId=r.TestSuiteId and r1.TestCaseId=r.TestCaseId and r1.ResultOwnerSK=r.ResultOwnerSK
											group by r1.TestPlanId,r1.TestSuiteId, r1.TestCaseId,r1.ResultOwnerSK)

order by r.TestCaseId, r.TestSuiteId'; 

EXEC sp_executesql @ResultTS,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
----------------------
--final
--------------------------
truncate table [tbl_CbPruebas_PCOPCAP];

DECLARE @insertPcopcap NVARCHAR(MAX);
 
 SET @insertPcopcap=N'
INSERT INTO [dbo].[tbl_CbPruebas_PCOPCAP]
([P_WorkItemSK],
[P_Id],
[P_TeamProjectSK],
[P_ProjectName],
[P_FechaCreado],
[P_FechaDisenado],
[P_IdCOPRaiz],
[P_EvaluadorPpal],
[COP_WorkItemSK],
[COP_Id],
[COP_Titulo],
[CAP_WorkItemSK],
[CAP_Id],
[CAP_Titulo],
[CAP_Resultado],
[CAP_FechaCreacion],
CAP_EsTestStandar)
--Vista tecnica 1.Planes, Conjuntos,Casos de Prueba
select distinct linksPConj.TestPlanWISK,linksPConj.TestPlanId,linksPConj.TeamProjectSK,linksPConj.ProjectName,
linksPConj.System_CreatedDate,linksPConj.Claro_ALM_DisenadoFecha,
linksPConj.RootSuiteId,
o.DisplayName,
cj.WISKConjPrueba,
cj.systemidConjPrueba,cj.nombreConjPrueba,c.WISKCasoPrueba,c.systemidCasoPrueba,c.nombreCasoPrueba,
case r.Outcome when ''Nunca ejecutado'' then ''Activo''
when ''Superada'' then ''Superado'' else r.Outcome end as outcome, c.fechaCreacionCasoPrueba,c.Claro_ALM_EsTestStandar
from #PlanConjCaso linksPConj left join ##Caso c on linksPConj.TestCaseId=c.systemidCasoPrueba
left join ##TSuiteConj cj on linksPConj.TestSuiteId=cj.systemidConjPrueba
left join ##ResultTS r on c.systemidCasoPrueba=r.TestCaseId and linksPConj.TestPlanId=r.TestPlanId and linksPConj.TestSuiteId=r.TestSuiteId
left join '+@DDSpro+'.[dbo].[tbl_SuiteTester] st on			
		(linksPConj.RootSuiteId=st.SuiteId)
left join  '+@DDSpro+'.dbo.ADObjects o on st.Tester=o.TeamFoundationId
order by linksPConj.TestPlanId';

EXEC sp_executesql @insertPcopcap;

/*Borrar la tabla [tbl_CbPruebas_PCOPCAP] y recrearla incluyendo esta columna --Cuando autoricen agregar al cubo 
[P_EvaluadorPpal] [nvarchar](256) NULL

drop table [tbl_CbPruebas_PCOPCAP]
CREATE TABLE [dbo].[tbl_CbPruebas_PCOPCAP](
	[P_WorkItemSK] [int] NULL,
	[P_Id] [int] NULL,
	[P_TeamProjectSK] [int] NULL,
	[P_ProjectName] [nvarchar](256) NULL,
	[P_FechaCreado] [datetime] NULL,
	[P_FechaDisenado] [datetime] NULL,
	[P_IdCOPRaiz] [int] NULL,
	[P_EvaluadorPpal] [nvarchar](256) NULL,
	[COP_WorkItemSK] [int] NULL,
	[COP_Id] [int] NULL,
	[COP_Titulo] [nvarchar](256) NULL,
	[CAP_WorkItemSK] [int] NULL,
	[CAP_Id] [int] NULL,
	[CAP_Titulo] [nvarchar](256) NULL,
	[CAP_Resultado] [nvarchar](256) NULL,
	[CAP_FechaCreacion] [datetime] NULL
) ON [PRIMARY]

*/
DROP TABLE ##TSuite;
DROP TABLE ##TSuiteConj;
DROP TABLE ##Caso;
DROP TABLE ##ResultTS;
END






