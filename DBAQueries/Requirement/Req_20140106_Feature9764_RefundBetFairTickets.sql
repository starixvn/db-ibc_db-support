/*
	Created by: Elodie
	Date: 2014-01-06
	Task: Insert Log action for refunding Bet Fair tickets (Redmine:#9764)
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
       (135
       ,NULL
       ,'Admin_Settlement_Refund_BetFair'
       ,N'Refund BetFair Tickets'
       ,N'Refund BetFair Tickets'
       ,N'Refund BetFair Tickets'
       ,N'Refund BetFair Tickets'
       ,N'Refund BetFair Tickets'
       ,N'Refund BetFair Tickets'
       ,N'Refund BetFair Tickets'
       ,null
       ,0
       ,N'Refund BetFair Tickets'
       )
       
       
       