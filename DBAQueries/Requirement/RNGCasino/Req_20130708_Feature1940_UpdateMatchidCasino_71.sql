  ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids varchar(max)
AS
SET NOCOUNT ON

/*
	Created: Johnson
	Date: 2013-07-08
	Task: script update matchid for bingo
*/
BEGIN 
	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('bettrans') AND type = 'U') <> 1
		RETURN
		
	DECLARE @res AS TABLE (transid BIGINT)
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
		INSERT INTO @res  VALUES(CAST(@word AS BIGINT))
		SET @i=@i+1
	END
	
	UPDATE bettrans WITH(UPDLOCK,ROWLOCK)
	SET matchid = 71
	WHERE transid IN (SELECT transid FROM @res)
	
END


CREATE TABLE #tmp_bettrans (transid bigint primary key, isfinished bit)

DECLARE @max_transid bigint

SELECT @max_transid = max(transid) FROM bettrans WITH(NOLOCK) 

INSERT INTO #tmp_bettrans (transid, isfinished)
SELECT transid, 0
FROM bettrans WITH(NOLOCK)
WHERE bettype = 71
	AND matchid = 0
	AND transid <= @max_transid


declare @ids varchar(max), @rowcnt int

while (1=1)
begin
	select @ids = ''
	
	update TOP (10000) #tmp_bettrans
	set @ids = @ids + case @ids when '' then '' else ',' end + cast(transid as varchar(12))
		,isfinished = 1
	from #temp_bettrans
	where isfinished = 0
	
	select @rowcnt = @@rowcount	

	EXEC [Acc_ExecRep_09] @ids = @ids
	
	if @rowcnt < 5000 RETURN

	WAITFOR DELAY '00:00:01'
end

SELECT @max_transid as max_transid









