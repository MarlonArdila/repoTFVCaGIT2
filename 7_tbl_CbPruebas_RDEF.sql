USE [ADSReports]
GO

/****** Object:  Table [dbo].[tbl_CbPruebas_RDEF]    Script Date: 26/03/2020 7:36:20 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_CbPruebas_RDEF](
	[R_WorkItemSK] [int] NULL,
	[R_Id] [int] NULL,
	[R_Titulo] [nvarchar](256) NULL,
	[R_Estado] [nvarchar](256) NULL,
	[DEF_WorkItemSK] [int] NULL,
	[DEF_Id] [int] NULL,
	[DEF_Estado] [nvarchar](256) NULL,
	[DEF_Titulo] [nvarchar](256) NULL
) ON [PRIMARY]

GO


