ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids varchar(max)
AS
SET NOCOUNT ON

/*
	Task: update sync & enable Bingo for all customer of INDO & 75555
	
*/
	
BEGIN
	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('custinfo') AND type = 'U') <> 1
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
	
		
	UPDATE custinfo WITH(ROWLOCK,UPDLOCK)
	SET SyncBingo = 1
		,DisableBingo = 0
	WHERE custid IN (SELECT * FROM @res)
		
END

GO

DECLARE @max_custid INT
CREATE TABLE #tmpCust (custid INT primary key, isfinished bit default(0))

SET @max_custid = 2100000000

--downline of supers
INSERT INTO #tmpCust (custid)
SELECT custid 
FROM custinfo WITH(NOLOCK)
WHERE custid <= @max_custid
AND	srecommend IN (
					9905998	, --AC1
					9906062	, --AC2
					9932698	, --AXT
					9934245	, --FYT
					10392284	, --HIT
					9931047	, --HT1
					9933782	, --HT2
					11306634	, --HT3
					1220879	, --JAT
					3642574	, --KJT
					10827167	, --KKB
					9933512	, --KKT
					9934169	, --QQTB
					1959073	, --S13T
					1211966	, --S222T
					1716860	, --S222TA
					1687347	, --S222TH
					1524867	, --S257BT
					1537781	, --S257CT
					1920932	, --S257DT
					1973870	, --S257FT
					1041778	, --S257T
					1045966	, --S2T
					1517541	, --S2TB
					9933834	, --S51TB
					1653823	, --S56TA
					905146	, --S56TB
					1234074	, --S56TC
					1868135	, --S56TD
					1537688	, --S56TH
					2404437	, --S56TT
					1099555	, --S5AT
					1100587	, --S5BT
					1102474	, --S5CT
					1257655	, --S5DT
					1263564	, --S5ET
					1012252	, --S5T
					1022678	, --S5TT
					11230222	, --S66T
					9918280	, --S69TB
					1896755	, --S85T
					1584514	, --S88T
					495306	, --S8KT
					200032	, --S8T
					9933965	, --S922V
					1790291	, --S99T
					912272	, --S99TB
					9925322	, --S99TH
					995996	, --SFX
					9934055	, --SG1T
					9934074	, --SG2T
					9934146	, --SG3T
					1517548	, --SGAT
					905132	, --SGATB
					1523716	, --SGBT
					1523717	, --SGCT
					1517544	, --SGT
					642386	, --SGTB
					1584515	, --SHHT
					9840536	, --SLC
					9840478	, --SLT
					1258823	, --SYT
					985909	, --TL1
					985911	, --TL2
					985912	, --TL3
					987490	, --TL4
					994756	, --TL5
					1083052	, --TL6
					1528421	, --B10T
					1528422	, --B11T
					1536432	, --B12T
					1538057	, --B13T
					1538175	, --B14T
					1538183	, --B15T
					1538997	, --B16T
					1539009	, --B17T
					1539693	, --B18T
					1539698	, --B19T
					1523261	, --B1T
					1539699	, --B20T
					1539700	, --B21T
					1540216	, --B22T
					1540217	, --B23T
					1588140	, --B24T
					1588145	, --B25T
					2508822	, --B26T
					2541779	, --B27T
					7815141	, --B29T
					1528410	, --B2T
					8458736	, --B30T
					9664861	, --B31T
					9669693	, --B32T
					9933863	, --B33T
					9934001	, --B34T
					9933940	, --B35T
					9934027	, --B36T
					9934190	, --B37T
					9934210	, --B38T
					9934227	, --B39T
					1528411	, --B3T
					1528413	, --B4T
					1517951	, --B5T
					1528414	, --B6T
					1528418	, --B7T
					1528419	, --B8T
					1528420	, --B9T
					1517030	, --BT
					2421122	, --SABT
					1558372	, --SBBT
					2272187	, --SBCT
					1190555	, --SBT
					199094	, --ST
					641140	, --ST1T
					641144	, --ST2T
					641145	, --ST3T
					641148	, --ST4T
					901858	, --ST5T
					901862	, --ST6T
					901864	, --ST7T
					1099499	, --ST8T
					1101895	, --ST9T
					2388779	, --STEB
					487415	, --STT
					8205964	, --2DD
					10050741	, --2DE
					4546372	, --2ID
					1575555	, --AA
					3502109	, --AHD
					1954973	, --AHI
					4404031	, --AJ
					3977088	, --AL
					5086616	, --AN
					4314665	, --AP
					4212172	, --AS
					1812820	, --AW
					1584509	, --BA
					642291	, --BI
					1563928	, --CI
					4663772	, --CL
					2083036	, --CO
					2131553	, --CS
					2103376	, --CU
					10792955	, --CY
					4419846	, --D60
					3965614	, --D8G
					2078394	, --DA
					897588	, --DI
					1372998	, --DW
					11748799	, --E60
					4505274	, --FA
					1373748	, --FF
					11665608	, --FM
					5969746	, --GA
					747037	, --GI
					3824490	, --GN
					5420391	, --HA
					4664545	, --HD
					4915387	, --HE
					10182407	, --HF
					10573500	, --HH
					641918	, --HI
					712439	, --HP
					11242675	, --HPA
					11241067	, --HPE
					7723444	, --HPH
					5215598	, --HPI
					7656188	, --HPJ
					4100592	, --IB
					1716173	, --IC
					3526034	, --ID
					689767	, --II
					4802250	, --IK
					4378806	, --IM
					4404078	, --IN
					1564982	, --IP
					2831595	, --IR
					4152553	, --JA
					4404067	, --JB
					4437168	, --JC
					2302419	, --JJ
					4792246	, --KD
					3296923	, --KJI
					5055525	, --KL
					5771986	, --LA
					3770553	, --LB
					3810488	, --LC
					3954915	, --LD
					3973944	, --LE
					4189499	, --LF
					7680679	, --LG
					2749224	, --LH
					643456	, --LI
					8035161	, --LII
					2075688	, --LJ
					4100631	, --LK
					3556221	, --LL
					7680792	, --LM
					5473265	, --LS
					4367748	, --LT
					2835363	, --LU
					4006796	, --LV
					3539862	, --LY
					11548722	, --MH
					1581733	, --MM
					11674017	, --MO
					11674030	, --MP
					919892	, --MW
					4546391	, --PKID
					1349398	, --QQ
					11322574	, --QQMD
					1586764	, --RR
					4582838	, --S11RD
					1524078	, --S11RP
					11211742	, --S11RUP
					524760	, --S16RUP
					550945	, --S18RUP
					1177375	, --S257I
					7809141	, --S31D
					4672707	, --S42D
					8553985	, --S47DR
					3047517	, --S47IR
					981129	, --S5
					8062488	, --S56AI
					3681857	, --S56D
					2518170	, --S56I
					8237040	, --S56II
					1149824	, --S5AU
					1397026	, --S5I
					1576179	, --S60AR
					510159	, --S60RUP
					9727438	, --S62D
					6153706	, --S69RD
					835418	, --S6ARUP
					549191	, --S6RUP
					3131791	, --S79I
					7374379	, --S7D
					7260786	, --S822D
					7776236	, --S88D
					4744473	, --SADA
					4320374	, --SB
					3759177	, --SBTD
					4283123	, --SEA
					7410076	, --SEB
					3539281	, --SED
					3237129	, --SEI
					1504835	, --SGI
					11314815	, --SGRD
					3459605	, --SHI
					185849	, --SI
					2817968	, --STIR
					867735	, --SW
					1386293	, --TI
					4677011	, --UA
					4677048	, --UB
					656135	, --UI
					4048531	, --UK
					4323575	, --UL
					4253707	, --UM
					4320399	, --UN
					3965567	, --UT
					3909347	, --UU
					4548911	, --VC
					5931006	, --VD
					5957920	, --VF
					5938255	, --VM
					8284552	, --VO
					9514014	, --VP
					10927694, --VQ
					3216947	, --VV
					4739346	, --WB
					2895401	, --WE
					1124040	, --WI
					5325470	, --WU
					720475	, --WW
					2270259	, --YI
					4622387	 --YN
)
	AND (SyncBingo = 0 OR DisableBingo = 1)

--upline of direct masters
INSERT INTO #tmpCust (custid)
SELECT 4--SA-TB

--downlines of direct masters
INSERT INTO #tmpCust(custid)
SELECT custid 
FROM custInfo with(NOLOCK)
WHERE  custid <= @max_custid
AND mrecommend IN (
					8982	, --M86TB
					15517	, --MGTB
					465732	, --M73TB
					490306	, --M6JT
					525589	, --M85CTB
					361498	, --M85BTB
					475369	, --MKLTB
					546839	, --M85DTB
					669346	, --M866ITB
					5365	, --M5TB
					42643	, --M18TB
					206667	, --MGCTB
					1166793	, --D1T
					5994	, --CHTB
					12166	, --MMYTB
					120779	, --M85TB
					123990	, --MRTB
					156124	, --MGBTB
					298219	, --M85ATB
					350625	 --M51TB
				)
	AND (SyncBingo = 0 OR DisableBingo = 1)

--upline of direct agent
INSERT INTO #tmpCust (custid)
SELECT 15	
UNION SELECT 4183

--downlines of direct agent
INSERT INTO #tmpCust(custid)
SELECT custid 
FROM custinfo WITH(NOLOCK)
WHERE  custid <= @max_custid
AND recommend IN (
					1038826	--TBI
				)
AND (SyncBingo = 0 OR DisableBingo = 1)

--upline of direct members
INSERT INTO #tmpCust(custid)
		  SELECT 4177
UNION ALL SELECT 1265
UNION ALL SELECT 31987


--direct members
INSERT INTO #tmpCust(custid)
		  SELECT 	1635	--008TB
UNION ALL SELECT 	10228779	--D-KKT
UNION ALL SELECT 	1166405	--D1TB
UNION ALL SELECT 	24713	--marktb
UNION ALL SELECT 	1521065	--BCWL
UNION ALL SELECT 	2957769	--BTACC
UNION ALL SELECT 	1385	--CHAITB
UNION ALL SELECT 	2222517	--008RUP
UNION ALL SELECT 	63254	--INDORUP
UNION ALL SELECT 	847386	--WLARUP
UNION ALL SELECT 	641835	--WLRUP
 
GO

declare @ids varchar(max), @rowcnt int

while (1=1)
begin
	select @ids = ''
	
	update TOP (10000) #tmpCust
	set @ids = @ids + case @ids when '' then '' else ',' end + cast(custid as varchar(12))
		,isfinished = 1
	from #tmpCust
	where isfinished = 0
	
	select @rowcnt = @@rowcount	

	EXEC [Acc_ExecRep_09] @ids = @ids
	
	if @rowcnt < 10000 RETURN

	WAITFOR DELAY '00:00:01'
end
