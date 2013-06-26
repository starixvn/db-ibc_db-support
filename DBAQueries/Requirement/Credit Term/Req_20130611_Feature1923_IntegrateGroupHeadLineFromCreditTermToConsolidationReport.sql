/*
	Created by: Elodie
	Date: 2013-06-11
	Task: Insert Log action for setting IsRptConsol status of Credit Term Headline
		  Add new column IsRptConsol into CustAccount table
*/
ALTER TABLE CustAccount ADD IsRptConsol BIT NOT NULL DEFAULT (0)

GO
INSERT INTO [bodb_CustomerLog].[dbo].[LogAction]
       ([ActionID]
       ,[ActionTypeID]
       ,[SPName]
       ,[ActionNameEN]
       ,[ActionNameCH]
       ,[ActionNameCS]
       ,[ActionNameJP]
       ,[ActionNameIT]
       ,[ActionNameTH]
       ,[ActionNameKO]
       ,[XsltContent]
       ,[IsInternal])
 VALUES
       (1006
       ,4
       ,'Acc_CreditTermUpdIsRptConsol'
       ,N'Update Disallowed/Allowed Consolidation Report status'
       ,N'Update Disallowed/Allowed Consolidation Report status'
       ,N'Update Disallowed/Allowed Consolidation Report status'
       ,N'Update Disallowed/Allowed Consolidation Report status'
       ,N'Update Disallowed/Allowed Consolidation Report status'
       ,N'Update Disallowed/Allowed Consolidation Report status'
       ,N'Update Disallowed/Allowed Consolidation Report status'
       ,null
       ,1)