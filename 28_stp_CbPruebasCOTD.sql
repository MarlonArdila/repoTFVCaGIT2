USE [ADSReports]
GO
/****** Object:  StoredProcedure [dbo].[stp_CbPruebasCOTD]    Script Date: 26/03/2020 7:42:20 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_CbPruebasCOTD] 
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

-------------------------------------
--Campos del Elemento Contrato
-------------------------------------
DECLARE @ElemContract NVARCHAR(MAX);
 DECLARE @parambrief2 NVARCHAR(100);
 SET @parambrief2=N'@TEAMPROJECTCOLLECTIONGUID NVARCHAR(50)';
 SET @ElemContract=N'
select  WorkItemSK as C_WorkItemSK
,System_Id as C_Id
,System_Title as C_Titulo
,System_State as C_Estado
,system_changedBy as C_Modificadopor
,System_Reason as C_MotivoModificacion
,System_AssignedTo as C_asignadoA
,System_CreatedBy as C_creadoPor
,System_CreatedDate as C_fechaCreacion
,Claro_ALM_TipoContrato as C_Tipo
,Claro_ALM_NumeroSAP as C_NumeroSAP
,Claro_ALM_NumeroSAPContratoMarco as C_NumeroSAPContratoMarco
,Claro_ALM_Proveedor as C_Proveedor
,Claro_ALM_Proyecto as C_Proyecto
,Claro_ALM_ValorHora as C_ValorHoraProveedor
,Claro_ALM_NumeroHorasContrato as C_Horas
,Claro_ALM_FechaInicio as C_fechaInicio
,Claro_ALM_FechaFin as C_fechaFin
into ##contrato --DROP TABLE #contrato
FROM [dbo].[CurrentWorkItemView]
WHERE System_WorkItemType=''Contrato''
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and System_Title is not null';
 EXEC sp_executesql @ElemContract,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
---------------------------------------------
--Cruce de Workitems
---------------------------------------------
DECLARE @vFactLinkedCurrentWorkItem NVARCHAR(MAX);
 SET @vFactLinkedCurrentWorkItem=N'
select a.SourceWorkItemSK,a.TargetWorkitemSK
into ##vFactLinkedCurrentWorkItem --drop table #vFactLinkedCurrentWorkItem 
from '+@Warehousedb+'.[dbo].[vFactLinkedCurrentWorkItem] as a
group by  a.SourceWorkItemSK,a.TargetWorkitemSK';

EXEC sp_executesql @vFactLinkedCurrentWorkItem;
-----------------------------
--Campos OT 
-----------------------------
DECLARE @FieldsOt NVARCHAR(MAX);
 SET @FieldsOt =N'
select WorkItemSK as O_WorkItemSK
		,System_Id as O_Id
		,System_State as O_Estado
		,Microsoft_VSTS_Common_Discipline as O_Disciplina
		into ##OT 
  FROM [dbo].[CurrentWorkItemView] AS A
  where System_WorkItemType=''Orden de Trabajo''
  AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
  AND Claro_ALM_HorasPlaneadas is not null';

   EXEC sp_executesql @FieldsOt ,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
----------------------
--Contrato y OT
--------------------------
select c.*, link.TargetWorkitemSK
into #ContrLinks --DROP TABLE  #ContrLinks
from ##contrato c left join ##vFactLinkedCurrentWorkItem link
on c.C_WorkItemSK=link.SourceWorkItemSK
order by c.C_Id;

select linksC.C_WorkItemSK, linksC.C_Id,linksC. C_Titulo, linksC.C_Estado, linksC.C_Modificadopor, linksC.C_MotivoModificacion, linksC.C_asignadoA, linksC.C_creadoPor, 
linksC.C_fechaCreacion, linksC.C_Tipo, linksC.C_NumeroSAP, linksC.C_NumeroSAPContratoMarco, linksC.C_Proveedor, linksC.C_Proyecto, linksC.C_ValorHoraProveedor, 
linksC.C_Horas, linksC.C_fechaInicio, linksC.C_fechaFin,o.O_WorkItemSK, o.O_Id, o.O_Estado, o.O_Disciplina
into  #ContrOT --DROP TABLE  #ContrOT
from #ContrLinks linksC left join ##OT o
on linksC.TargetWorkitemSK=o.O_WorkItemSK
order by linksC.C_Id;

---------------------------------------------
--Campos Tarea Desfase
---------------------------------------------
DECLARE @TaskDefase NVARCHAR(MAX);
 SET @TaskDefase =N'
select  WorkItemSK as D_WorkItemSK
,System_Id as D_Id
,System_Title as D_Titulo
,System_State as D_Estado
,system_changedBy as D_ModificadoPor
,System_Reason as D_Motivo
,System_AssignedTo as D_AsignadoA
,System_CreatedBy as D_creadoPor
,System_CreatedDate as D_fechaCreacion
,Claro_ALM_Desfase_Causal as D_Causal
,Claro_ALM_Desfase_Ambiente as D_Ambiente
,Claro_ALM_Desfase_CausalAmbiente as D_CausalAmbiente
,Microsoft_VSTS_Scheduling_CompletedWork as D_TrabajoCompletado
into ##TarDesfase	
FROM [dbo].[CurrentWorkItemView]
WHERE System_WorkItemType=''Tarea'' 
and Microsoft_VSTS_CMMI_TaskType=''Desfase'' 
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and System_Title is not null';
 EXEC sp_executesql @TaskDefase,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
-------------------------------------------
---------------------------------------------
--Contrato, OT y Desfases
---------------------------------------------
select c.*, link.TargetWorkitemSK
into #ContrOTLinks --DROP TABLE  #ContrOTLinks
from #ContrOT c left join ##vFactLinkedCurrentWorkItem link
on c.O_WorkItemSK=link.SourceWorkItemSK
order by c.C_Id, c.O_Id;

---------------------------------------------
--Se agrega campo de orden para identificar registros con defecto=NULL
---------------------------------------------
--SELECT ROW_NUMBER() OVER (PARTITION BY temp.C_Id,temp.O_Id ORDER BY temp.C_Id asc,temp.O_Id asc,temp.D_Id desc ) AS ORDEN,temp.*
SELECT temp.*
INTO #C_OT_D
FROM
(select distinct linksCOT.C_WorkItemSK, linksCOT.C_Id,linksCOT. C_Titulo, linksCOT.C_Estado, linksCOT.C_Modificadopor, linksCOT.C_MotivoModificacion, linksCOT.C_asignadoA, linksCOT.C_creadoPor, 
linksCOT.C_fechaCreacion, linksCOT.C_Tipo, linksCOT.C_NumeroSAP, linksCOT.C_NumeroSAPContratoMarco, linksCOT.C_Proveedor, linksCOT.C_Proyecto, linksCOT.C_ValorHoraProveedor, 
linksCOT.C_Horas, linksCOT.C_fechaInicio, linksCOT.C_fechaFin,linksCOT.O_WorkItemSK, linksCOT.O_Id, linksCOT.O_Estado, linksCOT.O_Disciplina,
t.D_WorkItemSK, t.D_Id, t.D_Titulo, t.D_Estado, t.D_ModificadoPor,
t.D_Motivo, t.D_AsignadoA, t.D_creadoPor, t.D_fechaCreacion, t.D_Causal,
t.D_Ambiente, t.D_CausalAmbiente, t.D_TrabajoCompletado
from #ContrOTLinks linksCOT left join ##TarDesfase t
on linksCOT.TargetWorkitemSK=t.D_WorkItemSK
) AS temp
ORDER BY temp.C_Id,temp.O_Id,temp.D_Id;


-----------------------
--final
--------------------------
truncate table [tbl_CbPruebas_COTD];
--drop table informeGeneral
INSERT INTO [dbo].[tbl_CbPruebas_COTD]
([C_WorkItemSK],[C_Id],[C_Titulo],[C_Estado],[C_ModificadoPor],[C_Motivo],[C_AsignadoA],[C_CreadoPor],[C_FechaCreacion],[C_Tipo],[C_NumeroSAP],[C_NumeroSAPContratoMarco],
[C_Proveedor],[C_Proyecto],[C_ValorHoraProveedor],[C_Horas],[C_fechaInicio],[C_fechaFin],[O_WorkItemSK],[O_Id],[O_Estado],[O_Disciplina],[D_WorkItemSK],[D_Id],[D_Titulo],
[D_Estado],[D_ModificadoPor],[D_Motivo],[D_AsignadoA],[D_CreadoPor],[D_FechaCreacion],[D_Causal],[D_Ambiente],[D_CausalAmbiente],[D_TrabajoCompletado])
/***Se elimninan los registros que aparezcan con NULL en el campo D_Id solamente cuando ya haya un registro de**/
/***la misma OT y el mismo CONTRATO con valores diferentes a NULL*****/
select C_WorkItemSK, C_Id,C_Titulo, C_Estado, C_Modificadopor, C_MotivoModificacion, C_asignadoA, C_creadoPor, 
C_fechaCreacion, C_Tipo, C_NumeroSAP, C_NumeroSAPContratoMarco, C_Proveedor, C_Proyecto, C_ValorHoraProveedor, 
C_Horas, C_fechaInicio, C_fechaFin,O_WorkItemSK, O_Id, O_Estado, O_Disciplina,
D_WorkItemSK, D_Id, D_Titulo, D_Estado, D_ModificadoPor,
D_Motivo, D_AsignadoA, D_creadoPor, D_fechaCreacion, D_Causal,
D_Ambiente, D_CausalAmbiente, D_TrabajoCompletado
from #C_OT_D
order by C_Id,O_Id,D_Id;

DROP TABLE ##vFactLinkedCurrentWorkItem;
DROP TABLE ##OT;
DROP TABLE ##TarDesfase;
DROP TABLE ##contrato;

END



