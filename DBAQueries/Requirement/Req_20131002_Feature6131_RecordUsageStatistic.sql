/*
	Created by: Elodie
	Date: 2013-10-02
	Task: Create table UserLog_UsageStatistic to record usage statistic for the update functions [Redmine:#6131]
*/ 

CREATE TABLE [dbo].[UserLog_UsageStatistic](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustID] [int] NOT NULL,
	[RoleID] [tinyint] NOT NULL,
	[ActionID] [int] NOT NULL,
	[LogDate] [datetime] NOT NULL,
	[ServerID] [tinyint] NOT NULL,
	[Device] [nvarchar](500) NULL,
 CONSTRAINT [PK_UserLog_UsageStatistic] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]