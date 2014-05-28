/*
	Created by: Elodie
	Date: 2014-05-22
	Task: Prepare structure for Limit Loss [Redmine:#16502]	
*/
----------------------------------------------------------------
--Add new table to DBAGE.bodb_Age.dbo.LimitLoss_ActionItem------
----------------------------------------------------------------
USE [bodb_Age]
GO

/****** Object:  Table [dbo].[LimitLoss_ActionItem]    Script Date: 5/22/2014 1:36:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[LimitLoss_ActionItem](
	[ActionID] [tinyint] NOT NULL,
	[ActionDesc] [varchar](500) NULL,
 CONSTRAINT [PK_LimitLoss_ActionItem] PRIMARY KEY CLUSTERED 
(
	[ActionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ageDATA]
) ON [ageDATA]

GO

SET ANSI_PADDING OFF
GO

----------------------------------------------------------------
--Add new table to DBAGE.bodb_Age.dbo.LimitLoss_ActionConfig----
----------------------------------------------------------------
USE [bodb_Age]
GO

/****** Object:  Table [dbo].[LimitLoss_ActionConfig]    Script Date: 5/22/2014 2:53:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LimitLoss_ActionConfig](
	[ConfigID] [int] IDENTITY(1,1) NOT NULL,
	[LevelID] [tinyint] NOT NULL,
	[ActionID] [tinyint] NOT NULL,
	[Value] [int] NOT NULL,
 CONSTRAINT [PK_LimitLoss_ActionConfig] PRIMARY KEY CLUSTERED 
(
	[ConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ageDATA]
) ON [ageDATA]

GO

----------------------------------------------------------------
--Add new table to DBAGE.bodb_Age.dbo.LimitLoss_Setting---------
----------------------------------------------------------------
USE [bodb_Age]
GO

/****** Object:  Table [dbo].[LimitLoss_Setting]    Script Date: 5/23/2014 10:14:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LimitLoss_Setting](
	[CustID] [int] NOT NULL,
	[MaxLoss] [money] NOT NULL,
	[TotalBalance] [money] NULL,
	[LevelID] [tinyint] NOT NULL,
	--[IsDone] [bit] NOT NULL,
	--[HighestLevel] [tinyint] NOT NULL,
	--[HighestLevelLastUpd] [datetime] NOT NULL,
 CONSTRAINT [PK_LimitLoss_Setting] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ageDATA]
) ON [ageDATA]

GO

ALTER TABLE [dbo].[LimitLoss_Setting] ADD  CONSTRAINT [DF_LimitLoss_Setting_LevelID]  DEFAULT ((0)) FOR [LevelID]
GO

--ALTER TABLE [dbo].[LimitLoss_Setting] ADD  CONSTRAINT [DF_LimitLoss_Setting_IsDone]  DEFAULT ((1)) FOR [IsDone]
--GO

--ALTER TABLE [dbo].[LimitLoss_Setting] ADD  CONSTRAINT [DF_LimitLoss_Setting_HighestLevel]  DEFAULT ((0)) FOR [HighestLevel]
--GO

--ALTER TABLE [dbo].[LimitLoss_Setting] ADD  CONSTRAINT [DF_LimitLoss_Setting_HighestLevelLastUpd]  DEFAULT (getdate()) FOR [HighestLevelLastUpd]
--GO



