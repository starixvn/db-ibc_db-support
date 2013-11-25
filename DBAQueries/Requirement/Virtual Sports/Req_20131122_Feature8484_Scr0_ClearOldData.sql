/*
	Created: Johnson
	Date: 20131122
	Task: Clear old setting on virtual greyhound and virtual motor racing for credit customers
	DB: DBTXN/bodb02
*/ 
--200 rows affected
DELETE cs
FROM CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid AND cs.sporttype IN (182,184)
WHERE ci.srecommend NOT IN (SELECT custid from Dep_CustSuper WITH(NOLOCK))
	
GO
--104 rows affected
DELETE cs
FROM CustOverride3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid AND cs.sporttype IN (182,184)
WHERE ci.srecommend NOT IN (SELECT custid from Dep_CustSuper WITH(NOLOCK))
AND ci.roleid IN (2,3,4)