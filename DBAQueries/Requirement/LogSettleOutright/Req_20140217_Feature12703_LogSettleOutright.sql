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
       
       
   