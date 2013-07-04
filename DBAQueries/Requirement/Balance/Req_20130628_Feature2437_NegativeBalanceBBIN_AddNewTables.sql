/*
	Created by: Jamie
	Date: 2013-06-28
	Task: Add two new tables for looking for Negative Balance 
	DB: DBTXN/bodb02

*/

USE [bodb02]
GO

/****** Object:  Table [dbo].[BalanceNegative]    Script Date: 06/28/2013 10:23:44 ******/

CREATE TABLE [dbo].[BalanceNegative](
	[ExecID] [bigint] IDENTITY(1,1) NOT NULL,
	[ExecDate] [datetime] NOT NULL,
	[MatchID] [int] NOT NULL,
	[ActionID] [int] NULL,
	[GroupID] [tinyint] NOT NULL,
	[CustID] [int] NULL,
	[Balance] [money] NULL,
	[StatusID] [bit] NULL,
	[Remark] [varchar](2000) NULL,
 CONSTRAINT [PK_ExecID] PRIMARY KEY NONCLUSTERED 
(
	[ExecID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [BALANCE]
) ON [BALANCE]

GO

ALTER TABLE [dbo].[BalanceNegative] ADD  CONSTRAINT [DF_BalanceNegative_GroupID]  DEFAULT ((0)) FOR [GroupID]
GO


/****** Object:  Index [CIX_BalanceNegative]    Script Date: 06/28/2013 10:24:10 ******/
CREATE CLUSTERED INDEX [CIX_BalanceNegative] ON [dbo].[BalanceNegative] 
(
	[MatchID] ASC,
	[CustID] ASC,
	[GroupID] ASC,
	[StatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [BALANCE]
GO

--

/****** Object:  Table [dbo].[BalanceNegativeHistory]    Script Date: 06/28/2013 10:25:01 ******/
CREATE TABLE [dbo].[BalanceNegativeHistory](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[LogDate] [datetime] NULL,
	[ExecDate] [datetime] NOT NULL,
	[MatchID] [int] NOT NULL,
	[ActionID] [int] NULL,
	[CustID] [int] NULL,
	[GroupID] [tinyint] NOT NULL,
	[Balance] [money] NULL,
	[TotalBalance] [money] NULL,
	[StatusID] [bit] NULL,
	[Site] [varchar](50) NULL,
	[Remark] [varchar](2000) NULL,
 CONSTRAINT [PK_LogID] PRIMARY KEY NONCLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [BALANCE]
) ON [BALANCE]

GO

/****** Object:  Index [CIX_BalanceNegativeHistory]    Script Date: 06/28/2013 10:25:25 ******/
CREATE CLUSTERED INDEX [CIX_BalanceNegativeHistory] ON [dbo].[BalanceNegativeHistory] 
(
	[MatchID] ASC,
	[CustID] ASC,
	[GroupID] ASC,
	[StatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [BALANCE]
GO



