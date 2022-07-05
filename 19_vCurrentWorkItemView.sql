USE [ADSReports]
GO

/****** Object:  View [dbo].[CurrentWorkItemView]    Script Date: 26/03/2020 7:38:18 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


    CREATE VIEW [dbo].[CurrentWorkItemView]
    AS
    SELECT   [FactCurrentWorkItem].[CurrentWorkItemBK]
            ,[FactCurrentWorkItem].[LastUpdatedDateTime]
            ,[FactCurrentWorkItem].[Microsoft_VSTS_Common_BusinessValue],
			 [FactCurrentWorkItem].[Microsoft_VSTS_Scheduling_Effort],
			 [FactCurrentWorkItem].[Microsoft_VSTS_Scheduling_Size],
			 [FactCurrentWorkItem].[Microsoft_VSTS_Scheduling_OriginalEstimate],
			 [FactCurrentWorkItem].[Microsoft_VSTS_Scheduling_RemainingWork],
			 [FactCurrentWorkItem].[Microsoft_VSTS_Scheduling_CompletedWork],
			 [FactCurrentWorkItem].[Microsoft_VSTS_Scheduling_StoryPoints]
            ,[DimWorkItem].[WorkItemSK]
            ,[DimWorkItem].[System_WorkItemType] + ' ' + CAST([DimWorkItem].[System_Id] AS NVARCHAR(256)) + ' ' + [DimWorkItem].[System_Title] AS [WorkItem]
            ,[DimWorkItem].[PreviousState]
            ,[DimWorkItem].[TeamProjectCollectionSK]
            ,[DimWorkItem].[System_RevisedDate],
			[DimWorkItem].[System_ChangedDate],
			[DimWorkItem].[System_Id],
			[DimWorkItem].[System_Title],
			[DimWorkItem].[System_State],
			[DimWorkItem].[System_Rev]
             ,[DimPerson_System_ChangedBy].[Name] AS [System_ChangedBy]
             ,[DimWorkItem].[System_Reason]
                            ,[DimPerson_System_AssignedTo].[Name] AS [System_AssignedTo]
                        ,[DimWorkItem].[System_WorkItemType],
						[DimWorkItem].[System_CreatedDate]
                            ,[DimPerson_System_CreatedBy].[Name] AS [System_CreatedBy]
                        ,[DimWorkItem].[System_BoardColumn],
						[DimWorkItem].[System_BoardColumnDone],
						[DimWorkItem].[System_BoardLane],
						[DimWorkItem].[Microsoft_VSTS_Common_ActivatedDate]
                            ,[DimPerson_Microsoft_VSTS_Common_ActivatedBy].[Name] AS [Microsoft_VSTS_Common_ActivatedBy]
                        ,[DimWorkItem].[Microsoft_VSTS_Common_ResolvedDate]
                            ,[DimPerson_Microsoft_VSTS_Common_ResolvedBy].[Name] AS [Microsoft_VSTS_Common_ResolvedBy]
                        ,[DimWorkItem].[Microsoft_VSTS_Common_ResolvedReason],
						[DimWorkItem].[Microsoft_VSTS_Common_ClosedDate]
                            ,[DimPerson_Microsoft_VSTS_Common_ClosedBy].[Name] AS [Microsoft_VSTS_Common_ClosedBy]
                        ,[DimWorkItem].[Microsoft_VSTS_Common_Priority],
						[DimWorkItem].[Microsoft_VSTS_Common_Triage],
						[DimWorkItem].[Microsoft_VSTS_Common_StackRank],
						[DimWorkItem].[Microsoft_VSTS_Scheduling_TargetDate],
						[DimWorkItem].[Microsoft_VSTS_Build_IntegrationBuild],
						[DimWorkItem].[Claro_ALM_Consecutivo123MIC]
						,'' [Claro_ALM_Operacion]
						,[DimWorkItem].[Claro_ALM_Clasificacion],
						[DimWorkItem].[Claro_ALM_Estrategia],
						[DimWorkItem].[Claro_ALM_LineaProducto]
						,'' as [Claro_ALM_NaturalezaCambio]
						,[DimWorkItem].[Claro_ALM_GerenciaSolicitante]
                            ,[DimPerson_Claro_ALM_GerenteSolicitante].[Name] AS [Claro_ALM_GerenteSolicitante]
                        ,[DimWorkItem].[Claro_ALM_AutorizacionGerencia],
						[DimWorkItem].[Claro_ALM_AreaNegocio],
						[DimWorkItem].[Claro_ALM_Segmento]
                            ,[DimPerson_Claro_ALM_DirectorSolicitante].[Name] AS [Claro_ALM_DirectorSolicitante]
                        ,[DimWorkItem].[Claro_ALM_AutorizacionDireccion]
                            ,[DimPerson_Claro_ALM_LiderBrief].[Name] AS [Claro_ALM_LiderBrief]
                       -- ,[dbo].[DimWorkItem].[Claro_ALM_AnalistaRequerimientos]
                            ,[DimPerson_Claro_ALM_ResponsableNegocio].[Name] AS [Claro_ALM_ResponsableNegocio]
                        ,[DimWorkItem].[Claro_ALM_PAI],
						[DimWorkItem].[Claro_ALM_ParticipaArquitectura],
						[DimWorkItem].[Claro_ALM_Complejidad],
						[DimWorkItem].[Claro_ALM_RequiereReportes],
						[DimWorkItem].[Claro_ALM_TipoBeneficio],
					[DimWorkItem].[Claro_ALM_BeneficioResolucion]
						,'' as [Claro_ALM_FechaInicioRequerimientos]
						,[DimWorkItem].[Claro_ALM_FechaAprobacionPortafolio],
						[DimWorkItem].[Claro_ALM_FechaAprobacionJunta],
						[DimWorkItem].[Claro_ALM_CategoriaRiesgo],
						[DimWorkItem].[Claro_ALM_CargoAutorizadorRiesgo]
                            ,[DimPerson_Claro_ALM_UsuarioAutorizacionRiesgo].[Name] AS [Claro_ALM_UsuarioAutorizacionRiesgo]
                        ,[DimWorkItem].[Claro_ALM_AutorizacionRiesgo],
						[DimWorkItem].[Claro_ALM_AfectaSistemaFinanciero],
						[DimWorkItem].[Claro_ALM_CargoSistemaFinanciero]
                            ,[DimPerson_Claro_ALM_UsuarioAutorizacionSistemaFinanciero].[Name] AS [Claro_ALM_UsuarioAutorizacionSistemaFinanciero]
                        ,[DimWorkItem].[Claro_ALM_AutorizacionSistemaFinanciero]
                            ,[DimPerson_Claro_ALM_RadicadoPor].[Name] AS [Claro_ALM_RadicadoPor]
                        ,[DimWorkItem].[Claro_ALM_FechaRadicado]
                            ,[DimPerson_Claro_ALM_FactiblePor].[Name] AS [Claro_ALM_FactiblePor]
                        ,[DimWorkItem].[Claro_ALM_FechaFactible]
                            ,[DimPerson_Claro_ALM_FSPBasePor].[Name] AS [Claro_ALM_FSPBasePor]
                        ,[DimWorkItem].[Claro_ALM_FechaFSPBase]
                            ,[DimPerson_Claro_ALM_FSPCerradoPor].[Name] AS [Claro_ALM_FSPCerradoPor]
                        ,[DimWorkItem].[Claro_ALM_FechaFSPCerrado]
                            ,[DimPerson_Claro_ALM_EstimadoPor].[Name] AS [Claro_ALM_EstimadoPor]
                        ,[DimWorkItem].[Claro_ALM_FechaEstimado]
                            ,[DimPerson_Claro_ALM_AprobadoJuntaPor].[Name] AS [Claro_ALM_AprobadoJuntaPor]
                        ,[DimWorkItem].[Claro_ALM_FechaAprobadoJunta],
						[DimWorkItem].[Microsoft_VSTS_CMMI_Blocked],
						[DimWorkItem].[Microsoft_VSTS_Scheduling_StartDate],
						[DimWorkItem].[Microsoft_VSTS_Scheduling_FinishDate],
						[DimWorkItem].[Microsoft_VSTS_CMMI_RequirementType]
                            ,[DimPerson_Claro_ALM_LiderLineaProducto].[Name] AS [Claro_ALM_LiderLineaProducto]
                        ,[DimWorkItem].[Claro_ALM_PrioridadEnBrief],
						[DimWorkItem].[Claro_ALM_FechaDespliegue],
						[DimWorkItem].[Claro_ALM_EstadoDespliegue],
						[DimWorkItem].[Claro_ALM_FechaPlaneadaDespliegue],
						[DimWorkItem].[Claro_ALM_AutorizacionResponsableNegocio],
						[DimWorkItem].[Claro_ALM_AutorizacionLiderLinea],
						[DimWorkItem].[Claro_ALM_GerenciaDesarrollo]
						,'' as [Claro_ALM_AsignadoBrief]
						,'' as [Claro_ALM_AutorizacionAsignadoBrief]
                            ,[DimPerson_Claro_ALM_AnalizadoPor].[Name] AS [Claro_ALM_AnalizadoPor]
                        ,[DimWorkItem].[Claro_ALM_FechaAnalizado]
                            ,[DimPerson_Claro_ALM_AprobadoPor].[Name] AS [Claro_ALM_AprobadoPor]
                        ,[DimWorkItem].[Claro_ALM_FechaAprobado],
						[DimWorkItem].[Microsoft_VSTS_Common_Rating],
						[DimWorkItem].[Microsoft_VSTS_Common_Discipline],
						[DimWorkItem].[Microsoft_VSTS_CMMI_TaskType],
						[DimWorkItem].[Claro_ALM_Desfase_Causal],
						[DimWorkItem].[Claro_ALM_Desfase_Ambiente],
						[DimWorkItem].[Claro_ALM_Desfase_CausalAmbiente]
						,'' as [Claro_ALM_Planeacion_HorasOptimistas]
						,'' as [Claro_ALM_Planeacion_HorasPesimistas]
						,'' as [Claro_ALM_Planeacion_HorasPlaneadas]
						,'' as [Claro_ALM_Planeacion_HorasClaro]
						,'' as [Claro_ALM_Planeacion_HorasAcordadas]
						,'' as [Claro_ALM_Planeacion_Dias]
						,'' as [Claro_ALM_Planeacion_FechaInicial]
						,'' as [Claro_ALM_Planeacion_FechaFinal]
						,'' as [Claro_ALM_Planeacion_FechaFinalOptimista]
						,'' as [Claro_ALM_Planeacion_FechaFinalPesimista]
						,'' as [Claro_ALM_Planeacion_FechaInicialReal]
						,'' as [Claro_ALM_Planeacion_FechaFinalReal],
						[DimWorkItem].[Claro_ALM_CantidadAnalistas]
						,'' as [Claro_ALM_TallaEntrega],
						[DimWorkItem].[Claro_ALM_FechaEntrega1],
						[DimWorkItem].[Claro_ALM_FechaRecepcion1]
						,'' as [Claro_ALM_Entrega1Valida]
						,'' as [Claro_ALM_FechaEntrega1Valida]
						,'' as [Claro_ALM_Entrega1Pagada]
						,'' as [Claro_ALM_FechaEntrega1Pagada],
						[DimWorkItem].[Claro_ALM_FechaEntrega2],
						[DimWorkItem].[Claro_ALM_FechaRecepcion2]
						,'' as [Claro_ALM_Entrega2Valida]
						,'' as [Claro_ALM_FechaEntrega2Valida]
						,'' as [Claro_ALM_Entrega2Pagada]
						,'' as [Claro_ALM_FechaEntrega2Pagada],
						[DimWorkItem].[Claro_ALM_FechaEntrega3],
						[DimWorkItem].[Claro_ALM_FechaRecepcion3]
						,'' as [Claro_ALM_Entrega3Valida]
						,'' as [Claro_ALM_FechaEntrega3Valida]
						,'' as [Claro_ALM_Entrega3Pagada]
						,'' as [Claro_ALM_FechaEntrega3Pagada],
						[DimWorkItem].[Claro_ALM_FechaRecepcion4],
						[DimWorkItem].[Claro_ALM_FechaEntrega4]
						,'' as [Claro_ALM_Entrega4Valida]
						,'' as [Claro_ALM_FechaEntrega4Valida]
						,'' as [Claro_ALM_Entrega4Pagada]
						,'' as [Claro_ALM_FechaEntrega4Pagada]
						,'' as [Claro_ALM_OrdenCompra]
						,'' as [Claro_ALM_TipoTrabajo],
						[DimWorkItem].[Microsoft_VSTS_Common_Severity],
						[DimWorkItem].[Claro_ALM_CausalProblema],
						[DimWorkItem].[Microsoft_VSTS_Build_FoundIn],
						[DimWorkItem].[Microsoft_VSTS_CMMI_Probability]
						,'' as [Claro_ALM_NumeroContratoSAP]
						,'' as [Claro_ALM_ValorContrato]
						,'' as [Claro_ALM_HorasContrato]
						,'' as [Claro_ALM_ProveedorContrato],
						[DimWorkItem].[Microsoft_VSTS_CMMI_FoundInEnvironment],
						[DimWorkItem].[Microsoft_VSTS_CMMI_RootCause],
						[DimWorkItem].[Microsoft_VSTS_CMMI_HowFound],
						[DimWorkItem].[Claro_ALM_CausalDefecto],
						[DimWorkItem].[Microsoft_VSTS_CodeReview_ClosedStatus],
						[DimWorkItem].[Microsoft_VSTS_CodeReview_AcceptedDate]
                            ,[DimPerson_Microsoft_VSTS_CodeReview_AcceptedBy].[Name] AS [Microsoft_VSTS_CodeReview_AcceptedBy]
                        ,[DimWorkItem].[Microsoft_VSTS_TCM_AutomationStatus],
						[DimWorkItem].[Claro_ALM_Planeado],
						[DimWorkItem].[Claro_ALM_EsTestStandar],
						[DimWorkItem].[Claro_ALM_TipoPrueba],
						[DimWorkItem].[Claro_ALM_Garantia],
						[DimWorkItem].[Claro_ALM_AnunciadaEntregada],
						[DimWorkItem].[Claro_ALM_CentroCosto],
						[DimWorkItem].[Claro_ALM_FechaSmokeTest],
						[DimWorkItem].[Claro_ALM_NivelComplejidad],
						[DimWorkItem].[Claro_ALM_NivelPruebas],
						[DimWorkItem].[Claro_ALM_TipoServicioPruebas],
						[DimWorkItem].[Claro_ALM_AmbientePruebas],
						[DimWorkItem].[Claro_ALM_PlaneadoFecha]
                            ,[DimPerson_Claro_ALM_PlaneadoPor].[Name] AS [Claro_ALM_PlaneadoPor]
                        ,[DimWorkItem].[Claro_ALM_DisenadoFecha]
                            ,[DimPerson_Claro_ALM_DisenadoPor].[Name] AS [Claro_ALM_DisenadoPor]
                        ,[DimWorkItem].[Claro_ALM_EjecutadoFecha]
                            ,[DimPerson_Claro_ALM_EjecutadoPor].[Name] AS [Claro_ALM_EjecutadoPor]
                        ,'' as [Claro_ALM_FinalizadoFecha]
						,'' as [Claro_ALM_FinalizadoPor]
						,'' as [Claro_ALM_CanceladoFecha]
						,'' as [Claro_ALM_CanceladoPor]
						,[DimWorkItem].[Claro_ALM_FechaInicialDespliegue],
						[DimWorkItem].[Claro_ALM_FechaFinalDespliegue],
						[DimWorkItem].[Claro_ALM_FechaPlaneadaInicialUAT],
						[DimWorkItem].[Claro_ALM_FechaPlaneadaFinalUAT]
                            ,'' AS [Claro_ALM_LiderSoporte]
                        ,'' as [Claro_ALM_Contacto]
						,[DimWorkItem].[Claro_ALM_GerenciaSolicitanteUAT],
						[DimWorkItem].[Claro_ALM_TiempoContingencia],
						[DimWorkItem].[Microsoft_VSTS_TCM_TestSuiteType],
						[DimWorkItem].[Microsoft_VSTS_Common_Issue],
						[DimWorkItem].[Claro_ALM_TipoRequerimiento],
						[DimWorkItem].[Claro_ALM_TipoRequerimientoFuncional],
						[DimWorkItem].[Claro_ALM_TipoModificacionReqFuncional],
						[DimWorkItem].[Claro_ALM_TipoRequerimientoNoFuncional],
						[DimWorkItem].[Claro_ALM_AutorizacionLiderSistema],
						[DimWorkItem].[Claro_ALM_CentroCostoDesarrollo],
						[DimWorkItem].[Claro_ALM_NumeroBrief]
						,'' as [Claro_ALM_DireccionSolicitante]
						,'' as [Claro_ALM_FechaComiteGestionDemanda]
						,'' as [Claro_ALM_FechaComiteOperativo]
						,'' as [Claro_ALM_FechaComiteEjecutivo]
						,'' as [Claro_ALM_ValidadoPor]
						,'' as [Claro_ALM_FechaValidado]
                            ,[DimPerson_Claro_ALM_GestorPortafolio].[Name] AS [Claro_ALM_GestorPortafolio]
                        ,'' as [Claro_ALM_AutorizacionGestorPortafolio]
						,[DimWorkItem].[Claro_ALM_TipoValidacion]
						,'' as [Claro_ALM_ValorTotalContrato]
                            ,[DimPerson_Claro_ALM_PMO].[Name] AS [Claro_ALM_PMO]
                        ,[DimWorkItem].[Claro_ALM_CerradoIT]
                            ,[DimPerson_Claro_ALM_UsuarioReporta].[Name] AS [Claro_ALM_UsuarioReporta]
                        ,[DimWorkItem].[Claro_ALM_IM],
						[DimWorkItem].[Claro_ALM_FechaIniPlan],
						[DimWorkItem].[Claro_ALM_FechaFinPlan]
						,'' as [Claro_ALM_CalificacionEntrega1]
						,'' as [Claro_ALM_CalificacionEntrega2]
						,'' as [Claro_ALM_CalificacionEntrega3]
						,'' as [Claro_ALM_CalificacionEntrega4],
						[DimWorkItem].[Claro_ALM_CantidadReclamos],
						[DimWorkItem].[Claro_ALM_Fase]
						,'' as [Claro_ALM_Planeacion_DiasOptimistas]
						,'' as [Claro_ALM_Planeacion_DiasPesimistas]
						,'' as [Claro_ALM_Tarea_HorasClaro]
						,'' as [Claro_ALM_Tarea_HorasAcordadas]
						,'' as [Claro_ALM_Tarea_HorasPlaneadas]
						,'' as [Claro_ALM_Tarea_HorasOptimistas]
						,'' as [Claro_ALM_Tarea_HorasPesimistasPlaneacion]
						,'' as [Claro_ALM_Tarea_HorasPesimistasDiseno]
						,'' as [Claro_ALM_Tarea_HorasPesimistasEjecucion]
						,'' as [Claro_ALM_Tarea_HorasPesimistasCierre]
						,'' as [Claro_ALM_Incertidumbre]
                            ,[DimPerson_Claro_ALM_SolicitanteRequerimiento].[Name] AS [Claro_ALM_SolicitanteRequerimiento]

                            ,[DimPerson_Claro_ALM_Arquitecto].[Name] AS [Claro_ALM_Arquitecto]

                            ,[DimPerson_Claro_ALM_AnalistaNegocio].[Name] AS [Claro_ALM_AnalistaNegocio]
                        ,[DimWorkItem].[Claro_ALM_ValorHora],
						[DimWorkItem].[Claro_ALM_FechaInicio],
						[DimWorkItem].[Claro_ALM_FechaFin],
						[DimWorkItem].[Claro_ALM_TipoContrato],
						[DimWorkItem].[Claro_ALM_Proveedor],
						[DimWorkItem].[Claro_ALM_NumeroSAP],
						[DimWorkItem].[Claro_ALM_NumeroSAPContratoMarco],
						[DimWorkItem].[Claro_ALM_Proyecto],
						[DimWorkItem].[Claro_ALM_TipoOT],
						[DimWorkItem].[Claro_ALM_Gerencia],
						[DimWorkItem].[Claro_ALM_HorasPlaneadas],
						[DimWorkItem].[Claro_ALM_Dias],
						[DimWorkItem].[Claro_ALM_TallaAltoNivel],
						[DimWorkItem].[Claro_ALM_HorasClaro],
						[DimWorkItem].[Claro_ALM_HorasProveedor],
						[DimWorkItem].[Claro_ALM_HorasAcordadas],
						[DimWorkItem].[Claro_ALM_TallaDetalle],
						[DimWorkItem].[Claro_ALM_PorcentajeIncertidumbre],
						[DimWorkItem].[Claro_ALM_TrabajoEfectivo],
						[DimWorkItem].[Claro_ALM_HorasOptimistas],
						[DimWorkItem].[Claro_ALM_DiasOptimistas],
						[DimWorkItem].[Claro_ALM_FechaFinOptimista],
						[DimWorkItem].[Claro_ALM_HorasPesimistasPlaneacion],
						[DimWorkItem].[Claro_ALM_HorasPesimistasDiseno],
						[DimWorkItem].[Claro_ALM_HorasPesimistasEjecucion],
						[DimWorkItem].[Claro_ALM_HorasPesimistasCierre],
						[DimWorkItem].[Claro_ALM_DiasPesimistas],
						[DimWorkItem].[Claro_ALM_FacturableEntrega1],
						[DimWorkItem].[Claro_ALM_PagadaEntrega1],
						[DimWorkItem].[Claro_ALM_HorasPagadas1Entrega1],
						[DimWorkItem].[Claro_ALM_HorasPagadas2Entrega1],
						[DimWorkItem].[Claro_ALM_HorasPagadas3Entrega1]
						,'' as [Claro_ALM_IDContrato1Entrega1]
						,'' as [Claro_ALM_IDContrato2Entrega1]
						,'' as [Claro_ALM_IDContrato3Entrega1],
						[DimWorkItem].[Claro_ALM_FacturableEntrega2],
						[DimWorkItem].[Claro_ALM_PagadaEntrega2],
						[DimWorkItem].[Claro_ALM_HorasPagadas1Entrega2],
						[DimWorkItem].[Claro_ALM_HorasPagadas2Entrega2],
						[DimWorkItem].[Claro_ALM_HorasPagadas3Entrega2]
						,'' as [Claro_ALM_IDContrato1Entrega2]
						,'' as [Claro_ALM_IDContrato2Entrega2]
						,'' as [Claro_ALM_IDContrato3Entrega2],
						[DimWorkItem].[Claro_ALM_FacturableEntrega3],
						[DimWorkItem].[Claro_ALM_PagadaEntrega3],
						[DimWorkItem].[Claro_ALM_HorasPagadas1Entrega3],
						[DimWorkItem].[Claro_ALM_HorasPagadas2Entrega3],
						[DimWorkItem].[Claro_ALM_HorasPagadas3Entrega3]
						,'' as [Claro_ALM_IDContrato1Entrega3]
						,'' as [Claro_ALM_IDContrato2Entrega3]
						,'' as [Claro_ALM_IDContrato3Entrega3],
						[DimWorkItem].[Claro_ALM_FacturableEntrega4],
						[DimWorkItem].[Claro_ALM_PagadaEntrega4],
						[DimWorkItem].[Claro_ALM_HorasPagadas1Entrega4],
						[DimWorkItem].[Claro_ALM_HorasPagadas2Entrega4],
						[DimWorkItem].[Claro_ALM_HorasPagadas3Entrega4]
						,'' as [Claro_ALM_IDContrato1Entrega4]
						,'' as [Claro_ALM_IDContrato2Entrega4]
						,'' as [Claro_ALM_IDContrato3Entrega4],
						[DimWorkItem].[Claro_ALM_AsignadaAltoNivelFecha]
                            ,[DimPerson_Claro_ALM_AsignadaAltoNivelPor].[Name] AS [Claro_ALM_AsignadaAltoNivelPor]
                        ,[DimWorkItem].[Claro_ALM_EstimadaFecha]
                            ,[DimPerson_Claro_ALM_EstimadaPor].[Name] AS [Claro_ALM_EstimadaPor]
                        ,[DimWorkItem].[Claro_ALM_AsignadaDetalleFecha]
                            ,[DimPerson_Claro_ALM_AsignadaDetallePor].[Name] AS [Claro_ALM_AsignadaDetallePor]
                        ,[DimWorkItem].[Claro_ALM_AprobadaFecha]
                            ,[DimPerson_Claro_ALM_AprobadaPor].[Name] AS [Claro_ALM_AprobadaPor]
                        ,[DimWorkItem].[Claro_ALM_NumeroPRY]
                            ,'' AS [Claro_ALM_GestorUAT]
                        ,[DimWorkItem].[Claro_ALM_NumeroCelularGestor],
						[DimWorkItem].[Claro_ALM_FechaRealInicioUAT],
						[DimWorkItem].[Claro_ALM_FechaRealFinUAT],
						[DimWorkItem].[Claro_ALM_NumeroCelularSoporte],
						[DimWorkItem].[Claro_ALM_RatingEntrega1],
						[DimWorkItem].[Claro_ALM_RatingEntrega2],
						[DimWorkItem].[Claro_ALM_RatingEntrega3],
						[DimWorkItem].[Claro_ALM_RatingEntrega4],
						[DimWorkItem].[Claro_ALM_AtribuibleA],
						[DimWorkItem].[Claro_ALM_ClasePresupuesto],
						[DimWorkItem].[Claro_ALM_OrdenCompra1Entrega1],
						[DimWorkItem].[Claro_ALM_OrdenCompra2Entrega1],
						[DimWorkItem].[Claro_ALM_OrdenCompra3Entrega1],
						[DimWorkItem].[Claro_ALM_OrdenCompra1Entrega2],
						[DimWorkItem].[Claro_ALM_OrdenCompra2Entrega2],
						[DimWorkItem].[Claro_ALM_OrdenCompra3Entrega2],
						[DimWorkItem].[Claro_ALM_OrdenCompra1Entrega3],
						[DimWorkItem].[Claro_ALM_OrdenCompra2Entrega3],
						[DimWorkItem].[Claro_ALM_OrdenCompra3Entrega3],
						[DimWorkItem].[Claro_ALM_OrdenCompra1Entrega4],
						[DimWorkItem].[Claro_ALM_OrdenCompra2Entrega4],
						[DimWorkItem].[Claro_ALM_OrdenCompra3Entrega4],
						[DimWorkItem].[Claro_ALM_RecibirEntrega1],
						[DimWorkItem].[Claro_ALM_RecibirEntrega2],
						[DimWorkItem].[Claro_ALM_RecibirEntrega3],
						[DimWorkItem].[Claro_ALM_RecibirEntrega4],
						[DimWorkItem].[Claro_ALM_RatingEntregaFinal],
						[DimWorkItem].[Claro_ALM_FinalizadaFecha]
                            ,[DimPerson_Claro_ALM_FinalizadaPor].[Name] AS [Claro_ALM_FinalizadaPor]
                        ,[DimWorkItem].[Claro_ALM_SolicitadoFecha]
                            ,[DimPerson_Claro_ALM_SolicitadoPor].[Name] AS [Claro_ALM_SolicitadoPor]
                        ,[DimWorkItem].[Claro_ALM_Subsidiaria],
						[DimWorkItem].[Claro_ALM_NumeroHorasContrato],
						[DimWorkItem].[Microsoft_VSTS_Common_Activity],
						[DimWorkItem].[Microsoft_VSTS_Common_Risk],
						[DimWorkItem].[Microsoft_VSTS_Scheduling_DueDate],
					    '' AS [Claro_ALM_LiderLinea],
						[DimWorkItem].[Microsoft_VSTS_Common_BacklogPriority],
						[DimWorkItem].[System_IsDeleted]
                            ,[DimPerson_Microsoft_VSTS_Common_ReviewedBy].[Name] AS [Microsoft_VSTS_Common_ReviewedBy]
                        ,[DimWorkItem].[Claro_ALM_TotalFases],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase],
						[DimWorkItem].[Claro_ALM_UnidadNegocio],
						[DimWorkItem].[Claro_ALM_RequiereCasoNegocio],
						[DimWorkItem].[Claro_ALM_Costo],
						[DimWorkItem].[Claro_ALM_Ahorro],
						[DimWorkItem].[Claro_ALM_TiempoRetorno],
						[DimWorkItem].[Claro_ALM_NumeroFase1],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase1],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase1],
						[DimWorkItem].[Claro_ALM_EstadoFase1],
						[DimWorkItem].[Claro_ALM_NumeroFase2],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase2],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase2],
						[DimWorkItem].[Claro_ALM_EstadoFase2],
						[DimWorkItem].[Claro_ALM_NumeroFase3],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase3],
					    [DimWorkItem].[Claro_ALM_FechaDespliegueRealFase3],
						[DimWorkItem].[Claro_ALM_EstadoFase3],
						[DimWorkItem].[Claro_ALM_NumeroFase4],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase4],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase4],
						[DimWorkItem].[Claro_ALM_EstadoFase4],
						[DimWorkItem].[Claro_ALM_NumeroFase5],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase5],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase5],
						[DimWorkItem].[Claro_ALM_EstadoFase5],
						[DimWorkItem].[Claro_ALM_NumeroFase6],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase6],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase6],
						[DimWorkItem].[Claro_ALM_EstadoFase6],
						[DimWorkItem].[Claro_ALM_NumeroFase7],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase7],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase7],
						[DimWorkItem].[Claro_ALM_EstadoFase7],
						[DimWorkItem].[Claro_ALM_NumeroFase8],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase8],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase8],
						[DimWorkItem].[Claro_ALM_EstadoFase8],
						[DimWorkItem].[Claro_ALM_NumeroFase9],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase9],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase9],
						[DimWorkItem].[Claro_ALM_EstadoFase9],
						[DimWorkItem].[Claro_ALM_NumeroFase10],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase10],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase10],
						[DimWorkItem].[Claro_ALM_EstadoFase10],
						[DimWorkItem].[Claro_ALM_NumeroFase11],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase11],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase11],
						[DimWorkItem].[Claro_ALM_EstadoFase11],
						[DimWorkItem].[Claro_ALM_NumeroFase12],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase12],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase12],
						[DimWorkItem].[Claro_ALM_EstadoFase12],
						[DimWorkItem].[Claro_ALM_NumeroFase13],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase13],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase13],
						[DimWorkItem].[Claro_ALM_EstadoFase13],
						[DimWorkItem].[Claro_ALM_NumeroFase14],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase14],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase14],
						[DimWorkItem].[Claro_ALM_EstadoFase14],
						[DimWorkItem].[Claro_ALM_NumeroFase15],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase15],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase15],
						[DimWorkItem].[Claro_ALM_EstadoFase15],
						[DimWorkItem].[Claro_ALM_NumeroFase16],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase16],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase16],
						[DimWorkItem].[Claro_ALM_EstadoFase16],
						[DimWorkItem].[Claro_ALM_NumeroFase17],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase17],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase17],
						[DimWorkItem].[Claro_ALM_EstadoFase17],
						[DimWorkItem].[Claro_ALM_NumeroFase18],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase18],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase18],
						[DimWorkItem].[Claro_ALM_EstadoFase18],
						[DimWorkItem].[Claro_ALM_NumeroFase19],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase19],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase19],
						[DimWorkItem].[Claro_ALM_EstadoFase19],
						[DimWorkItem].[Claro_ALM_NumeroFase20],
						[DimWorkItem].[Claro_ALM_FechaDesplieguePlanFase20],
						[DimWorkItem].[Claro_ALM_FechaDespliegueRealFase20],
						[DimWorkItem].[Claro_ALM_EstadoFase20],
						[DimWorkItem].[Claro_ALM_CausalCambioFechaReal],
						[DimWorkItem].[Claro_ALM_CausalCambioFechaPlaneada],
						[DimWorkItem].[Claro_ALM_CumplimientoFabricaDesarrollo],
						[DimWorkItem].[Claro_ALM_Req_Neg_Pri],
						[DimWorkItem].[Claro_ALM_Fase_Req_Negocio],
						[DimWorkItem].[Claro_ALM_Desfase_Responsable],
						'' as [Claro_ALM_OrdenTrabajoId],
						'' as [Claro_ALM_Naturaleza],
						'' as [Claro_ALM_InyectionCompany],
						'' as [Claro_ALM_SolutionPriority],
						'' as [Claro_ALM_SolutionComplexity],
						'' as [Claro_ALM_CausaCancelacion],
						'' as [Claro_ALM_Solicitado],
						'' as [Claro_ALM_FecSolicitado],
						[DimWorkItem].[Claro_ALM_TiempoSLA],
						[DimWorkItem].[Claro_ALM_solucionTiempo],
						[DimWorkItem].[Claro_ALM_Fechacompromiso],
						[DimWorkItem].[Claro_ALM_Impacto]
						,'' as [Claro_ALM_Tipo]
						,'' as [Claro_ALM_FechaIni]
						,'' as [Claro_ALM_Asignador],
						'' as [Claro_ALM_TypeCase]
						,'' as [Claro_ALM_TypeError]
						,'' as [Claro_ALM_FechaEntDesarrollo]
            ,[DimTeamProject].[ProjectNodeSK]
            ,[DimTeamProject].[ProjectNodeGUID]
            ,[DimTeamProject].[ProjectNodeName]
            ,[DimTeamProject].[ProjectNodeType]
            ,[DimTeamProject].[ProjectNodeTypeName]
            ,[DimTeamProject].[IsDeleted] AS ProjectIsDeleted
            ,[DimTeamProject].[ProjectPath]
            ,[DimArea].[AreaName]
            ,[DimArea].[AreaPath]
            ,[DimArea].[AreaGUID]
            ,[DimArea].[ParentAreaGUID]
            ,[DimArea].[ForwardingID] AS AreaForwardingID
            ,[DimArea].[ProjectGUID] AS AreaProjectGUID
            ,[DimIteration].[IterationName]
            ,[DimIteration].[IterationPath]
            ,[DimIteration].[IterationGUID]
            ,[DimIteration].[ParentIterationGUID]
            ,[DimIteration].[ForwardingID] AS IterationForwardingID
            ,[DimIteration].[ProjectGUID] AS IterationProjectGUID
    FROM   [ads_Warehouse].[dbo].[FactCurrentWorkItem] [FactCurrentWorkItem]
        LEFT OUTER JOIN
            [ads_Warehouse].[dbo].[DimWorkItem]  [DimWorkItem] ON [FactCurrentWorkItem].[WorkItemSK] = [DimWorkItem].[WorkItemSK]
        LEFT OUTER JOIN
            [ads_Warehouse].[dbo].[DimTeamProject] [DimTeamProject] on [FactCurrentWorkItem].[TeamProjectSK] = [DimTeamProject].[ProjectNodeSK]
        LEFT OUTER JOIN
            [ads_Warehouse].[dbo].[DimArea] [DimArea] ON [DimWorkItem].[AreaSK] = [DimArea].[AreaSK]
        LEFT OUTER JOIN
            [ads_Warehouse].[dbo].[DimIteration] [DimIteration] ON [DimWorkItem].[IterationSK] = [DimIteration].[IterationSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_System_ChangedBy ON [DimWorkItem].[System_ChangedBy__PersonSK] = DimPerson_System_ChangedBy.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_System_AssignedTo ON [DimWorkItem].[System_AssignedTo__PersonSK] = DimPerson_System_AssignedTo.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_System_CreatedBy ON [DimWorkItem].[System_CreatedBy__PersonSK] = DimPerson_System_CreatedBy.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Microsoft_VSTS_Common_ActivatedBy ON [DimWorkItem].[Microsoft_VSTS_Common_ActivatedBy__PersonSK] = DimPerson_Microsoft_VSTS_Common_ActivatedBy.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Microsoft_VSTS_Common_ResolvedBy ON [DimWorkItem].[Microsoft_VSTS_Common_ResolvedBy__PersonSK] = DimPerson_Microsoft_VSTS_Common_ResolvedBy.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Microsoft_VSTS_Common_ClosedBy ON [DimWorkItem].[Microsoft_VSTS_Common_ClosedBy__PersonSK] = DimPerson_Microsoft_VSTS_Common_ClosedBy.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_GerenteSolicitante ON [DimWorkItem].[Claro_ALM_GerenteSolicitante__PersonSK] = DimPerson_Claro_ALM_GerenteSolicitante.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_DirectorSolicitante ON [DimWorkItem].[Claro_ALM_DirectorSolicitante__PersonSK] = DimPerson_Claro_ALM_DirectorSolicitante.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_LiderBrief ON [DimWorkItem].[Claro_ALM_LiderBrief__PersonSK] = DimPerson_Claro_ALM_LiderBrief.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_ResponsableNegocio ON [DimWorkItem].[Claro_ALM_ResponsableNegocio__PersonSK] = DimPerson_Claro_ALM_ResponsableNegocio.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_UsuarioAutorizacionRiesgo ON [DimWorkItem].[Claro_ALM_UsuarioAutorizacionRiesgo__PersonSK] = DimPerson_Claro_ALM_UsuarioAutorizacionRiesgo.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_UsuarioAutorizacionSistemaFinanciero ON [DimWorkItem].[Claro_ALM_UsuarioAutorizacionSistemaFinanciero__PersonSK] = DimPerson_Claro_ALM_UsuarioAutorizacionSistemaFinanciero.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_RadicadoPor ON [DimWorkItem].[Claro_ALM_RadicadoPor__PersonSK] = DimPerson_Claro_ALM_RadicadoPor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_FactiblePor ON [DimWorkItem].[Claro_ALM_FactiblePor__PersonSK] = DimPerson_Claro_ALM_FactiblePor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_FSPBasePor ON [DimWorkItem].[Claro_ALM_FSPBasePor__PersonSK] = DimPerson_Claro_ALM_FSPBasePor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_FSPCerradoPor ON [DimWorkItem].[Claro_ALM_FSPCerradoPor__PersonSK] = DimPerson_Claro_ALM_FSPCerradoPor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_EstimadoPor ON [DimWorkItem].[Claro_ALM_EstimadoPor__PersonSK] = DimPerson_Claro_ALM_EstimadoPor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_AprobadoJuntaPor ON [DimWorkItem].[Claro_ALM_AprobadoJuntaPor__PersonSK] = DimPerson_Claro_ALM_AprobadoJuntaPor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_LiderLineaProducto ON [DimWorkItem].[Claro_ALM_LiderLineaProducto__PersonSK] = DimPerson_Claro_ALM_LiderLineaProducto.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_AnalizadoPor ON [DimWorkItem].[Claro_ALM_AnalizadoPor__PersonSK] = DimPerson_Claro_ALM_AnalizadoPor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_AprobadoPor ON [DimWorkItem].[Claro_ALM_AprobadoPor__PersonSK] = DimPerson_Claro_ALM_AprobadoPor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Microsoft_VSTS_CodeReview_AcceptedBy ON [DimWorkItem].[Microsoft_VSTS_CodeReview_AcceptedBy__PersonSK] = DimPerson_Microsoft_VSTS_CodeReview_AcceptedBy.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_PlaneadoPor ON [DimWorkItem].[Claro_ALM_PlaneadoPor__PersonSK] = DimPerson_Claro_ALM_PlaneadoPor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_DisenadoPor ON [DimWorkItem].[Claro_ALM_DisenadoPor__PersonSK] = DimPerson_Claro_ALM_DisenadoPor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_EjecutadoPor ON [DimWorkItem].[Claro_ALM_EjecutadoPor__PersonSK] = DimPerson_Claro_ALM_EjecutadoPor.[PersonSK]

                            --LEFT OUTER JOIN
                    		  --  [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_LiderSoporte ON [DimWorkItem].[Claro_ALM_LiderSoporte__PersonSK] = DimPerson_Claro_ALM_LiderSoporte.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_GestorPortafolio ON [DimWorkItem].[Claro_ALM_GestorPortafolio__PersonSK] = DimPerson_Claro_ALM_GestorPortafolio.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_PMO ON [DimWorkItem].[Claro_ALM_PMO__PersonSK] = DimPerson_Claro_ALM_PMO.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_UsuarioReporta ON [DimWorkItem].[Claro_ALM_UsuarioReporta__PersonSK] = DimPerson_Claro_ALM_UsuarioReporta.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_SolicitanteRequerimiento ON [DimWorkItem].[Claro_ALM_SolicitanteRequerimiento__PersonSK] = DimPerson_Claro_ALM_SolicitanteRequerimiento.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_Arquitecto ON [DimWorkItem].[Claro_ALM_Arquitecto__PersonSK] = DimPerson_Claro_ALM_Arquitecto.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_AnalistaNegocio ON [DimWorkItem].[Claro_ALM_AnalistaNegocio__PersonSK] = DimPerson_Claro_ALM_AnalistaNegocio.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_AsignadaAltoNivelPor ON [DimWorkItem].[Claro_ALM_AsignadaAltoNivelPor__PersonSK] = DimPerson_Claro_ALM_AsignadaAltoNivelPor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_EstimadaPor ON [DimWorkItem].[Claro_ALM_EstimadaPor__PersonSK] = DimPerson_Claro_ALM_EstimadaPor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_AsignadaDetallePor ON [DimWorkItem].[Claro_ALM_AsignadaDetallePor__PersonSK] = DimPerson_Claro_ALM_AsignadaDetallePor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_AprobadaPor ON [DimWorkItem].[Claro_ALM_AprobadaPor__PersonSK] = DimPerson_Claro_ALM_AprobadaPor.[PersonSK]

                            --LEFT OUTER JOIN
                    		  --  [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_GestorUAT ON [DimWorkItem].[Claro_ALM_GestorUAT__PersonSK] = DimPerson_Claro_ALM_GestorUAT.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_FinalizadaPor ON [DimWorkItem].[Claro_ALM_FinalizadaPor__PersonSK] = DimPerson_Claro_ALM_FinalizadaPor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Claro_ALM_SolicitadoPor ON [DimWorkItem].[Claro_ALM_SolicitadoPor__PersonSK] = DimPerson_Claro_ALM_SolicitadoPor.[PersonSK]

                            LEFT OUTER JOIN
                    		    [ads_Warehouse].[dbo].[DimPerson] AS DimPerson_Microsoft_VSTS_Common_ReviewedBy ON [DimWorkItem].[Microsoft_VSTS_Common_ReviewedBy__PersonSK] = DimPerson_Microsoft_VSTS_Common_ReviewedBy.[PersonSK]



GO


