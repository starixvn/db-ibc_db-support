/*
	Created by: Elodie
	Date: 2014-06-05
	Task: Add new table GameType_tmp for Keno [Redmine:#17205]	
*/ 
----------------------------------------------------------------
--Add new table DBAGE.bodb02.dbo.GameType_tmp-------------------
---------------------------------------------------------------- 

USE [bodb02]
GO

/****** Object:  Table [dbo].[GameType_tmp]    Script Date: 6/5/2014 4:26:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GameType_tmp](
	[GameTypeID] [int] NOT NULL,
	[GameTypeName] [nvarchar](50) NULL,
	[IsDisabled] [bit] NULL,
	[IBCBetTypeID] [int] NULL,
 CONSTRAINT [PK_GameType_tmp] PRIMARY KEY CLUSTERED 
(
	[GameTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

ALTER TABLE [dbo].[GameType_tmp] ADD  CONSTRAINT [DF_GameType_tmp_IsDisabled]  DEFAULT ((0)) FOR [IsDisabled]
GO

----------------------------------------------------------------
--Insert data into DBAGE.bodb02.dbo.GameType_tmp-------------------
---------------------------------------------------------------- 
INSERT INTO GameType_tmp(GameTypeID, GameTypeName, IsDisabled, IBCBetTypeID)
SELECT GameTypeID, GameTypeName, IsDisabled, IBCBetTypeID
FROM GameType WITH (NOLOCK)

GO
UPDATE GameType_tmp set GameTypeID = 11, IBCBetTypeID = 1511, GameTypeName = 'Kentucky' where GameTypeID = 2
GO
UPDATE GameType_tmp set GameTypeID = 13, IBCBetTypeID = 1513, GameTypeName = 'Michigan' where GameTypeID = 6

