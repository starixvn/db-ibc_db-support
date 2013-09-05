  /*
	Created: Johnson
	Date: 2013-09-03
	Task: Copy maxpermatch UUS from soccer to virtual soccer for licensee sites
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
					WHERE site IN ('Mansion88','Mayfair','Vwin','ZZun88','haifa','Dela','Tycoon','VCAsia','Avia','67bet','3star88','SLC88')
						AND currency = 20
				)
	AND maxpermatch <> maxpermatch180
GO

--9495 customer affected
declare @rowcnt int

while (1=1)
begin	
	update TOP (5000) #temp
	set isfinished = 1
	from #temp
	where isfinished = 0

	select @rowcnt = @@rowcount	

	UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
	SET maxpermatch180 = maxpermatch		
	WHERE custid IN (SELECT custid FROM #temp WHERE isfinished = 1)
	
	if @rowcnt < 5000 RETURN
	
	DELETE #temp WHERE isfinished = 1

	WAITFOR DELAY '00:00:01'
end