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
SELECT  233, NULL, 'Acc_CustomerUpdSuperKeno_Commission', N'Update Keno Commission for super', N'Update Keno Commission for super', N'Update Keno Commission for super', N'Update Keno Commission for super', N'Update Keno Commission for super', N'Update Keno Commission for super', N'Update Keno Commission for super', N'Update Keno Commission for super', 0
UNION ALL
SELECT  234, NULL, 'Acc_CustomerUpdMasterKeno_Commission', N'Update Keno Commission for master', N'Update Keno Commission for master', N'Update Keno Commission for master', N'Update Keno Commission for master', N'Update Keno Commission for master', N'Update Keno Commission for master', N'Update Keno Commission for master', N'Update Keno Commission for master', 0
UNION ALL
SELECT  235, NULL, 'Acc_CustomerUpdAgentKeno_Commission', N'Update Keno Commission for agent', N'Update Keno Commission for agent', N'Update Keno Commission for agent', N'Update Keno Commission for agent', N'Update Keno Commission for agent', N'Update Keno Commission for agent', N'Update Keno Commission for agent', N'Update Keno Commission for agent', 0
UNION ALL
SELECT  236, NULL, 'Acc_CustomerUpdMemberKeno_Commission', N'Update Keno Commission for member', N'Update Keno Commission for member', N'Update Keno Commission for member', N'Update Keno Commission for member', N'Update Keno Commission for member', N'Update Keno Commission for member', N'Update Keno Commission for member', N'Update Keno Commission for member', 0
UNION ALL
SELECT  446, NULL, 'Acc_CustomerUpdMemberKeno_MAg', N'Update Master''s Keno Position Taking for member', N'Update Master''s Keno Position Taking for member', N'Update Master''s Keno Position Taking for member', N'Update Master''s Keno Position Taking for member', N'Update Master''s Keno Position Taking for member', N'Update Master''s Keno Position Taking for member', N'Update Master''s Keno Position Taking for member', N'Update Master''s Keno Position Taking for member', 0
UNION ALL
SELECT  447, NULL, 'Acc_CustomerUpdMemberKeno_SAg', N'Update Super''s Keno Position Taking for member', N'Update Super''s Keno Position Taking for member', N'Update Super''s Keno Position Taking for member', N'Update Super''s Keno Position Taking for member', N'Update Super''s Keno Position Taking for member', N'Update Super''s Keno Position Taking for member', N'Update Super''s Keno Position Taking for member', N'Update Super''s Keno Position Taking for member', 0
UNION ALL
SELECT  442, NULL, 'Acc_CustomerUpdSuperKeno_Positiontaking', N'Update Keno Position Taking for super', N'Update Keno Position Taking for super', N'Update Keno Position Taking for super', N'Update Keno Position Taking for super', N'Update Keno Position Taking for super', N'Update Keno Position Taking for super', N'Update Keno Position Taking for super', N'Update Keno Position Taking for super', 0
UNION ALL
SELECT  443, NULL, 'Acc_CustomerUpdMasterKeno_Positiontaking', N'Update Keno Position Taking for master', N'Update Keno Position Taking for master', N'Update Keno Position Taking for master', N'Update Keno Position Taking for master', N'Update Keno Position Taking for master', N'Update Keno Position Taking for master', N'Update Keno Position Taking for master', N'Update Keno Position Taking for master', 0
UNION ALL
SELECT  444, NULL, 'Acc_CustomerUpdAgentKeno_Positiontaking', N'Update Keno Position Taking for agent', N'Update Keno Position Taking for agent', N'Update Keno Position Taking for agent', N'Update Keno Position Taking for agent', N'Update Keno Position Taking for agent', N'Update Keno Position Taking for agent', N'Update Keno Position Taking for agent', N'Update Keno Position Taking for agent', 0
UNION ALL
SELECT  445, NULL, 'Acc_CustomerUpdMemberKeno_Positiontaking', N'Update Keno Position Taking for member', N'Update Keno Position Taking for member', N'Update Keno Position Taking for member', N'Update Keno Position Taking for member', N'Update Keno Position Taking for member', N'Update Keno Position Taking for member', N'Update Keno Position Taking for member', N'Update Keno Position Taking for member', 0
UNION ALL
SELECT  379, NULL, 'Acc_CustomerUpdSuperKeno_MinMaxBet', N'Update Keno Bet Setting for super', N'Update Keno Bet Setting for super', N'Update Keno Bet Setting for super', N'Update Keno Bet Setting for super', N'Update Keno Bet Setting for super', N'Update Keno Bet Setting for super', N'Update Keno Bet Setting for super', N'Update Keno Bet Setting for super', 0
UNION ALL
SELECT  380, NULL, 'Acc_CustomerUpdMasterKeno_MinMaxBet', N'Update Keno Bet Setting for master', N'Update Keno Bet Setting for master', N'Update Keno Bet Setting for master', N'Update Keno Bet Setting for master', N'Update Keno Bet Setting for master', N'Update Keno Bet Setting for master', N'Update Keno Bet Setting for master', N'Update Keno Bet Setting for master', 0
UNION ALL
SELECT  381, NULL, 'Acc_CustomerUpdAgentKeno_MinMaxBet', N'Update Keno Bet Setting for agent', N'Update Keno Bet Setting for agent', N'Update Keno Bet Setting for agent', N'Update Keno Bet Setting for agent', N'Update Keno Bet Setting for agent', N'Update Keno Bet Setting for agent', N'Update Keno Bet Setting for agent', N'Update Keno Bet Setting for agent', 0
UNION ALL
SELECT  382, NULL, 'Acc_CustomerUpdMemberKeno_MinMaxBet', N'Update Keno Bet Setting for member', N'Update Keno Bet Setting for member', N'Update Keno Bet Setting for member', N'Update Keno Bet Setting for member', N'Update Keno Bet Setting for member', N'Update Keno Bet Setting for member', N'Update Keno Bet Setting for member', N'Update Keno Bet Setting for member', 0
UNION ALL
SELECT  506, NULL, 'Acc_CustOverrideUpdKeno', N'Update Keno Min Position Taking', N'Update Keno Min Position Taking', N'Update Keno Min Position Taking', N'Update Keno Min Position Taking', N'Update Keno Min Position Taking', N'Update Keno Min Position Taking', N'Update Keno Min Position Taking', N'Update Keno Min Position Taking', 0


