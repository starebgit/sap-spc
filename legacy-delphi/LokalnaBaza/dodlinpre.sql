USE [Obdelov]
GO

/****** Object:  Table [dbo].[dodlin]    Script Date: 3.6.2020 7:00:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[dodlin](
	[iddod] [smallint] IDENTITY(1,1) NOT NULL,
	[idlin] [tinyint] NULL,
	[dodkratki] [char](10) NULL,
	[dodnaziv] [char](40) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

