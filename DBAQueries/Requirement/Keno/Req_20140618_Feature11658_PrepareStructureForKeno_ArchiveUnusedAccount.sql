/*
	Created by: Elodie
	Date: 2014-06-18
	Task: Prepare structure for archiving unused account function [Redmine:#11658]	
*/ 
----------------------------------------------------------------
--Add new table to DB05.bodb_Customer.dbo.CustGameType_old------
----------------------------------------------------------------
USE bodb_Customer
GO

ALTER DATABASE bodb_Customer ADD FILEGROUP [CustGameType_table]
GO

ALTER DATABASE bodb_Customer ADD FILE (name = 'CustGameType_table', filename = 'G:\IBC_DB\bodb_Customer\CustGameType_table.ndf', SIZE = 2048KB ,FILEGROWTH = 2048KB ) TO FILEGROUP [CustGameType_table]
GO

USE bodb_Customer
GO

/****** Object:  Table [dbo].[CustGameType]    Script Date: 6/18/2014 4:54:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CustGameType_old](
	[CustID] [int] NOT NULL,
	[GameTypeID] [int] NOT NULL,
	[StakeLevelList] [varchar](50) NULL,
	[MaxPerGameType] [money] NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
	[IsDisabled] [bit] NOT NULL,
 CONSTRAINT [PK_CustGameType] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[GameTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [CustGameType_table]
) ON [CustGameType_table]

GO

SET ANSI_PADDING OFF
GO