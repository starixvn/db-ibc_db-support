/** SP to insert default setting of Keno game **/
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09] 
	@ids VARCHAR(MAX)
	, @IsDisable BIT = 0 
AS
/*
	Created: Bobby
	Date: 20140312
	Task: Enable default setting of Keno game for credit customers
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
			WHERE NAME IN ('CustGameType', 'custInfo')
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

	;WITH kenoBetType AS 
	(
		SELECT 202 AS sporttype
			, IBCBetTypeID AS bettype
			, GameTypeID
		FROM DBPRO.bodb02.dbo.GameType WITH(NOLOCK)
		WHERE [IBCBetTypeID] >=  1501 AND [IBCBetTypeID] <= 1509
		AND IsDisabled = 0
	)
	,kenoEnableSetting AS
	(
		SELECT res.custid
			, t.[gametypeid]
			, @IsDisable [IsDisabled] 
		FROM @res res
		CROSS JOIN kenoBetType t
	)
	UPDATE cg
	SET [IsDisabled] = tmp.[IsDisabled]
	FROM [dbo].[CustGameType] cg WITH(ROWLOCK, UPDLOCK)
	INNER JOIN kenoEnableSetting tmp
		ON cg.custid = tmp.custid AND cg.gametypeid = tmp.gametypeid
	;
	--update hidekeno
	UPDATE cust
	SET HideKeno = @IsDisable
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
	, @IsDisable BIT = 0

--SELECT @maxCustID = MAX(CustId) FROM dbo.custInfo WITH (NOLOCK)

CREATE TABLE #temp (
	custid INT PRIMARY KEY
	,isfinished BIT
	)

;

WITH custInit
AS (
	SELECT c1.custid
		,c1.roleid
	FROM dbo.custInfo c1 WITH (NOLOCK)
	WHERE username IN (
			'302RM', 'M32RM', 'M32M', 'S32M', 'S32AM', 'S32BM', '92RM', 'MGRM', 'SGM', 'SG1M', 'SG2M', 'SG3M', 'SG5M', 'SG6M', 'SG7M', 'SG8M', 'sg9m', 'D922RM', 'M922M', 'S922M', 'S922N', 'S922MA', '359RM', '359SD', 'HD359', 'M359RM', 'M359SD', 'M359ARM', 'M359ASD', 'S359CM', 'SKM', 'PHRM', 'phsd', 'MPHSD', 'SPHM', 'SPKM', 'SPKR', 'TKRM', 'MYRM', 'MYMRM', 'MYSD', 'SYM', 'JMRM', 'S35M', 'S35RM', 'MMMRM', 'MMPRM', 'SMM', 'SMSM', 'MMSD', 'SMMS', 'SSMS', 'MKKRM', 'M7RM', 'M7ARM', 'M7SD', 'M7BRM', 'M7CRM', 'ywrm', '1158RM', 'M58SD', 'S58RM', '659RM', '6599RM', 'MALM', 'M12RM', 'S12M', 'SGS', 'SGSM', 'SGSN', 'SGMM', 'MAMRM', 'M96RM', '2588RM', 'M258RM', '2588SD', 'MHOSD', 'MHORM', 'MHO1SD', 'MHO2SD', 'MHOASD', 'M25RM', 'S25RM', 'L25RM', 'S09M', 'MQRM', 'MQARM', 'MMYBRM', 'BYS', '3SEXT', 'S33M', 'S33SM', 'S33S', '33RM', 'PTM', 'M26RM', 'M26SD', 'M26ARM', 'SVM', 'SVS', 'M11SD', 'S5S', 'S5M', '330SD', 'M1169RM', 'M116RM', 'M116ARM', 'M169RM', 'SCM', 'SCS', 'SCSM', 'HIS', 'HIM', '69SD', 'S69SD', 'S69RM', 'S7RM', 'S56RM', 'S56ARM', 'S56BRM', 'S56CRM', 'S56DRM', 'S56SD', '346RM', 'S36RM', '79RM', 'S79RM', 'WD', 'WC', 
			'M51SD', 'TAS51S', 'S51SM', 'S47SD', 'S47RM', 'SMORM', 'SMOM', 'SMOG', 'SS31S', 'S31SD', 'S31ARM', 'SAPM', 'A31M', 'S116SD', 'S31RRM', 'S31ASD', 'S31BSD', 'SPA1M', 'M3CRM', 'SPA2M', 'SPA3M ', 'A31AP', 'B31BP', 'M50RM', 'M53SD', 'S53S', 'S49RM', 'S91RM', 'SSTMM', 'S3ARM', 'M83RM', 'M83ARM', 'S31M', 'M98RM', 'SDRM', 'SDSD', 'SDARM', '1188RM', 'S188RM', 'S188ARM', 'M188SD', 'M90RM', 'S90RM', 'M6SD', 'M6RM', 'M73SD', 'M73ASD', 'M73BSD', 'M73CSD', 'M73DSD', 'M73ESD', 'S11S', 'S11SM', 'S11M', 'S11M1', 'S11M2', 'S11M4', 'S11M5', 'S11M6', 'S11M7', 'S11M8', 'S11N', 'M88SD', 'M88ASD', 'S88M', 'M88M', 'M553M', 'S70M', 'SOGO', 'SOGA', 'SEM', 'SEMA', 'SJM', 'SJSD', 'S93RM', 'S93M', 'S93S', 'M93S', 'S93D', 'S305RM', 'S31RM', 'S31BRM', '31bsd', 'SHSD', 'hhm', 'hhma', 'HHN', 'SBS', 'SBM', 'SCES', 'M222M', '2MM', '2MN', '2RM', '2NN', '2RR', '688rm', 'S688M', 'SAKM', 'SORM', 'MKM', 'MKS', 'MKM1', 'THM', 'JCM', 'MKM2', 'MKS1', 'HM', 'DKD', 'KYM', 'MKYM', '085RM', 'S85S', 'S85M', 's66s', 'JES', 'TH8m', 'SBSD', 'D2RM', 'DDT', 'SPSD', 'SWM', 'D3RM', '42rm', '42sd', 'S42RM', 'S42S', 'M42M', 'S42ARM', 'S42M', 'S2M', 'S2MM', 
			'STPM', 'MKWRM', 'SRRMB', 'SKWRMB', 'SRH', 'SRHK', 'SRMA', 'JAS', 'JAM', 'JAU', 'S99M', 'M797M', 'M797AM', 'M797RM', 'wm', 'S797S', 'WMA', 'WMB', 'DDS', 's45m', 'S45AM', 'KJM', 'KJMB', 'KJMC', 'KJMA', 'KJMD', 'KJME', 'AHM', 'AHT', 'AHV', 'AHZ', 'DKS', '415NSD', 'S41S', 'S41M', 'S43S', 'JAD', 'SZM', 'MA', 'YKM', 'CYKM', 'M822M', 'S822M', 'S822MA', 'D5RM', 'HPM', 'HPN', 'HPMM', 'SMY', 'HPD', 'SLM', 'SSSD', 'S23S', 'SLLM', 'SATS', 'SATM', 'AHS', 'AHSD', 'SFS', 'JM', 'SJS', 'JS9', 'SYSM', 'JMA', 'M95RM', 'S95M', 'S95RM', 'S95AM', '95RMOLD', 'PPM', '3008RM', '3008ARM', 'HS', 'SYLRM', 'SYLSD', 'SYLM', 'S71RM', 'S71M', 'S71MA', 'SSM', 'SCLM', 'HHBS', 'SBTN', 'BTRM', 'SBTL', 'M62SD', 'S62M', 'KM6', 'KS6', '113SD', 'SKMM', 'CCM', 'PKRM', 'MPKS', 'PKO', 'FYS', 'KPM', 'WVW', 'LHM', 'LHM1', 'LHM2', 'LHS ', 'JJM', 'AX', 'AXA', 'SVVG', 'S359M', 'S359S', 'S359am', 'S359bm', 'SLP', 'SLG', 'SLQ', 'SLR', 'LGA', 'QQMZ', 'QQMW', 'QQMY', 'QQMA', 'TP', 'KKM', 'KKMA', 'KKS', 'KKC', 'KKD', 'KKE', 'KKJ', 'KKN', 'KKF', 'KKL', 'KAA', 'XKM', 'cks', 'C2', 'C3', 'C12', 'KP', 'YUM', 'FJM', 'SAZM', 'A68M', 'FFM', '21M', 'BPK'
			)
	)
	,custAgent
AS (
	SELECT recommend AS custid
	FROM custInfo cs WITH (NOLOCK)
		INNER JOIN custInit ci ON cs.custid = ci.custid
	WHERE ci.roleid = 1
	)
	,custMaster
AS (
	SELECT mrecommend AS custid
	FROM custInfo cs WITH (NOLOCK)
		INNER JOIN custInit ci ON cs.custid = ci.custid
	WHERE ci.roleid = 2
	)
	,custSuper
AS (
	SELECT srecommend AS custid
	FROM custInfo cs WITH (NOLOCK)
		INNER JOIN custInit ci ON cs.custid = ci.custid
	WHERE ci.roleid = 3
	)
INSERT INTO #temp (
	custid
	,isfinished
	)
SELECT t.custid
	,0
FROM (
	SELECT custid
	FROM custInit
	
	UNION
	SELECT custid
	FROM custAgent
	
	UNION
	SELECT custid
	FROM custMaster
	
	UNION
	SELECT custid
	FROM custSuper
	) t;

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
	PRINT 'Keno- (CustGameType) - update completed - ' + CAST((@rowTotal*7) AS VARCHAR(20)) + 'rows'
GO
