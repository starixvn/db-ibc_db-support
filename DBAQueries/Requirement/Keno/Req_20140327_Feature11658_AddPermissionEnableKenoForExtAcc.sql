/*
	Created by: Elodie
	Date: 2014-03-27
	Task: Add Enable Keno permission for Ext Acc [Redmine:#11658]	
*/ 
USE bodb_EAS --DB052
GO

-- 17 rows affected
UPDATE gp1
SET gp1.Policy = gp2.Policy
FROM eaGroupPolicy gp1 WITH (ROWLOCK, UPDLOCK) 
	INNER JOIN eaGroupPolicy gp2 WITH (NOLOCK) ON gp1.GroupID = gp2.GroupID
WHERE gp1.FuncID = 81 and gp2.FuncID = 79

GO
-- 44 rows affected
UPDATE up1
SET up1.Policy = up2.Policy
FROM eaUserPolicy up1 WITH (ROWLOCK, UPDLOCK) 
	INNER JOIN eaUserPolicy up2 WITH (NOLOCK) ON up1.UserID = up2.UserID
WHERE up1.FuncID = 81 and up2.FuncID = 79
 