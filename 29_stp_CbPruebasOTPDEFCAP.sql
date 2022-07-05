USE [ADSReports]
GO
/****** Object:  StoredProcedure [dbo].[stp_CbPruebasOTPDEFCAP]    Script Date: 26/03/2020 7:43:01 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_CbPruebasOTPDEFCAP] 
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
 -----------------------------
--Campos OT 
-----------------------------
DECLARE @FielsOT NVARCHAR(MAX);
 DECLARE @parambrief2 NVARCHAR(100);
 SET @parambrief2=N'@TEAMPROJECTCOLLECTIONGUID NVARCHAR(50)';
 SET @FielsOT=N'
select WorkItemSK as WISKOT
		,System_Id as System_idOT
		,System_Title as System_titleOT
		,System_State as System_StateOT
		,Microsoft_VSTS_Common_Discipline as Disciplina
		,Microsoft_VSTS_Common_ClosedDate as fechaCierreOT
		into ##OT 
  FROM [dbo].[CurrentWorkItemView] AS A
  where System_WorkItemType=''Orden de Trabajo'' 
  AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID';

  EXEC sp_executesql @FielsOT,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;

---------------------------------------------
--Cruce de Workitems
---------------------------------------------
DECLARE @vFactLinkedCurrentWorkItem NVARCHAR(MAX);
 SET @vFactLinkedCurrentWorkItem=N'
select a.SourceWorkItemSK,a.TargetWorkitemSK
into ##vFactLinkedCurrentWorkItem 
from '+@Warehousedb+'.[dbo].[vFactLinkedCurrentWorkItem] as a
group by  a.SourceWorkItemSK,a.TargetWorkitemSK';

EXEC sp_executesql @vFactLinkedCurrentWorkItem;
 ---------------------------------------------
-- Campos Plan de Pruebas
---------------------------------------------
DECLARE @TestPlan NVARCHAR(MAX);
 SET @TestPlan=N'
select  WorkItemSK as WISKPlan
,System_Id as systemidPlan
,System_Title as nombrePlan
,System_State as EstadoPlan
,system_changedBy as modificadoporPlan
,System_ChangedDate  as fechaModificacionPlan
,System_Reason as razonModificacionPlan
,System_AssignedTo as asignadoAPlan
,System_CreatedBy as creadoPorPlan
,System_CreatedDate as fechaCreacionPlan
,substring([AreaPath],2,LEN([AreaPath])-1)as Sistema
,Claro_ALM_TipoPrueba as TipoPrueba
,Claro_ALM_NivelPruebas as NivelPruebas
,Claro_ALM_TipoServicioPruebas as TipoServicioPruebas
,Claro_ALM_TipoValidacion as TipoValidacion
,Claro_ALM_GerenciaSolicitanteUAT as GerenciaSolicitanteUAT
,Claro_ALM_LiderSoporte as LiderSoporte
,Claro_ALM_NumeroCelularSoporte as NumeroCelularSoporte
,Claro_ALM_FechaInicialDespliegue as FechaInicialDespliegue
,Claro_ALM_FechaFinalDespliegue as FechaFinalDespliegue
,Claro_ALM_FechaPlaneadaInicialUAT as FechaPlaneadaInicialUAT
,Claro_ALM_FechaPlaneadaFinalUAT as FechaPlaneadaFinalUAT
,Claro_ALM_TiempoContingencia as TiempoContingencia
,Claro_ALM_FechaRealInicioUAT as FechaRealInicioUAT
,Claro_ALM_FechaRealFinUAT as FechaRealFinUAT
,Claro_ALM_GestorUAT as GestorUAT
,Claro_ALM_NumeroCelularGestor as NumeroCelularGestor
,Claro_ALM_FechaFinPlan as FechaEsperadaFinPrueba
,Claro_ALM_FechaSmokeTest as FechaSmokeTest
,Claro_ALM_SolicitadoFecha as SolicitadoFecha
,Claro_ALM_AmbientePruebas as AmbientePruebas
,Claro_ALM_AnunciadaEntregada as AnunciadaEntregada
,Microsoft_VSTS_CMMI_Blocked as PlanBloqueado
,Claro_ALM_Subsidiaria as Subsidiaria
,Claro_ALM_Garantia as Garantia 
,Claro_ALM_NivelComplejidad as NivelComplejidad
,(SELECT Max(W.Microsoft_VSTS_Common_ClosedDate) FROM '+@Warehousedb+'.[dbo].[DimWorkItem] W 
  where W.System_Id = A.System_Id )as P_Fecha_Plan_Fin
INTO ##Planes 
FROM [dbo].[CurrentWorkItemView] as A
WHERE System_WorkItemType = ''Plan de pruebas'' 
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and System_Title is not null';

EXEC sp_executesql @TestPlan,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
---drop table #Planes

----------------------
-- OT Y Planes
--------------------------
select o.*, link.TargetWorkitemSK
into #OTLinks --DROP TABLE  #OTLinks
from ##OT o left join ##vFactLinkedCurrentWorkItem link
on o.WISKOT=link.SourceWorkItemSK
order by o.System_idOT;

select linksOT.WISKOT, linksOT.System_idOT, linksOT.System_titleOT, linksOT.System_StateOT, linksOT.Disciplina,
linksOT.fechaCierreOT,p.WISKPlan,p.systemidPlan,p.nombrePlan,p.EstadoPlan,
p.modificadoporPlan,p.fechaModificacionPlan,p.razonModificacionPlan,p.asignadoAPlan,p.creadoPorPlan,p.fechaCreacionPlan,p.Sistema,p.TipoPrueba,p.NivelPruebas,
p.TipoServicioPruebas,p.TipoValidacion,p.GerenciaSolicitanteUAT,p.LiderSoporte,p.NumeroCelularSoporte,p.FechaInicialDespliegue,p.FechaFinalDespliegue,
p.FechaPlaneadaInicialUAT,p.FechaPlaneadaFinalUAT,p.TiempoContingencia,p.FechaRealInicioUAT,p.FechaRealFinUAT,p.GestorUAT,p.NumeroCelularGestor,
p.FechaEsperadaFinPrueba,p.FechaSmokeTest,p.SolicitadoFecha,p.AmbientePruebas,p.AnunciadaEntregada,p.PlanBloqueado,p.Subsidiaria,p.Garantia,p.NivelComplejidad,p.P_Fecha_Plan_Fin
into  #OTP --DROP TABLE  #OTP
from #OTLinks linksOT inner join ##Planes p
on linksOT.TargetWorkitemSK=p.WISKPlan
order by linksOT.WISKOT,p.systemidPlan;

--select * from #OTP
---------------------------------------------
-- Campos Defecto
---------------------------------------------
DECLARE @FieldsBug NVARCHAR(MAX);
 SET @FieldsBug=N'
select  WorkItemSK as WISKDefecto
,System_Id as systemidDefecto
,System_Title as nombreDefecto
,System_State as EstadoDefecto
,system_changedBy as modificadoporDefecto
,System_Reason as motivoDefecto
,Microsoft_VSTS_Common_ResolvedReason  as motivoResolucionDefecto
,System_AssignedTo as asignadoADefecto
,System_CreatedBy as creadoPorDefecto
,System_CreatedDate as fechaCreacionDefecto
,Microsoft_VSTS_Common_Priority as PrioridadDefecto
,Microsoft_VSTS_Common_Severity as GravedadDefecto
,Microsoft_VSTS_Common_Triage as EvalErrores
,Microsoft_VSTS_CMMI_Blocked as BloqueadoDefecto
,Claro_ALM_UsuarioReporta as UsuarioReporta
,Claro_ALM_AreaNegocio as AreaNegocio
,Claro_ALM_IM as IM
,Microsoft_VSTS_Common_Discipline as DisciplinaDefecto
,Microsoft_VSTS_CMMI_RootCause as CausaPrincDefecto
,Claro_ALM_CausalDefecto as CausalDefecto
,Claro_ALM_AtribuibleA as AtribuibleA
,Microsoft_VSTS_Scheduling_OriginalEstimate as EstimaOriginDefecto
,Microsoft_VSTS_Scheduling_RemainingWork as TrabajoRestDefecto
,Microsoft_VSTS_Scheduling_CompletedWork as TrabajoCompDefecto
,Microsoft_VSTS_CMMI_HowFound as HowFound
,Microsoft_VSTS_CMMI_FoundInEnvironment as FoundInEnvironment
,Microsoft_VSTS_Build_FoundIn as EncontradoEnDefecto
,Microsoft_VSTS_Build_IntegrationBuild as IntegradoEnDefecto
INTO ##Defecto 
FROM [dbo].[CurrentWorkItemView]
WHERE System_WorkItemType = ''Error'' 
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and System_Title is not null';
EXEC sp_executesql @FieldsBug,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
-------------------------------------------
---------------------------------------------
-- OT, Planes y Defectos
---------------------------------------------
select o.*, link.TargetWorkitemSK
into #OTPLinks --DROP TABLE  #OTPLinks
from #OTP o left join ##vFactLinkedCurrentWorkItem link
on o.WISKPlan=link.SourceWorkItemSK
order by o.System_idOT, o.systemidPlan;

--Select * from #OTPLinks

select linksOTP.WISKOT, linksOTP.System_idOT, linksOTP.System_titleOT, linksOTP.System_StateOT, linksOTP.Disciplina,
linksOTP.fechaCierreOT,linksOTP.WISKPlan,linksOTP.systemidPlan,linksOTP.nombrePlan,
linksOTP.EstadoPlan,linksOTP.modificadoporPlan,linksOTP.fechaModificacionPlan,linksOTP.razonModificacionPlan,linksOTP.asignadoAPlan,linksOTP.creadoPorPlan,
linksOTP.fechaCreacionPlan,linksOTP.Sistema,linksOTP.TipoPrueba,linksOTP.NivelPruebas,linksOTP.TipoServicioPruebas,linksOTP.TipoValidacion,linksOTP.GerenciaSolicitanteUAT,
linksOTP.LiderSoporte,linksOTP.NumeroCelularSoporte,linksOTP.FechaInicialDespliegue,linksOTP.FechaFinalDespliegue,linksOTP.FechaPlaneadaInicialUAT,linksOTP.FechaPlaneadaFinalUAT,
linksOTP.TiempoContingencia,linksOTP.FechaRealInicioUAT,linksOTP.FechaRealFinUAT,linksOTP.GestorUAT,linksOTP.NumeroCelularGestor,linksOTP.FechaEsperadaFinPrueba,
linksOTP.FechaSmokeTest,linksOTP.SolicitadoFecha,linksOTP.AmbientePruebas,linksOTP.AnunciadaEntregada,linksOTP.PlanBloqueado,linksOTP.Subsidiaria,linksOTP.Garantia,
linksOTP.NivelComplejidad,d.WISKDefecto,d.systemidDefecto,d.nombreDefecto,d.EstadoDefecto,d.modificadoporDefecto,d.motivoDefecto,d.motivoResolucionDefecto,d.asignadoADefecto,
d.creadoPorDefecto,d.fechaCreacionDefecto,d.PrioridadDefecto,d.GravedadDefecto,d.EvalErrores,d.BloqueadoDefecto,d.UsuarioReporta,d.AreaNegocio,d.IM,d.DisciplinaDefecto,
d.CausaPrincDefecto,d.CausalDefecto,d.AtribuibleA,d.EstimaOriginDefecto,d.TrabajoRestDefecto,d.TrabajoCompDefecto,d.HowFound,d.FoundInEnvironment,d.EncontradoEnDefecto,
d.IntegradoEnDefecto,linksOTP.P_Fecha_Plan_Fin
into  #OTPDEF --DROP TABLE  #OTPDEF
from #OTPLinks linksOTP inner join ##Defecto d
on linksOTP.TargetWorkitemSK=D.WISKDefecto
order by linksOTP.WISKOT,linksOTP.systemidPlan, D.systemidDefecto;

--Defectos y Defectos2

select d.WISKDefecto,link.TargetWorkitemSK
into #DefLinks --DROP TABLE  ##DefLinks
from ##Defecto d left join ##vFactLinkedCurrentWorkItem link
on d.WISKDefecto=link.SourceWorkItemSK
where link.TargetWorkitemSK in (select distinct d2.WISKDefecto from ##Defecto d2);


---------------------------------------------
-- Campos Casos de prueba
---------------------------------------------
DECLARE @CaseTest NVARCHAR(MAX);
 SET @CaseTest=N'
select  WorkItemSK as WISKCasoPrueba
,System_Id as systemidCasoPrueba
,System_Title as nombreCasoPrueba
,System_State as EstadoCasoPrueba
,system_changedBy as modificadoporCasoPrueba
,System_Reason as motivoCasoPrueba
,System_AssignedTo as asignadoACasoPrueba
,System_CreatedBy as creadoPorCasoPrueba
,System_CreatedDate as fechaCreacionCasoPrueba
,Microsoft_VSTS_Common_Priority as PrioridadCasoPrueba
,Microsoft_VSTS_TCM_AutomationStatus as EstadoAutomatCasoPrueba
,Claro_ALM_Planeado as Planeado
,Claro_ALM_EsTestStandar as EsTestStandar
INTO ##Caso --drop table #Caso
FROM [dbo].[CurrentWorkItemView]
WHERE System_WorkItemType =  ''Caso de Prueba'' 
AND TeamProjectCollectionSK=@TEAMPROJECTCOLLECTIONGUID
and System_Title is not null';

EXEC sp_executesql @CaseTest,@parambrief2,@TEAMPROJECTCOLLECTIONGUID= @TEAMPROJECTCOLLECTIONGUID;
-------------------------------------------
---------------------------------------------
-- OT, Planes y Defectos, Planes y Casos de PRueba
---------------------------------------------
select o.*, link.TargetWorkitemSK
into #OTPDEFLinks --DROP TABLE  #OTPLinks
from #OTPDEF o inner join ##vFactLinkedCurrentWorkItem link
on o.WISKPlan=link.SourceWorkItemSK
order by o.System_idOT, o.systemidPlan, o.systemidDefecto

-----------------------
--final
--------------------------
truncate table [tbl_CbPruebas_OTPDEFCAP];
INSERT INTO [dbo].[tbl_CbPruebas_OTPDEFCAP]
([O_WorkItemSK],[O_Id],[O_Titulo],[O_Estado],[O_Disciplina],[O_FechaCierre],
 [P_WorkItemSK],[P_Id],[P_Titulo],[P_Estado],[P_ModificadoPor],[P_FechaModificacion],[P_Motivo],
 [P_AsignadoA],[P_CreadoPor],[P_FechaCreacion],[P_Sistema],[P_TipoPrueba],[P_NivelPrueba],[P_TipoServicioPrueba],[P_TipoValidacion],[P_GerenciaSolicitanteUAT],
 [P_LiderSoporte],[P_NumeroCelularSoporte],[P_FechaInicialDespliegue],[P_FechaFinalDespliegue],[P_FechaPlaneadaInicialUAT],[P_FechaPlaneadaFinalUAT],[P_TiempoContingencia],
 [P_FechaRealInicioUAT],[P_FechaRealFinUAT],[P_GestorUAT],[P_NumeroCelularGestor],[P_FechaEsperadaFinPrueba],[P_FechaSmokeTest],[P_SolicitadoFecha],[P_AmbientePruebas],
 [P_AnunciadaEntregada],[P_Bloqueado],[P_Subsidiaria],[P_Garantia],[P_NivelComplejidad],[DEF_WorkItemSK],[DEF_Id],[DEF_Estado],[DEF_Titulo],[DEF_ModificadoPor],
 [DEF_Motivo],[DEF_motivoResolucion],[DEF_AsignadoA],[DEF_CreadoPor],[DEF_FechaCreacion],[DEF_Prioridad],[DEF_Gravedad],[DEF_Evaluacion],[DEF_Bloqueado],[DEF_UsuarioReporta],
 [DEF_AreaNegocio],[DEF_IM],[DEF_Disciplina],[DEF_CausaPrincipal],[DEF_Causal],[DEF_AtribuibleA],[DEF_EstimOriginal],[DEF_TrabajoRestante],[DEF_TrabajoCompletado],[DEF_ComoSeEncontro],
 [DEF_EncontradoEnEntorno],[DEF_EncontradoEn],[DEF_IntegradoEn],[CAP_WorkItemSK],[CAP_Id],[CAP_Titulo],[CAP_Estado],[CAP_ModificadoPor],[CAP_Motivo],
 [CAP_AsignadoA],[CAP_CreadoPor],[CAP_FechaCreacion],[CAP_Prioridad],[CAP_EstadoAutomatizacion],[CAP_Planeado],[CAP_EsTestStandar],[P_Fecha_Plan_Fin])
select distinct linksOTPDEF.WISKOT, linksOTPDEF.System_idOT, linksOTPDEF.System_titleOT, linksOTPDEF.System_StateOT, 
linksOTPDEF.Disciplina,linksOTPDEF.fechaCierreOT,linksOTPDEF.WISKPlan,linksOTPDEF.systemidPlan,linksOTPDEF.nombrePlan,
linksOTPDEF.EstadoPlan,linksOTPDEF.modificadoporPlan,linksOTPDEF.fechaModificacionPlan,linksOTPDEF.razonModificacionPlan,linksOTPDEF.asignadoAPlan,linksOTPDEF.creadoPorPlan,
linksOTPDEF.fechaCreacionPlan,linksOTPDEF.Sistema,linksOTPDEF.TipoPrueba,linksOTPDEF.NivelPruebas,linksOTPDEF.TipoServicioPruebas,linksOTPDEF.TipoValidacion,linksOTPDEF.GerenciaSolicitanteUAT,
linksOTPDEF.LiderSoporte,linksOTPDEF.NumeroCelularSoporte,linksOTPDEF.FechaInicialDespliegue,linksOTPDEF.FechaFinalDespliegue,linksOTPDEF.FechaPlaneadaInicialUAT,linksOTPDEF.FechaPlaneadaFinalUAT,
linksOTPDEF.TiempoContingencia,linksOTPDEF.FechaRealInicioUAT,linksOTPDEF.FechaRealFinUAT,linksOTPDEF.GestorUAT,linksOTPDEF.NumeroCelularGestor,linksOTPDEF.FechaEsperadaFinPrueba,
linksOTPDEF.FechaSmokeTest,linksOTPDEF.SolicitadoFecha,linksOTPDEF.AmbientePruebas,linksOTPDEF.AnunciadaEntregada,linksOTPDEF.PlanBloqueado,linksOTPDEF.Subsidiaria,linksOTPDEF.Garantia,
linksOTPDEF.NivelComplejidad,linksOTPDEF.WISKDefecto, linksOTPDEF.systemidDefecto,linksOTPDEF.EstadoDefecto,linksOTPDEF.nombreDefecto,linksOTPDEF.modificadoporDefecto,linksOTPDEF.motivoDefecto,
linksOTPDEF.motivoResolucionDefecto,linksOTPDEF.asignadoADefecto,
linksOTPDEF.creadoPorDefecto,linksOTPDEF.fechaCreacionDefecto,linksOTPDEF.PrioridadDefecto,linksOTPDEF.GravedadDefecto,linksOTPDEF.EvalErrores,linksOTPDEF.BloqueadoDefecto,
linksOTPDEF.UsuarioReporta,linksOTPDEF.AreaNegocio,
linksOTPDEF.IM,linksOTPDEF.DisciplinaDefecto,
linksOTPDEF.CausaPrincDefecto,linksOTPDEF.CausalDefecto,linksOTPDEF.AtribuibleA,linksOTPDEF.EstimaOriginDefecto,linksOTPDEF.TrabajoRestDefecto,linksOTPDEF.TrabajoCompDefecto,
linksOTPDEF.HowFound,linksOTPDEF.FoundInEnvironment,linksOTPDEF.EncontradoEnDefecto,
linksOTPDEF.IntegradoEnDefecto,c.WISKCasoPrueba,c.systemidCasoPrueba,c.nombreCasoPrueba,c.EstadoCasoPrueba,c.modificadoporCasoPrueba,c.motivoCasoPrueba,
c.asignadoACasoPrueba,c.creadoPorCasoPrueba,c.fechaCreacionCasoPrueba,c.PrioridadCasoPrueba,c.EstadoAutomatCasoPrueba,c.Planeado,c.EsTestStandar,linksOTPDEF.P_Fecha_Plan_Fin
from #OTPDEFLinks linksOTPDEF inner join ##Caso c
on linksOTPDEF.TargetWorkitemSK=c.WISKCasoPrueba
order by linksOTPDEF.WISKOT,linksOTPDEF.systemidPlan, c.systemidCasoPrueba

--Actualiza defecto vinculado
Update [tbl_CbPruebas_OTPDEFCAP] 
set [DEF_EncontradoEn]=dl.TargetWorkitemSK
from [tbl_CbPruebas_OTPDEFCAP] otpdc left join #DefLinks dl on otpdc.DEF_WorkItemSK=dl.WISKDefecto
where not otpdc.DEF_Id is null

Update [tbl_CbPruebas_OTPDEFCAP] 
set [DEF_EncontradoEn]=f.systemidDefecto
from [tbl_CbPruebas_OTPDEFCAP] otpdc left join ##Defecto f on otpdc.DEF_EncontradoEn=f.WISKDefecto
where not otpdc.DEF_EncontradoEn is null

DROP TABLE ##OT;
DROP TABLE ##vFactLinkedCurrentWorkItem;
DROP TABLE ##Planes;
DROP TABLE ##Defecto;
DROP TABLE ##Caso;

END






