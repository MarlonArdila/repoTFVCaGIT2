USE [ADSReports]
GO

/****** Object:  Table [dbo].[tbl_CbPruebas_PCOPCAP]    Script Date: 26/03/2020 7:34:14 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_CbPruebas_PCOPCAP](
	[P_WorkItemSK] [int] NULL,
	[P_Id] [int] NULL,
	[P_TeamProjectSK] [int] NULL,
	[P_ProjectName] [nvarchar](256) NULL,
	[P_FechaCreado] [datetime] NULL,
	[P_FechaDisenado] [datetime] NULL,
	[P_IdCOPRaiz] [int] NULL,
	[P_EvaluadorPpal] [nvarchar](256) NULL,
	[COP_WorkItemSK] [int] NULL,
	[COP_Id] [int] NULL,
	[COP_Titulo] [nvarchar](256) NULL,
	[CAP_WorkItemSK] [int] NULL,
	[CAP_Id] [int] NULL,
	[CAP_Titulo] [nvarchar](256) NULL,
	[CAP_Resultado] [nvarchar](256) NULL,
	[CAP_FechaCreacion] [datetime] NULL,
	[CAP_EsTestStandar] [nvarchar](256) NULL
) ON [PRIMARY]

GO


