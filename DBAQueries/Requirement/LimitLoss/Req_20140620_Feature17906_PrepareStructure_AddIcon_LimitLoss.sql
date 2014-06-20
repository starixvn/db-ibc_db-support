/*
	Created by: Elodie
	Date: 2014-06-20
	Task: Add icon to indicate loss movement in LimitLoss Control [Redmine:#17906]	
*/
----------------------------------------------------------------
--Modify table to DBAGE.bodb_Age.dbo.LimitLoss_Setting----------
----------------------------------------------------------------
USE [bodb_Age]
GO
ALTER TABLE dbo.LimitLoss_Setting ADD [YesterdayBalance] MONEY NULL
ALTER TABLE dbo.LimitLoss_Setting ADD [OldLevelID] TINYINT NULL
ALTER TABLE [dbo].[LimitLoss_Setting] ADD CONSTRAINT [DF_LimitLoss_Setting_OldLevelID]  DEFAULT ((0)) FOR [OldLevelID]
GO
----------------------------------------------------------------
--Insert data into DBAGE.bodb_Age.dbo.LimitLoss_ActionConfig----
----------------------------------------------------------------
UPDATE LimitLoss_ActionConfig WITH (ROWLOCK,UPDLOCK) 
SET Value = 50 WHERE LevelID = 1

GO
UPDATE LimitLoss_ActionConfig WITH (ROWLOCK,UPDLOCK) 
SET Value = 60 WHERE LevelID = 2

GO
UPDATE LimitLoss_ActionConfig WITH (ROWLOCK,UPDLOCK) 
SET Value = 70 WHERE LevelID = 3

GO
INSERT INTO LimitLoss_ActionConfig (LevelID, ActionID, Value)
SELECT 4, 1, 80
UNION ALL
SELECT 5, 1, 90
