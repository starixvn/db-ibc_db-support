/*
	Created: Johnson
	Date: 2014-01-13
	Task: Enable live casino for SalonCS and Salon365
	DB: DBTXN/CustDB
*/ 


CREATE TABLE #temp(custid INT,roleid INT)


--60 rows affected
INSERT INTO #temp(custid, roleid)
SELECT custid, roleid
FROM custInfo WITH(NOLOCK)
WHERE srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE site IN ('Salon365','SalonCS'))
AND mrecommend NOT IN (		
	13105583	,--	Salon365ACCRMB
	13106785	,--	Salon365ACCUUS
	13105491	,--	SaloncsACCRMB
	13107308	--	SaloncsACCUUS
)
GO

UPDATE cs
SET spositiontaking = CASE WHEN roleid = 4 THEN 0.93 ELSE 0 END,
	mpositiontaking = CASE WHEN roleid = 3 THEN 0.93 ELSE 0 END,
	apositiontaking = CASE WHEN roleid IN (1,2) THEN 0.93 ELSE 0 END
FROM CustSettingGame cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN #temp c ON cs.custid = c.custid AND cs.sporttype = 162
GO


UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
SET DisableLiveCasino = 0, SyncLiveCasino = 1,
	DisableCasino = 0, SyncCasino = 1
WHERE custid IN (SELECT custid FROM #temp)


