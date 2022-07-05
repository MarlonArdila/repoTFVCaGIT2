USE [ADSReports]
GO

/****** Object:  Table [dbo].[tbl_VencimConstEstimNegIT]    Script Date: 26/03/2020 7:36:55 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_VencimConstEstimNegIT](
	[ID_Brief] [int] NULL,
	[TipoVencimiento] [nvarchar](256) NULL,
	[MaxDiasVencimiento] [int] NULL,
	[DiasDiferencia] [int] NULL,
	[En_Tiempo] [int] NULL,
	[Vencido] [int] NULL,
	[DiasAcum] [int] NULL,
	[PeriodosVenc] [int] NULL,
	[Claro_ALM_Segmento] [nvarchar](256) NULL
) ON [PRIMARY]

GO


