USE [ADSReports]
GO

/****** Object:  Table [dbo].[tbl_CbPruebas_RCAP]    Script Date: 26/03/2020 7:35:46 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_CbPruebas_RCAP](
	[R_WorkItemSK] [int] NULL,
	[R_Id] [int] NULL,
	[R_Titulo] [nvarchar](256) NULL,
	[R_Estado] [nvarchar](256) NULL,
	[CAP_WorkItemSK] [int] NULL,
	[CAP_Id] [int] NULL,
	[CAP_Estado] [nvarchar](256) NULL,
	[CAP_Titulo] [nvarchar](256) NULL
) ON [PRIMARY]

GO


