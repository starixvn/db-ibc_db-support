
/*
	Created by: Jamie
	Date: 2013-08-28
	Task: Add Maxpermatch184 for Virtual Motor Racing 

*/

--1. Add maxpermatch184 into Custinfo table [DBTRANS and Replicated DBs]

ALTER TABLE dbo.custInfo ADD maxpermatch184 MONEY NULL CONSTRAINT DF_custInfo_maxpermatch184  DEFAULT 0


--2. DB052/DB054.bodb_CustomerLog.dbo.CustInfo_history 

ALTER TABLE dbo.CustInfo_history ADD maxpermatch184 MONEY NULL


--2.1 Trigger : DB052/DB054.bodb02.dbo.Custinfo_Update


--3. DB05.bodb_Customer.dbo.custinfo_old 

ALTER TABLE dbo.custinfo_old ADD maxpermatch184 MONEY NULL 

