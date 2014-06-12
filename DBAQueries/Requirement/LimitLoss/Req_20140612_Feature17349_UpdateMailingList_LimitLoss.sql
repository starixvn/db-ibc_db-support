/*
	Created by: Elodie
	Date: 2014-06-12
	Task: Update data for Limit Loss Mailing list [Redmine:#17349]	
*/
------DBACC-------
----------------------------------------------------------------
--Update data into DBACC.bodb_Acc.dbo.Acc_MailingList-----------
----------------------------------------------------------------
USE [bodb_Acc]
GO

UPDATE Acc_MailingList WITH (ROWLOCK, UPDLOCK)
SET BCCList = 'julien.le@starixsoft.com;ronny.nguyen@starixsoft.com;kiwi.tran@nexcel.vn'
WHERE FuncID = 322 and siteid = 0
