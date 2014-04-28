/*
	Created by: Elodie
	Date: 2014-04-08
	Task: Prepare structure for SMA Turnover [Redmine:#14426]	
*/
----------------------------DBAGE-------------------------------
----------------------------------------------------------------
--Add new table to DBAGE.bodb_Age.dbo.DownlineTo_SportControl---
----------------------------------------------------------------
USE [bodb_Age]
GO

/****** Object:  Table [dbo].[DownlineTo_SportControl]    Script Date: 4/8/2014 10:34:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DownlineTo_SportControl](
	[SportID] [int] NOT NULL,
	[Value] [int] NOT NULL,
 CONSTRAINT [PK_DownlineTo_SportControl] PRIMARY KEY CLUSTERED 
(
	[SportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ageDATA]
) ON [ageDATA]

GO

----------------------------------------------------------------
--Add new table to DBAGE.bodb_Age.dbo.DownlineTo_LeagueControl--
----------------------------------------------------------------
USE [bodb_Age]
GO

/****** Object:  Table [dbo].[DownlineTo_LeagueControl]    Script Date: 4/8/2014 10:34:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DownlineTo_LeagueControl](
	[LeagueID] [int] NOT NULL,
	[Value] [int] NOT NULL,
 CONSTRAINT [PK_DownlineTo_LeagueControl] PRIMARY KEY CLUSTERED 
(
	[LeagueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ageDATA]
) ON [ageDATA]

GO

----------------------------------------------------------------
--Add new table to DBAGE.bodb_Age.dbo.DownlineTo_MatchControl---
----------------------------------------------------------------
USE [bodb_Age]
GO

/****** Object:  Table [dbo].[DownlineTo_MatchControl]    Script Date: 4/8/2014 10:34:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DownlineTo_MatchControl](
	[MatchID] [int] NOT NULL,
	[Value] [int] NOT NULL,
 CONSTRAINT [PK_DownlineTo_MatchControl] PRIMARY KEY CLUSTERED 
(
	[MatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ageDATA]
) ON [ageDATA]

GO

----------------------------------------------------------------
--Add new table to DBAGE.bodb_Age.dbo.DownlineTo_SMAControl-----
----------------------------------------------------------------
USE [bodb_Age]
GO

/****** Object:  Table [dbo].[DownlineTo_SMAControl]    Script Date: 4/8/2014 10:34:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DownlineTo_SMAControl](
	[SMAID] [int] NOT NULL,
	[Offset] [int] NOT NULL,
 CONSTRAINT [PK_DownlineTo_SMAControl] PRIMARY KEY CLUSTERED 
(
	[SMAID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ageDATA]
) ON [ageDATA]

GO

----------------------------------------------------------------
--Add new table to DBAGE.bodb_Age.dbo.DownlineTo_Match_SMAControl
----------------------------------------------------------------
USE [bodb_Age]
GO

/****** Object:  Table [dbo].[DownlineTo_Match_SMAControl]    Script Date: 4/21/2014 2:42:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DownlineTo_Match_SMAControl](
	[SMAID] [int] NOT NULL,
	[MatchID] [int] NOT NULL,
	[Value] [int] NOT NULL,
 CONSTRAINT [PK_DownlineTo_Match_SMAControl] PRIMARY KEY CLUSTERED 
(
	[MatchID] ASC,
	[SMAID] ASC
	
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ageDATA]
) ON [ageDATA]

GO

----------------------------------------------------------------
--Alter table DBAGE.bodb02.dbo.DownlineTurnover_Setting---------
----------------------------------------------------------------
USE [bodb02]
GO
sp_RENAME 'DownlineTurnover_Setting.Custid', 'SMAID' , 'COLUMN'
GO

----------------------------------------------------------------
--Add new fields to DBAGE.bodb02.dbo.DownlineTurnover_Setting---
----------------------------------------------------------------
USE [bodb02]
GO
ALTER TABLE dbo.DownlineTurnover_Setting ADD [Value] INT NULL
ALTER TABLE dbo.DownlineTurnover_Setting ADD [InheritLevel] TINYINT NULL
GO

----------------------------------------------------------------
--Alter table DBAGE.bodb02.dbo.DownlineTurnover_Setting_tmp-----
----------------------------------------------------------------
USE [bodb02]
GO
sp_RENAME 'DownlineTurnover_Setting_tmp.Custid', 'SMAID' , 'COLUMN'
GO

----------------------------------------------------------------
--Add new fields to DBAGE.bodb02.dbo.DownlineTurnover_Trigger---
----------------------------------------------------------------
USE [bodb02]
GO
ALTER TABLE dbo.DownlineTurnover_Trigger ADD mrecommend INT NULL
ALTER TABLE dbo.DownlineTurnover_Trigger ADD recommend INT NULL
GO

--------------------------------------------------------------------
--Add new fields to DBAGE.bodb02.dbo.DownlineTurnover_Trigger_tmp---
--------------------------------------------------------------------
USE [bodb02]
GO
ALTER TABLE dbo.DownlineTurnover_Trigger_tmp ADD mrecommend INT NULL
ALTER TABLE dbo.DownlineTurnover_Trigger_tmp ADD recommend INT NULL
GO

----------------------------------------------------------------
--Alter table DBAGE.bodb02.dbo.DownlineTurnOver_Setting_Delete--
----------------------------------------------------------------
USE [bodb02]
GO
sp_RENAME 'DownlineTurnOver_Setting_Delete.Custid', 'SMAID' , 'COLUMN'
GO

----------------------------------------------------------------
-----------------------------Grant permission-------------------
----------------------------------------------------------------
GRANT SELECT ON DownlineTo_SportControl TO bodbAdminNet
GRANT SELECT ON DownlineTo_LeagueControl TO bodbAdminNet
GRANT SELECT ON DownlineTo_MatchControl TO bodbAdminNet
GRANT SELECT ON DownlineTo_SMAControl TO bodbAdminNet
GRANT SELECT ON DownlineTo_Match_SMAControl TO bodbAdminNet
----------------------------END DBAGE---------------------------

----------------------------DBTXN-------------------------------
----------------------------------------------------------------
--Alter table DBTXN.bodb02.dbo.DownlineTurnover_Setting_tmp-----
----------------------------------------------------------------
USE [bodb02]
GO
sp_RENAME 'DownlineTurnover_Setting_tmp.Custid', 'SMAID' , 'COLUMN'
GO

----------------------------------------------------------------
--Alter table DBTXN.bodb02.dbo.DownlineTurnover_Setting---------
----------------------------------------------------------------
USE [bodb02]
GO
sp_RENAME 'DownlineTurnover_Setting.Custid', 'SMAID' , 'COLUMN'
GO

----------------------------------------------------------------
-----------------------------Grant permission-------------------
----------------------------------------------------------------
GRANT INSERT, DELETE ON DownlineTurnover_Trigger TO bodbAdminNet
GRANT DELETE ON DownlineTurnover_Trigger_tmp TO bodbAdminNet

GRANT SELECT ON DownlineTurnover_Setting TO bodbAdminNet
GRANT SELECT ON Dep_CustSuper TO bodbAdminNet
GRANT SELECT ON bettrans TO bodbAdminNet
GRANT SELECT ON match TO bodbAdminNet
----------------------------END DBTXN---------------------------- 