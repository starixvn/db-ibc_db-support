/*
	Created by: Elodie
	Date: 2014-02-18
	Task: Create table UserLog_SettleOutright to record log for settlement outright and Horse Racing
	      Insert Log action for settlement outright and Horse Racing (Redmine:#12703)
*/
USE bodb_CustomerLog
CREATE TABLE [dbo].[UserLog_SettleOutright](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[LogDate] [datetime] NOT NULL,
	[UserID] [int] NULL,
	[ActionID] [int] NULL,
	[LeagueID] [int] NULL,
	[MatchID] [int] NULL,
	[EventDate] [datetime] NULL,
	[Remark] [varchar](500) NULL
) ON [MATCH]

GO

SET ANSI_PADDING OFF
GO

GRANT SELECT ON [dbo].[UserLog_SettleOutright] TO [bodbAdminNet] AS [dbo]
GO

ALTER TABLE [dbo].[UserLog_SettleOutright] ADD  CONSTRAINT [DF_userlog_settleoutright_logdate]  DEFAULT (getdate()) FOR [LogDate]
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
       ,[IsInternal]
       ,[ActionNameVI])
 VALUES
       (136
       ,NULL
       ,'Dot_Admin_SettleOutright_Event'
       ,N'Outright - Settlement event'
       ,N'Outright - Settlement event'
       ,N'Outright - Settlement event'
       ,N'Outright - Settlement event'
       ,N'Outright - Settlement event'
       ,N'Outright - Settlement event'
       ,N'Outright - Settlement event'
       ,null
       ,0
       ,N'Outright - Settlement event'
       )

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
       ,[IsInternal]
       ,[ActionNameVI])
 VALUES
       (137
       ,NULL
       ,'Dot_Admin_SettleOutright_Trans'
       ,N'Outright - Settlement ticket'
       ,N'Outright - Settlement ticket'
       ,N'Outright - Settlement ticket'
       ,N'Outright - Settlement ticket'
       ,N'Outright - Settlement ticket'
       ,N'Outright - Settlement ticket'
       ,N'Outright - Settlement ticket'
       ,null
       ,0
       ,N'Outright - Settlement ticket'
       )
       
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
       (138
       ,NULL
       ,'Dot_Admin_SettleOutright_Event'
       ,N'Outright - Refund event'
       ,N'Outright - Refund event'
       ,N'Outright - Refund event'
       ,N'Outright - Refund event'
       ,N'Outright - Refund event'
       ,N'Outright - Refund event'
       ,N'Outright - Refund event'
       ,null
       ,0
       ,N'Outright - Refund event'
       )       

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
       ,[IsInternal]
       ,[ActionNameVI])
 VALUES
       (139
       ,NULL
       ,'Dot_Admin_SettleOutright_Trans'
       ,N'Outright - Refund ticket'
       ,N'Outright - Refund ticket'
       ,N'Outright - Refund ticket'
       ,N'Outright - Refund ticket'
       ,N'Outright - Refund ticket'
       ,N'Outright - Refund ticket'
       ,N'Outright - Refund ticket'
       ,null
       ,0
       ,N'Outright - Refund ticket'
       )   

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
       ,[IsInternal]
       ,[ActionNameVI])
 VALUES
       (140
       ,NULL
       ,'DBA_SettleOutright_Undo_Event'
       ,N'Outright - Undo event'
       ,N'Outright - Undo event'
       ,N'Outright - Undo event'
       ,N'Outright - Undo event'
       ,N'Outright - Undo event'
       ,N'Outright - Undo event'
       ,N'Outright - Undo event'
       ,null
       ,0
       ,N'Outright - Undo event'
       ) 

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
       ,[IsInternal]
       ,[ActionNameVI])
 VALUES
       (141
       ,NULL
       ,'DBA_SettleOutright_Undo_Ticket'
       ,N'Outright - Undo ticket'
       ,N'Outright - Undo ticket'
       ,N'Outright - Undo ticket'
       ,N'Outright - Undo ticket'
       ,N'Outright - Undo ticket'
       ,N'Outright - Undo ticket'
       ,N'Outright - Undo ticket'
       ,null
       ,0
       ,N'Outright - Undo ticket'
       ) 