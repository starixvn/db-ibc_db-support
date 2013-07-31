 /*
	Created by: Elodie
	Date: 2013-07-19
	Task: Insert Log action for updating CasinoBonus status
		 
*/
--Insert log action
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
       (1145
       ,NULL
       ,'Acc_CustomerUpdDisableCasinoBonus'
       ,N'Update Enabled/Disabled Casino''s bonus status'
       ,N'Update Enabled/Disabled Casino''s bonus status'
       ,N'Update Enabled/Disabled Casino''s bonus status'
       ,N'Update Enabled/Disabled Casino''s bonus status'
       ,N'Update Enabled/Disabled Casino''s bonus status'
       ,N'Update Enabled/Disabled Casino''s bonus status'
       ,N'Update Enabled/Disabled Casino''s bonus status'
       ,null
       ,1) --not show yet now
       
       