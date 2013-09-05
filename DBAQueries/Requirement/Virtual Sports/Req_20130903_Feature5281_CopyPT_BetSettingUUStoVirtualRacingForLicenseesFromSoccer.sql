 /*
	Created: Johnson
	Date: 2013-09-03
	Task: Copy bet setting UUS from soccer to virtual tennis and racing for licensee sites
	DB: DBTXN/bodb02
*/

DECLARE @maxCustID INT

SET @maxCustID = xxx

create table #temp (custid int primary key)

INSERT INTO #temp (custid)
SELECT DISTINCT c.custid
FROM custinfo c WITH(NOLOCK)
WHERE	c.custid < @maxCustID		
AND srecommend IN (	SELECT custid 
					FROM Dep_CustSuper WITH(NOLOCK) 
					WHERE site IN ('12bet','Mansion88','Mayfair','Vwin','Alog','ZZun88','haifa','Bodog','asiabet88','TLC','Dela','Sungame','Tycoon','VCAsia','W88','Avia','67bet','3star88','SLC88')
						AND currency = 20
				)	
GO

--10637 customers affected

--copy pt setting from soccer
	UPDATE vr WITH(ROWLOCK,UPDLOCK)
	SET spositiontaking = cs.spositiontaking
		,mpositiontaking = cs.mpositiontaking
		,apositiontaking = cs.apositiontaking
		,minbet = cs.minbet
		,maxbet = cs.maxbet
	FROM Dep_CustSetting3rd vr
		INNER JOIN Dep_CustSetting cs  ON vr.custid = cs.custid AND vr.sporttype IN (181,186) AND cs.sporttype = 1 and cs.bettype = 1 and islive =0
	WHERE vr.custid IN (SELECT custid FROM #temp)

GO
-- copy maxpermatch and enable status
	UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
	SET maxpermatch181 = maxpermatch,		
		maxpermatch186 = maxpermatch,
		HideVirtualSports = 0,
		DisableVirtualSports = 0
	WHERE custid IN (SELECT custid FROM #temp )

GO

