USE [ADSReports]
GO

/****** Object:  Table [dbo].[InformeRLPFechasModificadas]    Script Date: 26/03/2020 7:31:25 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[InformeRLPFechasModificadas](
	[Brief_Id] [int] NULL,
	[Fase] [int] NULL,
	[LineaProducto_Id] [int] NULL,
	[LineaProducto] [nvarchar](256) NULL,
	[GerenciaResponsable] [nvarchar](256) NULL,
	[FechaPlaneadaDespliegue] [datetime] NULL,
	[CausalCambioFechaPlaneada] [nvarchar](256) NULL,
	[FechaRealDespliegue] [datetime] NULL,
	[CausalCambioFechaReal] [nvarchar](256) NULL,
	[ValidacionFechaRealDespliegue] [nvarchar](10) NULL
) ON [PRIMARY]

GO


