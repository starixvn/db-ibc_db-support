 USE [bodb_RMS]
GO
/****** Object:  Table [dbo].[rmSumWinloss_Old2]    Script Date: 08/13/2013 13:03:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[rmSumWinloss_Old2](
	[winlostdate] [smalldatetime] NOT NULL,
	[custid] [int] NOT NULL,
	[sporttype] [tinyint] NOT NULL,
	[statusid] [tinyint] NOT NULL,
	[combo] [tinyint] NOT NULL,
	[username] [varchar](30) NOT NULL,
	[currency] [tinyint] NULL,
	[stake] [money] NULL,
	[winlost] [money] NULL,
	[company_stake] [money] NULL,
	[company_winlost] [money] NULL,
	[actualrate] [float] NULL,
	[odds] [smallmoney] NULL,
	[betcount] [int] NULL
) ON [rmSumWinlossOld]

GO
SET ANSI_PADDING OFF
GO

USE [bodb_RMS]
GO
/****** Object:  Index [CIX_rmSumWinloss_Old]    Script Date: 08/13/2013 13:03:23 ******/
CREATE CLUSTERED INDEX [CIX_rmSumWinloss_Old] ON [dbo].[rmSumWinloss_Old2] 
(
	[custid] ASC,
	[winlostdate] ASC,
	[sporttype] ASC,
	[statusid] ASC,
	[combo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [rmSumWinlossOld]