 /*
	Created by: Elodie
	Date: 2014-02-10
	Task: Prepare structure log for LAS
		  
*/
----------------------------------------------------------------
--Add new table to DBLOG.bodb_CustomerLog-----------------------
----------------------------------------------------------------
USE bodb_CustomerLog
GO

CREATE TABLE [dbo].[UserLog_RunSP_LAS](
	[LogID] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LogDate] [datetime] NOT NULL,
	[UserID] [int] NULL,
	[MatchID] [int] NULL,
	[ActionID] [int] NULL,
	[Remark] [varchar](500) NULL
) ON [MATCH]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[UserLog_RunSP_LAS] ADD  CONSTRAINT [DF_UserLog_RunSP_LAS_LogDate]  DEFAULT (getdate()) FOR [LogDate]
GO

CREATE CLUSTERED INDEX [CIX_MatchID] ON [dbo].[UserLog_RunSP_LAS] 
(	
	[MatchID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [MATCH]
GO


----------------------------------------------------------------
--Add new table to DBTRANS.bodb_CustomerLog-----------------------
----------------------------------------------------------------
USE bodb_CustomerLog
GO

CREATE TABLE [dbo].[UserLog_RunSP_LAS](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[LogDate] [datetime] NOT NULL,
	[UserID] [int] NULL,
	[MatchID] [int] NULL,
	[ActionID] [int] NULL,
	[Remark] [varchar](500) NULL
) ON [LogTable]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[UserLog_RunSP_LAS] ADD  CONSTRAINT [DF_UserLog_RunSP_LAS_LogDate]  DEFAULT (getdate()) FOR [LogDate]
GO

CREATE CLUSTERED INDEX [CIX_MatchID] ON [dbo].[UserLog_RunSP_LAS] 
(	
	[MatchID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [LogTable]
GO
