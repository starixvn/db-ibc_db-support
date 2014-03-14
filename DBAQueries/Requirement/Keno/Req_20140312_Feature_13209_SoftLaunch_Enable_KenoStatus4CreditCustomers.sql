/** SP to insert default setting of Keno game - soft launch **/
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

	IF NOT EXISTS ( SELECT * FROM sys.objects WHERE NAME = 'custgametype' AND type = 'U' )
		OR @@SERVERNAME IN ('DBBingoAdmin','DBLVCasino','DBBingo01','DBCasinoAdmin','DBCasinoQA1','DBCasinoQA2','LiveCasinoAdminDB')
		RETURN
	UPDATE cg
	SET [IsDisabled] = CASE WHEN GameTypeID IN (2,6) THEN 1 ELSE @IsDisable END
	FROM [dbo].[CustGameType] cg WITH(ROWLOCK, UPDLOCK)
	WHERE cg.custid IN (SELECT custid FROM @res)

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


--SELECT @maxCustID = MAX(CustId) FROM dbo.custInfo WITH (NOLOCK)

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
WHERE custid IN (
					211566	, --S33M
					266414	, --S31M
					324563	, --SRRMB
					356947	, --SKWRMB
					365483	, --S5S
					365484	, --S5M
					390567	, --S33SM
					398437	, --SGM
					398467	, --SMM
					398615	, --SCM
					398636	, --SCS
					399208	, --SGS
					400973	, --HIS
					404941	, --S305RM
					404986	, --S69SD
					405017	, --S56RM
					405391	, --S36RM
					405422	, --S58RM
					405975	, --S79RM
					406808	, --TAS51S
					406935	, --S47SD
					407649	, --SMORM
					407731	, --SS31S
					408317	, --S31RM
					409412	, --SYLRM
					409422	, --SYLSD
					409524	, --S31SD
					410722	, --SDRM
					410800	, --SDSD
					421328	, --S71RM
					426131	, --S49RM
					430524	, --S91RM
					430735	, --SHSD
					431696	, --S33S
					433306	, --S11S
					443008	, --S3ARM
					461084	, --S11SM
					463281	, --S93RM
					475270	, --SMSM
					478394	, --S69RM
					480725	, --S47RM
					490037	, --SVM
					499837	, --SDARM
					507226	, --S188RM
					512864	, --S188ARM
					534868	, --S56ARM
					550141	, --S31ARM
					550155	, --S56BRM
					592761	, --S93M
					604044	, --S7RM
					695131	, --S51SM
					735044	, --SCSM
					753624	, --SOGO
					754114	, --SYM
					755409	, --STPM
					774698	, --SEM
					787938	, --SJM
					794766	, --SG1M
					796555	, --SPHM
					817188	, --S42RM
					826317	, --S56CRM
					831604	, --S93S
					877770	, --S56DRM
					918522	, --SCES
					960134	, --SVS
					976536	, --JES
					985934	, --SRH
					994666	, --SAKM
					1013016	, --SRHK
					1016771	, --S88M
					1108229	, --S85S
					1111902	, --s66s
					1207541	, --S42S
					1211024	, --S2M
					1211027	, --SMMS
					1211237	, --SWM
					1247148	, --SRMA
					1248383	, --JAS
					1317514	, --S95M
					1342397	, --S922M
					1355380	, --SAPM
					1376434	, --wm
					1389689	, --hhm
					1407085	, --MKM
					1437908	, --MKS
					1448199	, --S99M
					1452602	, --S32M
					1456420	, --S32AM
					1492016	, --s45m
					1549924	, --S12M
					1571642	, --SMOM
					1593254	, --SBS
					1603986	, --JAM
					1604404	, --SBM
					1606473	, --MKM1
					1628179	, --AHM
					1690560	, --S41S
					1690565	, --S41M
					1797678	, --JM
					1809686	, --HIM
					1865464	, --KJM
					1886999	, --S85M
					1995341	, --SKM
					2026798	, --KYM
					2042873	, --S822M
					2116268	, --SGSM
					2116391	, --SGSN
					2143522	, --SPKM
					2181203	, --SPKR
					2192160	, --SSSD
					2193103	, --S23S
					2222683	, --SLLM
					2251491	, --HPM
					2258222	, --S35M
					2267027	, --AHS
					2279631	, --SFS
					2291699	, --S95RM
					2304163	, --JAU
					2425944	, --HS
					2428032	, --S42ARM
					2453866	, --SYLM
					2462689	, --JAD
					2464066	, --S922N
					2490335	, --DKS
					2504697	, --SOGA
					2509713	, --S688M
					2518720	, --S90RM
					2779621	, --S95AM
					2797447	, --S71M
					2807180	, --S11M
					2829199	, --SJS
					2882278	, --HM
					2957601	, --S71MA
					2967044	, --SSM
					3009929	, --SSTMM
					3019886	, --S43S
					3049143	, --S822MA
					3090145	, --SCLM
					3098979	, --DDT
					3099712	, --JS9
					3149272	, --S62M
					3150153	, --PTM
					3345772	, --SKMM
					3390598	, --HHBS
					3513305	, --S42M
					3515870	, --SBTN
					3569374	, --HPN
					3574705	, --PPM
					3589738	, --KM6
					3589744	, --KS6
					3623378	, --SPSD
					3654316	, --S32BM
					3854395	, --S797S
					3854925	, --KJMB
					3872491	, --AHT
					4014144	, --BYS
					4037357	, --KPM
					4037362	, --PKRM
					4045713	, --WMA
					4445198	, --LHM
					4487258	, --SG2M
					4500902	, --SYSM
					4508624	, --SGMM
					4546355	, --AHSD
					4622126	, --JMA
					4622222	, --SBSD
					4913546	, --S922MA
					4940784	, --DKD
					5005322	, --S09M
					5044097	, --HPMM
					5154534	, --2MM
					5334777	, --SG3M
					5336854	, --AHV
					5394462	, --CCM
					5395663	, --SATS
					5395973	, --S56SD
					5402188	, --THM
					5416825	, --KJMC
					5473299	, --SLM
					5515793	, --hhma
					5572280	, --KJMA
					5712158	, --AX
					5839381	, --SSMS
					5900375	, --SEMA
					5931469	, --YKM
					5973408	, --CYKM
					6087132	, --JCM
					6385611	, --S359M
					6525867	, --KJMD
					7165346	, --SG5M
					7186058	, --S359S
					7375633	, --KJME
					7596459	, --SG6M
					7680993	, --SG7M
					7753071	, --S359am
					7753114	, --LHM1
					7753178	, --S359bm
					7753926	, --LHM2
					7754654	, --S31BRM
					7756563	, --QQMZ
					7756603	, --QQMW
					7756631	, --QQMY
					7756637	, --QQMA
					7756855	, --SLP
					7757274	, --SLG
					7757511	, --SLQ
					7772139	, --S359CM
					7781015	, --SATM
					7958991	, --HHN
					8050233	, --FYS
					8100556	, --S70M
					8103018	, --LHS 
					8119630	, --SG8M
					8148919	, --S25RM
					8236892	, --L25RM
					8259601	, --MKM2
					8281764	, --2MN
					8282635	, --SBTL
					8315715	, --SMY
					8418920	, --SLR
					8452452	, --WD
					8488636	, --S31RRM
					8864806	, --WMB
					9057662	, --S31ASD
					9309922	, --S35RM
					9334173	, --WC
					9387568	, --S11M1
					9387880	, --S11M2
					9387993	, --S11M4
					9388053	, --S11M5
					9388086	, --S11M6
					9388111	, --S11M7
					9388127	, --S11M8
					9507450	, --sg9m
					9579024	, --cks
					9670471	, --2RM
					9691000	, --S45AM
					9727510	, --TP
					10346359	, --XKM
					10406226	, --KKM
					10431004	, --S31BSD
					10515004	, --KKMA
					10530225	, --LGA
					10551433	, --KKS
					10560596	, --C2
					10746159	, --S93D
					10775412	, --C3
					10933415	, --SVVG
					11014062	, --S11N
					11158383	, --KKC
					11158421	, --KKD
					11158444	, --KKE
					11158478	, --KKJ
					11158538	, --KKN
					11173365	, --HPD
					11242704	, --SPA1M
					11472964	, --YUM
					11548361	, --PKO
					11566943	, --FJM
					11584923	, --SAZM
					11733282	, --2NN
					11760592	, --JJM
					12070389	, --C12
					12142609	, --S53S
					12294019	, --MKS1
					12334400	, --KKF
					12341915	, --S2MM
					12343462	, --WVW
					12478088	, --SPA2M
					12550356	, --AXA
					12554928	, --2RR
					12575535	, --SJSD
					13058363	, --AHZ
					13448992	, --SMOG
					13615649	, --SPA3M
					13691135	, --KKL
					13856586	, --KP
					14014232	 --KAA
				)




-- insert direct master
INSERT INTO #temp (	custid	,isfinished	)
SELECT custid	,0
FROM custinfo WITh(NOLOCK)
WHERE custid IN (
					4356	, --MYRM
					5646	, --MGRM
					5664	, --MMMRM
					8979	, --MKKRM
					10708	, --M7RM
					14943	, --M12RM
					27026	, --MAMRM
					33903	, --M96RM
					35916	, --M51SD
					39577	, --M7ARM
					43272	, --M83RM
					47030	, --M6SD
					62834	, --M359RM
					63908	, --MHOSD
					65338	, --M25RM
					68899	, --M359SD
					73166	, --M98RM
					84546	, --M7SD
					98332	, --M359ARM
					121951	, --MQRM
					141928	, --MYMRM
					156071	, --MQARM
					175114	, --M88SD
					186017	, --M359ASD
					207868	, --MKWRM
					212644	, --MYSD
					221617	, --M258RM
					268037	, --M26RM
					289107	, --M7BRM
					290014	, --M73SD
					299760	, --MHORM
					325234	, --MMYBRM
					385148	, --MMPRM
					396127	, --M1169RM
					398333	, --M58SD
					399939	, --M32RM
					406807	, --M73ASD
					406811	, --M73BSD
					406814	, --M73CSD
					406821	, --M73DSD
					406840	, --M73ESD
					417557	, --M26SD
					419150	, --M50RM
					420686	, --M95RM
					421237	, --M53SD
					425835	, --MHO1SD
					449152	, --M83ARM
					453838	, --M88ASD
					459679	, --MPHSD
					487518	, --MHO2SD
					523977	, --M90RM
					555878	, --M822M
					591149	, --M188SD
					610550	, --M797M
					615061	, --M797AM
					647524	, --M116RM
					668389	, --M797RM
					692439	, --M116ARM
					698981	, --MMSD
					732206	, --M11SD
					777485	, --M7CRM
					835906	, --M169RM
					947130	, --M6RM
					974626	, --M26ARM
					1132163	, --M32M
					1175946	, --M553M
					1336489	, --M922M
					1349153	, --MHOASD
					1822905	, --MA
					2026854	, --MKYM
					2279092	, --M42M
					3080124	, --M62SD
					3535160	, --M222M
					4330184	, --M93S
					4458183	, --FFM
					5875579	, --MPKS
					8266979	, --MALM
					8436230	, --M88M
					12023210	, --M3CRM
					13876211	 --BPK
				)


-- insert srecommend of direct master
INSERT INTO #temp (custid,isfinished)
SELECT custid	,0
FROM custinfo WITh(NOLOCK)
WHERE custid IN (
					1	, --SA-SD$
					2	 --SA-RM
				)

-- insert direct agent
INSERT INTO #temp (custid,isfinished)
SELECT custid	,0
FROM custinfo WITh(NOLOCK)
WHERE custid IN (
					3290	, --6599RM
					3556	, --PHRM
					4295	, --TKRM
					4487	, --113SD
					5261	, --JMRM
					5966	, --1188RM
					10793	, --ywrm
					11237	, --1158RM
					32422	, --SORM
					46846	, --2588RM
					95304	, --69SD
					374774	, --330SD
					1052570	, --2588SD
					1486674	, --DDS
					3633125	, --21M
					4184712	, --A31M
					7380795	, --S116SD
					11760526	, --A68M
					13740659	, --B31BP
					13755773	 --A31AP
				)

-- insert srecommend, mrecommend of direct agent
INSERT INTO #temp (custid,isfinished)
SELECT custid	,0
FROM custinfo WITh(NOLOCK)
WHERE custid IN (
					4174	,	--mrm
					4175	,	--msd
					13755673	--MSSD
				)


-- insert direct member
INSERT INTO #temp (custid,isfinished)
SELECT custid	,0
FROM custinfo WITh(NOLOCK)
WHERE custid IN (
					1290	, --302RM
					1308	, --3008RM
					1373	, --92RM
					1482	, --085RM
					1491	, --D922RM
					1525	, --359RM
					1558	, --346RM
					1570	, --415NSD
					1579	, --659RM
					1588	, --688rm
					2397	, --42rm
					2662	, --359SD
					4002	, --HD359
					10732	, --3008ARM
					23123	, --79RM
					53307	, --3SEXT
					199003	, --phsd
					626836	, --42sd
					1174444	, --D2RM
					1207218	, --D3RM
					1726578	, --SZM
					1899936	, --33RM
					2042328	, --D5RM
					2638845	, --TH8m
					3646080	, --95RMOLD
					5544917	, --BTRM
					11024893	 --31bsd
				)


-- insert srecommend, mrecommend of direct member
INSERT INTO #temp (custid,isfinished)
SELECT custid	,0
FROM custinfo WITh(NOLOCK)
WHERE custid IN (
					1269	,	--wssd
					1262		--wsrm					
				)


GO
DECLARE @IsDisable BIT = 0

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
