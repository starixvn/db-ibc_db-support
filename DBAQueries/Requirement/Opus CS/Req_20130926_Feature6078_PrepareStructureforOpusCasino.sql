 /*
	Created: Johnson
	Date: 20130926
	Task: Prepare struture for Opus Casino
	DB: DBTXN/bodb02,CustDB
 */
 ----------------------------------------------------------------
 --Add more columns on CustInfo and Exchange tables--------------
 ----------------------------------------------------------------
 
 USE bodb02
GO

ALTER table CustInfo ADD DisableOpusCasino BIT NULL
GO
ALTER table CustInfo ADD MaxTransferOpusCasino MONEY NULL
GO
ALTER table CustInfo ADD IsAutoResetOpusCasino BIT NULL
GO
ALTER table CustInfo ADD SyncOpusCasino BIT NULL
GO


ALTER table exchange ADD MinTransferOpusCasino MONEY NULL
GO
ALTER table exchange ADD MaxTransferOpusCasino MONEY NULL
GO

----------------------------------------------------------------
--Create table on database BODB02-------------------------------
----------------------------------------------------------------

USE master
GO
ALTER DATABASE [BODB02] ADD FILEGROUP OpusCasino_Table
GO


ALTER DATABASE [BODB02]
ADD FILE 
(
	NAME = N'OpusCasinoTable_1', 
	FILENAME = N'E:\IBC_DB\OpusCasino\OpusCasinoTable_1.ndf' , 
	SIZE = 10240KB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 1024KB 
)
TO FILEGROUP OpusCasino_Table
GO


-------------------------------------------------------------------------
--Add tables GameType,StakeLevel-----------------------------------------
-------------------------------------------------------------------------

/****** Object:  Table [dbo].[StakeLevel]    Script Date: 09/30/2013 15:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StakeLevel](
	[StakeLevelID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[GameTypeID] [int] NULL,
	[MinLabel] [nvarchar](50) NULL,
	[MaxLabel] [nvarchar](50) NULL,
	[MinStake] [decimal](19, 8) NULL,
	[MaxStake] [decimal](19, 8) NULL,
	[ExchangeId] [int] NULL,
 CONSTRAINT [PK_StakeLevel] PRIMARY KEY CLUSTERED 
(
	[StakeLevelID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [OpusCasino_Table]
) ON [OpusCasino_Table]

/****** Object:  Table [dbo].[GameType]    Script Date: 09/26/2013 14:02:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameType](
	[GameTypeID] [int] NOT NULL,
	[GameTypeName] [nvarchar](50) NULL,
	[IsDisabled] [bit] NOT NULL,
	[IBCBetTypeID] [int] NULL,
 CONSTRAINT [PK_GameType] PRIMARY KEY CLUSTERED 
(
	[GameTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON OpusCasino_Table
) ON OpusCasino_Table



GO

-------------------------------------------------------------------------
-----Add table CustGameType on CustDB------------------------------------
-------------------------------------------------------------------------
ALTER DATABASE [CustDB] ADD FILEGROUP CustGameType_Table
GO

ALTER DATABASE [CustDB]
ADD FILE 
(
	NAME = N'CustGameType_Table', 
	FILENAME = N'E:\custdb\CustGameTypeTable_1.ndf' , 
	SIZE = 102400KB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 1024KB 
)
TO FILEGROUP CustGameType_Table
GO

/****** Object:  Table [dbo].[CustGameType]    Script Date: 09/26/2013 14:02:52 ******/


/****** Object:  Table [dbo].[CustGameType]    Script Date: 1/13/2014 4:24:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CustGameType](
	[GameTypeID] [int] NOT NULL,
	[CustID] [int] NOT NULL,
	[StakeLevelList] [varchar](50) NULL,
 CONSTRAINT [PK_CustGameType] PRIMARY KEY CLUSTERED 
(
	[GameTypeID] ASC,
	[CustID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [CustGameType_Table]
) ON [CustGameType_Table]

GO

SET ANSI_PADDING OFF
GO




---------------------------------------------------------------
---create table custSettingOpusHistory on bodb_CustomerLog
---------------------------------------------------------------
ALTER DATABASE [bodb_CustomerLog] ADD FILEGROUP CustSettingOpusHistory_Table
GO

ALTER DATABASE [bodb_CustomerLog]
ADD FILE 
(
	NAME = N'CustSettingOpusHistory_Table', 
	FILENAME = N'E:\IBC_DB\bodb_CustomerLog\CustSettingOpusHistoryTable_1.ndf' , 
	SIZE = 10240KB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 1024KB 
)
TO FILEGROUP CustSettingOpusHistory_Table
GO

/****** Object:  Table [dbo].[CustSettingOpusHistory]    Script Date: 09/26/2013 14:03:12 ******/
USE [bodb_CustomerLog]
GO


/****** Object:  Table [dbo].[CustSettingOpusHistory]    Script Date: 2/7/2014 1:59:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CustSettingOpusHistory](
	[CustID] [int] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[Sporttype] [smallint] NOT NULL,
	[apositiontaking] [smallmoney] NOT NULL,
	[mpositiontaking] [smallmoney] NOT NULL,
	[spositiontaking] [smallmoney] NOT NULL,
	[playerdiscount] [decimal](9, 8) NOT NULL,
	[discount] [decimal](9, 8) NOT NULL,
	[adiscount] [decimal](9, 8) NOT NULL,
	[sdiscount] [decimal](9, 8) NOT NULL,
	[UpdatedTime] [datetime] NOT NULL
) ON [CustSettingOpusHistory_Table]

GO

ALTER TABLE [dbo].[CustSettingOpusHistory] ADD  CONSTRAINT [DF_CustSettingOpusHistory_apositiontaking]  DEFAULT ((0)) FOR [apositiontaking]
GO

ALTER TABLE [dbo].[CustSettingOpusHistory] ADD  CONSTRAINT [DF_CustSettingOpusHistory_mpositiontaking]  DEFAULT ((0)) FOR [mpositiontaking]
GO

ALTER TABLE [dbo].[CustSettingOpusHistory] ADD  CONSTRAINT [DF_CustSettingOpusHistory_spositiontaking]  DEFAULT ((0)) FOR [spositiontaking]
GO

ALTER TABLE [dbo].[CustSettingOpusHistory] ADD  CONSTRAINT [DF_CustSettingOpusHistory_playerdiscount]  DEFAULT ((0)) FOR [playerdiscount]
GO

ALTER TABLE [dbo].[CustSettingOpusHistory] ADD  CONSTRAINT [DF_CustSettingOpusHistory_discount]  DEFAULT ((0)) FOR [discount]
GO

ALTER TABLE [dbo].[CustSettingOpusHistory] ADD  CONSTRAINT [DF_CustSettingOpusHistory_adiscount]  DEFAULT ((0)) FOR [adiscount]
GO

ALTER TABLE [dbo].[CustSettingOpusHistory] ADD  CONSTRAINT [DF_CustSettingOpusHistory_sdiscount]  DEFAULT ((0)) FOR [sdiscount]
GO

ALTER TABLE [dbo].[CustSettingOpusHistory] ADD  CONSTRAINT [DF_CustSettingOpusHistory_UpdatedTime]  DEFAULT (getdate()) FOR [UpdatedTime]
GO

USE [bodb_CustomerLog]
GO

/****** Object:  Index [CIX_custid_sporttype_bettype]    Script Date: 2/7/2014 2:01:13 PM ******/
CREATE CLUSTERED INDEX [CIX_custid_sporttype_bettype] ON [dbo].[CustSettingOpusHistory]
(
	[CustID] ASC,
	[Bettype] ASC,
	[Sporttype] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [CustSettingOpusHistory_Table]
GO




