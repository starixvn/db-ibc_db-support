/*
	Created by: Elodie
	Date: 2013-10-25
	Task: Insert Log action for inserting new super from existing super
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
       (638
       ,NULL
       ,'Acc_CustomerInsMember_CloneSetting_Com'
       ,N'Add the general information for super from existing super'
       ,N'Add the general information for super from existing super'
       ,N'Add the general information for super from existing super'
       ,N'Add the general information for super from existing super'
       ,N'Add the general information for super from existing super'
       ,N'Add the general information for super from existing super'
       ,N'Add the general information for super from existing super'
       ,null
       ,0
       ,N'Thiết lập thông tin tài khoản cho Super từ một tài khoản Super khác'       
       )
       
       
       