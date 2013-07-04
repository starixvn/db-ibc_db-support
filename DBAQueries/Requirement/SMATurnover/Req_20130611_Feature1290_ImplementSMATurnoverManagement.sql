/*
	Created by: Elodie
	Date: 2013-06-11
	Task: Insert log action for SMA Management function
*/
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
           (636
           ,4
           ,'Acc_SMATurnoverIns'
           ,N'IT Admin add new super that they want to control for a match'
           ,N'IT Admin add new super that they want to control for a match'
           ,N'IT Admin add new super that they want to control for a match'
           ,N'IT Admin add new super that they want to control for a match'
           ,N'IT Admin add new super that they want to control for a match'
           ,N'IT Admin add new super that they want to control for a match'
           ,N'IT Admin add new super that they want to control for a match'
           ,null
           ,1)
           
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
           (637
           ,4
           ,'Acc_SMATurnoverUpd'
           ,N'IT Admin update max turnover of the super that they want to control for a match'
           ,N'IT Admin update max turnover of the super that they want to control for a match'
           ,N'IT Admin update max turnover of the super that they want to control for a match'
           ,N'IT Admin update max turnover of the super that they want to control for a match'
           ,N'IT Admin update max turnover of the super that they want to control for a match'
           ,N'IT Admin update max turnover of the super that they want to control for a match'
           ,N'IT Admin update max turnover of the super that they want to control for a match'
           ,null
           ,1)
GO