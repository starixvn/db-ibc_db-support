 


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
 SELECT  229, 2, 'Acc_CustomerUpdSuperOpusCS_Commission', N'Update Opus Casino Commission for super', N'Update Opus Casino Commission for super', N'Update Opus Casino Commission for super', N'Update Opus Casino Commission for super', N'Update Opus Casino Commission for super', N'Update Opus Casino Commission for super', N'Update Opus Casino Commission for super', N'Update Opus Casino Commission for super',0
 UNION ALL
 SELECT  230, 2, 'Acc_CustomerUpdMasterOpusCS_Commission',N'Update Opus Casino Commission for master',N'Update Opus Casino Commission for master',N'Update Opus Casino Commission for master',N'Update Opus Casino Commission for master',N'Update Opus Casino Commission for master',N'Update Opus Casino Commission for master',N'Update Opus Casino Commission for master',N'Update Opus Casino Commission for master',0
 UNION ALL
 SELECT  231, 2, 'Acc_CustomerUpdMasterOpusCS_Commission', N'Update Opus Casino Commission for agent', N'Update Opus Casino Commission for agent', N'Update Opus Casino Commission for agent', N'Update Opus Casino Commission for agent', N'Update Opus Casino Commission for agent', N'Update Opus Casino Commission for agent', N'Update Opus Casino Commission for agent', N'Update Opus Casino Commission for agent',0
 UNION ALL
 SELECT  232, 2, 'Acc_CustomerUpdMemberOpusCS_Commission', N'Update Opus Casino Commission for member', N'Update Opus Casino Commission for member', N'Update Opus Casino Commission for member', N'Update Opus Casino Commission for member', N'Update Opus Casino Commission for member', N'Update Opus Casino Commission for member', N'Update Opus Casino Commission for member', N'Update Opus Casino Commission for member',0
 UNION ALL

 SELECT  378, 3, 'Acc_UpdateMaxTransferOpusCS', N'Update Opus Casino Max Transfer Credit', N'Update Opus Casino Max Transfer Credit', N'Update Opus Casino Max Transfer Credit', N'Update Opus Casino Max Transfer Credit', N'Update Opus Casino Max Transfer Credit', N'Update Opus Casino Max Transfer Credit', N'Update Opus Casino Max Transfer Credit', N'Update Opus Casino Max Transfer Credit', 0
 UNION ALL

  SELECT  436, 1, 'Acc_CustomerUpdSuperOpusCS_Positiontaking', N'Update Opus Casino Position Taking for super', N'Update Opus Casino Position Taking for super', N'Update Opus Casino Position Taking for super', N'Update Opus Casino Position Taking for super', N'Update Opus Casino Position Taking for super', N'Update Opus Casino Position Taking for super', N'Update Opus Casino Position Taking for super', N'Update Opus Casino Position Taking for super',0
 UNION ALL
 SELECT  437, 1, 'Acc_CustomerUpdMasterOpusCS_PositionTaking', N'Update Opus Casino Position Taking for master', N'Update Opus Casino Position Taking for master', N'Update Opus Casino Position Taking for master', N'Update Opus Casino Position Taking for master', N'Update Opus Casino Position Taking for master', N'Update Opus Casino Position Taking for master', N'Update Opus Casino Position Taking for master', N'Update Opus Casino Position Taking for master',0
 UNION ALL
 SELECT  438, 1, 'Acc_CustomerUpdAgentOpusCS_Positiontaking', N'Update Opus Casino Position Taking for agent', N'Update Opus Casino Position Taking for agent', N'Update Opus Casino Position Taking for agent', N'Update Opus Casino Position Taking for agent', N'Update Opus Casino Position Taking for agent', N'Update Opus Casino Position Taking for agent', N'Update Opus Casino Position Taking for agent', N'Update Opus Casino Position Taking for agent', 0
 UNION ALL
 SELECT  439, 1, 'Acc_CustomerUpdMemberOpusCS_Positiontaking', N'Update Opus Casino Position Taking for member', N'Update Opus Casino Position Taking for member', N'Update Opus Casino Position Taking for member', N'Update Opus Casino Position Taking for member', N'Update Opus Casino Position Taking for member', N'Update Opus Casino Position Taking for member', N'Update Opus Casino Position Taking for member', N'Update Opus Casino Position Taking for member', 0
 UNION ALL
 SELECT  440, 1, 'Acc_CustomerUpdMemberOpusCS_SAg', N'Update Super''s Opus Casino Position Taking for member', N'Update Super''s Opus Casino Position Taking for member', N'Update Super''s Opus Casino Position Taking for member', N'Update Super''s Opus Casino Position Taking for member', N'Update Super''s Opus Casino Position Taking for member', N'Update Super''s Opus Casino Position Taking for member', N'Update Super''s Opus Casino Position Taking for member', N'Update Super''s Opus Casino Position Taking for member',0
 UNION ALL
 SELECT  441, 1, 'Acc_CustomerUpdMemberOpusCS_MAg', N'Update Master''s Opus Casino Position Taking for member', N'Update Master''s Opus Casino Position Taking for member', N'Update Master''s Opus Casino Position Taking for member', N'Update Master''s Opus Casino Position Taking for member', N'Update Master''s Opus Casino Position Taking for member', N'Update Master''s Opus Casino Position Taking for member', N'Update Master''s Opus Casino Position Taking for member', N'Update Master''s Opus Casino Position Taking for member',0
 UNION ALL
 SELECT  505, 1, 'Acc_CustOverrideUpdOpusCS', N'Update Opus Casino Min Position Taking', N'Update Opus Casino Min Position Taking', N'Update Opus Casino Min Position Taking', N'Update Opus Casino Min Position Taking', N'Update Opus Casino Min Position Taking', N'Update Opus Casino Min Position Taking', N'Update Opus Casino Min Position Taking', N'Update Opus Casino Min Position Taking', 0
 
 UNION ALL
 SELECT  1146, NULL, 'Acc_CustomerUpdDisableCSOpus', N'Update enable/disable Opus Casino', N'Update enable/disable Opus Casino', N'Update enable/disable Opus Casino', N'Update enable/disable Opus Casino', N'Update enable/disable Opus Casino', N'Update enable/disable Opus Casino', N'Update enable/disable Opus Casino', N'Update enable/disable Opus Casino', 0
 