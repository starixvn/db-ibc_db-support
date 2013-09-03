/*
	Created: Johnson
	Date: 2013-09-03
	Task: Enable UUS to be able to bet virtual tennis and racing for licensee sites
	DB: DBTXN/bodb02
*/

DECLARE @maxCustID INT

SET @maxCustID = xxx

create table #temp (custid int primary key, isfinished bit)

INSERT INTO #temp (custid, isfinished)
SELECT DISTINCT custid, 0
FROM custinfo c WITH(NOLOCK)	
WHERE	custid < @maxCustID
		AND
		(
			HideVirtualSports = 1 
			OR
			DisableVirtualSports=1
		)
AND srecommend IN (	SELECT custid 
					FROM Dep_CustSuper WITH(NOLOCK) 
					WHERE site IN ('12bet','Mansion88','Mayfair','Vwin','Alog','ZZun88','haifa','Bodog','asiabet88','TLC','Dela','Sungame','Tycoon','VCAsia','W88','Avia','67bet','3star88','SLC88')
						AND currency = 20
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

	UPDATE custinfo WITH(ROWLOCK,UPDLOCK)
	SET HideVirtualSports = 0,
		DisableVirtualSports = 0
	WHERE custid IN (SELECT custid FROM #temp WHERE isfinished = 1)

	if @rowcnt < 1000 RETURN
	
	DELETE #temp WHERE isfinished = 1

	WAITFOR DELAY '00:00:01'
end

				


