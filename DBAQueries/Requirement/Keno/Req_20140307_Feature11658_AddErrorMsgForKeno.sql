/*
	Created by: Elodie
	Date: 2014-03-07
	Task: Add new error message for Keno [Redmine:#11658]	
*/ 
----------------------------------------------------------------
--Add new error message to DBTXN.bodb02.dbo.MsgError------------
----------------------------------------------------------------
USE bodb02
GO
INSERT INTO MsgError (MsgID, MsgGroupID, MsgNameEN, MsgNameCT, MsgNameCS, MsgNameJP, MsgNameTH, MsgNameKO, MsgNameES, MsgNameVI, IsActive) 
SELECT 60030,7,'Account disabled for Keno. Unable to edit downlines', N'Account disabled for Keno. Unable to edit downlines', N'Account disabled for Keno. Unable to edit downlines', N'Account disabled for Keno. Unable to edit downlines', N'Account disabled for Keno. Unable to edit downlines', N'Account disabled for Keno. Unable to edit downlines', N'Account disabled for Keno. Unable to edit downlines', N'Tài khoản không thể tham gia Keno. Không thể thay đổi thiết lập của thành viên cấp dưới',1
GO

----------------------------------------------------------------
--Add new error message to DBTXN.CustDB.dbo.MsgError------------
----------------------------------------------------------------
USE CustDB
GO
INSERT INTO MsgError (MsgID, MsgGroupID, MsgNameEN, MsgNameCT, MsgNameCS, MsgNameJP, MsgNameTH, MsgNameKO, MsgNameES, MsgNameVI, IsActive) 
SELECT 60030,7,'Account disabled for Keno. Unable to edit downlines', N'Account disabled for Keno. Unable to edit downlines', N'Account disabled for Keno. Unable to edit downlines', N'Account disabled for Keno. Unable to edit downlines', N'Account disabled for Keno. Unable to edit downlines', N'Account disabled for Keno. Unable to edit downlines', N'Account disabled for Keno. Unable to edit downlines', N'Tài khoản không thể tham gia Keno. Không thể thay đổi thiết lập của thành viên cấp dưới',1
GO