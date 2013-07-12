 ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids varchar(max)
AS
SET NOCOUNT ON

/*
	script 2: set bet setting for 12Bet customers
*/
	
BEGIN
	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('Dep_Custsetting3rd','custinfo') AND type = 'U') <> 2
		RETURN

	DECLARE @res AS TABLE (custid INT)
	DECLARE @splitter CHAR(1), @string VARCHAR(MAX)

	SELECT @splitter = ',', @string = @ids

	IF SUBSTRING (@string, LEN (@string), 1) <> @splitter
		  SET @string= @string+@splitter

	DECLARE @START INT, @word NVARCHAR(4000), @CHARINDEX INT, @i INT
	SET @i=1
	SET @START=1
	SET @CHARINDEX= CHARINDEX( @splitter, @string, @START)
	WHILE (@CHARINDEX <> 0)BEGIN
		SET @word= SUBSTRING( @string, @START, @CHARINDEX - @START)
		SET @START= @CHARINDEX +1
		SET @CHARINDEX= CHARINDEX( @splitter, @string, @START)
		INSERT INTO @res  VALUES(CAST(@word AS INT))
		SET @i=@i+1
	END
	
	CREATE TABLE #betsetting(currency INT, minbet MONEY, maxbet MONEY,maxpermatch MONEY)
	
	INSERT INTO #betsetting
			  SELECT	2	,	1	,	2000	,5000
	UNION ALL SELECT	13	,	2	,	3000	,10000
	UNION ALL SELECT	43	,	10	,	20000	,50000
	UNION ALL SELECT	34	,	3	,	5000	,15000
	UNION ALL SELECT	51	,	6	,	10000	,30000
	
	-- UPDATE min/max bet	
	UPDATE vs WITH(ROWLOCK,UPDLOCK)
	SET vs.minbet = b.minbet,
		vs.maxbet = b.maxbet
	FROM Dep_Custsetting3rd vs 
		INNER JOIN custinfo c WITH(NOLOCK) ON vs.custid = c.custid
			AND vs.sporttype = 180 AND vs.bettype = 1201
		INNER JOIN #betsetting b ON c.currency = b.currency
	WHERE c.custid IN (SELECT * FROM @res)
		AND (vs.minbet <> b.minbet OR vs.maxbet <> b.maxbet)
		
	-- UPDATE maxpermatch
	UPDATE c WITH(ROWLOCK,UPDLOCK)
	SET maxpermatch180 = b.maxpermatch
	FROM custinfo c 
		INNER JOIN #betsetting b ON c.currency = b.currency
	WHERE c.custid IN (SELECT * FROM @res)
		AND maxpermatch180 <> b.maxpermatch
END

GO

DECLARE @maxCustID INT
SET @maxCustID = xxx

CREATE TABLE #betsetting(currency INT, minbet MONEY, maxbet MONEY,maxpermatch MONEY)
	
	INSERT INTO #betsetting
			  SELECT	2	,	1	,	2000	,5000
	UNION ALL SELECT	13	,	2	,	3000	,10000
	UNION ALL SELECT	43	,	10	,	20000	,50000
	UNION ALL SELECT	34	,	3	,	5000	,15000
	UNION ALL SELECT	51	,	6	,	10000	,30000
	
create table #temp (custid int primary key, isfinished bit)

INSERT INTO #temp (custid, isfinished)
SELECT DISTINCT vs.custid, 0
FROM custinfo c WITH(NOLOCK)
	INNER JOIN Dep_Custsetting3rd vs WITH(NOLOCK) ON c.custid = vs.custid	
		AND vs.sporttype = 180 AND vs.bettype = 1201 
	INNER JOIN #betsetting b ON b.currency = c.currency
WHERE	vs.custid < @maxCustID
		AND
		(		
		c.maxpermatch180 <> b.maxpermatch
		OR
		vs.minbet <> b.minbet
		OR
		vs.maxbet <> b.maxbet
		)
AND srecommend IN (SELECT custid FROM f_depSuper_1('12Bet'))

GO

declare @ids varchar(max), @rowcnt int

while (1=1)
begin
	select @ids = ''
	
	update TOP (10000) #temp
	set @ids = @ids + case @ids when '' then '' else ',' end + cast(custid as varchar(12))
		,isfinished = 1
	from #temp
	where isfinished = 0
	
	select @rowcnt = @@rowcount	

	EXEC [Acc_ExecRep_09] @ids = @ids
	
	if @rowcnt < 10000 RETURN

	WAITFOR DELAY '00:00:01'
end
