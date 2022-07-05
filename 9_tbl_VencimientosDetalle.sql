USE [ADSReports]
GO

/****** Object:  Table [dbo].[tbl_VencimientosDetalle]    Script Date: 26/03/2020 7:37:32 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_VencimientosDetalle](
	[Wisk_Brief] [int] NULL,
	[ID_Brief] [int] NULL,
	[Titulo_Brief] [nvarchar](256) NULL,
	[ComplejidadBrief] [nvarchar](256) NULL,
	[Claro_ALM_Segmento] [nvarchar](256) NULL,
	[Estado_Brief] [nvarchar](256) NULL,
	[TipoVencimiento] [nvarchar](256) NULL,
	[MaxDiasVencimiento] [int] NULL,
	[Tipo_Wi] [nvarchar](256) NULL,
	[Wisk_Wi] [int] NULL,
	[ID_Wi] [int] NULL,
	[Estado_Wi] [nvarchar](256) NULL,
	[Campo_Wi] [nvarchar](256) NULL,
	[ValorCampo_Wi] [nvarchar](256) NULL,
	[FechaIniDesc] [nvarchar](256) NULL,
	[FechaIniValor] [datetime] NULL,
	[FechaFinDesc] [nvarchar](256) NULL,
	[FechaFinValor] [datetime] NULL,
	[DiasDiferencia] [int] NULL,
	[En_Tiempo] [int] NULL,
	[Vencido] [int] NULL,
	[Neg] [int] NULL,
	[IT] [int] NULL
) ON [PRIMARY]

GO


