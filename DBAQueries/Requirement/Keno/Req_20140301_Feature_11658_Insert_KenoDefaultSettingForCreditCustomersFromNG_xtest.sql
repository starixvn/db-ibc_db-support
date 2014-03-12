/** SP to insert default setting of Keno game **/
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09] 
	@ids VARCHAR(MAX)
	, @IsDisable BIT = 0 
AS
/*
	Created: Bobby
	Date: 20140303
	Task: Insert default setting of Keno game for credit customers
	DB: DBTRANS/CustDB

	Param's Explanation:
		• @ids: list custid
		• @IsDisable: 0:active|1:inactive
*/
BEGIN
	SET NOCOUNT ON

	IF (
			SELECT COUNT(1)
			FROM sys.objects
			WHERE NAME IN ('CustGameType')
				AND type = 'U'
			) <> 1 RETURN

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

	--re-check @IsDisable value
	SET @IsDisable = ISNULL(@IsDisable, 0)
	;WITH kenoBetType AS 
	(
		SELECT 202 AS sporttype
			,1501 AS bettype
			,1 AS gametypeid -- Australia Acttab
		
		UNION ALL
		SELECT 202 AS sporttype
			,1502 AS bettype
			,2 AS gametypeid -- Bejing Keno 8
		
		UNION ALL
		SELECT 202 AS sporttype
			,1503 AS bettype
			,3 AS gametypeid -- Slovakia Eklub

		UNION ALL
		SELECT 202 AS sporttype
			,1504 AS bettype
			,4 AS gametypeid -- Canada Keno

		UNION ALL
		SELECT 202 AS sporttype
			,1505 AS bettype
			,5 AS gametypeid -- West Canada Keno

		UNION ALL
		SELECT 202 AS sporttype
			,1506 AS bettype
			,6 AS gametypeid -- Taiwan Bingo Bingo

		UNION ALL
		SELECT 202 AS sporttype
			,1507 AS bettype
			,7 AS gametypeid -- Massac

		UNION ALL
		SELECT 202 AS sporttype
			,1508 AS bettype
			,8 AS gametypeid -- Ohio

		UNION ALL
		SELECT 202 AS sporttype
			,1509 AS bettype
			,9 AS gametypeid -- Malta
	)
	,kenoSetting AS
	(
		SELECT t.[gametypeid]
			, res.custid
			, '' [StakeLevelList]
			, 0.00 [MaxPerGameType]
			, 0.00 [MinBet]
			, 0.00 [MaxBet]
			, @IsDisable [IsDisabled] 
		FROM @res res
		CROSS JOIN kenoBetType t
	)
	INSERT INTO [dbo].[CustGameType]([GameTypeID]
		,[CustID]
		,[StakeLevelList]
		,[MaxPerGameType]
		,[MinBet]
		,[MaxBet]
		,[IsDisabled]
		)
	SELECT tmp.[GameTypeID]
		,tmp.[CustID]
		,tmp.[StakeLevelList]
		,tmp.[MaxPerGameType]
		,tmp.[MinBet]
		,tmp.[MaxBet]
		,tmp.[IsDisabled]
	FROM kenoSetting tmp
	;
	--update hidekeno
	UPDATE cust
		SET HideKeno = 1
	FROM dbo.custinfo cust WITH(ROWLOCK, UPDLOCK)
	INNER JOIN @res res on cust.custid = res.custid
END
GO

/*
	Created: Bobby
	Date: 20140303
	Task: Insert default setting of Keno game for credit customers
	DB: DBTRANS/CustDB
*/
--USE CustDB
--GO

DECLARE @maxCustID INT
	, @IsDisable BIT = 1

--SELECT @maxCustID = MAX(CustId) FROM dbo.custInfo WITH (NOLOCK)

CREATE TABLE #temp (
	custid INT PRIMARY KEY
	,isfinished BIT
	)

INSERT INTO #temp (
	custid
	,isfinished
	)
SELECT Custid
	, 0 isfinished
FROM dbo.custInfo WITH (NOLOCK)
WHERE srecommend IN (
	SELECT custid
	FROM dbo.custInfo WITH (NOLOCK)
	WHERE username IN ('supertest1', 'supertest2')
		AND roleid = 4
)

DECLARE @ids VARCHAR(max)
	,@rowcnt INT
	,@rowTotal INT = 0
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

	SELECT @rowcnt = @@rowcount
		, @rowTotal = @rowTotal + @@rowcount

	IF(@rowcnt > 0)
	BEGIN
		EXEC Acc_ExecRep_Cust_09 @ids = @ids
			, @IsDisable = @IsDisable
	END
	IF (@rowcnt < 10000
		OR @rowcnt = 0)
	BEGIN
		GOTO INS_COMPLETED
	END

	WAITFOR DELAY '00:00:01'
END

INS_COMPLETED:
	DROP TABLE #temp
	PRINT 'Keno- (CustGameType) - insert completed - ' + CAST((@rowTotal*9) AS VARCHAR(20)) + 'rows'
GO
