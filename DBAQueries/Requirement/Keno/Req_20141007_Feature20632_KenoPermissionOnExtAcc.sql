/*
	Created: Logan
	Date: 2014-10-17
	Task: Copy permission for Keno from Sportbook
	DB: DBEAS/bodb_EAS
*/ 
USE bodb_EAS
GO

--eaUserPolicy
UPDATE Keno WITH(ROWLOCK, UPDLOCK)
   SET Keno.Policy = SB.Policy
  FROM eaUserPolicy Keno
INNER JOIN eaUserPolicy SB ON Keno.UserID = SB.UserID
 WHERE Keno.FuncID = 82
   AND SB.FuncID = 49


--eaGroupPolicy
UPDATE Keno WITH(ROWLOCK, UPDLOCK)
   SET Keno.Policy = SB.Policy
  FROM eaGroupPolicy Keno
INNER JOIN eaGroupPolicy SB ON Keno.GroupID = SB.GroupID
 WHERE Keno.FuncID = 82
   AND SB.FuncID = 49