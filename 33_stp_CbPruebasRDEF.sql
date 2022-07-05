USE [ADSReports]
GO
/****** Object:  StoredProcedure [dbo].[stp_CbPruebasRDEF]    Script Date: 26/03/2020 7:45:48 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_CbPruebasRDEF] 
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
INTO ##Requerimiento
FROM [dbo].[CurrentWorkItemView]
WHERE System_WorkItemType =''Requerimiento'' 
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and System_Title is not null';

EXEC sp_executesql @reqFnF,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;

---------------------------------------------
-- Campos Defectos
---------------------------------------------

DECLARE @bug NVARCHAR(MAX);
 
 SET  @bug=N'
select  WorkItemSK as WISKDefecto
,System_Id as systemidDefecto
,System_Title as nombreDefecto
,System_State as EstadoDefecto
INTO ##Defecto
FROM [dbo].[CurrentWorkItemView]
WHERE System_WorkItemType = ''Error'' 
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and System_Title is not null';
--drop table #Defecto

EXEC sp_executesql @bug,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;

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
truncate table [tbl_CbPruebas_RDEF];
INSERT INTO [dbo].[tbl_CbPruebas_RDEF]
([R_WorkItemSK],
[R_Id],
[R_Titulo],
[R_Estado],
[DEF_WorkItemSK],
[DEF_Id],
[DEF_Titulo],
[DEF_Estado])
--Vista tecnica 1.Planes, Conjuntos,Casos de Prueba
select linksPConj.WISKReqFNF,linksPConj.systemidFNF,linksPConj.nombreReqFNF,linksPConj.EstadoReqFNF, d.WISKDefecto, d.systemidDefecto, d.nombreDefecto, d.EstadoDefecto
from #PlanConjLinks linksPConj left join ##Defecto d
on linksPConj.TargetWorkitemSK=d.WISKDefecto
order by linksPConj.systemidFNF;

DROP TABLE ##Requerimiento;
DROP TABLE ##Defecto;
DROP TABLE ##vFactLinkedCurrentWorkItem;

END






