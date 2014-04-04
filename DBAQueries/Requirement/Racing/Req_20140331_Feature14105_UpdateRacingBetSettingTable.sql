  /*
	Created: Johnson
	Date: 2014-03-31
	Task: Update default settings for RacingBetsetting
	DB: DBTXN/CustDB
 */
 
 DECLARE @tmpSetting TABLE (sporttype INT, currency INT, minbet MONEY)
 
 INSERT INTO @tmpSetting(sporttype, currency, minbet)
	--SA racing
		 select	151	,	2	,	10	--	RM
union select	151	,	35	,	5	--	$US
union select	151	,	9	,	5	--	AUD
union select	151	,	46	,	5	--	BND
union select	151	,	21	,	5	--	CAD
union select	151	,	50	,	5	--	CAN
union select	151	,	41	,	5	--	CHF
union select	151	,	57	,	100	--	CZK
union select	151	,	47	,	50	--	DDD
union select	151	,	52	,	20	--	DKK
union select	151	,	6	,	5	--	EURO
union select	151	,	12	,	5	--	GBP
union select	151	,	5	,	20	--	HK$
union select	151	,	33	,	50	--	IDD
union select	151	,	34	,	50	--	IDR
union select	151	,	15	,	50	--	IN
union select	151	,	22	,	50	--	IND
union select	151	,	61	,	200	--	INR
union select	151	,	40	,	5	--	IRR
union select	151	,	51	,	70	--	INH
union select	151	,	32	,	400	--	JPY
union select	151	,	62	,	5	--	KW
union select	151	,	49	,	50	--	MXN
union select	151	,	54	,	20	--	NOK
union select	151	,	30	,	150	--	NT
union select	151	,	17	,	5	--	NTD
union select	151	,	63	,	5	--	NZD
union select	151	,	37	,	5	--	P
union select	151	,	42	,	100	--	PE
union select	151	,	56	,	10	--	PLN
union select	151	,	44	,	30	--	PT
union select	151	,	31	,	400	--	Pts
union select	151	,	13	,	20	--	RMB
union select	151	,	58	,	10	--	RON
union select	151	,	55	,	100	--	RUB
union select	151	,	1	,	5	--	SD$
union select	151	,	53	,	20	--	SEK
union select	151	,	4	,	100	--	TB
union select	151	,	43	,	100	--	THB
union select	151	,	3	,	5	--	US$
--union select	151	,	64	,	5	--	UT
union select	151	,	45	,	4000	--	Won
union select	151	,	36	,	5	--	Y$US
union select	151	,	16	,	5	--	Yen
union select	151	,	48	,	20	--	ZAR	
---------------------------------------------------------
--UK racing

union select	152	,	2	,	30	--	RM
union select	152	,	35	,	10	--	$US
union select	152	,	9	,	10	--	AUD
union select	152	,	46	,	10	--	BND
union select	152	,	21	,	10	--	CAD
union select	152	,	50	,	10	--	CAN
union select	152	,	41	,	10	--	CHF
union select	152	,	57	,	100	--	CZK
union select	152	,	47	,	100	--	DDD
union select	152	,	52	,	40	--	DKK
union select	152	,	6	,	10	--	EURO
union select	152	,	12	,	10	--	GBP
union select	152	,	5	,	50	--	HK$
union select	152	,	33	,	100	--	IDD
union select	152	,	34	,	100	--	IDR
union select	152	,	15	,	100	--	IN
union select	152	,	22	,	100	--	IND
union select	152	,	61	,	400	--	INR
union select	152	,	40	,	10	--	IRR
union select	152	,	51	,	150	--	INH
union select	152	,	32	,	700	--	JPY
union select	152	,	62	,	10	--	KW
union select	152	,	49	,	100	--	MXN
union select	152	,	54	,	40	--	NOK
union select	152	,	30	,	300	--	NT
union select	152	,	17	,	10	--	NTD
union select	152	,	63	,	10	--	NZD
union select	152	,	37	,	10	--	P
union select	152	,	42	,	300	--	PE
union select	152	,	56	,	300	--	PLN
union select	152	,	44	,	100	--	PT
union select	152	,	31	,	700	--	Pts
union select	152	,	13	,	50	--	RMB
union select	152	,	58	,	30	--	RON
union select	152	,	55	,	300	--	RUB
union select	152	,	1	,	10	--	SD$
union select	152	,	53	,	40	--	SEK
union select	152	,	4	,	300	--	TB
union select	152	,	43	,	300	--	THB
union select	152	,	3	,	10	--	US$
--union select	152	,	64	,	10	--	UT
union select	152	,	45	,	7000	--	Won
union select	152	,	36	,	10	--	Y$US
union select	152	,	16	,	10	--	Yen
union select	152	,	48	,	50	--	ZAR
-------------------------------------------------------
--AUS racing

union select	153	,	2	,	10	--	RM
union select	153	,	35	,	5	--	$US
union select	153	,	9	,	5	--	AUD
union select	153	,	46	,	5	--	BND
union select	153	,	21	,	5	--	CAD
union select	153	,	50	,	5	--	CAN
union select	153	,	41	,	10	--	CHF
union select	153	,	57	,	100	--	CZK
union select	153	,	47	,	50	--	DDD
union select	153	,	52	,	20	--	DKK
union select	153	,	6	,	5	--	EURO
union select	153	,	12	,	5	--	GBP
union select	153	,	5	,	30	--	HK$
union select	153	,	33	,	50	--	IDD
union select	153	,	34	,	50	--	IDR
union select	153	,	15	,	50	--	IN
union select	153	,	22	,	50	--	IND
union select	153	,	61	,	300	--	INR
union select	153	,	40	,	5	--	IRR
union select	153	,	51	,	70	--	INH
union select	153	,	32	,	500	--	JPY
union select	153	,	62	,	5	--	KW
union select	153	,	49	,	50	--	MXN
union select	153	,	54	,	20	--	NOK
union select	153	,	30	,	100	--	NT
union select	153	,	17	,	5	--	NTD
union select	153	,	63	,	5	--	NZD
union select	153	,	37	,	5	--	P
union select	153	,	42	,	300	--	PE
union select	153	,	56	,	10	--	PLN
union select	153	,	44	,	100	--	PT
union select	153	,	31	,	600	--	Pts
union select	153	,	13	,	30	--	RMB
union select	153	,	58	,	10	--	RON
union select	153	,	55	,	300	--	RUB
union select	153	,	1	,	5	--	SD$
union select	153	,	53	,	20	--	SEK
union select	153	,	4	,	300	--	TB
union select	153	,	43	,	300	--	THB
union select	153	,	3	,	5	--	US$
--union select	153	,	64	,	5	--	UT
union select	153	,	45	,	7000	--	Won
union select	153	,	36	,	5	--	Y$US
union select	153	,	16	,	5	--	Yen
union select	153	,	48	,	30	--	ZAR


; with T as
	(
		SELECT currency, 31 as bettype, minbet
		FROm @tmpSetting
		where sporttype = 151
		union 
		SELECT currency, 41 as bettype, minbet
		FROm @tmpSetting
		where sporttype = 152		
		union 
		SELECT currency, 51 as bettype, minbet
		FROm @tmpSetting
		where sporttype = 153		
	)
	

--85 rows affected
UPDATE rs
SET rs.minbet = t.minbet
FROM RacingBetSetting rs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN T t ON rs.bettype = t.bettype AND rs.currency = t.currency
WHERE rs.minbet <> t.minbet
	



 
 