 USE [bodb_CustomerLog]
GO

INSERT INTO [dbo].[LogAction]
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
           ,[ActionNameVI]		   
           ,[IsInternal])
SELECT  1148, NULL, 'Acc_CustomerUpdDisableKeno', N'Update Enable/Disable Keno', N'Update Enable/Disable Keno', N'Update Enable/Disable Keno', N'Update Enable/Disable Keno', N'Update Enable/Disable Keno', N'Update Enable/Disable Keno', N'Update Enable/Disable Keno', N'Update Enable/Disable Keno', 0
 