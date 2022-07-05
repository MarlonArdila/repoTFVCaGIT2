USE [ADSReports]
GO

/****** Object:  Table [dbo].[DescripcionFasesBrief]    Script Date: 26/03/2020 7:28:23 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DescripcionFasesBrief](
	[workitemsk] [int] NOT NULL,
	[Fase] [int] NOT NULL,
	[Claro_ALM_DescripcionFase] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


