/*
	Created by: Elodie
	Date: 2014-03-27
	Task: Add Enable Keno permission for Ext Acc [Redmine:#11658]	
*/ 
USE bodb_EAS --DB052
GO

-- 17 rows affected
INSERT INTO eaGroupPolicy (GroupID, FuncID, Policy)
SELECT GroupID, 81, Policy
FROM eaGroupPolicy with (nolock)
WHERE FuncID = 79

GO
-- 44 rows affected
INSERT INTO eaUserPolicy (UserID, FuncID, Policy)
SELECT UserID, 81, Policy
FROM eaUserPolicy with (nolock)
WHERE FuncID = 79
 