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


