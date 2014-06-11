/*
	Created by: Elodie
	Date: 2014-06-11
	Task: Insert data for Limit Loss [Redmine:#17349]	
*/
------DBAGE-------
----------------------------------------------------------------
--Insert data into DBAGE.bodb_Age.dbo.LimitLoss_Setting---------
----------------------------------------------------------------
USE [bodb_Age]
GO

INSERT INTO LimitLoss_Setting (CustID, MaxLoss)
SELECT 14827246, -1000000.00 UNION ALL
SELECT 14827154, -300000.00 UNION ALL
SELECT 14810752, -200000.00 UNION ALL
SELECT 14822871, -500000.00 UNION ALL
SELECT 14809502, -5000000.00 
 