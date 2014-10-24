/*
	Created: Logan
	Date: 2014-10-17
	Task: Copy permission for Keno from Sportbook
	DB: DBEAS/bodb_EAS
*/ 

--eaFunction
INSERT INTO dbo.eaUserPolicy
(
    UserID
  , FuncID
  , Policy
)
SELECT UserID
     , 82
     , Policy
  FROM dbo.eaUserPolicy WITH(NOLOCK)
 WHERE FuncID = 49

--eaGroupPolicy
INSERT INTO dbo.eaGroupPolicy
(
    GroupID
  , FuncID
  , Policy
)
SELECT GroupID
     , 82
     , Policy
  FROM dbo.eaGroupPolicy WITH(NOLOCK)
 WHERE FuncID = 49