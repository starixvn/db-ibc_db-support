/*
	Created by: Elodie
	Date: 2014-05-22
	Task: Prepare structure for Limit Loss [Redmine:#16502]	
*/
----------------------------------------------------------------
--Add new table to DBAGE.bodb_Age.dbo.LimitLoss_ActionConfig----
----------------------------------------------------------------
USE [bodb_Age]
GO

/****** Object:  Table [dbo].[LimitLoss_ActionConfig]    Script Date: 5/22/2014 10:00:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[LimitLoss_ActionConfig](
	[ActionID] [tinyint] NOT NULL,
	[Value] [int] NOT NULL,
	[ActionDesc] [varchar](500) NULL,
 CONSTRAINT [PK_LimitLoss_ActionConfig] PRIMARY KEY CLUSTERED 
(
	[ActionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ageDATA]
) ON [ageDATA]

GO

SET ANSI_PADDING OFF
GO

----------------------------------------------------------------
--Add new table to DBAGE.bodb_Age.dbo.LimitLoss_Setting---------
----------------------------------------------------------------
USE [bodb_Age]
GO

/****** Object:  Table [dbo].[LimitLoss_Setting]    Script Date: 5/22/2014 10:04:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LimitLoss_Setting](
	[CustID] [int] NOT NULL,
	[MaxLoss] [money] NOT NULL,
	[TotalBalance] [money] NULL,
	[ActionID] [tinyint] NOT NULL,
	[IsAction] [bit] NOT NULL,
 CONSTRAINT [PK_LimitLoss_Setting] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ageDATA]
) ON [ageDATA]

GO

ALTER TABLE [dbo].[LimitLoss_Setting] ADD  CONSTRAINT [DF_LimitLoss_Setting_ActionID]  DEFAULT ((0)) FOR [ActionID]
GO

ALTER TABLE [dbo].[LimitLoss_Setting] ADD  CONSTRAINT [DF_LimitLoss_Setting_IsAction]  DEFAULT ((1)) FOR [IsAction]
GO


