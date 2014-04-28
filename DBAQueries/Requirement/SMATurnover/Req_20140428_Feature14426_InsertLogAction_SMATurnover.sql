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
SELECT  30000, NULL, 'NAP_SMATurnover_SportControlUpd', N'IT Admin update sport setting for SMA Turnover function', N'IT Admin update sport setting for SMA Turnover function', N'IT Admin update sport setting for SMA Turnover function', N'IT Admin update sport setting for SMA Turnover function', N'IT Admin update sport setting for SMA Turnover function', N'IT Admin update sport setting for SMA Turnover function', N'IT Admin update sport setting for SMA Turnover function', N'IT Admin update sport setting for SMA Turnover function', 1
UNION ALL
SELECT  30001, NULL, 'NAP_SMATurnover_LeagueControlUpd', N'IT Admin update league setting for SMA Turnover function', N'IT Admin update league setting for SMA Turnover function', N'IT Admin update league setting for SMA Turnover function', N'IT Admin update league setting for SMA Turnover function', N'IT Admin update league setting for SMA Turnover function', N'IT Admin update league setting for SMA Turnover function', N'IT Admin update league setting for SMA Turnover function', N'IT Admin update league setting for SMA Turnover function', 1
UNION ALL
SELECT  30002, NULL, 'NAP_SMATurnover_LeagueControlDel', N'IT Admin delete league setting for SMA Turnover function', N'IT Admin delete league setting for SMA Turnover function', N'IT Admin delete league setting for SMA Turnover function', N'IT Admin delete league setting for SMA Turnover function', N'IT Admin delete league setting for SMA Turnover function', N'IT Admin delete league setting for SMA Turnover function', N'IT Admin delete league setting for SMA Turnover function', N'IT Admin delete league setting for SMA Turnover function', 1
UNION ALL
SELECT  30003, NULL, 'NAP_SMATurnover_MatchControlUpd', N'IT Admin update match setting for SMA Turnover function', N'IT Admin update match setting for SMA Turnover function', N'IT Admin update match setting for SMA Turnover function', N'IT Admin update match setting for SMA Turnover function', N'IT Admin update match setting for SMA Turnover function', N'IT Admin update match setting for SMA Turnover function', N'IT Admin update match setting for SMA Turnover function', N'IT Admin update match setting for SMA Turnover function', 1
UNION ALL
SELECT  30004, NULL, 'NAP_SMATurnover_MatchControlDel', N'IT Admin delete match setting for SMA Turnover function', N'IT Admin delete match setting for SMA Turnover function', N'IT Admin delete match setting for SMA Turnover function', N'IT Admin delete match setting for SMA Turnover function', N'IT Admin delete match setting for SMA Turnover function', N'IT Admin delete match setting for SMA Turnover function', N'IT Admin delete match setting for SMA Turnover function', N'IT Admin delete match setting for SMA Turnover function', 1
UNION ALL
SELECT  30005, NULL, 'NAP_SMATurnover_SMAControlByEventIns', N'IT Admin insert SMA setting by match for SMA Turnover function', N'IT Admin insert SMA setting by match for SMA Turnover function', N'IT Admin insert SMA setting by match for SMA Turnover function', N'IT Admin insert SMA setting by match for SMA Turnover function', N'IT Admin insert SMA setting by match for SMA Turnover function', N'IT Admin insert SMA setting by match for SMA Turnover function', N'IT Admin insert SMA setting by match for SMA Turnover function', N'IT Admin insert SMA setting by match for SMA Turnover function', 1
UNION ALL
SELECT  30006, NULL, 'NAP_SMATurnover_SMAControlByEventUpd', N'IT Admin update SMA setting by match for SMA Turnover function', N'IT Admin update SMA setting by match for SMA Turnover function', N'IT Admin update SMA setting by match for SMA Turnover function', N'IT Admin update SMA setting by match for SMA Turnover function', N'IT Admin update SMA setting by match for SMA Turnover function', N'IT Admin update SMA setting by match for SMA Turnover function', N'IT Admin update SMA setting by match for SMA Turnover function', N'IT Admin update SMA setting by match for SMA Turnover function', 1
UNION ALL
SELECT  30007, NULL, 'NAP_SMATurnover_SMAControlByEventDel', N'IT Admin delete SMA setting by match for SMA Turnover function', N'IT Admin delete SMA setting by match for SMA Turnover function', N'IT Admin delete SMA setting by match for SMA Turnover function', N'IT Admin delete SMA setting by match for SMA Turnover function', N'IT Admin delete SMA setting by match for SMA Turnover function', N'IT Admin delete SMA setting by match for SMA Turnover function', N'IT Admin delete SMA setting by match for SMA Turnover function', N'IT Admin delete SMA setting by match for SMA Turnover function', 1
UNION ALL
SELECT  30008, NULL, 'NAP_SMATurnover_SMAControlIns', N'IT Admin insert SMA setting for SMA Turnover function', N'IT Admin insert SMA setting for SMA Turnover function', N'IT Admin insert SMA setting for SMA Turnover function', N'IT Admin insert SMA setting for SMA Turnover function', N'IT Admin insert SMA setting for SMA Turnover function', N'IT Admin insert SMA setting for SMA Turnover function', N'IT Admin insert SMA setting for SMA Turnover function', N'IT Admin insert SMA setting for SMA Turnover function', 1
UNION ALL
SELECT  30009, NULL, 'NAP_SMATurnover_SMAControlUpd', N'IT Admin update SMA setting for SMA Turnover function', N'IT Admin update SMA setting for SMA Turnover function', N'IT Admin update SMA setting for SMA Turnover function', N'IT Admin update SMA setting for SMA Turnover function', N'IT Admin update SMA setting for SMA Turnover function', N'IT Admin update SMA setting for SMA Turnover function', N'IT Admin update SMA setting for SMA Turnover function', N'IT Admin update SMA setting for SMA Turnover function', 1
UNION ALL
SELECT  30010, NULL, 'NAP_SMATurnover_SMAControlDel', N'IT Admin delete SMA setting for SMA Turnover function', N'IT Admin delete SMA setting for SMA Turnover function', N'IT Admin delete SMA setting for SMA Turnover function', N'IT Admin delete SMA setting for SMA Turnover function', N'IT Admin delete SMA setting for SMA Turnover function', N'IT Admin delete SMA setting for SMA Turnover function', N'IT Admin delete SMA setting for SMA Turnover function', N'IT Admin delete SMA setting for SMA Turnover function', 1
 