

ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids varchar(max)
AS
SET NOCOUNT ON

/*
	script update bingo status for credit customers
*/
	
BEGIN
	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('custinfo') AND type = 'U') <> 1
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
	
		
	UPDATE custinfo WITH(ROWLOCK,UPDLOCK)
	SET SyncBingo = 1
		,DisableBingo = 0
	WHERE custid IN (SELECT * FROM @res)
		
END

GO

CREATE TABLE #srecommend (custid INT)

INSERT INTO #srecommend
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE roleid = 4
	AND custid NOT IN (SELECT custid FROM f_depsuper_1('All'))

GO

DECLARE @maxCustID INT
SET @maxCustID = xxx

create table #temp (custid int primary key, isfinished bit)

--5263853
INSERT INTO #temp (custid, isfinished)
SELECT DISTINCT custid, 0
FROM custinfo c WITH(NOLOCK)	
WHERE	custid < @maxCustID
		AND
		(
		SyncBingo = 0
		OR 
		DisableBingo = 1
		)
AND srecommend IN (SELECT custid FROM #srecommend)
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
