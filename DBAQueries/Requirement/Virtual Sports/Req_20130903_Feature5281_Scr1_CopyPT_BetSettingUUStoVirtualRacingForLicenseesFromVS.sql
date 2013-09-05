 /*
	Created: Johnson
	Date: 2013-09-03
	Task: Copy bet setting UUS from virtual soccer to virtual tennis and racing for licensee sites
	DB: DBTXN/bodb02
*/

DECLARE @maxCustID INT

SET @maxCustID = xxx

create table #temp (custid int primary key, isfinished bit)

INSERT INTO #temp (custid, isfinished)
SELECT DISTINCT c.custid, 0
FROM custinfo c WITH(NOLOCK)
	inner join Dep_CustSetting3rd vsc with(nolock) on c.custid = vsc.custid and vsc.sporttype = 180 and vsc.bettype = 1201
	inner join Dep_CustSetting3rd vrc with(nolock) on c.custid = vrc.custid and vrc.sporttype in (182,181,186) and vrc.bettype in (1220,1231)
WHERE	c.custid < @maxCustID		
AND srecommend IN (	SELECT custid 
					FROM Dep_CustSuper WITH(NOLOCK) 
					WHERE site IN ('12bet','Mansion88','Mayfair','Vwin','Alog','ZZun88','haifa','Bodog','asiabet88','TLC','Dela','Sungame','Tycoon','VCAsia','W88','Avia','67bet','3star88','SLC88')
						AND currency = 20
				)
	and (vsc.apositiontaking <> vrc.apositiontaking
		 OR vsc.mpositiontaking <> vrc.mpositiontaking
		 OR vsc.spositiontaking <> vrc.spositiontaking
		 OR vsc.minbet <> vrc.minbet
		 OR vsc.maxbet <> vrc.maxbet
	 )

GO


declare @rowcnt int

while (1=1)
begin	
	update TOP (1000) #temp
	set isfinished = 1
	from #temp
	where isfinished = 0

	select @rowcnt = @@rowcount	

	UPDATE vr WITH(ROWLOCK,UPDLOCK)
	SET spositiontaking = vs.spositiontaking
		,mpositiontaking = vs.mpositiontaking
		,apositiontaking = vs.apositiontaking
		,minbet = vs.minbet
		,maxbet = vs.maxbet
	FROM Dep_CustSetting3rd vr
		INNER JOIN Dep_CustSetting3rd vs  ON vr.custid = vs.custid AND vr.sporttype IN (181,182,186) AND vs.sporttype = 180
	WHERE vr.custid IN (SELECT custid FROM #temp WHERE isfinished = 1)

	if @rowcnt < 1000 RETURN
	
	DELETE #temp WHERE isfinished = 1

	WAITFOR DELAY '00:00:02'
end