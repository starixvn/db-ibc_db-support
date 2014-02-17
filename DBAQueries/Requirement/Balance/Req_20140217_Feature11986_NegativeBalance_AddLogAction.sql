/*
	Created by: Elodie
	Date: 2014-02-17
	Task: Insert Log action for settlement outright (Redmine:#11986)
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
       ,[IsInternal]
       ,[ActionNameVI])
 VALUES
       (130
       ,NULL
       ,'Dot_Admin_SettleOutright_Trans'
       ,N'Outright settlement for ticket'
       ,N'Outright settlement for ticket'
       ,N'Outright settlement for ticket'
       ,N'Outright settlement for ticket'
       ,N'Outright settlement for ticket'
       ,N'Outright settlement for ticket'
       ,N'Outright settlement for ticket'
       ,null
       ,0
       ,N'Outright settlement for ticket'
       )
       
       
   