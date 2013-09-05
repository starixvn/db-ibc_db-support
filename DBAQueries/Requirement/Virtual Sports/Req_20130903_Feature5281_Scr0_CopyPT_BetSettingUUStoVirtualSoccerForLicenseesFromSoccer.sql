  /*
	Created: Johnson
	Date: 2013-09-03
	Task: Copy bet setting UUS from soccer to virtual soccer for licensee sites
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
					WHERE site IN ('Mansion88','Mayfair','Vwin','Alog','ZZun88','haifa','Dela','Tycoon','VCAsia','Avia','67bet','3star88','SLC88')
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

	UPDATE vs 
	SET spositiontaking = cs.spositiontaking
		,mpositiontaking = cs.mpositiontaking
		,apositiontaking = cs.apositiontaking
		,minbet = cs.minbet
		,maxbet = cs.maxbet
	FROM Dep_CustSetting3rd vs
		INNER JOIN Dep_CustSetting cs  ON vs.custid = cs.custid AND vs.sporttype = 180 AND vs.bettype = 1201 AND cs.sporttype = 1 AND cs.bettype = 1
	WHERE vs.custid IN (SELECT custid FROM #temp WHERE isfinished = 1)

	if @rowcnt < 1000 RETURN
	
	DELETE #temp WHERE isfinished = 1

	WAITFOR DELAY '00:00:02'
