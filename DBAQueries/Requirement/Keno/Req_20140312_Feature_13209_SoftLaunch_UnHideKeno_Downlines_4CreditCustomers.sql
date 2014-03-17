/** SP to insert default setting of Keno game - soft launch/unhide keno downlines **/
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09] 
	@ids VARCHAR(MAX)
	, @IsDisable BIT = 0 
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

		INSERT INTO @res(custid)
		VALUES (CAST(@word AS INT))

		SET @i = @i + 1
	END	
	
	
	
	IF NOT EXISTS ( SELECT * FROM sys.objects WHERE NAME IN ('custInfo') AND type = 'U')
		RETURN
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
	Task: Unhine keno downline's setting of Keno game for credit customers
	DB: DBTRANS/CustDB
*/
--USE CustDB
--GO

CREATE TABLE #temp (
	custid INT PRIMARY KEY
	,isfinished BIT
	)


-- insert super
INSERT INTO #temp (
	custid
	,isfinished
	)
SELECT custid	,0
FROM custinfo WITh(NOLOCK)
WHERE srecommend IN (324563, --SRRMB
				356947, --SKWRMB
				365484, --S5M
				409412, --SYLRM
				409422, --SYLSD
				410722, --SDRM
				410800, --SDSD
				421328, --S71RM
				426131, --S49RM
				433306, --S11S
				443008, --S3ARM
				461084, --S11SM
				463281, --S93RM
				475270, --SMSM
				490037, --SVM
				499837, --SDARM
				592761, --S93M
				604044, --S7RM
				695131, --S51SM
				753624, --SOGO
				754114, --SYM
				755409, --STPM
				817188, --S42RM
				831604, --S93S
				918522, --SCES
				960134, --SVS
				985934, --SRH
				994666, --SAKM
				1013016, --SRHK
				1016771, --S88M
				1108229, --S85S
				1207541, --S42S
				1211027, --SMMS
				1211237, --SWM
				1248383, --JAS
				1317514, --S95M
				1407085, --MKM
				1437908, --MKS
				1492016, --s45m
				1549924, --S12M
				1603986, --JAM
				1690560, --S41S
				1690565, --S41M
				1797678, --JM
				1809686, --HIM
				1886999, --S85M
				1995341, --SKM
				2026798, --KYM
				2143522, --SPKM
				2181203, --SPKR
				2192160, --SSSD
				2193103, --S23S
				2222683, --SLLM
				2267027, --AHS
				2279631, --SFS
				2291699, --S95RM
				2304163, --JAU
				2425944, --HS
				2428032, --S42ARM
				2453866, --SYLM
				2462689, --JAD
				2490335, --DKS
				2504697, --SOGA
				2779621, --S95AM
				2797447, --S71M
				2807180, --S11M
				2829199, --SJS
				2882278, --HM
				2957601, --S71MA
				2967044, --SSM
				3009929, --SSTMM
				3019886, --S43S
				3049143, --S822MA
				3099712, --JS9
				3149272, --S62M
				3150153, --PTM
				3345772, --SKMM
				3390598, --HHBS
				3513305, --S42M
				3515870, --SBTN
				3569374, --HPN
				3574705, --PPM
				3589744, --KS6
				3854395, --S797S
				3872491, --AHT
				4014144, --BYS
				4037357, --KPM
				4037362, --PKRM
				4045713, --WMA
				4445198, --LHM
				4500902, --SYSM
				4546355, --AHSD
				4622126, --JMA
				4622222, --SBSD
				4940784, --DKD
				5044097, --HPMM
				5336854, --AHV
				5394462, --CCM
				5395663, --SATS
				5402188, --THM
				5515793, --hhma
				5712158, --AX
				5839381, --SSMS
				5931469, --YKM
				5973408, --CYKM
				6087132, --JCM
				7186058, --S359S
				7753071, --S359am
				7753114, --LHM1
				7753178, --S359bm
				7753926, --LHM2
				7756603, --QQMW
				7756631, --QQMY
				7756637, --QQMA
				7756855, --SLP
				7757274, --SLG
				7757511, --SLQ
				7781015, --SATM
				7958991, --HHN
				8050233, --FYS
				8100556, --S70M
				8103018, --LHS 
				8119630, --SG8M
				8148919, --S25RM
				8236892, --L25RM
				8259601, --MKM2
				8282635, --SBTL
				8315715, --SMY
				8418920, --SLR
				8452452, --WD
				8864806, --WMB
				9334173, --WC
				9387568, --S11M1
				9387880, --S11M2
				9387993, --S11M4
				9388053, --S11M5
				9388086, --S11M6
				9388111, --S11M7
				9388127, --S11M8
				9579024, --cks
				9691000, --S45AM
				10406226, --KKM
				10515004, --KKMA
				10530225, --LGA
				10551433, --KKS
				10560596, --C2
				10746159, --S93D
				10775412, --C3
				11014062, --S11N
				11158383, --KKC
				11158421, --KKD
				11158444, --KKE
				11158478, --KKJ
				11158538, --KKN
				11173365, --HPD
				11472964, --YUM
				11548361, --PKO
				11566943, --FJM
				11584923, --SAZM
				11760592, --JJM
				12070389, --C12
				12142609, --S53S
				12294019, --MKS1
				12334400, --KKF
				12341915, --S2MM
				12343462, --WVW
				12550356, --AXA
				12575535, --SJSD
				13058363, --AHZ
				13691135, --KKL
				13856586, --KP
				14014232 --KAA
			) and roleid <> 4

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
		, @rowTotal = @rowTotal + @@rowcount

	IF(@rowcnt > 0)
	BEGIN
		EXEC Acc_ExecRep_Cust_09 @ids = @ids
			, @IsDisable = @HideKeno
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
	PRINT 'Un-HideKeno- completed.'
GO
