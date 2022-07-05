USE [ADSReports]
GO

/****** Object:  Table [dbo].[informeGeneral]    Script Date: 26/03/2020 7:30:39 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[informeGeneral](
	[briefSysID] [int] NULL,
	[Claro_ALM_UnidadNegocio] [nvarchar](256) NULL,
	[System_Title] [nvarchar](256) NULL,
	[descripcion] [nvarchar](max) NULL,
	[Claro_ALM_TipoBeneficio] [nvarchar](256) NULL,
	[numeroResolucion] [nvarchar](256) NOT NULL,
	[Claro_ALM_GerenteSolicitante] [nvarchar](256) NULL,
	[Claro_ALM_ResponsableNegocio] [nvarchar](256) NULL,
	[Claro_ALM_DirectorSolicitante] [nvarchar](256) NULL,
	[Claro_ALM_AreaNegocio] [nvarchar](256) NULL,
	[Claro_ALM_Estrategia] [nvarchar](256) NULL,
	[Claro_ALM_Clasificacion] [nvarchar](256) NULL,
	[Claro_ALM_Consecutivo123MIC] [nvarchar](256) NULL,
	[estadoBrief] [nvarchar](256) NULL,
	[Claro_ALM_LiderBrief] [nvarchar](256) NULL,
	[Claro_ALM_FechaRadicado] [datetime] NULL,
	[Claro_ALM_FechaFSPBase] [datetime] NULL,
	[Claro_ALM_FechaAprobado] [datetime] NULL,
	[Claro_ALM_FechaFactible] [datetime] NULL,
	[Claro_ALM_FechaFSPCerrado] [datetime] NULL,
	[Claro_ALM_FechaEstimado] [datetime] NULL,
	[Claro_ALM_FechaAprobadoJunta] [datetime] NULL,
	[Prioridad] [int] NULL,
	[LineaProducto] [nvarchar](256) NULL,
	[EstadoLineaProducto] [nvarchar](256) NOT NULL,
	[FaseLineaProducto] [int] NULL,
	[GerenciaDesarrollo] [nvarchar](256) NULL,
	[reqBloqueado] [nvarchar](256) NOT NULL,
	[LiderDesarrollo] [nvarchar](256) NULL,
	[RLP_FechaCreado] [datetime] NULL,
	[RLP_FechaAprobado] [datetime] NULL,
	[RLP_FechaAnalisis] [datetime] NULL,
	[RLP_FechaConstrucion] [datetime] NULL,
	[RLP_FechaPruebas] [datetime] NULL,
	[RLP_FechaDespliegue] [datetime] NULL,
	[CausalDemoraDespliegue] [bit] NULL,
	[CumplimientoFabricaDesarrollo] [nvarchar](256) NULL,
	[proveedorDesarrollo] [nvarchar](256) NULL,
	[FechaInicialDesarrollo] [datetime] NULL,
	[FechaFinalDesarrollo] [datetime] NULL,
	[TiempoDesarrollodias] [int] NULL,
	[claro_ALM_HorasAcordadasDes] [float] NULL,
	[Claro_ALM_HorasPlaneadasDes] [float] NULL,
	[CostoDesarrollo] [float] NULL,
	[TallaDesarrollo] [varchar](2) NOT NULL,
	[ViabilidadDesarrollo] [nvarchar](256) NOT NULL,
	[proveedorPruebas] [nvarchar](256) NULL,
	[FechaInicialPruebas] [datetime] NULL,
	[FechaFinalPruebas] [datetime] NULL,
	[TiempoPruebasDias] [int] NULL,
	[Claro_ALM_HorasPlaneadasPru] [float] NULL,
	[claro_ALM_HorasAcordadasPru] [float] NULL,
	[CostoPruebas] [float] NULL,
	[TallaPruebas] [varchar](2) NOT NULL,
	[proveedorReq] [nvarchar](256) NULL,
	[FechaInicialReq] [datetime] NULL,
	[FechaFinalReq] [datetime] NULL,
	[TiempoReqDias] [int] NULL,
	[Claro_ALM_HorasPlaneadasReq] [float] NULL,
	[claro_ALM_HorasAcordadasReq] [float] NULL,
	[CostoReq] [float] NULL,
	[TallaReq] [varchar](2) NOT NULL,
	[Claro_ALM_FechaPlaneadaDespliegue] [datetime] NULL,
	[EstadoDespliegue] [varchar](13) NULL,
	[FechaRealDespliegue] [datetime] NULL,
	[ParticipaArquitectura] [nvarchar](256) NULL,
	[ParticipaAseguramientoIngresos] [nvarchar](256) NULL,
	[NotificacionAlUsuario] [nvarchar](max) NULL,
	[SeguimientoIT] [nvarchar](max) NULL,
	[ReqLPSysID] [int] NULL,
	[ReqSysID] [int] NULL,
	[motivoBrief] [nvarchar](256) NULL,
	[estadoReqNeg] [nvarchar](256) NULL,
	[Claro_ALM_Segmento] [nvarchar](256) NULL,
	[bloqueadoBrief] [nvarchar](256) NOT NULL,
	[reason_RQLP] [nvarchar](256) NOT NULL,
	[WorkItemSK] [int] NULL,
	[wisk_RQLP] [int] NULL,
	[EstadosPRB] [varchar](17) NOT NULL,
	[PrioridadPRB] [tinyint] NULL,
	[AfectaSistemaFinanciero] [nvarchar](256) NULL,
	[CargoSistemaFinanciero] [nvarchar](256) NULL,
	[AutorizacionSistemaFinanciero] [nvarchar](256) NULL,
	[ComplejidadBrief] [nvarchar](256) NULL,
	[Claro_ALM_DescripcionFase] [nvarchar](max) NULL,
	[Claro_ALM_FechaDesplieguePlanFase] [datetime] NULL,
	[Claro_ALM_FechaDespliegueRealFase] [datetime] NULL,
	[Claro_ALM_EstadoFase] [nvarchar](30) NULL,
	[BriefAsignado] [nvarchar](256) NULL,
	[Fecha_Creacion_Brief] [datetime] NULL,
	[FecProRLP] [datetime] NULL,
	[Causal_Desfase_Despliegue] [nvarchar](256) NULL,
	[Causales_Cambio_fecha_planeada] [nvarchar](256) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


