/*
	Created by: Elodie
	Date: 2014-02-10
	Task: Insert Log action for LAS Special Delete
		  
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
       (2900
       ,NULL
       ,'NAP_BettransDelSpecialDel_EarlyKO'
       ,N'Deleted ticket for early kickoff'
       ,N'Deleted ticket for early kickoff'
       ,N'Deleted ticket for early kickoff'
       ,N'Deleted ticket for early kickoff'
       ,N'Deleted ticket for early kickoff'
       ,N'Deleted ticket for early kickoff'
       ,N'Deleted ticket for early kickoff'
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
       (2901
       ,NULL
       ,'NAP_BettransDelSpecialDel_MixParlay'
       ,N'Deleted Mix Parlay ticket'
       ,N'Deleted Mix Parlay ticket'
       ,N'Deleted Mix Parlay ticket'
       ,N'Deleted Mix Parlay ticket'
       ,N'Deleted Mix Parlay ticket'
       ,N'Deleted Mix Parlay ticket'
       ,N'Deleted Mix Parlay ticket'
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
       (2902
       ,NULL
       ,'NAP_BettransDelSpecial'
       ,N'Deleted ticket'
       ,N'Deleted ticket'
       ,N'Deleted ticket'
       ,N'Deleted ticket'
       ,N'Deleted ticket'
       ,N'Deleted ticket'
       ,N'Deleted ticket'
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
       (2903
       ,NULL
       ,'NAP_BettransRecoverBet'
       ,N'Recover deleted ticket'
       ,N'Recover deleted ticket'
       ,N'Recover deleted ticket'
       ,N'Recover deleted ticket'
       ,N'Recover deleted ticket'
       ,N'Recover deleted ticket'
       ,N'Recover deleted ticket'
       ,null
       ,1) 