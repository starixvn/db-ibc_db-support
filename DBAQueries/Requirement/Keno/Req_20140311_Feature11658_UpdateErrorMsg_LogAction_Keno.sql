/*
	Created by: Elodie
	Date: 2014-03-11
	Task: Update error message and log action for Keno [Redmine:#11658]	
*/ 

----------------------------------------------------------------
--Update log action in DBTXN.bodb02.dbo.MsgError------------
----------------------------------------------------------------
USE [bodb_CustomerLog]
GO

UPDATE LogAction with (rowlock, updlock)
SET ActionNameEN = 'Update Enable/Disable Keno status',
	ActionNameCH = 'Update Enable/Disable Keno status',
	ActionNameCS = 'Update Enable/Disable Keno status',
	ActionNameJP = 'Update Enable/Disable Keno status',
	ActionNameIT = 'Update Enable/Disable Keno status',
	ActionNameTH = 'Update Enable/Disable Keno status',
	ActionNameKO = 'Update Enable/Disable Keno status',
	ActionNameVI = N'Cập nhật trạng thái cho phép / không cho phép chơi Keno'
WHERE ActionID = 1148
GO

----------------------------------------------------------------
--Update error message in DBTXN.bodb02.dbo.MsgError------------
----------------------------------------------------------------
USE bodb02
GO
UPDATE MsgError with (rowlock, updlock)
SET MsgNameEN = 'Account was disabled Keno. Unable to edit downlines',
	MsgNameCT = 'Account was disabled Keno. Unable to edit downlines',
	MsgNameCS = 'Account was disabled Keno. Unable to edit downlines',
	MsgNameJP = 'Account was disabled Keno. Unable to edit downlines',
	MsgNameTH = 'Account was disabled Keno. Unable to edit downlines',
	MsgNameKO = 'Account was disabled Keno. Unable to edit downlines',
	MsgNameES = 'Account was disabled Keno. Unable to edit downlines'
WHERE MsgID = 60030
GO 
----------------------------------------------------------------
--Update error message in DBTXN.CustDB.dbo.MsgError------------
----------------------------------------------------------------
USE CustDB
GO
UPDATE MsgError with (rowlock, updlock)
SET MsgNameEN = 'Account was disabled Keno. Unable to edit downlines',
	MsgNameCT = 'Account was disabled Keno. Unable to edit downlines',
	MsgNameCS = 'Account was disabled Keno. Unable to edit downlines',
	MsgNameJP = 'Account was disabled Keno. Unable to edit downlines',
	MsgNameTH = 'Account was disabled Keno. Unable to edit downlines',
	MsgNameKO = 'Account was disabled Keno. Unable to edit downlines',
	MsgNameES = 'Account was disabled Keno. Unable to edit downlines'
WHERE MsgID = 60030
GO