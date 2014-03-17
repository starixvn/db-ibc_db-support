/** SP to insert default setting of Keno game - soft launch/unhide keno downlines - enable sheet **/
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
	WHERE Username IN (
			'SG8M', 'SKM', 'PHRM', 'phsd', 'MPHSD', 'SPHM', 'SPKM', 'SPKR', 'TKRM', 'MYRM', 'MYMRM', 'MYSD', 'SYM', 'MMMRM', 'MMPRM', 'SMM', 'SMSM', 'MMSD', 'SMMS', 'SSMS', 'M7RM', 'M7ARM', 'M7SD', 'M7BRM', 'M7CRM', 'ywrm', 'M12RM', 'S12M', 'MAMRM', 'M96RM', '2588RM', 'M258RM', '2588SD', 'MHOSD', 'MHORM', 'MHO1SD', 'MHO2SD', 'MHOASD', 'M25RM', 'S25RM', 'L25RM', 'MQRM', 'MQARM', 'MMYBRM', 'BYS', 'PTM', 'M26RM', 'M26SD', 'M26ARM', 'SVM', 'SVS', 'M11SD', 'S5S', 'S5M', '330SD', 'M1169RM', 'M116RM', 'M116ARM', 'M169RM', 'HIS', 'HIM', 'S69SD', 'S69SD', 'S69RM', 'S7RM', 'S56RM', '79RM', 'S79RM', 'WD', 'WC', 'M51SD', 'TAS51S', 'S51SM', 'SS31S', 'M50RM', 'M53SD', 'S53S', 'S49RM', 'SSTMM', 'S3ARM', 'M83RM', 'M83ARM', 'SDRM', 'SDSD', 'SDARM', 'M6SD', 'M6RM', 'M73SD', 'M73ASD', 'M73BSD', 'M73CSD', 'M73DSD', 'M73ESD', 'S11S', 'S11SM', 'S11M', 'S11M1', 'S11M2', 'S11M4', 'S11M5', 'S11M6', 'S11M7', 'S11M8', 'S11N', 'M88SD', 'M88ASD', 'S88M', 'M88M', 'M553M', 'S70M', 'SOGO', 'SOGA', 'SJM', 'SJSD', 'S93RM', 'S93M', 'S93S', 'M93S', 'S93D', 'SHSD', 'hhm', 'hhma', 'HHN', 'SCES', 'SAKM', 'SORM', 'MKM', 'MKS', 'MKM1', 'THM', 'JCM', 
			'MKM2', 'MKS1', 'HM', 'DKD', 'KYM', 'MKYM', '085RM', 'S85S', 'S85M', 'TH8m', 'SBSD', 'SWM', '42rm', '42sd', 'S42RM', 'S42S', 'M42M', 'S42ARM', 'S42M', 'S2M', 'S2MM', 'STPM', 'MKWRM', 'SRRMB', 'SKWRMB', 'SRH', 'SRHK', 'SRMA', 'JAS', 'JAM', 'JAU', 'S99M', 'M797M', 'M797AM', 'M797RM', 'wm', 'S797S', 'WMA', 'WMB', 'DDS', 's45m', 'S45AM', 'AHM', 'AHT', 'AHV', 'AHZ', 'DKS', '415NSD', 'S41S', 'S41M', 'S43S', 'JAD', 'SZM', 'MA', 'YKM', 'CYKM', 'M822M', 'S822M', 'S822MA', 'HPM', 'HPN', 'HPMM', 'SMY', 'HPD', 'SLM', 'SSSD', 'S23S', 'SLLM', 'SATS', 'SATM', 'AHS', 'AHSD', 'SFS', 'JM', 'SJS', 'JS9', 'SYSM', 'JMA', 'M95RM', 'S95M', 'S95RM', 'S95AM', '95RMOLD', 'PPM', '3008RM', '3008ARM', 'HS', 'SYLRM', 'SYLSD', 'SYLM', 'S71RM', 'S71M', 'S71MA', 'SSM', 'SCLM', 'HHBS', 'SBTN', 'BTRM', 'SBTL', 'M62SD', 'S62M', 'KM6', 'KS6', '113SD', 'SKMM', 'CCM', 'PKRM', 'MPKS', 'PKO', 'FYS', 'KPM', 'WVW', 'LHM', 'LHM1', 'LHM2', 'LHS ', 'JJM', 'AX', 'AXA', 'S359M', 'S359S', 'S359am', 'S359bm', 'SLP', 'SLG', 'SLQ', 'SLR', 'LGA', 'QQMZ', 'QQMW', 'QQMY', 'QQMA', 'KKM', 'KKMA', 'KKS', 'KKC', 'KKD', 'KKE', 'KKJ', 'KKN', 'KKF', 'KKL', 'KAA', 'cks', 'C2'
			, 'C3', 'C12', 'KP', 'YUM', 'FJM', 'SAZM', 'FFM', '21M', 'BPK'
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


