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
--Create table on database CustDB-------------------------------
----------------------------------------------------------------

USE master
GO
ALTER DATABASE [CustDB] ADD FILEGROUP OpusCasinoTable_1
GO
ALTER DATABASE [CustDB] ADD FILEGROUP CustSettingOpusHistory_Table
GO

ALTER DATABASE [CustDB]
ADD FILE 
(
	NAME = N'OpusCasinoTable_1', 
	FILENAME = N'E:\IBC_DB\OpusCasino\OpusCasinoTable_1.ndf' , 
	SIZE = 10240KB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 1024KB 
)
TO FILEGROUP GameTable_1
GO

ALTER DATABASE [CustDB]
ADD FILE 
(
	NAME = N'CustSettingOpusHistory_Table', 
	FILENAME = N'E:\IBC_DB\OpusCasino\CustSettingOpusHistory_Table.ndf' , 
	SIZE = 10240KB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 1024KB 
)
TO FILEGROUP CustSettingOpusHistory_Table
GO

-------------------------------------------------------------------------
--Add tables GameType,StakeLevel,CustGameType,CustSettingOpus_History----
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [OpusCasinoTable_1]
) ON [OpusCasinoTable_1]

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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON OpusCasinoTable_1
) ON OpusCasinoTable_1



GO
/****** Object:  Table [dbo].[CustGameType]    Script Date: 09/26/2013 14:02:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustGameType](
	[CustGameTypeID] [int] NOT NULL,
	[GameTypeID] [int] NULL,
	[CustID] [int] NULL,
	[StakeLevelList] [varchar](50) NULL,
 CONSTRAINT [PK_CustGameType] PRIMARY KEY CLUSTERED 
(
	[CustGameTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON OpusCasinoTable_1
) ON OpusCasinoTable_1

GO
SET ANSI_PADDING OFF

GO



/****** Object:  Table [dbo].[CustSettingOpus_History]    Script Date: 09/26/2013 14:03:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustSettingOpus_History](
	[CustID] [int] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[Sporttype] [smallint] NOT NULL,
	[apositiontaking] [smallmoney] NOT NULL CONSTRAINT [DF_CustSettingOpus_History_apositiontaking]  DEFAULT ((0)),
	[mpositiontaking] [smallmoney] NOT NULL CONSTRAINT [DF_CustSettingOpus_History_mpositiontaking]  DEFAULT ((0)),
	[spositiontaking] [smallmoney] NOT NULL CONSTRAINT [DF_CustSettingOpus_History_spositiontaking]  DEFAULT ((0)),
	[playerdiscount] [decimal](9, 8) NOT NULL CONSTRAINT [DF_CustSettingOpus_History_playerdiscount]  DEFAULT ((0)),
	[discount] [decimal](9, 8) NOT NULL CONSTRAINT [DF_CustSettingOpus_History_discount]  DEFAULT ((0)),
	[adiscount] [decimal](9, 8) NOT NULL CONSTRAINT [DF_CustSettingOpus_History_adiscount]  DEFAULT ((0)),
	[sdiscount] [decimal](9, 8) NOT NULL CONSTRAINT [DF_CustSettingOpus_History_sdiscount]  DEFAULT ((0)),
	[UpdatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_CustSettingOpus_History] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[Bettype] ASC,
	[Sporttype] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustSettingOpusHistory_Table]
) ON [CustSettingOpusHistory_Table]
