  USE [bodb_report]
GO
/****** Object:  Table [dbo].[rptWinLost2]    Script Date: 06/19/2013 17:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rptWinLost2](
	[winlostdate] [smalldatetime] NULL,
	[matchid] [int] NULL,
	[bettype] [smallint] NULL,
	[liveindicator] [bit] NULL,
	[Status] [nvarchar](10) NULL,
	[IBC] [tinyint] NULL,
	[RealTurnover] [money] NULL,
	[RealWinLost] [money] NULL,
	[RealPosition] [money] NULL,
	[RealCommission] [money] NULL,
	[RealLineTotal] [money] NULL,
	[VirtualTurnover] [money] NULL,
	[VirtualLineTotal] [money] NULL,
	[SportType] [smallint] NULL,
	[exrisk] [smallmoney] NULL
) ON [rptWinLost]

GO
GRANT SELECT ON [dbo].[rptWinLost2] TO [bodbAdminNet]

USE [bodb_report]
GO
/****** Object:  Index [IX_rptWinLost2]    Script Date: 06/19/2013 17:24:33 ******/
CREATE CLUSTERED INDEX [IX_rptWinLost2] ON [dbo].[rptWinLost2] 
(
	[winlostdate] DESC,
	[bettype] ASC,
	[SportType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [rptWinLost]
