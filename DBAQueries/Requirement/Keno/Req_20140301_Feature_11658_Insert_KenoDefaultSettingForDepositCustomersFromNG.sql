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
			WHERE NAME IN ('CustOverride3rd', 'custInfo')
				AND type = 'U'
			) <> 2 RETURN

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

	SELECT *
	INTO #kenoBetType 
	FROM
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
	) tmp

	;WITH kenoCustGameType AS
	(
		SELECT t.[gametypeid]
			, res.custid
			, '' [StakeLevelList]
			, c.maxpermatch161 AS [MaxPerGameType]
			, cs.[MinBet]
			, cs.[MaxBet]
			, @IsDisable [IsDisabled] 
		FROM @res AS res 
		INNER JOIN dbo.Dep_CustSetting3rd cs WITH(NOLOCK)
			ON res.custid = cs.custid
		INNER JOIN dbo.custinfo c WITH(NOLOCK)
			ON res.custid = c.custid
		CROSS JOIN #kenoBetType t
		WHERE cs.[sporttype] = 161
			AND cs.[bettype] = 81
	)
	--SELECT * FROM kenoCustGameType
	MERGE INTO [dbo].[CustGameType] AS cust
	USING kenoCustGameType AS tmp
		ON cust.custid			= tmp.custid 
			AND cust.gametypeid = tmp.gametypeid
	WHEN NOT MATCHED BY TARGET THEN
		INSERT([GameTypeID]
			,[CustID]
			,[StakeLevelList]
			,[MaxPerGameType]
			,[MinBet]
			,[MaxBet]
			,[IsDisabled]
			)
		VALUES(tmp.[GameTypeID]
			,tmp.[CustID]
			,tmp.[StakeLevelList]
			,tmp.[MaxPerGameType]
			,tmp.[MinBet]
			,tmp.[MaxBet]
			,tmp.[IsDisabled]
		)
	;
	WITH kenoCustSettingGame AS 
	(
		SELECT cust.[CustID]
           ,t.[Bettype]
           ,t.[Sporttype]
           ,cust.[apositiontaking]
           ,cust.[mpositiontaking]
           ,cust.[spositiontaking]
           ,cust.[playerdiscount]
           ,cust.[discount]
           ,cust.[adiscount]
           ,cust.[sdiscount]
           ,NULL AS [autopositiontaking]
           ,NULL AS [isautopositiontaking]
           ,NULL AS [autompositiontaking]
           ,NULL AS [isautompositiontaking]
		FROM dbo.[Dep_CustSetting3rd] cust WITH(NOLOCK)
		INNER JOIN @res AS res 
			ON cust.custid = res.custid
		CROSS JOIN #kenoBetType t
		WHERE cust.[sporttype] = 161
			AND cust.[bettype] = 81
	)
	--SELECT * FROM kenoCustSettingGame
	MERGE INTO [dbo].[CustSettingGame] AS cust
	USING kenoCustSettingGame AS tmp
		ON cust.custid				= tmp.custid 
			AND cust.[Sporttype]	= tmp.[Sporttype]
			AND cust.[Bettype]		= tmp.[Bettype]
	WHEN NOT MATCHED BY TARGET THEN
		INSERT([CustID]
           ,[Bettype]
           ,[Sporttype]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           --,[autopositiontaking]
           --,[isautopositiontaking]
           --,[autompositiontaking]
           --,[isautompositiontaking]
		)
		VALUES(tmp.[CustID]
           ,tmp.[Bettype]
           ,tmp.[Sporttype]
           ,tmp.[apositiontaking]
           ,tmp.[mpositiontaking]
           ,tmp.[spositiontaking]
           ,tmp.[playerdiscount]
           ,tmp.[discount]
           ,tmp.[adiscount]
           ,tmp.[sdiscount]
           --,tmp.[autopositiontaking]
           --,tmp.[isautopositiontaking]
           --,tmp.[autompositiontaking]
           --,tmp.[isautompositiontaking]
		)
	;

	DROP TABLE #kenoBetType;
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
	, @IsDisable BIT = 0

SELECT @maxCustID = 1000000--MAX(CustId) FROM dbo.custInfo WITH (NOLOCK)

CREATE TABLE #temp (
	custid INT PRIMARY KEY
	,isfinished BIT
	)

INSERT INTO #temp (
	custid
	,isfinished
	)
SELECT cs.custid
	,0
FROM dbo.CustOverride3rd cs WITH (NOLOCK)
	INNER JOIN dbo.custInfo ci WITH (NOLOCK)
	ON cs.custid = ci.custid
		AND cs.sporttype = 161 -- Number Game 
		AND cs.bettype = 81
WHERE ci.srecommend IN (
		SELECT custid
		FROM dbo.Dep_CustSuper WITH (NOLOCK)
		)
	AND ci.roleid IN (2, 3, 4)
	AND ci.custid <= @maxCustID

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
	PRINT 'Keno- (CustGameType,CustSettingGame) - insert completed - ' + CAST((@rowTotal * 9 * 2) AS VARCHAR(20)) + 'rows'
GO
