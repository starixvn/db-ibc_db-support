/*
	Created by: Elodie
	Date: 2014-03-03
	Task: Prepare structure for Keno in phrase 1 [Redmine:#11658]
	DB: DBTXN, DBPRO
*/ 
----------------------------------------------------------------
--Add new sporttype Keno to DBPRO.bodb02.dbo.Sports-------------------------------
----------------------------------------------------------------
USE bodb02
INSERT INTO Sports (SportType, SportName, SportNameCh, SportNameCs, SportNameJp, SportNameIt, SportNameTh, ParlayMaxPayout, SportNameKo, SportNameES, SportNameVN, SportNameEL) VALUES
(202, N'Keno', N'Keno', N'Keno', N'Keno',N'Keno',N'Keno', NULL, N'Keno', N'Keno', N'Keno', N'Keno', N'Keno', N'Keno')
GO

--Add new bettype Keno to DBPRO.bodb02.dbo.Bettype-------------------------------
INSERT INTO bettype (typeid, typenamee, typenamec, typedesc, creator, typenamec_uni, typenamej, typenamcn, typenamecn, typenameth, typenameit, typenameko, typenameES, typenameVN, typenameEL, typenamee_Eu, typenameRU, typenameID) 
SELECT 1501, 'Australia Acttab', 'Australia Acttab', NULL, NULL, 'Australia Acttab', 'Australia Acttab', 'Australia Acttab', 'Australia Acttab', 'Australia Acttab', 'Australia Acttab', 'Australia Acttab', 'Australia Acttab', 'Australia Acttab', 'Australia Acttab', 'Australia Acttab', 'Australia Acttab', 'Australia Acttab'
UNION ALL
SELECT 1502, 'Bejing Keno 8', 'Bejing Keno 8', NULL, NULL, 'Bejing Keno 8', 'Bejing Keno 8', 'Bejing Keno 8', 'Bejing Keno 8', 'Bejing Keno 8', 'Bejing Keno 8', 'Bejing Keno 8', 'Bejing Keno 8', 'Bejing Keno 8', 'Bejing Keno 8', 'Bejing Keno 8', 'Bejing Keno 8', 'Bejing Keno 8'
UNION ALL
SELECT 1503, 'Slovakia Eklub', 'Slovakia Eklub', NULL, NULL, 'Slovakia Eklub', 'Slovakia Eklub', 'Slovakia Eklub', 'Slovakia Eklub', 'Slovakia Eklub', 'Slovakia Eklub', 'Slovakia Eklub', 'Slovakia Eklub', 'Slovakia Eklub', 'Slovakia Eklub', 'Slovakia Eklub', 'Slovakia Eklub', 'Slovakia Eklub'
UNION ALL
SELECT 1504, 'Canada Keno', 'Canada Keno', NULL, NULL, 'Canada Keno', 'Canada Keno', 'Canada Keno', 'Canada Keno', 'Canada Keno', 'Canada Keno', 'Canada Keno', 'Canada Keno', 'Canada Keno', 'Canada Keno', 'Canada Keno', 'Canada Keno', 'Canada Keno'
UNION ALL
SELECT 1505, 'West Canada Keno', 'West Canada Keno', NULL, NULL, 'West Canada Keno', 'West Canada Keno', 'West Canada Keno', 'West Canada Keno', 'West Canada Keno', 'West Canada Keno', 'West Canada Keno', 'West Canada Keno', 'West Canada Keno', 'West Canada Keno', 'West Canada Keno', 'West Canada Keno', 'West Canada Keno'
UNION ALL
SELECT 1506, 'Taiwan Bingo Bingo', 'Taiwan Bingo Bingo', NULL, NULL, 'Taiwan Bingo Bingo', 'Taiwan Bingo Bingo', 'Taiwan Bingo Bingo', 'Taiwan Bingo Bingo', 'Taiwan Bingo Bingo', 'Taiwan Bingo Bingo', 'Taiwan Bingo Bingo', 'Taiwan Bingo Bingo', 'Taiwan Bingo Bingo', 'Taiwan Bingo Bingo', 'Taiwan Bingo Bingo', 'Taiwan Bingo Bingo', 'Taiwan Bingo Bingo'
UNION ALL
SELECT 1507, 'Massac', 'Massac', NULL, NULL, 'Massac', 'Massac', 'Massac', 'Massac', 'Massac', 'Massac', 'Massac', 'Massac', 'Massac', 'Massac', 'Massac', 'Massac', 'Massac'
UNION ALL
SELECT 1508, 'Ohio', 'Ohio', NULL, NULL, 'Ohio', 'Ohio', 'Ohio', 'Ohio', 'Ohio', 'Ohio', 'Ohio', 'Ohio', 'Ohio', 'Ohio', 'Ohio', 'Ohio', 'Ohio'
UNION ALL
SELECT 1509, 'Malta', 'Malta', NULL, NULL, 'Malta', 'Malta', 'Malta', 'Malta', 'Malta', 'Malta', 'Malta', 'Malta', 'Malta', 'Malta', 'Malta', 'Malta', 'Malta'
GO

----------------------------------------------------------------
--Add new fields to DBTXN.CustDB.dbo.custinfo------------------------------------
----------------------------------------------------------------
USE CustDB
ALTER TABLE dbo.custInfo ADD HideKeno BIT NOT NULL CONSTRAINT DF_custInfo_HideKeno DEFAULT 0
GO

----------------------------------------------------------------
--Add new fields to DB05.bodb_Customer.dbo.custinfo_old tables--
----------------------------------------------------------------
USE bodb_Customer
ALTER TABLE dbo.custInfo_old ADD HideKeno BIT NOT NULL CONSTRAINT DF_custInfo_HideKeno DEFAULT 0
GO

--------------------------------------------------------------------------
--Add new fields into DB052/DB054.bodb_CustomerLog.dbo.custinfo_history tables--
--------------------------------------------------------------------------
USE bodb_CustomerLog
ALTER TABLE dbo.custInfo_history ADD HideKeno BIT NOT NULL CONSTRAINT DF_custInfo_HideKeno DEFAULT 0
GO

----------------------------------------------------------------
--Modify trigger DB052.bodb02.dbo.CustInfo_update---------------
----------------------------------------------------------------
USE bodb02
ALTER TRIGGER [dbo].[CustInfo_update] ON [dbo].[custInfo] AFTER UPDATE
AS
/*
Created by: 20120731@
Task: Trigger for updating Custinfo table 
DB: DBEXT/bodb02
Revisions: 
    - 20120731@Dan: add fields for Virtual soccer
    - 20120821@Elodie: add Abnormal fields to support Abnormal bets
    - 20120925@Dan: add fields for LCS-Win Limit
    - 20121004@Johnson: add double comm losing status
    - 20130125@Tom: add fields for Virtual Tennis
    - 20130221@Elodie: add field maxpermatch181 for Virtual Horse Racing
    - 20130604@Jamie: Add new field maxpermatch182 for Virtual Greyhound
    - 20130718@Lukas: add column DisableCasinoBonus 
    - 20130830@Jamie: Add MaxPerMatch184 for Virtual Motor Racing 
    - 20131011@Elodie: Add HR Fixed Odds [Redmine:#6505]
    - 20131022@Lukas: add autosuspend2 for other sports [Redmine:#5520]
	- 20131022@Lukas: add maxpermatch for virtual Speedway & Cycling [Redmine:#5520]
	- 20140224@Elodie: Add Keno [Redmine:#11658]

*/
SET NOCOUNT ON
INSERT INTO bodb_CustomerLog.dbo.CustInfo_history (
                username, custid, currency, roleid, srecommend, mrecommend, recommend, dangercust, autosuspend, reject, credit, closed, MatchLimit,
                  VirtualMultiplier, maxpermatch, maxpermatch2, maxpermatch3, maxpermatch5, maxpermatch8, maxpermatch10, maxpermatch11, maxpermatch12,
                  maxpermatch99, [Enabled], danger, maxpermatch151, maxpermatch201, DisableHorseRacing, DisableFinancial, DisableCasino,
                  SyncCasino, danger2, danger3, DisableOutright, DisableOpenTote, maxpermatch151_OT
                  ,[DisableBingo]
                  ,[DisableNumber]
                  ,[SyncBingo]
                  ,[MaxPerMatch161]
                  ,[MaxPerMatch99MP]
                  ,[MaxPerBall161]
                  ,MaxtransferP2P
                  ,IsAutoResetP2P
                  ,DisableP2P
                  ,DisableFunP2P
                  ,DisableLiveCasino
                  ,SyncLiveCasino
                  ,DisableVirtualSports
                  ,HideVirtualSports
                  ,maxpermatch180
                  ,maxpermatch181
                  ,maxpermatch182
                  ,maxpermatch186
                  ,Abnormal
                  ,isAutoResetLiveCasino
                  ,MaxWinLiveCasino
                  ,DoubleCommLosing
                  ,DisableCasinoBonus 
                  ,maxpermatch184
                  ,MaxPerMatch154
                  ,DisableHRFixedOdds
                  ,autosuspend2
				  ,maxpermatch183
				  ,maxpermatch185
				  ,HideKeno
                )
SELECT
                username, custid, currency, roleid, srecommend, mrecommend, recommend, dangercust, autosuspend, reject, credit, closed, MatchLimit,
                  VirtualMultiplier, maxpermatch, maxpermatch2, maxpermatch3, maxpermatch5, maxpermatch8, maxpermatch10, maxpermatch11, maxpermatch12,
                  maxpermatch99, [Enabled], danger, maxpermatch151, maxpermatch201, DisableHorseRacing, DisableFinancial, DisableCasino,
                  SyncCasino, danger2, danger3, DisableOutright, DisableOpenTote, maxpermatch151_OT
                  ,[DisableBingo]
                  ,[DisableNumber]
                  ,[SyncBingo]
                  ,[MaxPerMatch161]
                  ,[MaxPerMatch99MP]
                  ,[MaxPerBall161]
                  ,MaxtransferP2P
                  ,IsAutoResetP2P
                  ,DisableP2P
                  ,DisableFunP2P
                  ,DisableLiveCasino
                  ,SyncLiveCasino
                  ,DisableVirtualSports
                  ,HideVirtualSports
                  ,maxpermatch180
                  ,maxpermatch181
                  ,maxpermatch182
                  ,maxpermatch186
                  ,Abnormal
                  ,isAutoResetLiveCasino
                  ,MaxWinLiveCasino
                  ,DoubleCommLosing
                  ,DisableCasinoBonus 
                  ,maxpermatch184
				  ,MaxPerMatch154
                  ,DisableHRFixedOdds
                  ,autosuspend2
				  ,maxpermatch183
				  ,maxpermatch185
				  ,HideKeno
FROM [DELETED]
GO

--Create table GameType in DBPRO.bodb02
USE bodb02
CREATE TABLE [dbo].[GameType](
           [GameTypeID] [int] NOT NULL,
           [GameTypeName] [nvarchar](50) NULL,
           [IsDisabled] [bit] NULL,
           [IBCBetTypeID] [int] NULL,
CONSTRAINT [PK_GameType] PRIMARY KEY CLUSTERED
(
           [GameTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]
GO
ALTER TABLE [dbo].[GameType] ADD  CONSTRAINT [DF_GameType_IsDisabled]  DEFAULT ((0)) FOR [IsDisabled]

GO
INSERT INTO GameType (GameTypeID, GameTypeName, IsDisabled, IBCBetTypeID) 
SELECT 1,'Australia Acttab', 0, 1501
UNION ALL
SELECT 2,'Bejing Keno 8', 0, 1502
UNION ALL
SELECT 3,'Slovakia Eklub', 0, 1503
UNION ALL
SELECT 4,'Canada Keno', 0, 1504
UNION ALL
SELECT 5,'West Canada Keno', 0, 1505
UNION ALL
SELECT 6,'Taiwan Bingo Bingo', 0, 1506
UNION ALL
SELECT 7,'Massac', 0, 1507
UNION ALL
SELECT 8,'Ohio', 0, 1508
UNION ALL
SELECT 9,'Malta', 0, 1509

--Create table CustGameType
GO
USE CustDB
CREATE TABLE [dbo].[CustGameType](
           [CustID] [int] NOT NULL,
           [GameTypeID] [int] NOT NULL,
           [StakeLevelList] [varchar](50) NULL,       -- keno project: this field will be null
           [MaxPerGameType] [money] NULL,
           [MinBet] [money] NULL,
           [MaxBet] [money] NULL,
           [IsDisabled] [bit] NOT NULL,
CONSTRAINT [PK_CustGameType] PRIMARY KEY NONCLUSTERED
(
           [CustID] ASC,
           [GameTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [CustGameType_table]
) ON [CustGameType_table]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[CustGameType] ADD  CONSTRAINT [DF_CustGameType_IsDisabled]  DEFAULT ((0)) FOR [IsDisabled]

--Create table TransLog
GO
USE bodb02
CREATE TABLE [dbo].[TransLog](

           [translogid] [bigint] IDENTITY(1,1) NOT NULL,

           [custid] [int] NOT NULL,

           [transdate] [datetime] NOT NULL,

           [odds] [smallmoney] NULL,

           [stake] [money] NOT NULL,

           [status] [nvarchar](10) NULL,

           [apositiontaking] [smallmoney] NULL,

           [mpositiontaking] [smallmoney] NULL,

           [tpositiontaking] [smallmoney] NULL,

           [spositiontaking] [smallmoney] NULL,

           [playerdiscount] [decimal](9, 8) NULL,

           [discount] [decimal](9, 8) NULL,

           [adiscount] [decimal](9, 8) NULL,

           [sdiscount] [decimal](9, 8) NULL,

           [creator] [int] NOT NULL,

           [winlostdate] [smalldatetime] NULL,

           [betfrom] [nvarchar](1) NULL,

           [virtualrate] [float] NOT NULL,

           [actualrate] [float] NULL,

           [actual_stake] [money] NULL,

           [currency] [tinyint] NULL,

           [CurrencyName] [nvarchar](50) NULL,

           [recommend] [int] NOT NULL,

           [mrecommend] [int] NOT NULL,

           [srecommend] [int] NOT NULL,

           [ip] [nvarchar](15) NULL,

           [statusID] [tinyint] NULL,

           [balance] [money] NULL,

           [Username] [nvarchar](50) NULL,

           [transdesc] [nvarchar](300) NULL,

           [productID] [int] NOT NULL,

           [gameID] [int] NOT NULL,

           [eventID] [int] NOT NULL,

           [vendorID] [int] NOT NULL,

CONSTRAINT [PK_translog] PRIMARY KEY NONCLUSTERED
(
           [translogid] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Bettrans_index3]

) ON [Bettrans_table]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_transdate]  DEFAULT (getdate()) FOR [transdate]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_odds]  DEFAULT ((0)) FOR [odds]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_stake]  DEFAULT ((0)) FOR [stake]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_apositiontaking]  DEFAULT ((0)) FOR [apositiontaking]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_mpositiontaking]  DEFAULT ((0)) FOR [mpositiontaking]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_tpositiontaking]  DEFAULT ((0)) FOR [tpositiontaking]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_spositiontaking]  DEFAULT ((0)) FOR [spositiontaking]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_playerdiscount]  DEFAULT ((0)) FOR [playerdiscount]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_discount]  DEFAULT ((0)) FOR [discount]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_adiscount]  DEFAULT ((0)) FOR [adiscount]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_sdiscount]  DEFAULT ((0)) FOR [sdiscount]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_creator]  DEFAULT ((0)) FOR [creator]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_betfrom]  DEFAULT ('i') FOR [betfrom]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_virtualrate]  DEFAULT ((0)) FOR [virtualrate]
GO

ALTER TABLE [dbo].[translog] ADD  CONSTRAINT [DF_translog_actual_stake]  DEFAULT ((0)) FOR [actual_stake]
GO
