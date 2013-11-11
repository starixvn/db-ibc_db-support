 USE [bodb_RMS]
GO
/****** Object:  Table [dbo].[rmAgent]    Script Date: 11/11/2013 13:30:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rmAgent](
	[AgentID] [int] NOT NULL,
	[username] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[createdDate] [datetime] NULL,
	[creator] [int] NULL,
 CONSTRAINT [PK_rmAgent] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [rmCustomer]
) ON [rmCustomer]


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
           ,[IsInternal]
           ,[ActionNameVI])
  SELECT 10402,NULL,'RMS_DangerousAgentIns','Add new dangerous agent','Add new dangerous agent','Add new dangerous agent','Add new dangerous agent','Add new dangerous agent','Add new dangerous agent','Add new dangerous agent',0,'Add new dangerous agent'
UNION 
 SELECT 10403,NULL,'RMS_DangerousAgentDel','Delete dangerous agent','Delete dangerous agent','Delete dangerous agent','Delete dangerous agent','Delete dangerous agent','Delete dangerous agent','Delete dangerous agent',0,'Delete dangerous agent'
