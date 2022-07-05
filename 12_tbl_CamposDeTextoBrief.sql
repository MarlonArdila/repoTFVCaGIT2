USE [ADSReports]
GO

/****** Object:  Table [dbo].[CamposDeTextoBrief]    Script Date: 26/03/2020 7:26:46 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CamposDeTextoBrief](
	[workitemsk] [int] NOT NULL,
	[descripcion] [nvarchar](max) NULL,
	[beneficioBrief] [nvarchar](max) NULL,
	[ReqNOFuncionalBrief] [nvarchar](max) NULL,
	[NotificacionAlUsuario] [nvarchar](max) NULL,
	[SeguimientoIT] [nvarchar](max) NULL,
	[RiskDescPlanMitiga] [nvarchar](max) NULL,
	[RiskDesencPlanMitiga] [nvarchar](max) NULL,
	[RiskDesencPlanConting] [nvarchar](max) NULL,
	[ReqNegfuncionalidadActual] [nvarchar](max) NULL,
	[ReqNegcriteriosAceptacion] [nvarchar](max) NULL,
 CONSTRAINT [PK_CamposDeTextoBrief] PRIMARY KEY CLUSTERED 
(
	[workitemsk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


