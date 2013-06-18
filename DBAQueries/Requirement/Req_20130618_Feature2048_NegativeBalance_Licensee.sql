/*
	Created by:Jamie
	Date: 2013-06-18
	Task: Negative Balanace for HAIFA - Email notification
		+ Add new table [BalanceNegativeRecord]


*/

USE [bodb02]
GO

CREATE TABLE [dbo].[BalanceNegativeRecord](
	[CustID] [int] NOT NULL,
	[Balance] [money] NULL,
	[Site] [nvarchar](50) NULL,
 CONSTRAINT [PK_BalanceNegativeRecord] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [BALANCE]
) ON [BALANCE]

GO


