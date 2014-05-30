/*
	Created by: Elodie
	Date: 2014-05-30
	Task: Insert data for Limit Loss [Redmine:#16502]	
*/
------DBAGE-------
----------------------------------------------------------------
--Insert data into DBAGE.bodb_Age.dbo.LimitLoss_ActionItem------
----------------------------------------------------------------
USE [bodb_Age]
GO

INSERT INTO LimitLoss_ActionItem (ActionID, ActionDesc)
SELECT 1, 'Send email to recipient'
UNION ALL
SELECT 2, 'Deny bet tickets of member under this line'

GO
----------------------------------------------------------------
--Insert data into DBAGE.bodb_Age.dbo.LimitLoss_ActionConfig----
----------------------------------------------------------------
INSERT INTO LimitLoss_ActionConfig (LevelID, ActionID, Value)
SELECT 1, 1, 50
UNION ALL
SELECT 2, 1, 80
UNION ALL
SELECT 3, 1, 90

GO
----------------------------------------------------------------
--Insert data into DBAGE.bodb_Age.dbo.LimitLoss_Setting---------
----------------------------------------------------------------
INSERT INTO LimitLoss_Setting (CustID, MaxLoss)
SELECT 576313, -30000
UNION ALL
SELECT 1176070, -1172716.88
UNION ALL
SELECT 14424987, -100

GO
------DBACC-------
----------------------------------------------------------------
--Insert data into DBACC.bodb_Acc.dbo.Acc_MailingList-----------
----------------------------------------------------------------
USE [bodb_Acc]
GO

INSERT INTO Acc_MailingList (SiteId, FuncID, ToList, CcList, BccList)
SELECT 0, 322, 'kaka.huynh@nexcel.vn', '', 'paladin.dao@nexcel.vn;Susan.le@nexcel.vn;solaris.errors@gmail.com'