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
SELECT DISTINCT custid, 0
FROM custinfo c WITH(NOLOCK)	
WHERE	custid < @maxCustID		
AND srecommend IN (	SELECT custid 
					FROM Dep_CustSuper WITH(NOLOCK) 
					WHERE site IN ('12bet','Mansion88','Mayfair','Vwin','Alog','ZZun88','haifa','Bodog','asiabet88','TLC','Dela','Sungame','Tycoon','VCAsia','W88','Avia','67bet','3star88','SLC88')
						AND currency = 20
				)
GO

--6872 customer affected
declare @rowcnt int

while (1=1)
begin	
	update TOP (1000) #temp
	set isfinished = 1
	from #temp
	where isfinished = 0

	select @rowcnt = @@rowcount	

	UPDATE vr 
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