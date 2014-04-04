/*
	Created: Johnson
	Date: 2014-04-02
	Task: Fix racing settings after settings updated(newly credit customers)
	DB: DBTXN/CustDB
*/

DECLARE @tmpSetting TABLE(sporttype INT, currency INT, minbet MONEY, maxbet MONEY, maxpermatch MONEY)

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
	--union select	151	,	64	,	5	,	12000	,	24000	--	UT
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
	--union select	152	,	64	,	10	,	1200	,	24000	--	UT
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
	--union select	153	,	64	,	5	,	6000	,	24000	--	UT
	union select	153	,	45	,	7000	,	6000000	,	24000000	--	Won
	union select	153	,	36	,	5	,	6000	,	24000	--	Y$US
	union select	153	,	16	,	5	,	6000	,	24000	--	Yen
	union select	153	,	48	,	30	,	60000	,	240000	--	ZAR	

		
	;WITH B
		AS
		(
			SELECT currency
				,MAX(CASE when sporttype = 151 then maxpermatch ELSE 0 end) as maxpermatch151
				,MAX(CASE when sporttype = 152 then maxpermatch ELSE 0 end) as maxpermatch152
				,MAX(CASE when sporttype = 153 then maxpermatch ELSE 0 end) as maxpermatch153			
			from @tmpSetting
			group BY currency
		)

	--2 rows affected
	select ci.custid, b.maxpermatch151, b.maxpermatch152, b.maxpermatch153
	into #tmpCust
	from custInfo ci with(nolock)	
	inner join B b on ci.currency = b.currency
	where (  ci.maxpermatch151 <> b.maxpermatch151 
			or maxpermatch152 <> ci.maxpermatch151_OT or maxpermatch152 <> ci.maxpermatch152_UK
			or maxpermatch153 <> ci.maxpermatch151_AU or maxpermatch153 <> ci.maxpermatch152_AU or maxpermatch153 <> ci.maxpermatch153_AU
		)
		and srecommend not in (select custid from Dep_CustSuper with(nolock))
		and roleid <= 4
		and custid <= 14241748 --lastest customer created yesterday
	
	UPDATE ci
	SET ci.maxpermatch151 = t.maxpermatch151 
		ci.maxpermatch151_OT = maxpermatch152,  
		ci.maxpermatch152_UK = maxpermatch152,
		ci.maxpermatch151_AU = maxpermatch153,
		ci.maxpermatch152_AU = maxpermatch153,
		ci.maxpermatch153_AU = maxpermatch153		
	FROM custinfo ci WITH(UPDLOCK,ROWLOCK)
		INNER JOIN #tmpCust t ON ci.custid = t.custid
		
	
	; with T as
	(
		SELECT currency,31 as bettype, minbet, maxbet
		FROm @tmpSetting
		where sporttype = 151
		union 
		SELECT currency,32 as bettype, minbet, maxbet
		FROm @tmpSetting
		where sporttype = 151
		union 		
		SELECT currency,41 as bettype, minbet, maxbet
		FROm @tmpSetting
		where sporttype = 152
		union 
		SELECT currency,42 as bettype, minbet, maxbet
		FROm @tmpSetting
		where sporttype = 152
		union 		
		SELECT currency,51 as bettype, minbet, maxbet
		FROm @tmpSetting
		where sporttype = 153
		union 
		SELECT currency,52 as bettype, minbet, maxbet
		FROm @tmpSetting
		where sporttype = 153
	)
	
	--2 customers affected
	  select distinct ci.custid, t.bettype, t.minbet, t.maxbet
	into #cust
	from custInfo ci with(nolock)
		inner join CustSetting3rd cs with(nolock) on ci.custid = cs.custid 
		inner join T t on ci.currency = t.currency and cs.bettype = t.bettype
	where srecommend not in (select custid from Dep_CustSuper with(nolock))
		and roleid <= 4
		and cs.sporttype between 151 and 153
		and (cs.minbet <> t.minbet or cs.maxbet <> t.maxbet)
		and ci.custid <= 14241748 --lastest customer created yesterday
	
	UPDATE cs
	SET cs.minbet = c.minbet,
		cs.maxbet = c.maxbet
	FROM CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN #Cust c ON cs.custid = c.custid AND cs.bettype = c.bettype
	WHERE cs.sporttype BETWEEN 151 and 153
	
	
	--drop table #tmpCust
	--drop table #cust





