USE [ADSReports]
GO
/****** Object:  StoredProcedure [dbo].[stp_CbPruebasBLPOT]    Script Date: 26/03/2020 7:41:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_CbPruebasBLPOT] 
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
-------------------------------------
--Campos del Elemento BRIEF
-------------------------------------
DECLARE @briefVar NVARCHAR(MAX);
 DECLARE @parambrief2 NVARCHAR(100);
 SET @parambrief2=N'@TEAMPROJECTCOLLECTIONGUID NVARCHAR(50)';
 SET @briefVar=N'
SELECT [WorkItemSK] as B_WorkItemSK
		,System_Id as B_Id
      ,[System_ChangedDate] as B_FechaModificacion
      ,[System_Title] as B_Titulo
      ,[System_State] as B_Estado
      ,[System_Reason] as B_Motivo
	  ,[Microsoft_VSTS_CMMI_Blocked] as B_Bloqueado
      ,[System_CreatedBy] as B_CreadoPor
      ,[Microsoft_VSTS_Common_Priority] as B_Prioridad
      ,[Claro_ALM_Consecutivo123MIC] as B_Consec123
      --,[Claro_ALM_Operacion] as B_Operacion
	  ,'''' as B_Operacion
      ,[Claro_ALM_Clasificacion] as B_Clasificacion
	  ,Claro_ALM_NumeroPRY as B_NumeroPRY
      ,[Claro_ALM_Estrategia] as B_Estrategia
	  ,[Claro_ALM_LiderBrief]  as B_LiderBrief
      --,substring([Claro_ALM_LiderBrief],1
	  --  ,(CHARINDEX(''<'',[Claro_ALM_LiderBrief],1 )-1))  as B_LiderBrief
      ,[Claro_ALM_Complejidad] as B_Complejidad
	  ,[Claro_ALM_DirectorSolicitante] as B_DirectorSolicitante
      -- ,substring([Claro_ALM_DirectorSolicitante],1
	  --  ,(CHARINDEX(''<'',[Claro_ALM_DirectorSolicitante],1 )-1)) as B_DirectorSolicitante
      ,[Claro_ALM_RadicadoPor] as B_RadicadoPor
      ,[Claro_ALM_FactiblePor] as B_FactiblePor
      ,[Claro_ALM_FSPBasePor] as B_FSPBasePor
      ,[Claro_ALM_FSPCerradoPor] as B_FSPCerradoPor
      ,[Claro_ALM_EstimadoPor] as B_EstimadoPor
      ,Claro_ALM_AprobadoJuntaPor as B_AprobadoJuntaPor
	  ,Claro_ALM_FechaRadicado as B_FechaRadicado
	  ,Claro_ALM_FechaFactible as B_FechaFactible
	  ,Claro_ALM_FechaFSPBase as B_FechaFSPBase
	  ,Claro_ALM_FechaFSPCerrado as B_FechaFSPCerrado
	  ,Claro_ALM_FechaEstimado as B_FechaEstimado
	  ,Claro_ALM_FechaAprobadoJunta as B_FechaAprobadoJunta
	  ,[Claro_ALM_ResponsableNegocio] as B_ResponsableNegocio
      --,substring([Claro_ALM_ResponsableNegocio],1
	  --  ,(CHARINDEX(''<'',[Claro_ALM_ResponsableNegocio],1 )-1)) as B_ResponsableNegocio
      ,[Claro_ALM_CategoriaRiesgo] as B_CategoriaRiesgo
      ,[Claro_ALM_CargoAutorizadorRiesgo] as B_CargoAutorizadorRiesgo
      ,[Claro_ALM_AutorizacionRiesgo] as B_AutorizacionRiesgo
	  ,Claro_ALM_RequiereReportes as B_RequiereReportes
      ,[Claro_ALM_AfectaSistemaFinanciero] as B_AfectaSistemaFinanciero
      ,[Claro_ALM_CargoSistemaFinanciero] as B_CargoSistemaFinanciero
      ,[Claro_ALM_AutorizacionSistemaFinanciero] as B_AutorizacionSistemaFinanciero
      --,[Claro_ALM_NaturalezaCambio] as B_NaturalezaCambio
	  ,'''' as B_NaturalezaCambio
      ,[Claro_ALM_GerenteSolicitante] as B_GerenteSolicitante
	  --,substring([Claro_ALM_GerenteSolicitante],1
	  --  ,(CHARINDEX(''<'',[Claro_ALM_GerenteSolicitante],1 )-1)) as B_GerenteSolicitante
      ,[Claro_ALM_AutorizacionGerencia] as B_AutorizacionGerencia
      ,[Claro_ALM_AutorizacionDireccion] as B_AutorizacionDireccion
    --  ,[Claro_ALM_AnalistaRequerimientos] as B_AnalistaRequerimientos
	  ,'''' as B_AnalistaRequerimientos
      ,[Claro_ALM_PAI] as B_ParticipaAseguramientoIngresos
      ,[Claro_ALM_ParticipaArquitectura] as B_ParticipaArquitectura
      ,[Claro_ALM_TipoBeneficio] as B_TipoBeneficio
      ,[Claro_ALM_BeneficioResolucion] as B_BeneficioResolucion
      --,[Claro_ALM_FechaInicioRequerimientos] as B_FechaInicioRequerimientos
	  ,'''' as B_FechaInicioRequerimientos
      ,[Claro_ALM_Segmento] as B_Segmento
      ,[Claro_ALM_NumeroBrief] as B_NumeroBrief
      ,[Claro_ALM_FechaAprobacionPortafolio] as B_FechaAprobacionPortafolio
	  ,[Claro_ALM_CerradoIT] as B_CerradoIT
	  ,Claro_ALM_AreaNegocio as B_AreaNegocio
into ##Brief--drop Table #Brief 
FROM [dbo].[CurrentWorkItemView]
  where System_WorkItemType=''BRIEF'' and System_Title NOT IN (''Para eliminar espacio'')
  AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID'; --@TEAMPROJECTCOLLECTIONGUID
  --select * from #Brief where B_Id='23219'


  EXEC sp_executesql @briefVar,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
---------------------------------------------
--Cruce de Requerimientos LP
---------------------------------------------

DECLARE @ReqLp NVARCHAR(MAX);
SET @ReqLp =N'
select  WorkItemSK as LP_WorkItemSK
		,System_Id as LP_Id
		,system_state as LP_Estado
		,System_Reason as LP_Motivo
		,Microsoft_VSTS_CMMI_Blocked as LP_Bloqueado
		,Claro_ALM_Fase as LP_Fase
		,Claro_ALM_GerenciaDesarrollo as LP_GerenciaDesarrollo
		,Claro_ALM_LineaProducto as LP_LineaProducto
		,Claro_ALM_LiderLineaProducto as LP_LiderLineaProducto    /**Al pasar a produccion volver a dejar esta linea e inhabilitar la siguiente**/
--,substring([Claro_ALM_LiderLinea],1
	    --,(CHARINDEX(''<'',[Claro_ALM_LiderLinea],1 )-1)) as LP_LiderLineaProducto 	/**Al pasar a produccion inhabilitar esta linea y dejar la anterior**/
		,Claro_ALM_FechaPlaneadaDespliegue as LP_FechaPlaneadaDespliegue
		,Claro_ALM_FechaDespliegue as LP_FechaRealDespliegue
INTO ##RQLP --DROP TABLE #RQLP
FROM [dbo].[CurrentWorkItemView]
WHERE System_WorkItemType=''Requerimiento por Linea Producto''
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and System_Title is not null';
EXEC sp_executesql @ReqLp,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;

---select * from #RQLP where LP_id='23272'
---------------------------------------------
--Deja una sola relación posible entre dos objetos
--corrige problema en que creen más de una relación entre
--un brief y una línea de producto
---------------------------------------------
DECLARE @vFactLinkedCurrentWorkItem NVARCHAR(MAX);
 SET @vFactLinkedCurrentWorkItem=N'
select a.SourceWorkItemSK,a.TargetWorkitemSK
into ##vFactLinkedCurrentWorkItem --drop table #vFactLinkedCurrentWorkItem --DROP TABLE #RQLP
from '+@Warehousedb+'.[dbo].[vFactLinkedCurrentWorkItem] as a
group by  a.SourceWorkItemSK,a.TargetWorkitemSK';

EXEC sp_executesql @vFactLinkedCurrentWorkItem;
---------------------------------------------
--brief y req LINEA DE PRODUCTO
---------------------------------------------
select b.*, link.TargetWorkitemSK
into #BriefLinks --DROP TABLE  #BriefLinks
from ##Brief b left join ##vFactLinkedCurrentWorkItem link
on b.B_WorkItemSK=link.SourceWorkItemSK
order by b.B_id;


select linksB.B_WorkItemSK, linksB.B_Id,linksB.B_FechaModificacion, linksB.B_Titulo, linksB.B_Estado, linksB.B_Motivo, linksB.B_Bloqueado, linksB.B_CreadoPor, 
linksB.B_Prioridad, linksB.B_Consec123, linksB.B_Operacion, linksB.B_Clasificacion, linksB.B_NumeroPRY, linksB.B_Estrategia, linksB.B_LiderBrief, 
linksB.B_Complejidad, linksB.B_DirectorSolicitante, linksB.B_RadicadoPor, linksB.B_FactiblePor, linksB.B_FSPBasePor, linksB.B_FSPCerradoPor, 
linksB.B_EstimadoPor, linksB.B_AprobadoJuntaPor, linksB.B_FechaRadicado, linksB.B_FechaFactible, linksB.B_FechaFSPBase, linksB.B_FechaFSPCerrado, 
linksB.B_FechaEstimado, linksB.B_FechaAprobadoJunta, linksB.B_ResponsableNegocio, linksB.B_CategoriaRiesgo, linksB.B_CargoAutorizadorRiesgo, 
linksB.B_AutorizacionRiesgo, linksB.B_RequiereReportes, linksB.B_AfectaSistemaFinanciero, linksB.B_CargoSistemaFinanciero, linksB.B_AutorizacionSistemaFinanciero, 
linksB.B_NaturalezaCambio, linksB.B_GerenteSolicitante, linksB.B_AutorizacionGerencia, linksB.B_AutorizacionDireccion, linksB.B_AnalistaRequerimientos, 
linksB.B_ParticipaAseguramientoIngresos, linksB.B_ParticipaArquitectura, linksB.B_TipoBeneficio, linksB.B_BeneficioResolucion, linksB.B_FechaInicioRequerimientos, 
linksB.B_Segmento, linksB.B_NumeroBrief, linksB.B_FechaAprobacionPortafolio, linksB.B_CerradoIT, linksB.B_AreaNegocio,r.LP_WorkItemSK, r.LP_Id, r.LP_Estado, r.LP_Motivo, 
r.LP_Bloqueado,r.LP_Fase, r.LP_GerenciaDesarrollo,r.LP_LineaProducto, r.LP_LiderLineaProducto, r.LP_FechaPlaneadaDespliegue, r.LP_FechaRealDespliegue
into  #BriefRQLP --DROP TABLE  #BriefRQLP
from #BriefLinks linksB inner join ##RQLP r 
on linksB.TargetWorkitemSK=r.LP_WorkItemSK 
order by linksB.B_Id;

--select * from  #BriefRQLP 
-----------------------------
DECLARE @DimWorkItem NVARCHAR(MAX);
 SET @DimWorkItem=N'
SELECT System_Id,System_State,CLARO_ALM_ESTIMADAFECHA,CLARO_ALM_ASIGNADADETALLEFECHA,TeamProjectSK,
	System_Reason
	into ##DimworItem2 FROM '+@Warehousedb+'.[dbo].[DimWorkItem] as d';


EXEC sp_executesql @DimWorkItem;		
-----------------------------
--OT
-----------------------------

DECLARE @OT NVARCHAR(MAX);
SET @OT =N'
select WorkItemSK as OT_WorkItemSK
		,System_Id as OT_Id
		,System_State as OT_Estado
		,System_Reason as OT_Motivo
		,Microsoft_VSTS_Common_Discipline as OT_Disciplina
		,Claro_ALM_TipoOT as OT_Tipo
		,Claro_ALM_Gerencia as OT_Gerencia
		,Claro_ALM_CentroCosto as OT_CentroCosto
		,Claro_ALM_HorasPlaneadas as OT_EAN_HorasPlaneadas
		,claro_alm_dias as OT_EAN_dias
		,Claro_ALM_Proveedor as OT_EAN_proveedor
		,Claro_ALM_ValorHora as EAN_valorHoraOT
		,Claro_ALM_TallaAltoNivel as OT_EAN_Talla
		,Claro_ALM_HorasClaro AS OT_ED_HorasClaro
		,Claro_ALM_HorasProveedor as OT_ED_HorasProveedor
		,Claro_ALM_HorasAcordadas as OT_ED_HorasAcordadas
		,Claro_ALM_TallaDetalle as OT_ED_Talla
		,Claro_ALM_FechaInicio as OT_ED_fechaInicio
		,Claro_alm_fechafin as OT_ED_fechaFin
		,Claro_ALM_ClasePresupuesto as OT_ED_ClasePresupuesto
		,Claro_ALM_CantidadAnalistas as OT_ED_CantidadAnalistas
		,Claro_ALM_PorcentajeIncertidumbre as OT_ED_PorcentajeIncertidumbre
		,Claro_ALM_TrabajoEfectivo as OT_ED_TrabajoEfectivo
		,Claro_ALM_CantidadReclamos as OT_ED_CantidadReclamos
		,Claro_ALM_HorasOptimistas as OT_ED_HorasOptimistas
		,Claro_ALM_DiasOptimistas as OT_ED_DiasOptimistas
		,Claro_ALM_FechaFinOptimista as OT_ED_FechaFinOptimista
		,Claro_ALM_DiasPesimistas as OT_ED_DiasPesimistas
		,Claro_ALM_HorasPesimistasPlaneacion as OT_ED_HorasPesimPlan
		,Claro_ALM_HorasPesimistasDiseno as OT_ED_HorasPesimDiseño
		,Claro_ALM_HorasPesimistasEjecucion as OT_ED_HorasPesimEjec
		,Claro_ALM_HorasPesimistasCierre as OT_ED_HorasPesimCierre
		,Claro_ALM_FechaEntrega1 as OT_ED_FechaPlanEntregaPaq1
		,Claro_ALM_FechaEntrega2 as OT_ED_FechaPlanEntregaPaq2
		,Claro_ALM_FechaEntrega3 as OT_ED_FechaPlanEntregaPaq3
		,Claro_ALM_FechaEntrega4 as OT_ED_FechaPlanEntregaPaq4
		,ISNULL(Claro_ALM_RecibirEntrega1, ''No'') as OT_ED_RecibirPaq1
		,ISNULL(Claro_ALM_RecibirEntrega2, ''No'') as OT_ED_RecibirPaq2
		,ISNULL(Claro_ALM_RecibirEntrega3, ''No'') as OT_ED_RecibirPaq3
		,ISNULL(Claro_ALM_RecibirEntrega4, ''No'') as OT_ED_RecibirPaq4
		,Claro_ALM_FechaRecepcion1 as OT_ED_FechaRecepPaq1
		,Claro_ALM_FechaRecepcion2 as OT_ED_FechaRecepPaq2
		,Claro_ALM_FechaRecepcion3 as OT_ED_FechaRecepPaq3
		,Claro_ALM_FechaRecepcion4 as OT_ED_FechaRecepPaq4
		,Claro_ALM_FacturableEntrega1 as OT_AP_FacturableEntrega1
		,Claro_ALM_FacturableEntrega2 as OT_AP_FacturableEntrega2
		,Claro_ALM_FacturableEntrega3 as OT_AP_FacturableEntrega3
		,Claro_ALM_FacturableEntrega4 as OT_AP_FacturableEntrega4
,CASE WHEN Claro_ALM_PagadaEntrega1 IS NULL AND NOT Claro_ALM_TallaDetalle IS NULL THEN ''No''
     ELSE Claro_ALM_PagadaEntrega1  END AS OT_AP_PagadaEntrega1
,CASE WHEN Claro_ALM_PagadaEntrega2 IS NULL AND NOT Claro_ALM_TallaDetalle IS NULL AND Claro_ALM_TallaDetalle IN (''M'',''L'',''XL'') THEN ''No''
    ELSE Claro_ALM_PagadaEntrega2  END AS OT_AP_PagadaEntrega2
,CASE WHEN Claro_ALM_PagadaEntrega3 IS NULL AND NOT Claro_ALM_TallaDetalle IS NULL AND Claro_ALM_TallaDetalle IN (''L'',''XL'') THEN ''No''
    ELSE Claro_ALM_PagadaEntrega3  END AS OT_AP_PagadaEntrega3
,CASE WHEN Claro_ALM_PagadaEntrega4 IS NULL AND NOT Claro_ALM_TallaDetalle IS NULL AND Claro_ALM_TallaDetalle=''XL'' THEN ''No''
    ELSE Claro_ALM_PagadaEntrega4  END AS OT_AP_PagadaEntrega4
		,Claro_ALM_HorasPagadas1Entrega1 as OT_AP_HorasPag1Entrega1
		,Claro_ALM_OrdenCompra1Entrega1 as OT_AP_OrdenCompra1Entrega1
		,Claro_ALM_HorasPagadas2Entrega1 as OT_AP_HorasPag2Entrega1
		,Claro_ALM_OrdenCompra2Entrega1 as OT_AP_OrdenCompra2Entrega1
		,Claro_ALM_HorasPagadas3Entrega1 as OT_AP_HorasPag3Entrega1
		,Claro_ALM_OrdenCompra3Entrega1 as OT_AP_OrdenCompra3Entrega1
		,Claro_ALM_HorasPagadas1Entrega2 as OT_AP_HorasPag1Entrega2
		,Claro_ALM_OrdenCompra1Entrega2 as OT_AP_OrdenCompra1Entrega2
		,Claro_ALM_HorasPagadas2Entrega2 as OT_AP_HorasPag2Entrega2
		,Claro_ALM_OrdenCompra2Entrega2 as OT_AP_OrdenCompra2Entrega2
		,Claro_ALM_HorasPagadas3Entrega2 as OT_AP_HorasPag3Entrega2
		,Claro_ALM_OrdenCompra3Entrega2 as OT_AP_OrdenCompra3Entrega2
		,Claro_ALM_HorasPagadas1Entrega3 as OT_AP_HorasPag1Entrega3
		,Claro_ALM_OrdenCompra1Entrega3 as OT_AP_OrdenCompra1Entrega3
		,Claro_ALM_HorasPagadas2Entrega3 as OT_AP_HorasPag2Entrega3
		,Claro_ALM_OrdenCompra2Entrega3 as OT_AP_OrdenCompra2Entrega3
		,Claro_ALM_HorasPagadas3Entrega3 as OT_AP_HorasPag3Entrega3
		,Claro_ALM_OrdenCompra3Entrega3 as OT_AP_OrdenCompra3Entrega3
		,Claro_ALM_HorasPagadas1Entrega4 as OT_AP_HorasPag1Entrega4
		,Claro_ALM_OrdenCompra1Entrega4 as OT_AP_OrdenCompra1Entrega4
		,Claro_ALM_HorasPagadas2Entrega4 as OT_AP_HorasPag2Entrega4
		,Claro_ALM_OrdenCompra2Entrega4 as OT_AP_OrdenCompra2Entrega4
		,Claro_ALM_HorasPagadas3Entrega4 as OT_AP_HorasPag3Entrega4
		,Claro_ALM_OrdenCompra3Entrega4 as OT_AP_OrdenCompra3Entrega4						
		,Claro_ALM_RatingEntrega1 as OT_AP_RatingEntrega1		
		,Claro_ALM_RatingEntrega2 as OT_AP_RatingEntrega2		
		,Claro_ALM_RatingEntrega3 as OT_AP_RatingEntrega3
		,Claro_ALM_RatingEntrega4 as OT_AP_RatingEntrega4
		,Claro_ALM_RatingEntregaFinal as OT_AP_RatingEntregaFinal
	     ,(SELECT Max(CLARO_ALM_ASIGNADADETALLEFECHA) FROM [##DimworItem2] as d
			where d.System_Id = A.System_Id 
			and d.TeamProjectSK = 480 
			and d.System_Reason= ''Asignada Detalle'')AS OT_Fecha_Asignada_Detalle 
		, --(SELECT Max(W.System_ChangedDate) 
			--FROM [#DimworItem2] W 
			--where W.System_Id = A.System_Id 
			---AND w.System_Reason =''Estimación detallada por aprobar'')AS  OT_Fecha_EstDetXAprob
			(SELECT Max(CLARO_ALM_ESTIMADAFECHA) FROM [##DimworItem2] as d
			where d.System_Id = A.System_Id 
			and d.TeamProjectSK = 480 
			and d.System_Reason= ''Estimación detallada por aprobar'')AS  OT_Fecha_EstDetXAprob
		into ##OT 
		FROM [dbo].[CurrentWorkItemView] AS A
  where System_WorkItemType=''Orden de Trabajo'' 
 AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID';
 EXEC sp_executesql @OT,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
---------------------------------------------

--brief, req LINEA DE PRODUCTO y Ordenes de Trabajo
---------------------------------------------
--select SourceWorkItemSK,TargetWorkitemSK
--	into #vfactConDesfases --DROP TABLE  #vfactConDesfases
--from #vFactLinkedCurrentWorkItem as t
--where t.SourceWorkItemSK in (select k.LP_WorkItemSK from #RQLP as k)
--and t.TargetWorkitemSK  in (select k.OT_WorkItemSK from #OT as k)
select b.LP_WorkItemSK,LP_LineaProducto, link.TargetWorkitemSK
into #BriefRQLPLinks ---DROP TABLE  #BriefRQLPLinks
from #BriefRQLP b 
Left join 
 ##vFactLinkedCurrentWorkItem link
on b.LP_WorkItemSK=link.SourceWorkItemSK
order by b.B_id, b.LP_Id;



-----------------------

Select o.* ,L.LP_WorkItemSK,L.LP_LineaProducto
into #OT2  ---DROP TABLE #OT2
from ##OT o
inner join #BriefRQLPLinks L on L.TargetWorkitemSK=o.OT_WorkItemSK; 



----------------------
--final
--------------------------
truncate table [tbl_CbPruebas_BLPOT];
--drop table informeGeneral
INSERT INTO [dbo].[tbl_CbPruebas_BLPOT](
	[B_WorkItemSK],[B_Id],[B_FechaModificacion],[B_Titulo],[B_Estado],[B_Motivo], [B_Bloqueado],[B_CreadoPor],[B_Prioridad],[B_Consec123],[B_Operacion],[B_Clasificacion],
	[B_NumeroPRY],[B_Estrategia],[B_LiderBrief],[B_Complejidad],[B_DirectorSolicitante],[B_RadicadoPor],[B_FactiblePor],[B_FSPBasePor],[B_FSPCerradoPor],[B_EstimadoPor],
	[B_AprobadoJuntaPor],[B_FechaRadicado],	[B_FechaFactible],[B_FechaFSPBase],[B_FechaFSPCerrado],[B_FechaEstimado],[B_FechaAprobadoJunta],[B_ResponsableNegocio],
	[B_CategoriaRiesgo],[B_CargoAutorizadorRiesgo],	[B_AutorizacionRiesgo],[B_RequiereReportes],[B_AfectaSistemaFinanciero],[B_CargoSistemaFinanciero],
	[B_AutorizacionSistemaFinanciero],[B_NaturalezaCambio],[B_GerenteSolicitante],[B_AutorizacionGerencia],[B_AutorizacionDireccion],[B_AnalistaRequerimientos],
	[B_ParticipaAseguramientoIngresos],[B_ParticipaArquitectura],[B_TipoBeneficio],	[B_BeneficioResolucion],[B_FechaInicioRequerimientos],[B_Segmento],[B_NumeroBrief],
	[B_FechaAprobacionPortafolio],[B_CerradoIT],[B_AreaNegocio],[LP_WorkItemSK],[LP_Id],[LP_Estado],[LP_Motivo],[LP_Bloqueado],[LP_Fase],[LP_GerenciaDesarrollo],
	[LP_LineaProducto],[LP_LiderLineaProducto],[LP_FechaPlaneadaDespliegue],[LP_FechaRealDespliegue],[OT_WorkItemSK],[OT_Id],[OT_Estado],[OT_Motivo],[OT_Disciplina],[OT_Tipo],[OT_Gerencia],
	[OT_CentroCosto],[OT_EAN_HorasPlaneadas],[OT_EAN_Dias],[OT_EAN_Proveedor],[OT_EAN_ValorHora],[OT_EAN_Talla],[OT_ED_HorasClaro],[OT_ED_HorasProveedor],[OT_ED_HorasAcordadas],
	[OT_ED_Talla],[OT_ED_FechaInicio],[OT_ED_FechaFin],[OT_ED_ClasePresupuesto],[OT_ED_CantidadAnalistas],[OT_ED_PorcentajeIncertidumbre],[OT_ED_TrabajoEfectivo],[OT_ED_CantidadReclamos],
	[OT_ED_HorasOptimistas],[OT_ED_DiasOptimistas],[OT_ED_FechaFinOptimista],[OT_ED_DiasPesimistas],[OT_ED_HorasPesimistasPlaneacion],
	[OT_ED_HorasPesimistasDiseno],[OT_ED_HorasPesimistasEjecucion],[OT_ED_HorasPesimistasCierre],[OT_ED_FechaPlanEntregaPaq1],[OT_ED_FechaPlanEntregaPaq2],[OT_ED_FechaPlanEntregaPaq3],
	[OT_ED_FechaPlanEntregaPaq4],[OT_ED_RecibirPaq1],[OT_ED_RecibirPaq2],[OT_ED_RecibirPaq3],[OT_ED_RecibirPaq4],[OT_ED_FechaRecepPaq1],[OT_ED_FechaRecepPaq2],[OT_ED_FechaRecepPaq3],
	[OT_ED_FechaRecepPaq4],[OT_AP_FacturableEntrega1],[OT_AP_FacturableEntrega2],[OT_AP_FacturableEntrega3],[OT_AP_FacturableEntrega4],[OT_AP_PagadaEntrega1],[OT_AP_PagadaEntrega2],
	[OT_AP_PagadaEntrega3],[OT_AP_PagadaEntrega4],
	[OT_AP_HorasPag1Entrega1],OT_AP_OrdenCompra1Entrega1,[OT_AP_HorasPag2Entrega1],OT_AP_OrdenCompra2Entrega1,
	[OT_AP_HorasPag3Entrega1],OT_AP_OrdenCompra3Entrega1,
	[OT_AP_HorasPag1Entrega2],OT_AP_OrdenCompra1Entrega2,[OT_AP_HorasPag2Entrega2],OT_AP_OrdenCompra2Entrega2,
	[OT_AP_HorasPag3Entrega2],OT_AP_OrdenCompra3Entrega2,
	[OT_AP_HorasPag1Entrega3],OT_AP_OrdenCompra1Entrega3,[OT_AP_HorasPag2Entrega3],OT_AP_OrdenCompra2Entrega3,
	[OT_AP_HorasPag3Entrega3],OT_AP_OrdenCompra3Entrega3,
	[OT_AP_HorasPag1Entrega4],OT_AP_OrdenCompra1Entrega4,[OT_AP_HorasPag2Entrega4],OT_AP_OrdenCompra2Entrega4,
	[OT_AP_HorasPag3Entrega4],OT_AP_OrdenCompra3Entrega4,
	[OT_AP_RatingEntrega1],[OT_AP_RatingEntrega2],[OT_AP_RatingEntrega3],[OT_AP_RatingEntrega4],
	[OT_AP_RatingEntregaFinal],OT_Fecha_Asignada_Detalle,OT_Fecha_EstDetXAprob)
select distinct linksBLP.B_WorkItemSK, linksBLP.B_Id,linksBLP.B_FechaModificacion, linksBLP.B_Titulo, linksBLP.B_Estado, linksBLP.B_Motivo, linksBLP.B_Bloqueado, 
linksBLP.B_CreadoPor, linksBLP.B_Prioridad, linksBLP.B_Consec123, linksBLP.B_Operacion, linksBLP.B_Clasificacion, linksBLP.B_NumeroPRY, linksBLP.B_Estrategia, 
linksBLP.B_LiderBrief, linksBLP.B_Complejidad, linksBLP.B_DirectorSolicitante, linksBLP.B_RadicadoPor, linksBLP.B_FactiblePor, linksBLP.B_FSPBasePor, 
linksBLP.B_FSPCerradoPor, linksBLP.B_EstimadoPor, linksBLP.B_AprobadoJuntaPor, linksBLP.B_FechaRadicado, linksBLP.B_FechaFactible, linksBLP.B_FechaFSPBase, 
linksBLP.B_FechaFSPCerrado, linksBLP.B_FechaEstimado, linksBLP.B_FechaAprobadoJunta, linksBLP.B_ResponsableNegocio, linksBLP.B_CategoriaRiesgo,
linksBLP.B_CargoAutorizadorRiesgo, linksBLP.B_AutorizacionRiesgo, linksBLP.B_RequiereReportes, linksBLP.B_AfectaSistemaFinanciero, linksBLP.B_CargoSistemaFinanciero, 
linksBLP.B_AutorizacionSistemaFinanciero, linksBLP.B_NaturalezaCambio, linksBLP.B_GerenteSolicitante, linksBLP.B_AutorizacionGerencia, linksBLP.B_AutorizacionDireccion, 
linksBLP.B_AnalistaRequerimientos, linksBLP.B_ParticipaAseguramientoIngresos, linksBLP.B_ParticipaArquitectura, linksBLP.B_TipoBeneficio, linksBLP.B_BeneficioResolucion, 
linksBLP.B_FechaInicioRequerimientos, linksBLP.B_Segmento, linksBLP.B_NumeroBrief, linksBLP.B_FechaAprobacionPortafolio, linksBLP.B_CerradoIT, linksBLP.B_AreaNegocio,
linksBLP.LP_WorkItemSK, linksBLP.LP_Id, linksBLP.LP_Estado, linksBLP.LP_Motivo, linksBLP.LP_Bloqueado,linksBLP.LP_Fase, linksBLP.LP_GerenciaDesarrollo,
linksBLP.LP_LineaProducto, linksBLP.LP_LiderLineaProducto, linksBLP.LP_FechaPlaneadaDespliegue, linksBLP.LP_FechaRealDespliegue,
O.OT_WorkItemSK,o.OT_Id,o.OT_Estado,o.OT_Motivo,o.OT_Disciplina,o.OT_Tipo,o.OT_Gerencia,o.OT_CentroCosto,o.OT_EAN_HorasPlaneadas,o.OT_EAN_dias,
o.OT_EAN_proveedor,o.EAN_valorHoraOT,o.OT_EAN_Talla,o.OT_ED_HorasClaro,o.OT_ED_HorasProveedor,o.OT_ED_HorasAcordadas,o.OT_ED_Talla,o.OT_ED_fechaInicio,
o.OT_ED_fechaFin,o.OT_ED_ClasePresupuesto,o.OT_ED_CantidadAnalistas,o.OT_ED_PorcentajeIncertidumbre,o.OT_ED_TrabajoEfectivo,o.OT_ED_CantidadReclamos,
o.OT_ED_HorasOptimistas,o.OT_ED_DiasOptimistas,o.OT_ED_FechaFinOptimista,o.OT_ED_DiasPesimistas,o.OT_ED_HorasPesimPlan,o.OT_ED_HorasPesimDiseño,
o.OT_ED_HorasPesimEjec,o.OT_ED_HorasPesimCierre,o.OT_ED_FechaPlanEntregaPaq1,o.OT_ED_FechaPlanEntregaPaq2,o.OT_ED_FechaPlanEntregaPaq3,o.OT_ED_FechaPlanEntregaPaq4,
o.OT_ED_RecibirPaq1,o.OT_ED_RecibirPaq2,o.OT_ED_RecibirPaq3,o.OT_ED_RecibirPaq4,o.OT_ED_FechaRecepPaq1,o.OT_ED_FechaRecepPaq2,o.OT_ED_FechaRecepPaq3,o.OT_ED_FechaRecepPaq4,
o.OT_AP_FacturableEntrega1,o.OT_AP_FacturableEntrega2,o.OT_AP_FacturableEntrega3,o.OT_AP_FacturableEntrega4,o.OT_AP_PagadaEntrega1,o.OT_AP_PagadaEntrega2,
o.OT_AP_PagadaEntrega3,o.OT_AP_PagadaEntrega4,
o.OT_AP_HorasPag1Entrega1,o.OT_AP_OrdenCompra1Entrega1,o.OT_AP_HorasPag2Entrega1,o.OT_AP_OrdenCompra2Entrega1,
o.OT_AP_HorasPag3Entrega1,o.OT_AP_OrdenCompra3Entrega1,
o.OT_AP_HorasPag1Entrega2,o.OT_AP_OrdenCompra1Entrega2,o.OT_AP_HorasPag2Entrega2,o.OT_AP_OrdenCompra2Entrega2,
o.OT_AP_HorasPag3Entrega2,o.OT_AP_OrdenCompra3Entrega2,
o.OT_AP_HorasPag1Entrega3,o.OT_AP_OrdenCompra1Entrega3,o.OT_AP_HorasPag2Entrega3,o.OT_AP_OrdenCompra2Entrega3,
o.OT_AP_HorasPag3Entrega3,o.OT_AP_OrdenCompra3Entrega3,
o.OT_AP_HorasPag1Entrega4,o.OT_AP_OrdenCompra1Entrega4,o.OT_AP_HorasPag2Entrega4,o.OT_AP_OrdenCompra2Entrega4,
o.OT_AP_HorasPag3Entrega4,o.OT_AP_OrdenCompra3Entrega4,
o.OT_AP_RatingEntrega1,
o.OT_AP_RatingEntrega2,o.OT_AP_RatingEntrega3,o.OT_AP_RatingEntrega4, o.OT_AP_RatingEntregaFinal,
o.OT_Fecha_Asignada_Detalle,o.OT_Fecha_EstDetXAprob
 from #BriefRQLP linksBLP left join #OT2 o
on linksBLP.LP_WorkItemSK=o.LP_WorkItemSK
order by linksBLP.B_Id, linksBLP.LP_Id, o.OT_Id;

DROP TABLE ##Brief;
DROP TABLE ##RQLP;
DROP TABLE ##vFactLinkedCurrentWorkItem;
DROP TABLE ##DimworItem2;
DROP TABLE ##OT;

END





