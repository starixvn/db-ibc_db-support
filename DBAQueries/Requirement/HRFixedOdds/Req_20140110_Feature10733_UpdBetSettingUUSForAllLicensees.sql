 /*
	Created: Johnson
	Date: 20140110
	Task: Update bet settings for horse racing fixed odds for all licensees
	DB: DBTXN/CustDB
 */
 
 
 CREATE TABLE #tmpCust(custid INT PRIMARY KEY)
 DECLARE @max_custid INT
 
 SELECT @max_custid = xxx
 
 --17466 rows affected
 INSERT INTO #tmpCust
 SELECT custid
 FROM custinfo with(NOLOCK)
 WHERE srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE currency = 20)
 AND custid <= @max_custid
 GO
 
 
 UPDATE CustSetting WITH(UPDLOCK,ROWLOCK)
 SET minbet = 1,
	maxbet = 100000 
 WHERE custid IN( SELECT custid FROM #tmpCust)
	 AND sporttype = 154
	 AND bettype = 20
GO

UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
SET maxpermatch154 = 1000000
WHERE custid IN (SELECT custid FROM #tmpCust)


