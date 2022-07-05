USE [ADSReports]
GO

/****** Object:  Table [dbo].[tbl_CbPruebas_COTD]    Script Date: 26/03/2020 7:32:48 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_CbPruebas_COTD](
	[C_WorkItemSK] [int] NULL,
	[C_Id] [int] NULL,
	[C_Titulo] [nvarchar](256) NULL,
	[C_Estado] [nvarchar](256) NULL,
	[C_ModificadoPor] [nvarchar](256) NULL,
	[C_Motivo] [nvarchar](256) NULL,
	[C_AsignadoA] [nvarchar](256) NULL,
	[C_CreadoPor] [nvarchar](256) NULL,
	[C_FechaCreacion] [datetime] NULL,
	[C_Tipo] [nvarchar](256) NULL,
	[C_NumeroSAP] [nvarchar](256) NULL,
	[C_NumeroSAPContratoMarco] [nvarchar](256) NULL,
	[C_Proveedor] [nvarchar](256) NULL,
	[C_Proyecto] [nvarchar](256) NULL,
	[C_ValorHoraProveedor] [int] NULL,
	[C_Horas] [int] NULL,
	[C_fechaInicio] [datetime] NULL,
	[C_fechaFin] [datetime] NULL,
	[O_WorkItemSK] [int] NULL,
	[O_Id] [int] NULL,
	[O_Estado] [nvarchar](256) NULL,
	[O_Disciplina] [nvarchar](256) NULL,
	[D_WorkItemSK] [int] NULL,
	[D_Id] [int] NULL,
	[D_Titulo] [nvarchar](256) NULL,
	[D_Estado] [nvarchar](256) NULL,
	[D_ModificadoPor] [nvarchar](256) NULL,
	[D_Motivo] [nvarchar](256) NULL,
	[D_AsignadoA] [nvarchar](256) NULL,
	[D_CreadoPor] [nvarchar](256) NULL,
	[D_FechaCreacion] [datetime] NULL,
	[D_Causal] [nvarchar](256) NULL,
	[D_Ambiente] [nvarchar](256) NULL,
	[D_CausalAmbiente] [nvarchar](256) NULL,
	[D_TrabajoCompletado] [float] NULL
) ON [PRIMARY]

GO


