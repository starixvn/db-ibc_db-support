/*
	Created by: Elodie
	Date: 2014-04-11
	Task: Add new error message for Keno [Redmine:#13156]	
*/ 
----------------------------------------------------------------
--Add new error message to DBTXN.bodb02.dbo.MsgError------------
----------------------------------------------------------------
USE bodb02
GO
INSERT INTO MsgError (MsgID, MsgGroupID, MsgNameEN, MsgNameCT, MsgNameCS, MsgNameJP, MsgNameTH, MsgNameKO, MsgNameES, MsgNameVI, IsActive) 
SELECT 10030,2,'Min Bet must be greater than or equal to Min Bet limit.', N'Min Bet must be greater than or equal to Min Bet limit.', N'Min Bet must be greater than or equal to Min Bet limit.', N'Min Bet must be greater than or equal to Min Bet limit.', N'Min Bet must be greater than or equal to Min Bet limit.', N'Min Bet must be greater than or equal to Min Bet limit.', N'Min Bet must be greater than or equal to Min Bet limit.', N'Min Bet must be greater than or equal to Min Bet limit.',1
GO

----------------------------------------------------------------
--Add new error message to DBTXN.CustDB.dbo.MsgError------------
----------------------------------------------------------------
USE CustDB
GO
INSERT INTO MsgError (MsgID, MsgGroupID, MsgNameEN, MsgNameCT, MsgNameCS, MsgNameJP, MsgNameTH, MsgNameKO, MsgNameES, MsgNameVI, IsActive) 
SELECT 10030,2,'Min Bet must be greater than or equal to Min Bet limit.', N'Min Bet must be greater than or equal to Min Bet limit.', N'Min Bet must be greater than or equal to Min Bet limit.', N'Min Bet must be greater than or equal to Min Bet limit.', N'Min Bet must be greater than or equal to Min Bet limit.', N'Min Bet must be greater than or equal to Min Bet limit.', N'Min Bet must be greater than or equal to Min Bet limit.', N'Min Bet must be greater than or equal to Min Bet limit.',1
GO