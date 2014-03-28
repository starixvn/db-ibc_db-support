/*
	Created by: Elodie
	Date: 2014-03-28
	Task: Insert Log action for Update winlost date of LAS's ticket
		  
*/
USE bodb_CustomerLog

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
       (2904
       ,NULL
       ,'Las_UpdateWinlostDate'
       ,N'Update winlost date of LAS''s ticket'
       ,N'Update winlost date of LAS''s ticket'
       ,N'Update winlost date of LAS''s ticket'
       ,N'Update winlost date of LAS''s ticket'
       ,N'Update winlost date of LAS''s ticket'
       ,N'Update winlost date of LAS''s ticket'
       ,N'Update winlost date of LAS''s ticket'
       ,null
       ,0) 