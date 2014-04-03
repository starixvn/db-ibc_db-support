  /*
	Created: Johnson
	Date: 2014-03-31
	Task: Update racing bet setting for deposit customers
	DB: DBTXN/CustDB
 */
 
 
-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
 
 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]	
	@srecommend INT,
	@sporttype INT,
	@minbet MONEY,
	@maxbet MONEY,
	@maxpermatch MONEY,
	@maxcustid INT,
	@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('custinfo') AND type = 'U'
	) <> 1 RETURN
	
	IF @sporttype = 151 -- SA racing
	BEGIN
		UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
		SET maxpermatch151 = @maxpermatch			
		WHERE srecommend = @srecommend
			AND custid <= @maxcustid
	END
	ELSE IF @sporttype = 152 -- UK
	BEGIN
		UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
		SET MaxPerMatch151_OT = @maxpermatch, 
			MaxPerMatch152_UK = @maxpermatch
		WHERE srecommend = @srecommend
			AND custid <= @maxcustid
	END
	ELSE IF @sporttype = 153-- AUS
	BEGIN
		UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
		SET MaxPerMatch151_AU = @maxpermatch,
			MaxPerMatch152_AU = @maxpermatch,
			MaxPerMatch153_AU = @maxpermatch
		WHERE srecommend = @srecommend
			AND custid <= @maxcustid
	END
	
	IF (SELECT COUNT(1)
	FROM sys.objects
	WHERE NAME IN ('Dep_custsetting3rd') AND type = 'U'
	) <> 1 RETURN
	
	IF @sporttype = 151-- SA racing
	BEGIN
		UPDATE cs
		SET minbet = @minbet,
			maxbet = @maxbet
		FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		WHERE ci.srecommend = @srecommend
			AND cs.sporttype = 151
			AND cs.bettype IN (31,32)
			AND ci.custid <= @maxcustid
	END	
	ELSE IF @sporttype = 152--UK
	BEGIN
		UPDATE cs
		SET minbet = @minbet,
			maxbet = @maxbet
		FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		WHERE ci.srecommend = @srecommend
			AND cs.sporttype IN (151,152)
			AND cs.bettype IN (41,42)
			AND ci.custid <= @maxcustid
	END
	ELSE IF @sporttype = 153--AUS
	BEGIN
		UPDATE cs
		SET minbet = @minbet,
			maxbet = @maxbet
		FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		WHERE ci.srecommend = @srecommend
			AND cs.sporttype between 151 and 153
			AND cs.bettype IN (51,52)
			AND ci.custid <= @maxcustid
	END
END
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
CREATE TABLE #Supers(Custid INT PRIMARY KEY, isfinished bit default(0))

DECLARE @tmpSetting TABLE(sporttype INT, currency INT, minbet MONEY, maxbet MONEY, maxpermatch MONEY, isfinished bit default(0))

INSERT INTO @tmpSetting(sporttype, currency, minbet, maxbet, maxpermatch)
		--SA racing
		 select	151	,	2	,	10	,	40000	,	80000	--	RM
union select	151	,	35	,	5	,	12000	,	24000	--	$US
union select	151	,	9	,	5	,	13000	,	26000	--	AUD
union select	151	,	46	,	5	,	15000	,	30000	--	BND
union select	151	,	21	,	5	,	5000	,	10000	--	CAD
union select	151	,	50	,	5	,	13000	,	26000	--	CAN
union select	151	,	41	,	5	,	10000	,	20000	--	CHF
union select	151	,	57	,	100	,	200000	,	400000	--	CZK
union select	151	,	47	,	50	,	140000	,	280000	--	DDD
union select	151	,	52	,	20	,	60000	,	120000	--	DKK
union select	151	,	6	,	5	,	8000	,	16000	--	EURO
union select	151	,	12	,	5	,	7000	,	14000	--	GBP
union select	151	,	5	,	20	,	80000	,	160000	--	HK$
union select	151	,	33	,	50	,	140000	,	280000	--	IDD
union select	151	,	34	,	50	,	140000	,	280000	--	IDR
union select	151	,	15	,	50	,	140000	,	280000	--	IN
union select	151	,	22	,	50	,	140000	,	280000	--	IND
union select	151	,	61	,	200	,	700000	,	1400000	--	INR
union select	151	,	40	,	5	,	12000	,	24000	--	IRR
union select	151	,	51	,	70	,	240000	,	480000	--	INH
union select	151	,	32	,	400	,	1100000	,	2200000	--	JPY
union select	151	,	62	,	5	,	12000	,	24000	--	KW
union select	151	,	49	,	50	,	150000	,	300000	--	MXN
union select	151	,	54	,	20	,	70000	,	140000	--	NOK
union select	151	,	30	,	150	,	350000	,	700000	--	NT
union select	151	,	17	,	5	,	12000	,	24000	--	NTD
union select	151	,	63	,	5	,	13000	,	26000	--	NZD
union select	151	,	37	,	5	,	12000	,	24000	--	P
union select	151	,	42	,	100	,	500000	,	1000000	--	PE
union select	151	,	56	,	10	,	35000	,	70000	--	PLN
union select	151	,	44	,	30	,	120000	,	240000	--	PT
union select	151	,	31	,	400	,	1100000	,	2200000	--	Pts
union select	151	,	13	,	20	,	70000	,	140000	--	RMB
union select	151	,	58	,	10	,	35000	,	70000	--	RON
union select	151	,	55	,	100	,	400000	,	800000	--	RUB
union select	151	,	1	,	5	,	15000	,	30000	--	SD$
union select	151	,	53	,	20	,	70000	,	140000	--	SEK
union select	151	,	4	,	100	,	380000	,	760000	--	TB
union select	151	,	43	,	100	,	380000	,	760000	--	THB
union select	151	,	3	,	5	,	12000	,	24000	--	US$
union select	151	,	64	,	5	,	12000	,	24000	--	UT
union select	151	,	45	,	4000	,	12000000	,	24000000	--	Won
union select	151	,	36	,	5	,	12000	,	24000	--	Y$US
union select	151	,	16	,	5	,	12000	,	24000	--	Yen
union select	151	,	48	,	20	,	120000	,	240000	--	ZAR
-----------------------------------------------------------
--UK racing

union select	152	,	2	,	30	,	4000	,	80000	--	RM
union select	152	,	35	,	10	,	1200	,	24000	--	$US
union select	152	,	9	,	10	,	1400	,	28000	--	AUD
union select	152	,	46	,	10	,	1500	,	30000	--	BND
union select	152	,	21	,	10	,	500	,	10000	--	CAD
union select	152	,	50	,	10	,	1300	,	26000	--	CAN
union select	152	,	41	,	10	,	1000	,	20000	--	CHF
union select	152	,	57	,	100	,	20000	,	400000	--	CZK
union select	152	,	47	,	100	,	15000	,	300000	--	DDD
union select	152	,	52	,	40	,	7000	,	140000	--	DKK
union select	152	,	6	,	10	,	1000	,	20000	--	EURO
union select	152	,	12	,	10	,	800	,	16000	--	GBP
union select	152	,	5	,	50	,	10000	,	200000	--	HK$
union select	152	,	33	,	100	,	15000	,	300000	--	IDD
union select	152	,	34	,	100	,	15000	,	300000	--	IDR
union select	152	,	15	,	100	,	15000	,	300000	--	IN
union select	152	,	22	,	100	,	15000	,	300000	--	IND
union select	152	,	61	,	400	,	70000	,	1400000	--	INR
union select	152	,	40	,	10	,	1300	,	26000	--	IRR
union select	152	,	51	,	150	,	25000	,	500000	--	INH
union select	152	,	32	,	700	,	120000	,	2400000	--	JPY
union select	152	,	62	,	10	,	1300	,	26000	--	KW
union select	152	,	49	,	100	,	15000	,	300000	--	MXN
union select	152	,	54	,	40	,	7000	,	140000	--	NOK
union select	152	,	30	,	300	,	38000	,	760000	--	NT
union select	152	,	17	,	10	,	1200	,	24000	--	NTD
union select	152	,	63	,	10	,	1400	,	28000	--	NZD
union select	152	,	37	,	10	,	1200	,	24000	--	P
union select	152	,	42	,	300	,	50000	,	1000000	--	PE
union select	152	,	56	,	300	,	4000	,	80000	--	PLN
union select	152	,	44	,	100	,	12000	,	240000	--	PT
union select	152	,	31	,	700	,	120000	,	2400000	--	Pts
union select	152	,	13	,	50	,	7000	,	140000	--	RMB
union select	152	,	58	,	30	,	4000	,	80000	--	RON
union select	152	,	55	,	300	,	40000	,	800000	--	RUB
union select	152	,	1	,	10	,	1500	,	30000	--	SD$
union select	152	,	53	,	40	,	8000	,	160000	--	SEK
union select	152	,	4	,	300	,	40000	,	800000	--	TB
union select	152	,	43	,	300	,	40000	,	800000	--	THB
union select	152	,	3	,	10	,	1200	,	24000	--	US$
union select	152	,	64	,	10	,	1200	,	24000	--	UT
union select	152	,	45	,	7000	,	1200000	,	24000000	--	Won
union select	152	,	36	,	10	,	1200	,	24000	--	Y$US
union select	152	,	16	,	10	,	1200	,	24000	--	Yen
union select	152	,	48	,	50	,	12000	,	240000	--	ZAR
----------------------------------------------------------
--AUS racing

union select	153	,	2	,	10	,	20000	,	80000	--	RM
union select	153	,	35	,	5	,	6000	,	24000	--	$US
union select	153	,	9	,	5	,	6000	,	24000	--	AUD
union select	153	,	46	,	5	,	7000	,	28000	--	BND
union select	153	,	21	,	5	,	2000	,	8000	--	CAD
union select	153	,	50	,	5	,	6000	,	24000	--	CAN
union select	153	,	41	,	10	,	5000	,	20000	--	CHF
union select	153	,	57	,	100	,	100000	,	400000	--	CZK
union select	153	,	47	,	50	,	60000	,	240000	--	DDD
union select	153	,	52	,	20	,	32000	,	128000	--	DKK
union select	153	,	6	,	5	,	4000	,	16000	--	EURO
union select	153	,	12	,	5	,	3000	,	12000	--	GBP
union select	153	,	5	,	30	,	40000	,	160000	--	HK$
union select	153	,	33	,	50	,	65000	,	260000	--	IDD
union select	153	,	34	,	50	,	65000	,	260000	--	IDR
union select	153	,	15	,	50	,	65000	,	260000	--	IN
union select	153	,	22	,	50	,	65000	,	260000	--	IND
union select	153	,	61	,	300	,	350000	,	1400000	--	INR
union select	153	,	40	,	5	,	6000	,	24000	--	IRR
union select	153	,	51	,	70	,	120000	,	480000	--	INH
union select	153	,	32	,	500	,	500000	,	2000000	--	JPY
union select	153	,	62	,	5	,	6000	,	24000	--	KW
union select	153	,	49	,	50	,	70000	,	280000	--	MXN
union select	153	,	54	,	20	,	35000	,	140000	--	NOK
union select	153	,	30	,	100	,	150000	,	600000	--	NT
union select	153	,	17	,	5	,	6000	,	24000	--	NTD
union select	153	,	63	,	5	,	6000	,	24000	--	NZD
union select	153	,	37	,	5	,	6000	,	24000	--	P
union select	153	,	42	,	300	,	250000	,	1000000	--	PE
union select	153	,	56	,	10	,	16000	,	64000	--	PLN
union select	153	,	44	,	100	,	60000	,	240000	--	PT
union select	153	,	31	,	600	,	500000	,	2000000	--	Pts
union select	153	,	13	,	30	,	32000	,	128000	--	RMB
union select	153	,	58	,	10	,	18000	,	72000	--	RON
union select	153	,	55	,	300	,	200000	,	800000	--	RUB
union select	153	,	1	,	5	,	7000	,	28000	--	SD$
union select	153	,	53	,	20	,	35000	,	140000	--	SEK
union select	153	,	4	,	300	,	180000	,	720000	--	TB
union select	153	,	43	,	300	,	180000	,	720000	--	THB
union select	153	,	3	,	5	,	6000	,	24000	--	US$
union select	153	,	64	,	5	,	6000	,	24000	--	UT
union select	153	,	45	,	7000	,	6000000	,	24000000	--	Won
union select	153	,	36	,	5	,	6000	,	24000	--	Y$US
union select	153	,	16	,	5	,	6000	,	24000	--	Yen
union select	153	,	48	,	30	,	60000	,	240000	--	ZAR	

DECLARE @srecommend INT, @max_custid INT, @sporttype INT, @currency INT, @minbet MONEY, @maxbet MONEY, @maxpermatch MONEY

SET @max_custid = xxx

WHILE (1=1)
BEGIN
	DELETE #Supers
	
	SELECT TOP (1) @currency = currency FROM @tmpSetting WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
		
	INSERT INTO #supers(custid)
	SELECT custid
	FROM Dep_CustSuper WITH(NOLOCK)
	WHERE currency = @currency
		AND custid <= @max_custid 
		
	WHILE(1=1)
	BEGIN
		UPDATE TOP(1) @tmpSetting
		SET @sporttype = sporttype,
			@minbet = minbet,
			@maxbet = maxbet,
			@maxpermatch = maxpermatch,
			isfinished = 1
		WHERE currency = @currency
			AND isfinished = 0
		
		IF @@ROWCOUNT = 0 BREAK
		
		WHILE (1=1)
		BEGIN
			UPDATE TOP(1) #Supers
			SET @srecommend = custid,
				isfinished = 1
			WHERE isfinished = 0
			
			IF @@ROWCOUNT = 0 BREAK
			
			EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
				,@sporttype = @sporttype
				,@minbet = @minbet
				,@maxbet = @maxbet
				,@maxpermatch = @maxpermatch		
				,@maxcustid = @max_custid
				,@target = 'REPLICATED'
				
			WAITFOR DELAY '00:00:00.280'
		END
		
		UPDATE #supers 
		SET isfinished = 0
	END		
END
GO
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
---

---
---
-- BEGIN STEP 3:  RUN THIS SCRIPT AT DBTRANS -----
--------------------------------------------------------------------------------------
CREATE TABLE #Supers(Custid INT PRIMARY KEY, isfinished bit default(0))

DECLARE @tmpSetting TABLE(sporttype INT, currency INT, minbet MONEY, maxbet MONEY, maxpermatch MONEY, isfinished bit default(0))

INSERT INTO @tmpSetting(sporttype, currency, minbet, maxbet, maxpermatch)
		--SA racing
		 select	151	,	2	,	10	,	40000	,	80000	--	RM
union select	151	,	35	,	5	,	12000	,	24000	--	$US
union select	151	,	9	,	5	,	13000	,	26000	--	AUD
union select	151	,	46	,	5	,	15000	,	30000	--	BND
union select	151	,	21	,	5	,	5000	,	10000	--	CAD
union select	151	,	50	,	5	,	13000	,	26000	--	CAN
union select	151	,	41	,	5	,	10000	,	20000	--	CHF
union select	151	,	57	,	100	,	200000	,	400000	--	CZK
union select	151	,	47	,	50	,	140000	,	280000	--	DDD
union select	151	,	52	,	20	,	60000	,	120000	--	DKK
union select	151	,	6	,	5	,	8000	,	16000	--	EURO
union select	151	,	12	,	5	,	7000	,	14000	--	GBP
union select	151	,	5	,	20	,	80000	,	160000	--	HK$
union select	151	,	33	,	50	,	140000	,	280000	--	IDD
union select	151	,	34	,	50	,	140000	,	280000	--	IDR
union select	151	,	15	,	50	,	140000	,	280000	--	IN
union select	151	,	22	,	50	,	140000	,	280000	--	IND
union select	151	,	61	,	200	,	700000	,	1400000	--	INR
union select	151	,	40	,	5	,	12000	,	24000	--	IRR
union select	151	,	51	,	70	,	240000	,	480000	--	INH
union select	151	,	32	,	400	,	1100000	,	2200000	--	JPY
union select	151	,	62	,	5	,	12000	,	24000	--	KW
union select	151	,	49	,	50	,	150000	,	300000	--	MXN
union select	151	,	54	,	20	,	70000	,	140000	--	NOK
union select	151	,	30	,	150	,	350000	,	700000	--	NT
union select	151	,	17	,	5	,	12000	,	24000	--	NTD
union select	151	,	63	,	5	,	13000	,	26000	--	NZD
union select	151	,	37	,	5	,	12000	,	24000	--	P
union select	151	,	42	,	100	,	500000	,	1000000	--	PE
union select	151	,	56	,	10	,	35000	,	70000	--	PLN
union select	151	,	44	,	30	,	120000	,	240000	--	PT
union select	151	,	31	,	400	,	1100000	,	2200000	--	Pts
union select	151	,	13	,	20	,	70000	,	140000	--	RMB
union select	151	,	58	,	10	,	35000	,	70000	--	RON
union select	151	,	55	,	100	,	400000	,	800000	--	RUB
union select	151	,	1	,	5	,	15000	,	30000	--	SD$
union select	151	,	53	,	20	,	70000	,	140000	--	SEK
union select	151	,	4	,	100	,	380000	,	760000	--	TB
union select	151	,	43	,	100	,	380000	,	760000	--	THB
union select	151	,	3	,	5	,	12000	,	24000	--	US$
union select	151	,	64	,	5	,	12000	,	24000	--	UT
union select	151	,	45	,	4000	,	12000000	,	24000000	--	Won
union select	151	,	36	,	5	,	12000	,	24000	--	Y$US
union select	151	,	16	,	5	,	12000	,	24000	--	Yen
union select	151	,	48	,	20	,	120000	,	240000	--	ZAR
-----------------------------------------------------------
--UK racing

union select	152	,	2	,	30	,	4000	,	80000	--	RM
union select	152	,	35	,	10	,	1200	,	24000	--	$US
union select	152	,	9	,	10	,	1400	,	28000	--	AUD
union select	152	,	46	,	10	,	1500	,	30000	--	BND
union select	152	,	21	,	10	,	500	,	10000	--	CAD
union select	152	,	50	,	10	,	1300	,	26000	--	CAN
union select	152	,	41	,	10	,	1000	,	20000	--	CHF
union select	152	,	57	,	100	,	20000	,	400000	--	CZK
union select	152	,	47	,	100	,	15000	,	300000	--	DDD
union select	152	,	52	,	40	,	7000	,	140000	--	DKK
union select	152	,	6	,	10	,	1000	,	20000	--	EURO
union select	152	,	12	,	10	,	800	,	16000	--	GBP
union select	152	,	5	,	50	,	10000	,	200000	--	HK$
union select	152	,	33	,	100	,	15000	,	300000	--	IDD
union select	152	,	34	,	100	,	15000	,	300000	--	IDR
union select	152	,	15	,	100	,	15000	,	300000	--	IN
union select	152	,	22	,	100	,	15000	,	300000	--	IND
union select	152	,	61	,	400	,	70000	,	1400000	--	INR
union select	152	,	40	,	10	,	1300	,	26000	--	IRR
union select	152	,	51	,	150	,	25000	,	500000	--	INH
union select	152	,	32	,	700	,	120000	,	2400000	--	JPY
union select	152	,	62	,	10	,	1300	,	26000	--	KW
union select	152	,	49	,	100	,	15000	,	300000	--	MXN
union select	152	,	54	,	40	,	7000	,	140000	--	NOK
union select	152	,	30	,	300	,	38000	,	760000	--	NT
union select	152	,	17	,	10	,	1200	,	24000	--	NTD
union select	152	,	63	,	10	,	1400	,	28000	--	NZD
union select	152	,	37	,	10	,	1200	,	24000	--	P
union select	152	,	42	,	300	,	50000	,	1000000	--	PE
union select	152	,	56	,	300	,	4000	,	80000	--	PLN
union select	152	,	44	,	100	,	12000	,	240000	--	PT
union select	152	,	31	,	700	,	120000	,	2400000	--	Pts
union select	152	,	13	,	50	,	7000	,	140000	--	RMB
union select	152	,	58	,	30	,	4000	,	80000	--	RON
union select	152	,	55	,	300	,	40000	,	800000	--	RUB
union select	152	,	1	,	10	,	1500	,	30000	--	SD$
union select	152	,	53	,	40	,	8000	,	160000	--	SEK
union select	152	,	4	,	300	,	40000	,	800000	--	TB
union select	152	,	43	,	300	,	40000	,	800000	--	THB
union select	152	,	3	,	10	,	1200	,	24000	--	US$
union select	152	,	64	,	10	,	1200	,	24000	--	UT
union select	152	,	45	,	7000	,	1200000	,	24000000	--	Won
union select	152	,	36	,	10	,	1200	,	24000	--	Y$US
union select	152	,	16	,	10	,	1200	,	24000	--	Yen
union select	152	,	48	,	50	,	12000	,	240000	--	ZAR
----------------------------------------------------------
--AUS racing

union select	153	,	2	,	10	,	20000	,	80000	--	RM
union select	153	,	35	,	5	,	6000	,	24000	--	$US
union select	153	,	9	,	5	,	6000	,	24000	--	AUD
union select	153	,	46	,	5	,	7000	,	28000	--	BND
union select	153	,	21	,	5	,	2000	,	8000	--	CAD
union select	153	,	50	,	5	,	6000	,	24000	--	CAN
union select	153	,	41	,	10	,	5000	,	20000	--	CHF
union select	153	,	57	,	100	,	100000	,	400000	--	CZK
union select	153	,	47	,	50	,	60000	,	240000	--	DDD
union select	153	,	52	,	20	,	32000	,	128000	--	DKK
union select	153	,	6	,	5	,	4000	,	16000	--	EURO
union select	153	,	12	,	5	,	3000	,	12000	--	GBP
union select	153	,	5	,	30	,	40000	,	160000	--	HK$
union select	153	,	33	,	50	,	65000	,	260000	--	IDD
union select	153	,	34	,	50	,	65000	,	260000	--	IDR
union select	153	,	15	,	50	,	65000	,	260000	--	IN
union select	153	,	22	,	50	,	65000	,	260000	--	IND
union select	153	,	61	,	300	,	350000	,	1400000	--	INR
union select	153	,	40	,	5	,	6000	,	24000	--	IRR
union select	153	,	51	,	70	,	120000	,	480000	--	INH
union select	153	,	32	,	500	,	500000	,	2000000	--	JPY
union select	153	,	62	,	5	,	6000	,	24000	--	KW
union select	153	,	49	,	50	,	70000	,	280000	--	MXN
union select	153	,	54	,	20	,	35000	,	140000	--	NOK
union select	153	,	30	,	100	,	150000	,	600000	--	NT
union select	153	,	17	,	5	,	6000	,	24000	--	NTD
union select	153	,	63	,	5	,	6000	,	24000	--	NZD
union select	153	,	37	,	5	,	6000	,	24000	--	P
union select	153	,	42	,	300	,	250000	,	1000000	--	PE
union select	153	,	56	,	10	,	16000	,	64000	--	PLN
union select	153	,	44	,	100	,	60000	,	240000	--	PT
union select	153	,	31	,	600	,	500000	,	2000000	--	Pts
union select	153	,	13	,	30	,	32000	,	128000	--	RMB
union select	153	,	58	,	10	,	18000	,	72000	--	RON
union select	153	,	55	,	300	,	200000	,	800000	--	RUB
union select	153	,	1	,	5	,	7000	,	28000	--	SD$
union select	153	,	53	,	20	,	35000	,	140000	--	SEK
union select	153	,	4	,	300	,	180000	,	720000	--	TB
union select	153	,	43	,	300	,	180000	,	720000	--	THB
union select	153	,	3	,	5	,	6000	,	24000	--	US$
union select	153	,	64	,	5	,	6000	,	24000	--	UT
union select	153	,	45	,	7000	,	6000000	,	24000000	--	Won
union select	153	,	36	,	5	,	6000	,	24000	--	Y$US
union select	153	,	16	,	5	,	6000	,	24000	--	Yen
union select	153	,	48	,	30	,	60000	,	240000	--	ZAR	

DECLARE @srecommend INT, @max_custid INT, @sporttype INT, @currency INT, @minbet MONEY, @maxbet MONEY, @maxpermatch MONEY

SET @max_custid = xxx

WHILE (1=1)
BEGIN
	DELETE #Supers
	
	SELECT TOP (1) @currency = currency FROM @tmpSetting WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
		
	INSERT INTO #supers(custid)
	SELECT custid
	FROM Dep_CustSuper WITH(NOLOCK)
	WHERE currency = @currency
		AND custid <= @max_custid 
		
	WHILE(1=1)
	BEGIN
		UPDATE TOP(1) @tmpSetting
		SET @sporttype = sporttype,
			@minbet = minbet,
			@maxbet = maxbet,
			@maxpermatch = maxpermatch,
			isfinished = 1
		WHERE currency = @currency
			AND isfinished = 0
		
		IF @@ROWCOUNT = 0 BREAK
		
		WHILE (1=1)
		BEGIN
			UPDATE TOP(1) #Supers
			SET @srecommend = custid,
				isfinished = 1
			WHERE isfinished = 0
			
			IF @@ROWCOUNT = 0 BREAK
			
			EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
				,@sporttype = @sporttype
				,@minbet = @minbet
				,@maxbet = @maxbet
				,@maxpermatch = @maxpermatch		
				,@maxcustid = @max_custid
				,@target = 'DBTRANS'
				
			WAITFOR DELAY '00:00:00.280'
		END
		
		UPDATE #supers 
		SET isfinished = 0
	END		
END
GO
-- END STEP 3: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
