
/*
	Created by: Jamie
	Date: 2013-06-04
	Task: Add Maxpermatch182 for virtual Greyhounds

*/

--2. Add maxpermatch182 into Custinfo table 

ALTER TABLE dbo.custInfo ADD maxpermatch182 MONEY NULL CONSTRAINT DF_custInfo_maxpermatch182  DEFAULT 0


--3. DB05.bodb02.dbo.custinfo_old 

ALTER TABLE dbo.custinfo_old ADD maxpermatch181 MONEY NULL CONSTRAINT DF_custInfo_maxpermatch181  DEFAULT NULL


--4. DB052/DB054.bodb_CustomerLog.dbo.CustInfo_history 

ALTER TABLE dbo.CustInfo_history ADD maxpermatch181 MONEY NULL CONSTRAINT DF_custInfo_maxpermatch181  DEFAULT NULL


--4.1 Trigger : DBEXT.bod02.dbo.Custinfo_Update

