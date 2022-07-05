USE [ADSReports]
GO
/****** Object:  StoredProcedure [dbo].[stp_InfomeGeneralGE]    Script Date: 26/03/2020 7:46:20 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_InfomeGeneralGE] 
as
BEGIN

DECLARE @Warehousedb varchar(50) = (Select p.value from PARAMETERS p where p.name='Warehosedb');  

Declare @collectionguid NVARCHAR(500);
Declare @Params nvarchar(50);

SET @collectionguid =N'(select @varresul=ProjectNodeSK from '+ @Warehousedb+N'.[dbo].[DimTeamProject] where ProjectNodeName='''+'DDSPro'+''')';
--Execute sp_executesql @collectionguid
SET  @Params=N'@varresul NVARCHAR(50) OUTPUT'
DECLARE @TEAMPROJECTCOLLECTIONGUID NVARCHAR(50);
Exec sp_executesql @collectionguid,@Params,@varresul = @TEAMPROJECTCOLLECTIONGUID output;
                 
select @TEAMPROJECTCOLLECTIONGUID;

/*(select ProjectNodeSK from [Tfs_Warehouse22].[dbo].[DimTeamProject] --SELECT * from [dbo].[DimTeamProject] where projectnodesk=23
 where ProjectNodeName='DDSPro');*/


 
 
 DECLARE @briefVar NVARCHAR(MAX);
 DECLARE @parambrief2 NVARCHAR(100);
 SET @parambrief2=N'@TEAMPROJECTCOLLECTIONGUID NVARCHAR(50)';
 SET @briefVar=N'SELECT [CurrentWorkItemBK]
		,System_Id as briefSysID
      ,[LastUpdatedDateTime]
      ,[WorkItemSK]
      ,[WorkItem]
      ,[PreviousState]
      ,[TeamProjectCollectionSK]
      ,[System_ChangedDate]
      ,[System_Id]
      ,[System_Title]
      ,[System_State]
	  ,[System_CreatedDate] as System_CreatedDate_Brief
      ,[System_Rev]
      ,[System_ChangedBy]
      ,[System_Reason]
	  ,[Microsoft_VSTS_CMMI_Blocked]
      ,[System_AssignedTo]
      ,[System_WorkItemType]
      ,[System_CreatedBy]
      ,[System_BoardColumn]
      ,[Microsoft_VSTS_Common_Priority]
      ,[Claro_ALM_Consecutivo123MIC]
      ,[Claro_ALM_Clasificacion]
      ,[Claro_ALM_Estrategia]
	  ,[Claro_ALM_LiderBrief]
      ,[Claro_ALM_Complejidad]      
      ,[Claro_ALM_DirectorSolicitante]
      ,[Claro_ALM_RequiereReportes]
      ,[Claro_ALM_RadicadoPor]
      ,[Claro_ALM_FSPBasePor]
      ,[Claro_ALM_FSPCerradoPor]
      ,[Claro_ALM_EstimadoPor]
      ,[Claro_ALM_AprobadoPor]
      ,[Claro_ALM_FechaAprobado]
	    ,[Claro_ALM_ResponsableNegocio]
      ,[Claro_ALM_CategoriaRiesgo]
      ,[Claro_ALM_CargoAutorizadorRiesgo]
      ,[Claro_ALM_AutorizacionRiesgo]
      ,[Claro_ALM_AfectaSistemaFinanciero]
      ,[Claro_ALM_CargoSistemaFinanciero]
      ,[Claro_ALM_AutorizacionSistemaFinanciero]
	  ,[Claro_ALM_GerenteSolicitante]
      ,[Claro_ALM_AutorizacionGerencia]
      ,[Claro_ALM_AutorizacionDireccion]
      ,[Claro_ALM_PAI] as ParticipaAseguramientoIngresos
      ,[Claro_ALM_ParticipaArquitectura]
      ,[Claro_ALM_TipoBeneficio]
      ,[Claro_ALM_BeneficioResolucion]
      ,[Claro_ALM_Segmento]
	  ,[Claro_ALM_UnidadNegocio]
      ,[Claro_ALM_FechaAprobacionPortafolio]
      ,[Claro_ALM_FactiblePor]
      ,[Claro_ALM_AprobadoJuntaPor]
      ,[Claro_ALM_FechaAprobadoJunta]
	  ,[Claro_ALM_CerradoIT]
      ,[ProjectNodeSK]
      ,[ProjectNodeName]
	  ,Claro_ALM_FechaRadicado
	  ,Claro_ALM_FechaFactible
	  ,Claro_ALM_FechaFSPBase
	  ,Claro_ALM_FechaFSPCerrado
	  ,Claro_ALM_FechaEstimado
	  ,Claro_ALM_AreaNegocio
into ##Brief2 FROM [dbo].[CurrentWorkItemView] where System_WorkItemType='+''''+'BRIEF'+''''
+' AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID ';
--SELECT @briefVar;
EXEC sp_executesql @briefVar,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;

SELECT * FROM  ##Brief2;
PRINT 'BriefReqLn'
  ---------------------------------------------
--Cruce de Elementos BRIEF con Requerimientos LN
---------------------------------------------

DECLARE @BriefReqLn NVARCHAR(500);
SET @BriefReqLn =
'select WorkItemSK as wiskrq,WorkItem as wirq
,System_Id as ReqSysID
,system_state as staterq 
,System_Reason as reasonrq
INTO ##RQ2
FROM [CurrentWorkItemView] where System_WorkItemType='+''''+'RequerimientoNegocio'+''''
+' AND (system_state NOT IN(N''Cerrado'') AND System_Reason NOT IN (N''Cancelado''))';
--SELECT @BriefReqLn;

EXEC sp_executesql @BriefReqLn;
Select * from ##RQ2;

PRINT 'BriefRp ANtes'
	 ---------------------------------------------
--Cruce de Elementos BRIEF con Requerimientos LP
---------------------------------------------
DECLARE @BriefRp NVARCHAR(MAX);
SET @BriefRp=
'select  WorkItemSK as wisk_RQLP
		,WorkItem as wi_RQLP
		,System_Id as ReqLPSysID
		,system_state as state_RQLP
		,Microsoft_VSTS_CMMI_Blocked  as blocked_RQLP
		,System_Reason as reason_RQLP
,System_AssignedTo as assigned_RQLP
,System_WorkItemType as witype_RQLP
,System_BoardColumn as wiboardcolum_RQLP
,Microsoft_VSTS_CMMI_RequirementType as wiCMMIReqType_RQLP
,Claro_ALM_GerenciaDesarrollo as ALMGciaDiv_RQLP
,Claro_ALM_LineaProducto as ALMLINEAPRODUCTO_RQLP
,Claro_ALM_LiderLineaProducto AS ALMLIDERLP_RQLP
,Claro_ALM_Fase AS FASE_RQLP
,Claro_ALM_FechaPlaneadaDespliegue
,Claro_ALM_FechaDespliegue as FechaRealDespliegue
,CASE WHEN system_state=''Produccion''  THEN ''En Producción''
	  WHEN system_state=''Despliegue'' and Microsoft_VSTS_CMMI_Blocked=''Sí'' THEN ''Aplazado'' 
	  WHEN system_state=''Despliegue'' and System_Reason=''Cancelado'' THEN ''Cancelado''  
	  WHEN system_state=''Produccion''  THEN ''En Producción'' 
	  WHEN system_state=''Despliegue'' and System_Reason=''Programado'' THEN ''Programado''
	   WHEN system_state=''Produccion'' and System_Reason=''Finalizado'' THEN ''Finalizado''
	  ELSE ''Que Viene'' 
	END as EstadoDespliegue,[dbo].[fn_EsCambiadaFechaPlaneada]( @TEAMPROJECTCOLLECTIONGUID,System_Id) as CausalDemoraDespliegue
,Claro_ALM_CumplimientoFabricaDesarrollo as CumplimientoFabricaDesarrollo
,System_CreatedDate as RLP_FechaCreado
,[dbo].[fn_ObtenerFechaCambioEstado](@TEAMPROJECTCOLLECTIONGUID,System_Id,''Aprobado'') as RLP_FechaAprobado
,[dbo].[fn_ObtenerFechaCambioEstado](@TEAMPROJECTCOLLECTIONGUID,System_Id,''Analisis'') as RLP_FechaAnalisis
,[dbo].[fn_ObtenerFechaCambioEstado](@TEAMPROJECTCOLLECTIONGUID,System_Id,''Construccion'') as RLP_FechaConstrucion
,[dbo].[fn_ObtenerFechaCambioEstado](@TEAMPROJECTCOLLECTIONGUID,System_Id,''Pruebas'') as RLP_FechaPruebas
,[dbo].[fn_ObtenerFechaCambioEstado](@TEAMPROJECTCOLLECTIONGUID,System_Id,''Despliegue'') as RLP_FechaDespliegue
INTO ##RQLP2 FROM [dbo].[CurrentWorkItemView]
WHERE System_WorkItemType=''Requerimiento por Linea Producto''
and System_Title is not null';

--SELECT  @BriefRp;
EXEC sp_executesql @BriefRp,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
--SELECT * FROM ##RQLP2;

PRINT 'BriefRp';
------------------------------------------------------
--Se obtiene la informaci�n de las fases de los briefs
------------------------------------------------------

SELECT BriefId,Fase
 into #numerosFases 
 FROM [dbo].[fn_GetNumerosFases](@TEAMPROJECTCOLLECTIONGUID);


--SELECT * FROM ##numerosFases;


SELECT BriefId,Fase,Claro_ALM_EstadoFase
into #estadosFases
FROM [dbo].[fn_GetEstadosFases](@TEAMPROJECTCOLLECTIONGUID);

--SELECT * FROM ##estadosFases;


SELECT BriefId,Fase,Claro_ALM_FechaDesplieguePlanFase
into #fechasdespliegue
FROM [dbo].[fn_GetFechasDesplieguePlanFases](@TEAMPROJECTCOLLECTIONGUID);


--SELECT * FROM ##fechasdespliegue;


SELECT BriefId,Fase,Claro_ALM_FechaDespliegueRealFase 
into #fechasreales
FROM [dbo].[fn_GetFechasDespliegueRealFases](@TEAMPROJECTCOLLECTIONGUID);

--SELECT * FROM ##fechasreales;

DECLARE @insertInfFasesBri NVARCHAR(MAX);
DECLARE @Parameterstab NVARCHAR(MAX);


SET @insertInfFasesBri =
'SELECT nf.BriefId, nf.Fase, ef.Claro_ALM_EstadoFase, fd.Claro_ALM_FechaDesplieguePlanFase,fr.Claro_ALM_FechaDespliegueRealFase,df.Claro_ALM_DescripcionFase
INTO ##InformacionFasesBrief
FROM #numerosFases nf 
	 LEFT JOIN  #estadosFases ef
	 ON nf.BriefId = ef.BriefId AND nf.Fase = ef.Fase
	 LEFT JOIN #fechasdespliegue fd
	 ON nf.BriefId = fd.BriefId AND nf.Fase = fd.Fase
	 LEFT JOIN #fechasreales fr
	 ON nf.BriefId = fr.BriefId AND nf.Fase = fr.Fase
	 LEFT JOIN [dbo].[DescripcionFasesBrief] df
	 ON nf.BriefId = df.workitemsk AND nf.Fase = df.Fase';

EXEC sp_executesql @insertInfFasesBri;
--Select * FROM ##InformacionFasesBrief;
PRINT 'linkedworkItemSQL'
---------------------------------------------
--Deja una sola relaci�n posible entre dos objetos
--corrige problema en que creen m�s de una relaci�n entre
--un brief y una l�nea de producto
---------------------------------------------
DECLARE @linkedworkItemSQL NVARCHAR(300);
SET @linkedworkItemSQL =
'select a.SourceWorkItemSK,a.TargetWorkitemSK
into ##vFactLinkedCurrentWorkItem2
from '+ @Warehousedb+'.[dbo].[vFactLinkedCurrentWorkItem] as a
group by  a.SourceWorkItemSK,a.TargetWorkitemSK';

EXEC sp_executesql  @linkedworkItemSQL;
--SELECT * FROM  ##vFactLinkedCurrentWorkItem2;


---------------------------------------------
--brief y req LINEA DE PRODUCTO
---------------------------------------------

WITH BRQLP AS (
	SELECT b.briefSysID,B.WorkItemSK,TeamProjectCollectionSK,c.*
	,ROW_NUMBER() OVER (PARTITION BY b.briefSysID ORDER BY C.wisk_RQLP DESC) AS ORDEN
	FROM ##vFactLinkedCurrentWorkItem2 as a
	INNER JOIN   ##brief2 as b
	ON a.SourceWorkItemSK=b.WorkItemSK
	LEFT JOIN ##RQLP2   as c
	ON a.[TargetWorkitemSK]=c.wisk_RQLP
	WHERE wisk_RQLP is not null 
	)
SELECT *
	INTO ##briefReqlp2 
FROM BRQLP;

--SELECT * FROM ##briefReqlp2;

---------------------------------------------
--Prioridad de Estados de la RegNeg
---------------------------------------------
CREATE TABLE #prioridadEstadoRegNeg2
	(	Motivo nvarchar(50),	estado nvarchar(50), prioridad tinyint)
INSERT INTO  #prioridadEstadoRegNeg2 (estado,motivo,prioridad)
	VALUES
	('Creado',	'Nuevo'	,1),
	('Documentado'	,'Viabilidad IT'	,3),
	('Creado','Aclaración negocio'	,2),
	('Aprobado',	'Aprobado'	,4);


	---------------------------------------------
--brief y req NEGOCIO
---------------------------------------------
DECLARE @BriReqNeg NVARCHAR(MAX);
SET @BriReqNeg =
'WITH BRREQNEG AS (
	select b.briefSysID,B.WorkItemSK,TeamProjectCollectionSK,c.*
	,ROW_NUMBER() OVER (PARTITION BY b.briefSysID ORDER BY F.PRIORIDAD ASC) AS ORDEN
	FROM '+@Warehousedb+'.[dbo].[vFactLinkedCurrentWorkItem]as a
	INNER JOIN   ##brief2 as b
	ON a.SourceWorkItemSK=b.WorkItemSK
	LEFT JOIN ##RQ2   as c 
	ON a.[TargetWorkitemSK]=c.wiskrq
	LEFT JOIN #prioridadEstadoRegNeg2 AS F
	ON C.reasonrq=F.Motivo
	AND C.staterq=F.estado
	WHERE  wiskrq is not null
	)
SELECT *
	INTO ##briefReqneg2 
FROM BRREQNEG
WHERE ORDEN=1';
EXEC sp_executesql @BriReqNeg;
---------------------------------------------
--Prioridad de Estados de la OT
---------------------------------------------
CREATE TABLE #prioridadEstadoOT2
	(estado nvarchar(50), prioridad tinyint)
INSERT INTO  #prioridadEstadoOT2 (estado,prioridad)
	VALUES 
	('Creada',	1),
	('Asignada alto Nivel',	2),
	('Estimada',	3),
	('Asignada detalle',	4),
	('Aprobada',	5),
	('Cerrada',	6)


PRINT 'otdesarrolloSQ';
-----------------------------
--OT De desarrollo
-----------------------------
DECLARE @otdesarrolloSQL NVARCHAR(MAX);
SET @otdesarrolloSQL=
'select WorkItemSK as WISKOT
		,WorkItem AS WIOT
		,System_Id as System_idOTDes
		,System_State as System_StateOTDes
		,Claro_ALM_Proveedor as proveedorOTDes
		,Claro_ALM_ValorHora as valorHoraOTDes
		,Claro_ALM_FechaInicio As fechaInicioOTDes
		,claro_alm_fechafin as fechaFinOTDes
		,claro_alm_dias as diasOTDes
		,Claro_ALM_HorasAcordadas AS Claro_ALM_HorasAcordadasDes
		,Claro_ALM_HorasPlaneadas as Claro_ALM_HorasPlaneadasDes
		,F.prioridad
		into ##OT_desarrollo2
  FROM [dbo].[CurrentWorkItemView] AS A
  INNER JOIN #prioridadEstadoOT2 AS F
  ON A.System_State=F.estado
  where System_WorkItemType=''Orden de Trabajo''
  and Microsoft_VSTS_Common_Discipline =''Desarrollo''
  AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
  AND Claro_ALM_HorasPlaneadas is not null';

  EXEC sp_executesql @otdesarrolloSQL,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
 -- SELECT * FROM ##OT_desarrollo2;

 -----------------------------
--OT De Requerimientos agregada 03septiembre 2018
-----------------------------
DECLARE @Otreq NVARCHAR(MAX);
SET @Otreq =
'select WorkItemSK as WISKOTReq
		,WorkItem  as WSIOTReq
		,System_Id as System_idOTReq
		,System_State as System_StateOTReq
		,Claro_ALM_Proveedor as proveedorOTReq
		,Claro_ALM_ValorHora as valorHoraOTReq
		,Claro_ALM_FechaInicio As fechaInicioOTReq
		,claro_alm_fechafin as fechaFinOTReq
		,claro_alm_dias as diasOTReq
		,Claro_ALM_HorasAcordadas AS Claro_ALM_HorasAcordadasReq
		,Claro_ALM_HorasPlaneadas as Claro_ALM_HorasPlaneadasReq
		,F.prioridad
		into ##OT_Requerimientos2 
  FROM [dbo].[CurrentWorkItemView] AS A
  INNER JOIN #prioridadEstadoOT2 AS F
  ON A.System_State=F.estado
  where System_WorkItemType=''Orden de Trabajo''
  and Microsoft_VSTS_Common_Discipline =''Requerimientos''
  AND Claro_ALM_HorasPlaneadas is not null';
 EXEC sp_executesql @Otreq;
 --SELECT * FROM ##OT_Requerimientos2;
 PRINT 'otpruebas';

 -------------------------------------
--Campos del Elemento OT pruebas
-------------------------------------
DECLARE @otpruebas NVARCHAR(MAX);
SET @otpruebas=
'select WorkItemSK as WISKOTPru
		,WorkItem AS WIOTPru
		,System_Id as System_idOTPru
		,System_State as System_StateOTPru
		,Claro_ALM_Proveedor as proveedorOTPru
		,isnull(Claro_ALM_ValorHora,0) as valorHoraOTPru
		,Claro_ALM_FechaInicio As fechaInicioOTPru
		,claro_alm_fechafin as fechaFinOTPru
		,isnull(claro_alm_dias,0) as diasOTPru
		,Claro_ALM_TallaAltoNivel as Claro_ALM_TallaAltoNivelPru
		,isnull(Claro_ALM_HorasAcordadas,0) AS Claro_ALM_HorasAcordadasPru
		,isnull(Claro_ALM_HorasPlaneadas,0) as Claro_ALM_HorasPlaneadasPru
		,F.prioridad
	into ##OT_pruebas2
FROM [dbo].[CurrentWorkItemView] AS A
INNER JOIN #prioridadEstadoOT2 AS F
  ON A.System_State=F.estado
where System_WorkItemType=''Orden de Trabajo''
and Microsoft_VSTS_Common_Discipline =''Pruebas''
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
AND Claro_ALM_Proveedor is not null';
EXEC sp_executesql @otpruebas,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
--SELECT * FROM ##OT_pruebas2;


-----------------------
--Prefiltra las vista de enlaces para detectar cuales 
--son tareas de desarrollo y cuales de pruebas
--se adiciona vista para detectar que tareas son de la OT Requerimientos 04 de septiembre
--------------------------
select SourceWorkItemSK,TargetWorkitemSK
	into #vfactDesarrollo2
from ##vFactLinkedCurrentWorkItem2 as t
where t.TargetWorkitemSK in (select e.WISKOT from ##OT_desarrollo2 as e)

select SourceWorkItemSK,TargetWorkitemSK
	into #vfactRequerimientos2
from ##vFactLinkedCurrentWorkItem2 as t
where t.TargetWorkitemSK in (select k.WISKOTReq from ##OT_Requerimientos2 as k)


select SourceWorkItemSK,TargetWorkitemSK
	into #vfactPruebas2
from ##vFactLinkedCurrentWorkItem2 as t
where t.TargetWorkitemSK in (select k.WISKOTPru from ##OT_pruebas2 as k);

--SELECT * FROM #vfactDesarrollo2;
--SELECT * FROM #vfactRequerimientos2;
--SELECT * FROM #vfactPruebas2;


-----------------------
--Agrupaci�n de OT's de Desarrollo por BRIEF
--------------------------
with nomprov as (
select d.SourceWorkItemSK,max(proveedorOTDes)proveedorOTDes,count(distinct proveedorOTDes)nroprov
FROM    #vfactDesarrollo2 as d
LEFT JOIN   ##OT_desarrollo2 as e 
on d.TargetWorkitemSK=e.WISKOT
group by d.SourceWorkItemSK)
select d.SourceWorkItemSK--, d.TargetWorkitemSK
		,CASE WHEN nroprov>1 THEN 'VARIOS' ELSE MAX(F.proveedorOTDes) END AS proveedorOTDes
		,avg(valorHoraOTDes) as valorHoraOTDes
		,min(fechaInicioOTDes) as fechaInicioOTDes
		,max(fechaFinOTDes) as fechaFinOTDes
		,sum(diasOTDes) as diasOTDes
		,sum(claro_ALM_HorasAcordadasDes) as claro_ALM_HorasAcordadasDes
		,sum(Claro_ALM_HorasPlaneadasDes) as Claro_ALM_HorasPlaneadasDes
		,sum(valorHoraOTDes * Claro_ALM_HorasPlaneadasDes) as CostoDesarrollo
		,max(prioridad) as prioridad
into #OTDesarrollo2
FROM    #vfactDesarrollo2 as d
LEFT JOIN   ##OT_desarrollo2 as e 
on d.TargetWorkitemSK=e.WISKOT
LEFT JOIN nomprov AS F
ON d.SourceWorkItemSK=f.SourceWorkItemSK
group by d.SourceWorkItemSK,nroprov
order by d.SourceWorkItemSK asc;

--SELECT * FROM #OTDesarrollo2;
-----------------------
--Agrupaci�n de OT's de Desarrollo por BRIEF
--------------------------
with nomprov as (
select d.SourceWorkItemSK,max(proveedorOTPru)proveedorOTPru,count(distinct proveedorOTPru)nroprov
FROM    #vfactPruebas2 as d
LEFT JOIN   ##OT_pruebas2 as e 
on d.TargetWorkitemSK=e.WISKOTPru
group by d.SourceWorkItemSK)
select d.SourceWorkItemSK--,d.TargetWorkitemSK
		,CASE WHEN nroprov>1 THEN 'VARIOS' ELSE MAX(F.proveedorOTPru) END AS proveedorOTPru
		,avg(valorHoraOTPru) as valorHoraOTPru
		,min(fechaInicioOTPru) as fechaInicioOTPru
		,max(fechaFinOTPru) as fechaFinOTPru
		,sum(diasOTPru) as diasOTPru
		,sum(claro_ALM_HorasAcordadasPru) as claro_ALM_HorasAcordadasPru
		,sum(Claro_ALM_HorasPlaneadasPru) as Claro_ALM_HorasPlaneadasPru
		,sum(valorHoraOTPru * Claro_ALM_HorasPlaneadasPru) as CostoPrueba
		,max(prioridad) as prioridad
into #OTPrueba2
FROM    #vfactPruebas2 as d
LEFT JOIN   ##OT_pruebas2 as e 
on d.TargetWorkitemSK=e.WISKOTPru
LEFT JOIN nomprov AS F
ON d.SourceWorkItemSK=f.SourceWorkItemSK
group by d.SourceWorkItemSK,nroprov
order by d.SourceWorkItemSK asc;

--SELECT * FROM #OTPrueba2;

----------------------
--Agrupacion OT requerimientos 04 septiembre
 
 with nomprov as (
select d.SourceWorkItemSK,max(proveedorOTReq)proveedorOTReq,count(distinct proveedorOTReq)nroprov
FROM    #vfactRequerimientos2 as d
LEFT JOIN   ##OT_Requerimientos2 as e 
on d.TargetWorkitemSK=e.WISKOTReq
group by d.SourceWorkItemSK)
select d.SourceWorkItemSK--, d.TargetWorkitemSK
		,CASE WHEN nroprov>1 THEN 'VARIOS' ELSE MAX(F.proveedorOTReq) END AS proveedorOTReq
		,avg(valorHoraOTReq) as valorHoraOTReq
		,min(fechaInicioOTReq) as fechaInicioOTReq
		,max(fechaFinOTReq) as fechaFinOTReq
		,sum(diasOTReq) as diasOTReq
		,sum(claro_ALM_HorasAcordadasReq) as claro_ALM_HorasAcordadasReq
		,sum(Claro_ALM_HorasPlaneadasReq) as Claro_ALM_HorasPlaneadasReq
		,sum(valorHoraOTReq * Claro_ALM_HorasPlaneadasReq) as CostoReq
		,max(prioridad) as prioridad
into #OTRequerimientos2
FROM    #vfactRequerimientos2 as d
LEFT JOIN   ##OT_Requerimientos2 as e 
on d.TargetWorkitemSK=e.WISKOTreq
LEFT JOIN nomprov AS F
ON d.SourceWorkItemSK=f.SourceWorkItemSK
group by d.SourceWorkItemSK,nroprov		
order by d.SourceWorkItemSK asc;

--SELECT * FROM #OTRequerimientos2;

--Query que trae las columnas Claro_ALM_CausalCambioFechaReal y Claro_ALM_CausalCambioFechaPlaneada de los WI 'RequerimientoNegocio','Requerimiento por Linea Producto','Orden de Trabajo'
DECLARE @columsadd NVARCHAR(500);
SET @columsadd=
'SELECT v.System_Id,v.WorkItemSK,v.Claro_ALM_CausalCambioFechaReal,v.Claro_ALM_CausalCambioFechaPlaneada
  INTO ##causalescambiofec
  FROM [dbo].[CurrentWorkItemView] v
  WHERE v.System_WorkItemType=''Requerimiento por Linea Producto'' and v.System_Title is not null
  ORDER BY v.System_Id, v.WorkItemSK ASC';
  EXEC sp_executesql @columsadd;
--SELECT * FROM ##causalescambiofec;

---------------------------------
PRINT 'insertInfgeneral';
truncate table informeGeneral;
--DECLARE @insertInfgeneral NVARCHAR(MAX);
--SET @insertInfgeneral =
INSERT INTO [dbo].[informeGeneral]
           ([briefSysID]
           --,[Claro_ALM_NumeroBrief]
		   ,[Claro_ALM_UnidadNegocio]
           ,[System_Title]
           ,[descripcion]
           ,[Claro_ALM_TipoBeneficio]
           ,[numeroResolucion]
           ,[Claro_ALM_GerenteSolicitante]
           ,[Claro_ALM_ResponsableNegocio]
           ,[Claro_ALM_DirectorSolicitante]
           ,[Claro_ALM_AreaNegocio]
           ,[Claro_ALM_Estrategia]
           ,[Claro_ALM_Clasificacion]
           ,[Claro_ALM_Consecutivo123MIC]
           ,[estadoBrief]
           ,[Claro_ALM_LiderBrief]
           ,[Claro_ALM_FechaRadicado]
           ,[Claro_ALM_FechaFSPBase]
           ,[Claro_ALM_FechaAprobado]
           ,[Claro_ALM_FechaFactible]
           ,[Claro_ALM_FechaFSPCerrado]
           ,[Claro_ALM_FechaEstimado]
           ,[Claro_ALM_FechaAprobadoJunta]
           ,[Prioridad]
           ,[LineaProducto]
           ,[EstadoLineaProducto]
           ,[FaseLineaProducto]
           ,[GerenciaDesarrollo]
           ,[reqBloqueado]
           ,[LiderDesarrollo]
		   ,[RLP_FechaCreado]
		   ,[RLP_FechaAprobado]
		   ,[RLP_FechaAnalisis]
		   ,[RLP_FechaConstrucion]
		   ,[RLP_FechaPruebas]
		   ,[RLP_FechaDespliegue]
		   ,[CausalDemoraDespliegue]
		   ,[CumplimientoFabricaDesarrollo]
           ,[proveedorDesarrollo]
           ,[FechaInicialDesarrollo]
           ,[FechaFinalDesarrollo]
           ,[TiempoDesarrollodias]
           ,[claro_ALM_HorasAcordadasDes]
           ,[Claro_ALM_HorasPlaneadasDes]
           ,[CostoDesarrollo]
           ,[TallaDesarrollo]
           ,[ViabilidadDesarrollo]
           ,[proveedorPruebas]
           ,[FechaInicialPruebas]
           ,[FechaFinalPruebas]
           ,[TiempoPruebasDias]
           ,[Claro_ALM_HorasPlaneadasPru]
           ,[claro_ALM_HorasAcordadasPru]
           ,[CostoPruebas]
           ,[TallaPruebas]
		   ,[proveedorReq] ------adiciono campos requerimiento OT
           ,[FechaInicialReq]
           ,[FechaFinalReq]
           ,[TiempoReqDias]
           ,[Claro_ALM_HorasPlaneadasReq]
           ,[claro_ALM_HorasAcordadasReq]
           ,[CostoReq]
           ,[TallaReq]
           ,[Claro_ALM_FechaPlaneadaDespliegue]
           ,[EstadoDespliegue]
           ,[FechaRealDespliegue]
           ,[ParticipaArquitectura]
           ,[ParticipaAseguramientoIngresos]
           ,[NotificacionAlUsuario]
           ,[SeguimientoIT]
           ,[ReqLPSysID]
           ,[ReqSysID]
           ,[motivoBrief]
           ,[estadoReqNeg]
           ,[Claro_ALM_Segmento]
           ,[bloqueadoBrief]
           ,[reason_RQLP]
           ,[WorkItemSK]
           ,[wisk_RQLP]
           ,[EstadosPRB]
		   ,AfectaSistemaFinanciero
		   ,CargoSistemaFinanciero
		   ,AutorizacionSistemaFinanciero
		   ,ComplejidadBrief
		   ,[Claro_ALM_DescripcionFase]
		   ,[Claro_ALM_FechaDesplieguePlanFase]
		   ,[Claro_ALM_FechaDespliegueRealFase]
		   ,[Claro_ALM_EstadoFase]
		   ,BriefAsignado
		   ,Fecha_Creacion_Brief
		   ,Causal_Desfase_Despliegue 
		   ,Causales_Cambio_fecha_planeada)
		   
select 
a.briefSysID
--,a.Claro_ALM_NumeroBrief
,a.Claro_ALM_UnidadNegocio
,a.System_Title
,x.descripcion
,Claro_ALM_TipoBeneficio
,ISNULL(a.Claro_ALM_BeneficioResolucion, '') as numeroResolucion
,a.[Claro_ALM_GerenteSolicitante]
,a.Claro_ALM_ResponsableNegocio
,a.Claro_ALM_DirectorSolicitante
,a.Claro_ALM_AreaNegocio
,a.Claro_ALM_Estrategia
,a.Claro_ALM_Clasificacion
,a.Claro_ALM_Consecutivo123MIC
,a.System_State as estadoBrief
,a.Claro_ALM_LiderBrief
,Claro_ALM_FechaRadicado
,Claro_ALM_FechaFSPBase
,Claro_ALM_FechaAprobado
,Claro_ALM_FechaFactible
,Claro_ALM_FechaFSPCerrado
,Claro_ALM_FechaEstimado
,Claro_ALM_FechaAprobadoJunta
,a.Microsoft_VSTS_Common_Priority as Prioridad
,h.ALMLINEAPRODUCTO_RQLP as LineaProducto
,ISNULL(h.state_RQLP,'') as EstadoLineaProducto
,h.FASE_RQLP as FaseLineaProducto
,h.ALMGciaDiv_RQLP AS GerenciaDesarrollo
,ISNULL(h.blocked_RQLP,'') as reqBloqueado
--,substring(h.ALMLIDERLP_RQLP,1
	--    ,(CHARINDEX('<',h.ALMLIDERLP_RQLP,1 )-1))  as LiderDesarrollo
,h.ALMLIDERLP_RQLP as LiderDesarrollo
,h.RLP_FechaCreado
,h.RLP_FechaAprobado
,h.RLP_FechaAnalisis
,h.RLP_FechaConstrucion
,h.RLP_FechaPruebas
,h.RLP_FechaDespliegue
,h.CausalDemoraDespliegue
,h.CumplimientoFabricaDesarrollo
,e.proveedorOTDes as proveedorDesarrollo
,e.fechaInicioOTDes as FechaInicialDesarrollo
,e.fechaFinOTDes as FechaFinalDesarrollo
, e.diasOTDes as TiempoDesarrollodias
,e.claro_ALM_HorasAcordadasDes
,e.Claro_ALM_HorasPlaneadasDes
,e.CostoDesarrollo as CostoDesarrollo
,CASE WHEN  e.Claro_ALM_HorasPlaneadasDes <201 then 'S' 
	  WHEN   e.Claro_ALM_HorasPlaneadasDes <401 then 'M'
	  WHEN   e.Claro_ALM_HorasPlaneadasDes <1001 then 'L'
	  WHEN   e.Claro_ALM_HorasPlaneadasDes <9000 then 'XL'
	  ELSE '' END AS TallaDesarrollo
,ISNULL([Claro_ALM_CerradoIT],'') as ViabilidadDesarrollo  --todo: definir origen de campo
,m.proveedorOTPru as proveedorPruebas
,m.fechaInicioOTPru as FechaInicialPruebas
,m.fechaFinOTPru as FechaFinalPruebas
,m.diasOTPru as TiempoPruebasDias
,m.Claro_ALM_HorasPlaneadasPru
,m.claro_ALM_HorasAcordadasPru
,(m.CostoPrueba) as CostoPruebas  
,CASE WHEN  m.Claro_ALM_HorasPlaneadasPru <201 then 'S' 
	  WHEN  m.Claro_ALM_HorasPlaneadasPru <401 then 'M' 
	  WHEN   m.Claro_ALM_HorasPlaneadasPru <1001 then 'L'
	  WHEN   m.Claro_ALM_HorasPlaneadasPru <9000 then 'XL' 
	  ELSE '''' END AS TallaPruebas
----se adiciona campos OT requerimientos 4 septiembre
,r.proveedorOTReq as proveedorReq
,r.fechaInicioOTReq as FechaInicialReq
,r.fechaFinOTReq as FechaFinalReq
,r.diasOTReq as TiempoReq
,r.Claro_ALM_HorasPlaneadasReq
,r.claro_ALM_HorasAcordadasReq
,r.CostoReq as CostoReq
,CASE WHEN  r.Claro_ALM_HorasPlaneadasReq <201 then 'S' 
	  WHEN   r.Claro_ALM_HorasPlaneadasReq <401 then 'M' 
	  WHEN   r.Claro_ALM_HorasPlaneadasReq <1001 then 'L' 
	  WHEN   r.Claro_ALM_HorasPlaneadasReq <9000 then 'XL' 
	  ELSE '' END AS TallaRequerimientos
 ,h.Claro_ALM_FechaPlaneadaDespliegue
 ,h.EstadoDespliegue
 ,h.FechaRealDespliegue
,a.Claro_ALM_ParticipaArquitectura as ParticipaArquitectura
,a.ParticipaAseguramientoIngresos
,x.NotificacionAlUsuario
,x.SeguimientoIT
,h.ReqLPSysID
,i.ReqSysID
,a.System_Reason as motivoBrief
,i.staterq as estadoReqNeg
,a.Claro_ALM_Segmento
,ISNULL(a.[Microsoft_VSTS_CMMI_Blocked],'') as bloqueadoBrief
,ISNULL(h.reason_RQLP,'') as reason_RQLP
,a.WorkItemSK
,h.wisk_RQLP
,case 
	  when a.System_State = 'Aprobado Junta' and h.state_RQLP = 'Aprobado'  then '04. Cola A&d'
	  when a.System_State = 'Aprobado Junta' and h.state_RQLP = 'Analisis' and h.blocked_RQLP='Sí' then '04. Cola A&d'
	  when a.System_State = 'Aprobado Junta' and h.state_RQLP = 'Analisis' and h.blocked_RQLP='No' then '04.1. A&D'
	  when a.System_State = 'Aprobado Junta' and h.state_RQLP = 'Construccion' and h.blocked_RQLP='Sí' then '05. Cola Dev'
	  when a.System_State = 'Aprobado Junta' and h.state_RQLP = 'Construccion' and h.blocked_RQLP='No' then '05.1. Desarrollo'
	  when a.System_State = 'Aprobado Junta' and h.state_RQLP = 'Pruebas' and h.blocked_RQLP='Sí' then '06. Cola Pruebas'
	  when a.System_State = 'Aprobado Junta' and h.state_RQLP = 'Pruebas' and h.blocked_RQLP='No' then '07. Pruebas'
	  when a.System_State = 'Aprobado Junta' and h.state_RQLP = 'Despliegue'  then '08. Despliegue'
	  when a.System_State = 'Aprobado Junta' and h.state_RQLP = 'Produccion'  then '09. Produccion'
	  when a.System_State = 'Factible' then '00. Const. FSP'
	  when a.System_State = 'FSP Base' then '01. Cierre FSP'
	  when a.System_State = 'FSP Cerrado' then '02. Sin Estimar'
	  when a.System_State = 'Estimado' then '02.1 Estimado'
	  when a.System_State = 'Aprobado Junta' and h.state_RQLP='Creado' then '04.2 ESTADO VACIO'
	  when a.System_State = 'Cerrado' then '10. Cerrado'
	  else '' END AS EstadosPRB
,a.Claro_ALM_AfectaSistemaFinanciero
,a.Claro_ALM_CargoSistemaFinanciero
,a.Claro_ALM_AutorizacionSistemaFinanciero
,a.Claro_ALM_Complejidad
,infofases.Claro_ALM_DescripcionFase
,infofases.Claro_ALM_FechaDesplieguePlanFase
,infofases.Claro_ALM_FechaDespliegueRealFase
,infofases.Claro_ALM_EstadoFase
,a.System_AssignedTo
,a.System_CreatedDate_Brief
,Claro_ALM_CausalCambioFechaReal
,Claro_ALM_CausalCambioFechaPlaneada
from ##brief2 
as a
left join  ##briefReqlp2 as h 
on a.briefSysID=h.briefSysID
left join ##InformacionFasesBrief infofases
on a.briefSysID = infofases.BriefId AND h.FASE_RQLP = infofases.Fase
left join  ##briefReqneg2 as i
on a.briefSysID=i.briefSysID
LEFT JOIN   #OTdesarrollo2 as e  --select * from #OTdesarrollo
on h.wisk_RQLP=e.SourceWorkItemSK
left join #OTPrueba2 as m
on h.wisk_RQLP=m.SourceWorkItemSK
left join #OTRequerimientos2 as r-----se adiciono OT requerimientos
on h.wisk_RQLP=r.SourceWorkItemSK
left join ##causalescambiofec as ccf 
on h.ReqLPSysID = ccf.System_Id and h.wisk_RQLP = ccf.WorkItemSK
left join [dbo].[CamposDeTextoBrief] as x
on a.briefSysID=x.workitemsk
where a.System_Title <> 'Para eliminar espacio' -- Al pasar al ambiente de migracion descomentarear esta lineas
order by briefSysID;


--SELECT @insertInfgeneral;
--EXEC sp_executesql @insertInfgeneral;
select * from [dbo].[informeGeneral];
----------

---------------------------------------------
--Crear prioridad prb
---------------------------------------------
CREATE TABLE #prioridadEstadoPRB2 --DROP TABLE #prioridadEstadoPRB
	(estado nvarchar(50), prioridad tinyint)
INSERT INTO  #prioridadEstadoPRB2 (estado,prioridad)
	VALUES 
	('00. Const. FSP',1),
	('01. Cierre FSP',2),
	('02. Sin Estimar',3),
	('02.1 Estimado',4),
	('04. Cola A&d',5),
	('04.1. A&D',6),
	('04.2 ESTADO VACIO',7),
	('05. Cola Dev',8),
	('05.1. Desarrollo',9),
	('06. Cola Pruebas',10),
	('07. Pruebas',11),
	('08. Despliegue',12),
	('09. Produccion',13),
	('10. Cerrado',14),
	('',15)


UPDATE informeGeneral 
SET PrioridadPRB = P.ORDERN
FROM  informeGeneral  AS A
INNER JOIN 
(SELECT A.briefSysID
,A.ReqLPSysID
,ROW_NUMBER() OVER (PARTITION BY A.briefSysID ORDER BY A.briefSysID,B.prioridad) AS ORDERN
FROM informeGeneral AS A
INNER JOIN  #prioridadEstadoPRB2 AS B
ON A.EstadosPRB=B.estado) AS P
ON A.briefSysID=P.briefSysID
AND A.ReqLPSysID=P.ReqLPSysID
-----------------------------------
Drop TABLE ##Brief2;
DROP TABLE ##RQ2;
DROP TABLE ##RQLP2;	 
DROP TABLE #numerosFases;
DROP TABLE #estadosFases;
DROP TABLE #fechasdespliegue;
DROP TABLE #fechasreales;
DROP TABLE ##InformacionFasesBrief;
DROP TABLE ##vFactLinkedCurrentWorkItem2;
DROP TABLE ##briefReqlp2;
DROP TABLE ##briefReqneg2;
DROP TABLE ##OT_desarrollo2;
DROP TABLE #prioridadEstadoRegNeg2;
DROP TABLE #prioridadEstadoOT2;
DROP TABLE ##OT_Requerimientos2;
DROP TABLE ##OT_pruebas2;
DROP TABLE #vfactDesarrollo2;
DROP TABLE #vfactRequerimientos2;
DROP TABLE #vfactPruebas2;
DROP TABLE #OTDesarrollo2;
DROP TABLE #OTPrueba2;
DROP TABLE #OTRequerimientos2;
DROP TABLE ##causalescambiofec;
DROP TABLE #prioridadEstadoPRB2;

END




