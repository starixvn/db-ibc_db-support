/*
	Created: Johnson
	Date: 2014-03-24
	DB: DBTXN/CustDB
	Task: Enable keno for 12bet
*/ 

ALTER PROCEDURE [dbo].[Acc_CustSetting_03]
	@ids VARCHAR(MAX)	
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @res AS TABLE (custid INT)
	DECLARE @splitter CHAR(1)
		,@string VARCHAR(MAX)

	SELECT @splitter = ','
		,@string = @ids

	IF SUBSTRING(@string, LEN(@string), 1) <> @splitter
		SET @string = @string + @splitter

	DECLARE @START INT
		,@word NVARCHAR(4000)
		,@CHARINDEX INT
		,@i INT

	SET @i = 1
	SET @START = 1
	SET @CHARINDEX = CHARINDEX(@splitter, @string, @START)

	WHILE (@CHARINDEX <> 0)
	BEGIN
		SET @word = SUBSTRING(@string, @START, @CHARINDEX - @START)
		SET @START = @CHARINDEX + 1
		SET @CHARINDEX = CHARINDEX(@splitter, @string, @START)

		INSERT INTO @res(custid)
		VALUES (CAST(@word AS INT))

		SET @i = @i + 1
	END

	IF NOT EXISTS ( SELECT * FROM sys.objects WHERE NAME = 'CustGameType' AND type = 'U' )
		RETURN
	
	UPDATE custGameType WITH(UPDLOCK,ROWLOCK)
	SET IsDisabled = 0
	WHERE custid IN (SELECT custid FROM @res)
	
END
GO

DECLARE @maxCustID INT
	
SELECT @maxCustID = xx
--SELECT MAX(CustId) FROM dbo.custInfo WITH (NOLOCK)

CREATE TABLE #temp (
	custid INT PRIMARY KEY
	,isfinished BIT
	)

--268765 rows affected
INSERT INTO #temp (
	custid
	,isfinished
	)
SELECT ci.custid
	,0
FROM dbo.custInfo ci WITH (NOLOCK)
WHERE ci.srecommend IN (
		SELECT custid
		FROM dbo.Dep_CustSuper WITH (NOLOCK)
		WHERE site = '12bet'
	)
	AND ci.custid <= @maxCustID



DECLARE @ids VARCHAR(max)
	

WHILE (1 = 1)
BEGIN
	SELECT @ids = ''

	UPDATE TOP (10000) #temp
	SET @ids = @ids + CASE @ids
			WHEN '' THEN ''
			ELSE ','
			END + cast(custid AS VARCHAR(12))
		,isfinished = 1
	FROM #temp
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 RETURN
	
	EXEC [Acc_CustSetting_03] @ids = @ids
	
	WAITFOR DELAY '00:00:01'
END