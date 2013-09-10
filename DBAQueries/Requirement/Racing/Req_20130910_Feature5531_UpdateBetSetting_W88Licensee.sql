 
 DECLARE @betsetting table (sporttype int ,bettype int ,currency int, currencyName nvarchar(10), minbet money, maxbet money, maxpermatch money)

declare @max_custid int 
select @max_custid = xxxxx

insert into @betsetting (sporttype, bettype, currency,currencyName ,minbet ,maxbet)
--INH 
		 SELECT	151	,	31	,	51	,	'INH'	,	150.00	,	12000.00
union SELECT	151	,	32	,	51	,	'INH'	,	150.00	,	12000.00
union SELECT	151	,	41	,	51	,	'INH'	,	150.00	,	12000.00
union SELECT	151	,	42	,	51	,	'INH'	,	150.00	,	12000.00
union SELECT	151	,	51	,	51	,	'INH'	,	150.00	,	12000.00
union SELECT	151	,	52	,	51	,	'INH'	,	150.00	,	12000.00
union SELECT	152	,	41	,	51	,	'INH'	,	150.00	,	9999.00
union SELECT	152	,	42	,	51	,	'INH'	,	150.00	,	9999.00
union SELECT	152	,	51	,	51	,	'INH'	,	150.00	,	40000.00
union SELECT	152	,	52	,	51	,	'INH'	,	150.00	,	40000.00
union SELECT	153	,	51	,	51	,	'INH'	,	150.00	,	40000.00
union SELECT	153	,	52	,	51	,	'INH'	,	150.00	,	40000.00		
--INR
union SELECT	151	,	31	,	61	,	'INR'	,	500.00	,	70000.00
union SELECT	151	,	32	,	61	,	'INR'	,	500.00	,	70000.00
union SELECT	151	,	41	,	61	,	'INR'	,	500.00	,	70000.00
union SELECT	151	,	42	,	61	,	'INR'	,	500.00	,	70000.00
union SELECT	151	,	51	,	61	,	'INR'	,	500.00	,	70000.00
union SELECT	151	,	52	,	61	,	'INR'	,	500.00	,	70000.00
union SELECT	152	,	41	,	61	,	'INR'	,	500.00	,	700000.00
union SELECT	152	,	42	,	61	,	'INR'	,	500.00	,	700000.00
union SELECT	152	,	51	,	61	,	'INR'	,	500.00	,	700000.00
union SELECT	152	,	52	,	61	,	'INR'	,	500.00	,	700000.00
union SELECT	153	,	51	,	61	,	'INR'	,	500.00	,	700000.00
union SELECT	153	,	52	,	61	,	'INR'	,	500.00	,	700000.00
--JPY
union SELECT	151	,	31	,	32	,	'JPY'	,	700.00	,	110000.00
union SELECT	151	,	32	,	32	,	'JPY'	,	700.00	,	110000.00
union SELECT	151	,	41	,	32	,	'JPY'	,	700.00	,	110000.00
union SELECT	151	,	42	,	32	,	'JPY'	,	700.00	,	110000.00
union SELECT	151	,	51	,	32	,	'JPY'	,	700.00	,	110000.00
union SELECT	151	,	52	,	32	,	'JPY'	,	700.00	,	110000.00
union SELECT	152	,	41	,	32	,	'JPY'	,	700.00	,	1100000.00
union SELECT	152	,	42	,	32	,	'JPY'	,	700.00	,	1100000.00
union SELECT	152	,	51	,	32	,	'JPY'	,	700.00	,	1100000.00
union SELECT	152	,	52	,	32	,	'JPY'	,	700.00	,	1100000.00
union SELECT	153	,	51	,	32	,	'JPY'	,	700.00	,	1100000.00
union SELECT	153	,	52	,	32	,	'JPY'	,	700.00	,	1100000.00
--RM
union SELECT	151	,	31	,	2	,	'RM'	,	30.00	,	4000.00
union SELECT	151	,	32	,	2	,	'RM'	,	30.00	,	4000.00
union SELECT	151	,	41	,	2	,	'RM'	,	30.00	,	4000.00
union SELECT	151	,	42	,	2	,	'RM'	,	30.00	,	4000.00
union SELECT	151	,	51	,	2	,	'RM'	,	30.00	,	4000.00
union SELECT	151	,	52	,	2	,	'RM'	,	30.00	,	4000.00
union SELECT	152	,	41	,	2	,	'RM'	,	30.00	,	40000.00
union SELECT	152	,	42	,	2	,	'RM'	,	30.00	,	40000.00
union SELECT	152	,	51	,	2	,	'RM'	,	30.00	,	40000.00
union SELECT	152	,	52	,	2	,	'RM'	,	30.00	,	40000.00
union SELECT	153	,	51	,	2	,	'RM'	,	30.00	,	40000.00
union SELECT	153	,	52	,	2	,	'RM'	,	30.00	,	40000.00
--TB
union SELECT	151	,	31	,	4	,	'TB'	,	300.00	,	40000.00
union SELECT	151	,	32	,	4	,	'TB'	,	300.00	,	40000.00
union SELECT	151	,	41	,	4	,	'TB'	,	300.00	,	40000.00
union SELECT	151	,	42	,	4	,	'TB'	,	300.00	,	40000.00
union SELECT	151	,	51	,	4	,	'TB'	,	300.00	,	40000.00
union SELECT	151	,	52	,	4	,	'TB'	,	300.00	,	40000.00
union SELECT	152	,	41	,	4	,	'TB'	,	300.00	,	400000.00
union SELECT	152	,	42	,	4	,	'TB'	,	300.00	,	400000.00
union SELECT	152	,	51	,	4	,	'TB'	,	300.00	,	400000.00
union SELECT	152	,	52	,	4	,	'TB'	,	300.00	,	400000.00
union SELECT	153	,	51	,	4	,	'TB'	,	300.00	,	400000.00
union SELECT	153	,	52	,	4	,	'TB'	,	300.00	,	400000.00
--US$
union SELECT	151	,	31	,	3	,	'US$'	,	10.00	,	1200.00
union SELECT	151	,	32	,	3	,	'US$'	,	10.00	,	1200.00
union SELECT	151	,	41	,	3	,	'US$'	,	10.00	,	1200.00
union SELECT	151	,	42	,	3	,	'US$'	,	10.00	,	1200.00
union SELECT	151	,	51	,	3	,	'US$'	,	10.00	,	1200.00
union SELECT	151	,	52	,	3	,	'US$'	,	10.00	,	1200.00
union SELECT	152	,	41	,	3	,	'US$'	,	10.00	,	15000.00
union SELECT	152	,	42	,	3	,	'US$'	,	10.00	,	15000.00
union SELECT	152	,	51	,	3	,	'US$'	,	10.00	,	15000.00
union SELECT	152	,	52	,	3	,	'US$'	,	10.00	,	15000.00
union SELECT	153	,	51	,	3	,	'US$'	,	10.00	,	15000.00
union SELECT	153	,	52	,	3	,	'US$'	,	10.00	,	15000.00
--AUD
union SELECT	151	,	31	,	9	,	'AUD'	,	5.00	,	1400.00
union SELECT	151	,	32	,	9	,	'AUD'	,	5.00	,	1400.00
union SELECT	151	,	41	,	9	,	'AUD'	,	10.00	,	1400.00
union SELECT	151	,	42	,	9	,	'AUD'	,	10.00	,	1400.00
union SELECT	151	,	51	,	9	,	'AUD'	,	5.00	,	1400.00
union SELECT	151	,	52	,	9	,	'AUD'	,	5.00	,	1400.00
union SELECT	152	,	41	,	9	,	'AUD'	,	10.00	,	15000.00
union SELECT	152	,	42	,	9	,	'AUD'	,	10.00	,	15000.00
union SELECT	152	,	51	,	9	,	'AUD'	,	5.00	,	15000.00
union SELECT	152	,	52	,	9	,	'AUD'	,	5.00	,	15000.00
union SELECT	153	,	51	,	9	,	'AUD'	,	5.00	,	15000.00
union SELECT	153	,	52	,	9	,	'AUD'	,	5.00	,	15000.00
--RMB
union SELECT	151	,	31	,	13	,	'RMB'	,	50.00	,	7000.00
union SELECT	151	,	32	,	13	,	'RMB'	,	50.00	,	7000.00
union SELECT	151	,	41	,	13	,	'RMB'	,	50.00	,	7000.00
union SELECT	151	,	42	,	13	,	'RMB'	,	50.00	,	7000.00
union SELECT	151	,	51	,	13	,	'RMB'	,	50.00	,	7000.00
union SELECT	151	,	52	,	13	,	'RMB'	,	50.00	,	7000.00
union SELECT	152	,	41	,	13	,	'RMB'	,	50.00	,	80000.00
union SELECT	152	,	42	,	13	,	'RMB'	,	50.00	,	80000.00
union SELECT	152	,	51	,	13	,	'RMB'	,	50.00	,	80000.00
union SELECT	152	,	52	,	13	,	'RMB'	,	50.00	,	80000.00
union SELECT	153	,	51	,	13	,	'RMB'	,	50.00	,	80000.00
union SELECT	153	,	52	,	13	,	'RMB'	,	50.00	,	80000.00
--EURO
union SELECT	151	,	31	,	6	,	'EURO'	,	10.00	,	1000.00
union SELECT	151	,	32	,	6	,	'EURO'	,	10.00	,	1000.00
union SELECT	151	,	41	,	6	,	'EURO'	,	10.00	,	1000.00
union SELECT	151	,	42	,	6	,	'EURO'	,	10.00	,	1000.00
union SELECT	151	,	51	,	6	,	'EURO'	,	10.00	,	1000.00
union SELECT	151	,	52	,	6	,	'EURO'	,	10.00	,	1000.00
union SELECT	152	,	41	,	6	,	'EURO'	,	10.00	,	10000.00
union SELECT	152	,	42	,	6	,	'EURO'	,	10.00	,	10000.00
union SELECT	152	,	51	,	6	,	'EURO'	,	10.00	,	10000.00
union SELECT	152	,	52	,	6	,	'EURO'	,	10.00	,	10000.00
union SELECT	153	,	51	,	6	,	'EURO'	,	10.00	,	10000.00
union SELECT	153	,	52	,	6	,	'EURO'	,	10.00	,	10000.00
--GBP
union SELECT	151	,	31	,	12	,	'GBP'	,	10.00	,	800.00
union SELECT	151	,	32	,	12	,	'GBP'	,	10.00	,	800.00
union SELECT	151	,	41	,	12	,	'GBP'	,	10.00	,	800.00
union SELECT	151	,	42	,	12	,	'GBP'	,	10.00	,	800.00
union SELECT	151	,	51	,	12	,	'GBP'	,	10.00	,	800.00
union SELECT	151	,	52	,	12	,	'GBP'	,	10.00	,	800.00
union SELECT	152	,	41	,	12	,	'GBP'	,	10.00	,	10000.00
union SELECT	152	,	42	,	12	,	'GBP'	,	10.00	,	10000.00
union SELECT	152	,	51	,	12	,	'GBP'	,	10.00	,	10000.00
union SELECT	152	,	52	,	12	,	'GBP'	,	10.00	,	10000.00
union SELECT	153	,	51	,	12	,	'GBP'	,	10.00	,	10000.00
union SELECT	153	,	52	,	12	,	'GBP'	,	10.00	,	10000.00
--IN
union SELECT	151	,	31	,	15	,	'IN'	,	50.00	,	12000.00
union SELECT	151	,	32	,	15	,	'IN'	,	50.00	,	12000.00
union SELECT	151	,	41	,	15	,	'IN'	,	100.00	,	12000.00
union SELECT	151	,	42	,	15	,	'IN'	,	100.00	,	12000.00
union SELECT	151	,	51	,	15	,	'IN'	,	50.00	,	12000.00
union SELECT	151	,	52	,	15	,	'IN'	,	50.00	,	12000.00
union SELECT	152	,	41	,	15	,	'IN'	,	100.00	,	120000.00
union SELECT	152	,	42	,	15	,	'IN'	,	100.00	,	120000.00
union SELECT	152	,	51	,	15	,	'IN'	,	50.00	,	120000.00
union SELECT	152	,	52	,	15	,	'IN'	,	50.00	,	120000.00
union SELECT	153	,	51	,	15	,	'IN'	,	50.00	,	120000.00
union SELECT	153	,	52	,	15	,	'IN'	,	50.00	,	120000.00
--UUS
union SELECT	151	,	31	,	20	,	'UUS'	,	10.00	,	500.00
union SELECT	151	,	32	,	20	,	'UUS'	,	10.00	,	500.00
union SELECT	151	,	41	,	20	,	'UUS'	,	10.00	,	499.00
union SELECT	151	,	42	,	20	,	'UUS'	,	10.00	,	499.00
union SELECT	151	,	51	,	20	,	'UUS'	,	5.00	,	15000.00
union SELECT	151	,	52	,	20	,	'UUS'	,	5.00	,	15000.00
union SELECT	152	,	41	,	20	,	'UUS'	,	10.00	,	499.00
union SELECT	152	,	42	,	20	,	'UUS'	,	10.00	,	499.00
union SELECT	152	,	51	,	20	,	'UUS'	,	5.00	,	15000.00
union SELECT	152	,	52	,	20	,	'UUS'	,	5.00	,	15000.00
union SELECT	153	,	51	,	20	,	'UUS'	,	5.00	,	15000.00
union SELECT	153	,	52	,	20	,	'UUS'	,	5.00	,	15000.00


--1551 customers affected
update cs
Set cs.minbet = b.minbet,
	cs.maxbet = b.maxbet
from Dep_CustSetting3rd cs
	INNER JOIN custInfo ci WITH(NOLOCK) On cs.custid = ci.custid 
	INNER JOIN @betsetting b ON cs.sporttype = b.sporttype AND cs.bettype = b.bettype and ci.currency = b.currency 
WHERE ci.srecommend IN (
	SELECT custid from Dep_CustSuper with(nolock) where currency in (20, 13, 4, 15, 51, 2, 3, 9, 6, 12, 32, 61) and site = 'w88'
)
	AND ci.custid <= @max_custid 

GO



DECLARE @tmp_maxpermatch TABLE(currency int,currencyName nvarchar(10), maxpermatch151 money,
	maxpermatch151_OT money, maxpermatch151_AU money, maxpermatch152_UK money
	, maxpermatch152_AU money ,maxpermatch153_AU money
)

declare @max_custid int 
select @max_custid = xxxxx

INSERT INTO @tmp_maxpermatch (currency, currencyName,maxpermatch151, maxpermatch151_OT 
	,maxpermatch151_AU , maxpermatch152_UK ,maxpermatch152_AU ,maxpermatch153_AU)
		 SELECT	20	,	'UUS'	,	1500.00	,	1500.00	,	30000.00	,	1500.00	,	30000.00	,	30000.00
union SELECT	3	,	'US$'	,	30000.00	,	30000.00	,	30000.00	,	30000.00	,	30000.00	,	30000.00
union SELECT	6	,	'EURO'	,	20000.00	,	20000.00	,	20000.00	,	20000.00	,	20000.00	,	20000.00
union SELECT	4	,	'TB'	,	800000.00	,	800000.00	,	800000.00	,	800000.00	,	800000.00	,	800000.00
union SELECT	12	,	'GBP'	,	20000.00	,	20000.00	,	20000.00	,	20000.00	,	20000.00	,	20000.00
union SELECT	2	,	'RM'	,	80000.00	,	80000.00	,	80000.00	,	80000.00	,	80000.00	,	80000.00
union SELECT	13	,	'RMB'	,	160000.00	,	160000.00	,	160000.00	,	160000.00	,	160000.00	,	160000.00
union SELECT	20	,	'UUS'	,	1500.00	,	1500.00	,	30000.00	,	1500.00	,	30000.00	,	30000.00
union SELECT	9	,	'AUD'	,	30000.00	,	30000.00	,	30000.00	,	30000.00	,	30000.00	,	30000.00
union SELECT	15	,	'IN'	,	240000.00	,	240000.00	,	240000.00	,	240000.00	,	240000.00	,	240000.00
union SELECT	51	,	'INH'	,	20000.00	,	99999.00	,	80000.00	,	99999.00	,	80000.00	,	80000.00
union SELECT	61	,	'INR'	,	1400000.00	,	1400000.00	,	1400000.00	,	1400000.00	,	1400000.00	,	1400000.00
union SELECT	32	,	'JPY'	,	2200000.00	,	2200000.00	,	2200000.00	,	2200000.00	,	2200000.00	,	2200000.00


--1551 customers affected
UPDATE ci
SET ci.maxpermatch151 = t.maxpermatch151,
	ci.maxpermatch151_OT = t.maxpermatch151_OT,
	ci.maxpermatch151_AU = t.maxpermatch151_AU,
	ci.maxpermatch152_UK = t.maxpermatch152_UK,
	ci.maxpermatch152_AU = t.maxpermatch152_AU,
	ci.MaxPerMatch153_AU = t.MaxPerMatch153_AU
FROM custInfo ci with(UPDLOCK,ROWLOCK)
	INNER JOIN @tmp_maxpermatch t ON ci.currency = t.currency
WHERE ci.srecommend in (
	SELECT custid from Dep_CustSuper with(nolock) where currency in (20, 13, 4, 15, 51, 2, 3, 9, 6, 12, 32, 61) and site = 'w88'
)
AND ci.custid <= @max_custid 

