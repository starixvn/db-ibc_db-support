/*
	Created by: Elodie
	Date: 2014-03-18
	Task: Add new table and insert data for Keno [Redmine:#13156]	
*/ 
----------------------------------------------------------------
--Add new table DBTXN.CustDB.dbo.ProductBetSetting--------------
----------------------------------------------------------------
USE [CustDB]
GO

/****** Object:  Table [dbo].[ProductBetSetting]    Script Date: 3/18/2014 11:32:11 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProductBetSetting](
	[Sporttype] [int] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[Currency] [tinyint] NOT NULL,
	[MinBet] [money] NULL,
	[IsDep] [bit] NULL,
 CONSTRAINT [PK_ProductBetSetting] PRIMARY KEY CLUSTERED 
(
	[Sporttype] ASC,
	[Bettype] ASC,
	[Currency] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

ALTER TABLE [dbo].[ProductBetSetting] ADD  CONSTRAINT [DF_ProductBetSetting_Minbet]  DEFAULT ((0)) FOR [MinBet]
GO

----------------------------------------------------------------
--Add new table DBTXN.CustDB.dbo.ProductGlobalSetting-----------
----------------------------------------------------------------
USE [CustDB]
GO

/****** Object:  Table [dbo].[ProductGlobalSetting]    Script Date: 3/18/2014 11:32:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProductGlobalSetting](
	[Sporttype] [int] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[MaxPositiontaking] [smallmoney] NULL,
	[Maxsdiscount] [decimal](9, 8) NULL,
	[IsDep] [bit] NULL,
 CONSTRAINT [PK_ProductGlobalSetting] PRIMARY KEY CLUSTERED 
(
	[Sporttype] ASC,
	[Bettype] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

ALTER TABLE [dbo].[ProductGlobalSetting] ADD  CONSTRAINT [DF_ProductGlobalSetting_MaxPositiontaking]  DEFAULT ((0)) FOR [MaxPositiontaking]
GO

ALTER TABLE [dbo].[ProductGlobalSetting] ADD  CONSTRAINT [DF_ProductGlobalSetting_Maxsdiscount]  DEFAULT ((0)) FOR [Maxsdiscount]
GO

----------------------------------------------------------------
--Insert data into DBTXN.CustDB.dbo.ProductBetSetting-----------
----------------------------------------------------------------
USE CustDB
GO
INSERT INTO ProductBetSetting (Sporttype, Bettype, Currency, MinBet) 
SELECT 202,1501,20,10,0
UNION ALL
SELECT 202,1502,20,10,0
UNION ALL
SELECT 202,1503,20,10,0
UNION ALL
SELECT 202,1504,20,20,0
UNION ALL
SELECT 202,1505,20,15,0
UNION ALL
SELECT 202,1506,20,10,0
UNION ALL
SELECT 202,1507,20,10,0
UNION ALL
SELECT 202,1508,20,10,0
UNION ALL
SELECT 202,1509,20,10,0
GO

----------------------------------------------------------------
--Insert data into DBTXN.CustDB.dbo.ProductGlobalSetting--------
----------------------------------------------------------------
USE CustDB
GO
INSERT INTO ProductGlobalSetting (Sporttype, Bettype, MaxPositiontaking, Maxsdiscount) 
SELECT 202,1501,0.85,0,0
UNION ALL
SELECT 202,1502,0.85,0,0
UNION ALL
SELECT 202,1503,0.85,0,0
UNION ALL
SELECT 202,1504,0.85,0,0
UNION ALL
SELECT 202,1505,0.85,0,0
UNION ALL
SELECT 202,1506,0.85,0,0
UNION ALL
SELECT 202,1507,0.85,0,0
UNION ALL
SELECT 202,1508,0.85,0,0
UNION ALL
SELECT 202,1509,0.85,0,0
GO

