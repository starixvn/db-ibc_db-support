

ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids varchar(max)
AS
SET NOCOUNT ON

/*
	Fun88 licensee customers 
	Virtual soccer: copy setting from NG 
*/
	
BEGIN
	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('Dep_Custsetting3rd') AND type = 'U') <> 1
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
	
		
	UPDATE vs WITH(ROWLOCK,UPDLOCK)
	SET spositiontaking = ng.spositiontaking
		,mpositiontaking = ng.mpositiontaking
		,apositiontaking = ng.apositiontaking
		,minbet = ng.minbet
		,maxbet = ng.maxbet
	FROM Dep_Custsetting3rd vs 
		INNER JOIN Dep_Custsetting3rd ng WITH(NOLOCK) ON vs.custid = ng.custid
			AND vs.sporttype = 180 AND vs.bettype = 1201 AND ng.sporttype = 161 AND ng.bettype = 81
	WHERE vs.custid IN (SELECT * FROM @res)
		
END

GO

DECLARE @maxCustID INT

SET @maxCustID = xxx

create table #temp (custid int primary key, isfinished bit)

INSERT INTO #temp (custid, isfinished)
SELECT DISTINCT vs.custid, 0
FROM custinfo c WITH(NOLOCK)
	INNER JOIN Dep_Custsetting3rd vs WITH(NOLOCK) ON c.custid = vs.custid
	INNER JOIN Dep_Custsetting3rd ng WITH(NOLOCK) ON vs.custid = ng.custid
		AND vs.sporttype = 180 AND vs.bettype = 1201 AND ng.sporttype = 161 AND ng.bettype = 81
WHERE	vs.custid < @maxCustID
		AND
		(
		vs.spositiontaking <> ng.spositiontaking
		OR 
		vs.mpositiontaking <> ng.mpositiontaking
		OR
		vs.apositiontaking <> ng.apositiontaking
		OR
		vs.minbet <> ng.minbet
		OR
		vs.maxbet <> ng.maxbet
		)
AND srecommend IN (SELECT custid FROM f_depSuper_1('Asiabet88'))
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


