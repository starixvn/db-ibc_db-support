/** SP to insert default setting of Keno game - deposit customers **/
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

	SET @IsDisable = ISNULL(@IsDisable, 1)

	IF NOT EXISTS ( SELECT * FROM sys.objects WHERE NAME IN ('custInfo') AND type = 'U')
		RETURN

	--update hidekeno
	UPDATE c
	SET HideKeno = @IsDisable
	FROM dbo.custinfo c WITH(ROWLOCK, UPDLOCK)
	INNER JOIN @res res on c.custid = res.custid

	--create gametype data
	DECLARE @kenoBetType AS TABLE (sporttype INT, bettype INT, gametypeid INT)

	INSERT INTO @kenoBetType(sporttype, bettype, gametypeid)
	SELECT sporttype, bettype, gametypeid
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

	IF NOT EXISTS ( SELECT * FROM sys.objects WHERE NAME = 'custgametype' AND type = 'U' )
		OR @@SERVERNAME IN ('DBBingoAdmin','DBLVCasino','DBBingo01','DBCasinoAdmin','DBCasinoQA1','DBCasinoQA2','LiveCasinoAdminDB')
		RETURN

	--insert into CustGameType
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
		CROSS JOIN @kenoBetType t
		WHERE cs.[sporttype] = 161
			AND cs.[bettype] = 81
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
	FROM kenoCustGameType tmp
	;

	IF NOT EXISTS ( SELECT * FROM sys.objects WHERE NAME = 'CustSettingGame' AND type = 'U' )
		RETURN

	--insert into CustSettingGame
	;WITH kenoCustSettingGame AS 
	(
		SELECT c.[CustID]
		,t.[Bettype]
		,t.[Sporttype]
		,case c.roleid --agent/member
			when 4 then 0.85 
			when 2 then 0.85 
			when 1 then 0.85 
			else 0 
			end AS [apositiontaking]
		,case c.roleid ----master
			when 4 then 0.85 
			when 3 then 0.85 
			else 0 
			end AS [mpositiontaking]
		,case c.roleid --super
			when 4 then 0.85 
			else 0 
			end AS [spositiontaking]
		,0 AS [playerdiscount]
		,0 AS [discount]
		,0 AS [adiscount]
		,0 AS [sdiscount]
		,0.00 AS [autopositiontaking]
		,0 AS [isautopositiontaking]
		,0.00 AS [autompositiontaking]
		,0 AS [isautompositiontaking]
		FROM @res AS res 
		INNER JOIN dbo.custinfo c WITH(NOLOCK)
			ON res.custid = c.custid
		CROSS JOIN (select top 1 * from @kenoBetType where bettype=1501) t
	)
	INSERT INTO [dbo].[CustSettingGame]([CustID]
	   ,[Bettype]
	   ,[Sporttype]
	   ,[apositiontaking]
	   ,[mpositiontaking]
	   ,[spositiontaking]
	   ,[playerdiscount]
	   ,[discount]
	   ,[adiscount]
	   ,[sdiscount]
	   ,[autopositiontaking]
	   ,[isautopositiontaking]
	   ,[autompositiontaking]
	   ,[isautompositiontaking]
	)
	SELECT tmp.[CustID]
	   ,tmp.[Bettype]
	   ,tmp.[Sporttype]
	   ,tmp.[apositiontaking]
	   ,tmp.[mpositiontaking]
	   ,tmp.[spositiontaking]
	   ,tmp.[playerdiscount]
	   ,tmp.[discount]
	   ,tmp.[adiscount]
	   ,tmp.[sdiscount]
	   ,tmp.[autopositiontaking]
	   ,tmp.[isautopositiontaking]
	   ,tmp.[autompositiontaking]
	   ,tmp.[isautompositiontaking]
	FROM kenoCustSettingGame tmp
	;
END
GO

/*
	Created: Bobby
	Date: 20140303
	Task: Insert default setting of Keno game for deposit customers
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
SELECT ci.custid
	,0
FROM dbo.custInfo ci WITH (NOLOCK)
WHERE ci.srecommend IN (
		SELECT custid
		FROM dbo.Dep_CustSuper WITH (NOLOCK)
	)
	AND ci.roleid IN (1,2,3,4)
	--AND ci.custid <= @maxCustID

	
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
