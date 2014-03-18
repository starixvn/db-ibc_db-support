/** SP to insert default setting of Keno game - soft launch/unhide keno downlines- disable sheet **/
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09] 
	@ids VARCHAR(MAX)
	,@IsDisable BIT = 0
AS
/*
	Created: Bobby
	Date: 20140312
	Task:unhide keno downlines setting of Keno game for credit customers
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

		INSERT INTO @res (custid)
		VALUES (CAST(@word AS INT))

		SET @i = @i + 1
	END

	IF NOT EXISTS (
			SELECT *
			FROM sys.objects
			WHERE NAME IN ('custInfo')
				AND type = 'U'
			) RETURN

	--update hidekeno
	UPDATE cust
	SET HideKeno = @IsDisable
	FROM dbo.custinfo cust WITH (ROWLOCK, UPDLOCK)
		INNER JOIN @res res
		ON cust.custid = res.custid
END
GO

/*
	Created: Bobby
	Date: 20140303
	Task: Unhine keno downline's setting of Keno game for credit customers
	DB: DBTRANS/CustDB
*/
--USE CustDB
--GO
CREATE TABLE #temp (
	custid INT PRIMARY KEY
	,isfinished BIT DEFAULT 0
	);

WITH CustKenoTemp
AS (
	SELECT [srecommend]
	FROM [dbo].[custInfo] WITH (NOLOCK)
	WHERE Username IN ('302RM', 'M32RM', 'M32M', 'S32M', 'S32AM', 'S32BM', '92RM', 'MGRM', 'SGM', 'SG1M', 'SG2M', 'SG3M', 'SG5M', 'SG6M', 'SG7M', 'sg9m', '999SD', '999RM', '9999SD', 'M999SD', 'M9999S', 'S999S', 'D922RM', 'M922M', 'S922M', 'S922N', 'S922MA', '359RM', '359SD', 'HD359', 'M359RM', 'M359SD', 'M359ARM', 'M359ASD', 'S359CM', 'JMRM', 'S35M', 'S35RM', 'SGS', 'SGSM', 'SGSN', 'SGMM', '679SD', '679RM', 'KM', 'KS', 'KSD', 'KMM', 'KMA', 'KAM', 'KMAM', 'KMBM', 'S09M', '3SEXT', 'S33M', 'S33SM', 'S33S', '33RM', 'SCM', 'SCS', 'SCSM', 'S56ARM', 'S56BRM', 'S56CRM', 'S56DRM', 'S56SD', '346RM', 'S36RM', 'S47SD', 'S47RM', 'SMORM', 'SMOM', 'SMOG', 'S31SD', 'S31ARM', 'SAPM', 'A31M', 'S116SD', 'S31RRM', 'S31ASD', 'S31BSD', 'SPA1M', 'M3CRM', 'SPA2M', 'SPA3M ', 'A31AP', 'S91RM', 'S31M', 'M98RM', '1188RM', 'S188RM', 'S188ARM', 'M188SD', 'M90RM', 'S90RM', 'SEM', 'SEMA', 'S305RM', 'S31RM', 'S31BRM', '31bsd', 'SBS', 'SBM', 'M222M', '2MM', '2MN', '2RM', '2NN', '2RR', '688rm', 'S688M', 's66s', 'JES', 'D2RM', 'DDT', 'SPSD', 'D3RM', 'KJM', 'KJMB', 'KJMC', 'KJMA', 'KJMD', 'KJME', 'D5RM', 'SVVG', 'TP', 'XKM', 'MKKRM', 'A68M'
			)
	GROUP BY [srecommend]
	)
-- insert super
INSERT INTO #temp (
	custid
	)
SELECT custid
FROM custinfo c WITH (NOLOCK)
	INNER JOIN CustKenoTemp tmp
	ON c.[srecommend] = tmp.[srecommend]
GO

--run exceRep to un-hidekeno
DECLARE @HideKeno BIT = 0 --un-hidekeno for downlines
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
		,@rowTotal = @rowTotal + @@rowcount

	IF (@rowcnt > 0)
	BEGIN
		EXEC Acc_ExecRep_Cust_09 @ids = @ids
			,@IsDisable = @HideKeno
	END

	IF (
			@rowcnt < 10000
			OR @rowcnt = 0
			)
	BEGIN
		GOTO INS_COMPLETED
	END

	WAITFOR DELAY '00:00:01'
END

INS_COMPLETED:

DROP TABLE #temp

PRINT 'Un-HideKeno- completed.'
GO


