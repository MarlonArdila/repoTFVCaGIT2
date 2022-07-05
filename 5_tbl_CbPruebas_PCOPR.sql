USE [ADSReports]
GO

/****** Object:  Table [dbo].[tbl_CbPruebas_PCOPR]    Script Date: 26/03/2020 7:34:59 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_CbPruebas_PCOPR](
	[P_WorkItemSK] [int] NULL,
	[P_Id] [int] NULL,
	[P_TeamProjectSK] [int] NULL,
	[P_ProjectName] [nvarchar](256) NULL,
	[P_IdCOPRaiz] [int] NULL,
	[COP_WorkItemSK] [int] NULL,
	[COP_Id] [int] NULL,
	[COP_Estado] [nvarchar](256) NULL,
	[COP_Titulo] [nvarchar](256) NULL,
	[COP_ModificadoPor] [nvarchar](256) NULL,
	[COP_Motivo] [nvarchar](256) NULL,
	[COP_AsignadoA] [nvarchar](256) NULL,
	[COP_CreadoPor] [nvarchar](256) NULL,
	[COP_FechaCreacion] [datetime] NULL,
	[COP_Tipo] [nvarchar](256) NULL,
	[R_WorkItemSK] [int] NULL,
	[R_Id] [int] NULL,
	[R_Titulo] [nvarchar](256) NULL,
	[R_Estado] [nvarchar](256) NULL,
	[R_ModificadoPor] [nvarchar](256) NULL,
	[R_Motivo] [nvarchar](256) NULL,
	[R_AsignadoA] [nvarchar](256) NULL,
	[R_CreadoPor] [nvarchar](256) NULL,
	[R_FechaCreacion] [datetime] NULL,
	[R_Tipo] [nvarchar](256) NULL,
	[R_TipoFuncional] [nvarchar](256) NULL,
	[R_TipoModificacionFuncional] [nvarchar](256) NULL,
	[R_TipoNoFuncional] [nvarchar](256) NULL,
	[R_Prioridad] [int] NULL,
	[R_Bloqueado] [nvarchar](256) NULL,
	[R_AutorizacionLiderSis] [nvarchar](256) NULL,
	[R_AutorizacionResponsableNeg] [nvarchar](256) NULL
) ON [PRIMARY]

GO


