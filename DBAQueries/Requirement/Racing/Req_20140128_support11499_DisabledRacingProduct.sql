 
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]	
	@ids varchar(max)
AS
BEGIN
	SET NOCOUNT ON

	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('custInfo') AND type = 'U') <> 1
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

	
				
	UPDATE custInfo WITH(UPDLOCK,ROWLOCK)
	SET	DisableHorseracing = 1,
		DisableOpenTote = 1,
		Disable151_AU =	1,
		Disable152_UK =	1,
		Disable152_AU =	1,
		Disable153_AU =	1
	WHERE custid IN (SELECT * FROM @res)					
	
END
GO



DECLARE @maxCustID INT

SET @maxCustID = xxx

create table #temp (custid int primary key, isfinished bit)

--23323 rows affected
INSERT INTO #temp (custid, isfinished)
SELECT ci.custid , 0 
FROM custInfo ci WITH(NOLOCK)
WHERE ci.srecommend = 4138910  -- S863R
	AND ci.custid <= @maxCustID

GO

declare @ids varchar(max), @rowcnt int

while (1=1)begin
	select @ids = ''
	
	update TOP (10000) #temp
	set @ids = @ids + case @ids when '' then '' else ',' end + cast(custid as varchar(12))
		,isfinished = 1
	from #temp
	where isfinished = 0

	select @rowcnt = @@rowcount	

	EXEC [Acc_ExecRep_Cust_09] @ids = @ids

	if @rowcnt < 10000 RETURN

	WAITFOR DELAY '00:00:01'
end
