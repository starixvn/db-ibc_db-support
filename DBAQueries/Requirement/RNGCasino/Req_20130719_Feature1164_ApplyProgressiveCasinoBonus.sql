 /*
	Created by: Elodie
	Date: 2013-07-19
	Task: Insert Log action for updating CasinoBonus status
		  Add new column DisableCasinoBonus
		  Modify trigger on CustInfo table
*/

-- BODB02.dbo.custinfo
ALTER TABLE custinfo ADD DisableCasinoBonus BIT


-- bodb_customerLog.dbo.custinfo_history
ALTER TABLE custinfo_history ADD DisableCasinoBonus BIT


-- BODB_customer.dbo.custInfo_old
ALTER TABLE custInfo_old ADD DisableCasinoBonus BIT



---

ALTER TRIGGER [dbo].[CustInfo_update] ON [dbo].[custInfo] AFTER UPDATE
AS
/*
Created by: 20120731@
Task: Trigger for updating Custinfo table 
DB: DBEXT/bodb02; 
Revisions: 
    - 20120731@Dan: add fields for Virtual soccer
    - 20120821@Elodie: add Abnormal fields to support Abnormal bets
    - 20120925@Dan: add fields for LCS-Win Limit
    - 20121004@Johnson: add double comm losing status
    - 20130125@Tom: add fields for Virtual Tennis
    - 20130221@Elodie: add field maxpermatch181 for Virtual Horse Racing
    - 20130604@Jamie: Add new field maxpermatch182 for Virtual Greyhound
    - 20130718@Lukas: add column DisableCasinoBonus 
*/
SET NOCOUNT ON
INSERT INTO bodb_CustomerLog.dbo.CustInfo_history (
                username, custid, currency, roleid, srecommend, mrecommend, recommend, dangercust, autosuspend, reject, credit, closed, MatchLimit,
                  VirtualMultiplier, maxpermatch, maxpermatch2, maxpermatch3, maxpermatch5, maxpermatch8, maxpermatch10, maxpermatch11, maxpermatch12,
                  maxpermatch99, [Enabled], danger, maxpermatch151, maxpermatch201, DisableHorseRacing, DisableFinancial, DisableCasino,
                  SyncCasino, danger2, danger3, DisableOutright, DisableOpenTote, maxpermatch151_OT
                  ,[DisableBingo]
                  ,[DisableNumber]
                  ,[SyncBingo]
                  ,[MaxPerMatch161]
                  ,[MaxPerMatch99MP]
                  ,[MaxPerBall161]
                  ,MaxtransferP2P
                  ,IsAutoResetP2P
                  ,DisableP2P
                  ,DisableFunP2P
                  ,DisableLiveCasino
                  ,SyncLiveCasino
                  ,DisableVirtualSports
                  ,HideVirtualSports
                  ,maxpermatch180
                  ,maxpermatch181
                  ,maxpermatch182
                  ,maxpermatch186
                  ,Abnormal
                  ,isAutoResetLiveCasino
                  ,MaxWinLiveCasino
                  ,DoubleCommLosing
                  ,DisableCasinoBonus 
                )
SELECT
                username, custid, currency, roleid, srecommend, mrecommend, recommend, dangercust, autosuspend, reject, credit, closed, MatchLimit,
                  VirtualMultiplier, maxpermatch, maxpermatch2, maxpermatch3, maxpermatch5, maxpermatch8, maxpermatch10, maxpermatch11, maxpermatch12,
                  maxpermatch99, [Enabled], danger, maxpermatch151, maxpermatch201, DisableHorseRacing, DisableFinancial, DisableCasino,
                  SyncCasino, danger2, danger3, DisableOutright, DisableOpenTote, maxpermatch151_OT
                  ,[DisableBingo]
                  ,[DisableNumber]
                  ,[SyncBingo]
                  ,[MaxPerMatch161]
                  ,[MaxPerMatch99MP]
                  ,[MaxPerBall161]
                  ,MaxtransferP2P
                  ,IsAutoResetP2P
                  ,DisableP2P
                  ,DisableFunP2P
                  ,DisableLiveCasino
                  ,SyncLiveCasino
                  ,DisableVirtualSports
                  ,HideVirtualSports
                  ,maxpermatch180
                  ,maxpermatch181
                  ,maxpermatch182
                  ,maxpermatch186
                  ,Abnormal
                  ,isAutoResetLiveCasino
                  ,MaxWinLiveCasino
                  ,DoubleCommLosing
                  ,DisableCasinoBonus 
FROM [DELETED]


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
       ,0) 
       
       