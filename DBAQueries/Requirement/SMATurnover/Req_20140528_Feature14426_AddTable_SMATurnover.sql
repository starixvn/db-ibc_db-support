/*
	Created by: Elodie
	Date: 2014-05-28
	Task: Add Acc_CustDirect table for SMA Turnover [Redmine:#14426]	
*/

----------------------------DBTXN-------------------------------
----------------------------------------------------------------
--Add new table to DBTXN.CustDB.dbo.Acc_CustDirect--------------
----------------------------------------------------------------
USE [CustDB]
GO

/****** Object:  Table [dbo].[Acc_CustDirect]    Script Date: 05/28/2014 05:35:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Acc_CustDirect](
	[custid] [int] NOT NULL,
	[roleid] [tinyint] NOT NULL,
 CONSTRAINT [PK_Acc_CustDirect] PRIMARY KEY CLUSTERED 
(
	[custid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]

GO

----------------------------------------------------------------
--Insert data into DBTXN.CustDB.dbo.Acc_CustDirect--------------
----------------------------------------------------------------
USE [CustDB]
GO

INSERT INTO Acc_CustDirect (custid, roleid)
SELECT custid, roleid
FROM DBACC.bodb_Acc.dbo.Acc_CustDirect

GO

----------------------------DBAGE-------------------------------
----------------------------------------------------------------
--Add new table to DBAGE.bodb02.dbo.Acc_CustDirect--------------
----------------------------------------------------------------
USE [bodb02]
GO

/****** Object:  Table [dbo].[Acc_CustDirect]    Script Date: 05/28/2014 05:35:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Acc_CustDirect](
	[custid] [int] NOT NULL,
	[roleid] [tinyint] NOT NULL,
 CONSTRAINT [PK_Acc_CustDirect] PRIMARY KEY CLUSTERED 
(
	[custid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]

GO

----------------------------------------------------------------
--Insert data into DBAGE.bodb02.dbo.Acc_CustDirect--------------
----------------------------------------------------------------
USE [bodb02]
GO

INSERT INTO Acc_CustDirect (custid, roleid)
SELECT custid, roleid
FROM DBACC.bodb_Acc.dbo.Acc_CustDirect

GO

----------------------------DBACC-------------------------------
----------------------------------------------------------------
--Add new table to DBACC.bodb02.dbo.Acc_CustDirect--------------
----------------------------------------------------------------
USE [bodb02]
GO

/****** Object:  Table [dbo].[Acc_CustDirect]    Script Date: 05/28/2014 05:35:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Acc_CustDirect](
	[custid] [int] NOT NULL,
	[roleid] [tinyint] NOT NULL,
 CONSTRAINT [PK_Acc_CustDirect] PRIMARY KEY CLUSTERED 
(
	[custid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]

GO

----------------------------------------------------------------
--Insert data into DBACC.bodb02.dbo.Acc_CustDirect--------------
----------------------------------------------------------------
USE [bodb02]
GO

INSERT INTO Acc_CustDirect (custid, roleid)
SELECT custid, roleid
FROM bodb_Acc.dbo.Acc_CustDirect

GO 