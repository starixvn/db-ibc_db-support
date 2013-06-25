/*
	Created by: Elodie
	Date: 2013-06-11
	Task: Insert Log action for setting IsViewReport status of Credit Term Headline
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
           ,'Acc_CreditTermUpdIsViewReport'
           ,N'Update IsViewReport status for Credit Term Headline'
           ,N'Update IsViewReport status for Credit Term Headline'
           ,N'Update IsViewReport status for Credit Term Headline'
           ,N'Update IsViewReport status for Credit Term Headline'
           ,N'Update IsViewReport status for Credit Term Headline'
           ,N'Update IsViewReport status for Credit Term Headline'
           ,N'Update IsViewReport status for Credit Term Headline'
           ,null
           ,1)