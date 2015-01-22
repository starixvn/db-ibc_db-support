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
SELECT  2043, 3, 'Lrf_LicenseeBetSettingUpd', N'Update Bet Setting for super', N'Update Bet Setting for super', N'Update Bet Setting for super', N'Update Bet Setting for super', N'Update Bet Setting for super', N'Update Bet Setting for super', N'Update Bet Setting for super', N'Update Bet Setting for super', 0
UNION ALL
SELECT  2717, 1, 'Lrf_LicenseePositionTakingUpd', N'Update Position Taking for super', N'Update Position Taking for super', N'Update Position Taking for super', N'Update Position Taking for super', N'Update Position Taking for super', N'Update Position Taking for super', N'Update Position Taking for super', N'Update Position Taking for super', 0
UNION ALL
SELECT  2613, 2, 'Lrf_LicenseeCommUpd', N'Update Super Commission', N'Update Super Commission', N'Update Super Commission', N'Update Super Commission', N'Update Super Commission', N'Update Super Commission', N'Update Super Commission', N'Update Super Commission', 0
