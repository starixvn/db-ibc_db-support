/*
	Created by: Elodie
	Date: 2013-10-11
	Task: Insert Log action for updating HR Fixed Odds status
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
       (1147
       ,NULL
       ,'Acc_CustomerUpdDisableHRFixedOdds'
       ,N'Update Enabled/Disabled HR Fixed Odds status'
       ,N'Update Enabled/Disabled HR Fixed Odds status'
       ,N'Update Enabled/Disabled HR Fixed Odds status'
       ,N'Update Enabled/Disabled HR Fixed Odds status'
       ,N'Update Enabled/Disabled HR Fixed Odds status'
       ,N'Update Enabled/Disabled HR Fixed Odds status'
       ,N'Update Enabled/Disabled HR Fixed Odds status'
       ,null
       ,0
       ,N'Cập nhật trạng thái cho phép / không cho phép chơi Horse Racing Fixed Odds'       
       )