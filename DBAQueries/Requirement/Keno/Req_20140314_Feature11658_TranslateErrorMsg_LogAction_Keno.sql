/*
	Created by: Elodie
	Date: 2014-03-14
	Task: Translate error message and log action for Keno [Redmine:#11658]	
*/ 

----------------------------------------------------------------
--Update log action in DBTXN.bodb02.dbo.MsgError------------
----------------------------------------------------------------
USE [bodb_CustomerLog]
GO

UPDATE LogAction with (rowlock, updlock)
SET ActionNameCH = N'更新啟用/禁用快樂彩狀態',
	ActionNameCS = N'更新启用/禁用快乐彩状态',
	ActionNameTH = N'สถานะการปรับปรุงเปิด / ปิดคีโน',
	ActionNameKO = N'케노 상태 활성화/비활성화 업데이트'
WHERE ActionID = 1148
GO

----------------------------------------------------------------
--Update error message in DBTXN.bodb02.dbo.MsgError------------
----------------------------------------------------------------
USE bodb02
GO
UPDATE MsgError with (rowlock, updlock)
SET MsgNameCT = N'賬號已禁用快樂彩. 無法編輯下線',
	MsgNameCS = N'账号已禁用快乐彩. 无法编辑下线',
	MsgNameTH = N'บัญชีถูกปิดใช้งานคีโน ไม่สามารถทำการแก้ไขดาวน์ไลน์',
	MsgNameKO = N'케노 계정이 비활성화되었습니다. 다운라인을 편집할수 없습니다.'
WHERE MsgID = 60030
GO 

----------------------------------------------------------------
--Update error message in DBTXN.CustDB.dbo.MsgError------------
----------------------------------------------------------------
USE CustDB
GO
UPDATE MsgError with (rowlock, updlock)
SET MsgNameCT = N'賬號已禁用快樂彩. 無法編輯下線',
	MsgNameCS = N'账号已禁用快乐彩. 无法编辑下线',
	MsgNameTH = N'บัญชีถูกปิดใช้งานคีโน ไม่สามารถทำการแก้ไขดาวน์ไลน์',
	MsgNameKO = N'케노 계정이 비활성화되었습니다. 다운라인을 편집할수 없습니다.'
WHERE MsgID = 60030
GO 