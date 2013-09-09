  /*
	Created: Johnson
	Date: 2013-09-09
	Task: Update max bet, max per match racing setting for VCAsia
	DB: DBTXN/bodb02
 */
 
 DECLARE @betsetting table (sporttype int ,bettype int ,currency int, currencyName nvarchar(10), minbet money, maxbet money, maxpermatch money)

declare @max_custid int 
select @max_custid = xxxxx

insert into @betsetting (sporttype, bettype, currency,currencyName ,minbet ,maxbet)
--USD
		select	151	,	31	,	3	,	'US$'	,	10.00	,	1200.00	
union select	151	,	32	,	3	,	'US$'	,	10.00	,	1200.00	
union select	151	,	41	,	3	,	'US$'	,	10.00	,	1200.00	
union select	151	,	42	,	3	,	'US$'	,	10.00	,	1200.00	
union select	151	,	51	,	3	,	'US$'	,	10.00	,	1200.00	
union select	151	,	52	,	3	,	'US$'	,	10.00	,	1200.00	
union select	152	,	41	,	3	,	'US$'	,	10.00	,	15000.00
union select	152	,	42	,	3	,	'US$'	,	10.00	,	15000.00
union select	152	,	51	,	3	,	'US$'	,	10.00	,	15000.00
union select	152	,	52	,	3	,	'US$'	,	10.00	,	15000.00
union select	153	,	51	,	3	,	'US$'	,	10.00	,	15000.00
union select	153	,	52	,	3	,	'US$'	,	10.00	,	15000.00
--RMB
union select	151	,	31	,	13	,	'RMB'	,	50.00	,	7000.00
union select	151	,	32	,	13	,	'RMB'	,	50.00	,	7000.00
union select	151	,	41	,	13	,	'RMB'	,	50.00	,	7000.00
union select	151	,	42	,	13	,	'RMB'	,	50.00	,	7000.00	
union select	151	,	51	,	13	,	'RMB'	,	50.00	,	7000.00
union select	151	,	52	,	13	,	'RMB'	,	50.00	,	7000.00	
union select	152	,	41	,	13	,	'RMB'	,	50.00	,	80000.00	
union select	152	,	42	,	13	,	'RMB'	,	50.00	,	80000.00	
union select	152	,	51	,	13	,	'RMB'	,	50.00	,	80000.00	
union select	152	,	52	,	13	,	'RMB'	,	50.00	,	80000.00	
union select	153	,	51	,	13	,	'RMB'	,	50.00	,	80000.00	
union select	153	,	52	,	13	,	'RMB'	,	50.00	,	80000.00	
--GBP
union select	151	,	31	,	12	,	'GBP'	,	10.00	,	800.00	
union select	151	,	32	,	12	,	'GBP'	,	10.00	,	800.00	
union select	151	,	41	,	12	,	'GBP'	,	10.00	,	800.00
union select	151	,	42	,	12	,	'GBP'	,	10.00	,	800.00	
union select	151	,	51	,	12	,	'GBP'	,	10.00	,	800.00	
union select	151	,	52	,	12	,	'GBP'	,	10.00	,	800.00	
union select	152	,	41	,	12	,	'GBP'	,	10.00	,	10000.00	
union select	152	,	42	,	12	,	'GBP'	,	10.00	,	10000.00	
union select	152	,	51	,	12	,	'GBP'	,	10.00	,	10000.00	
union select	152	,	52	,	12	,	'GBP'	,	10.00	,	10000.00	
union select	153	,	51	,	12	,	'GBP'	,	10.00	,	10000.00	
union select	153	,	52	,	12	,	'GBP'	,	10.00	,	10000.00	
--AUD
union select	151	,	31	,	9	,	'AUD'	,	5.00	,	1400.00
union select	151	,	32	,	9	,	'AUD'	,	5.00	,	1400.00	
union select	151	,	41	,	9	,	'AUD'	,	10.00	,	1400.00	
union select	151	,	42	,	9	,	'AUD'	,	10.00	,	1400.00	
union select	151	,	51	,	9	,	'AUD'	,	5.00	,	1400.00	
union select	151	,	52	,	9	,	'AUD'	,	5.00	,	1400.00	
union select	152	,	41	,	9	,	'AUD'	,	10.00	,	15000.00
union select	152	,	42	,	9	,	'AUD'	,	10.00	,	15000.00	
union select	152	,	51	,	9	,	'AUD'	,	5.00	,	15000.00	
union select	152	,	52	,	9	,	'AUD'	,	5.00	,	15000.00	
union select	153	,	51	,	9	,	'AUD'	,	5.00	,	15000.00	
union select	153	,	52	,	9	,	'AUD'	,	5.00	,	15000.00	
--EURO
union select	151	,	31	,	6	,	'EURO'	,	10.00	,	1000.00	
union select	151	,	32	,	6	,	'EURO'	,	10.00	,	1000.00	
union select	151	,	41	,	6	,	'EURO'	,	10.00	,	1000.00
union select	151	,	42	,	6	,	'EURO'	,	10.00	,	1000.00
union select	151	,	51	,	6	,	'EURO'	,	10.00	,	1000.00	
union select	151	,	52	,	6	,	'EURO'	,	10.00	,	1000.00	
union select	152	,	41	,	6	,	'EURO'	,	10.00	,	10000.00
union select	152	,	42	,	6	,	'EURO'	,	10.00	,	10000.00
union select	152	,	51	,	6	,	'EURO'	,	10.00	,	10000.00	
union select	152	,	52	,	6	,	'EURO'	,	10.00	,	10000.00	
union select	153	,	51	,	6	,	'EURO'	,	10.00	,	10000.00	
union select	153	,	52	,	6	,	'EURO'	,	10.00	,	10000.00	
--SD$
union select	151	,	31	,	1	,	'SD$'	,	10.00	,	1500.00	
union select	151	,	32	,	1	,	'SD$'	,	10.00	,	1500.00	
union select	151	,	41	,	1	,	'SD$'	,	10.00	,	1500.00
union select	151	,	42	,	1	,	'SD$'	,	10.00	,	1500.00	
union select	151	,	51	,	1	,	'SD$'	,	10.00	,	1500.00	
union select	151	,	52	,	1	,	'SD$'	,	10.00	,	1500.00
union select	152	,	41	,	1	,	'SD$'	,	10.00	,	20000.00	
union select	152	,	42	,	1	,	'SD$'	,	10.00	,	20000.00
union select	152	,	51	,	1	,	'SD$'	,	10.00	,	20000.00	
union select	152	,	52	,	1	,	'SD$'	,	10.00	,	20000.00	
union select	153	,	51	,	1	,	'SD$'	,	10.00	,	20000.00	
union select	153	,	52	,	1	,	'SD$'	,	10.00	,	20000.00	

--1854 customers affected
update cs
Set cs.minbet = b.minbet,
	cs.maxbet = b.maxbet
from Dep_CustSetting3rd cs
	INNER JOIN custInfo ci WITH(NOLOCK) On cs.custid = ci.custid 
	INNER JOIN @betsetting b ON cs.sporttype = b.sporttype AND cs.bettype = b.bettype and ci.currency = b.currency 
WHERE ci.srecommend IN (
	SELECT custid from Dep_CustSuper with(nolock) where currency in (6,3,9,1,12,13) and site = 'vcasia'
)
	AND custid <= @max_custid 

GO




DECLARE @tmp_maxpermatch TABLE(currency int,currencyName nvarchar(10), maxpermatch151 money,
	maxpermatch151_OT money, maxpermatch151_AU money, maxpermatch152_UK money
	, maxpermatch152_AU money ,maxpermatch153_AU money
)

declare @max_custid int 
select @max_custid = xxxxx

INSERT INTO @tmp_maxpermatch (currency, currencyName,maxpermatch151, maxpermatch151_OT 
	,maxpermatch151_AU , maxpermatch152_UK ,maxpermatch152_AU ,maxpermatch153_AU)
		 select	3	,	'US$'	,	30000.00	,	30000.00	,	30000.00	,	30000.00	,	30000.00	,	30000.00
union select	6	,	'EURO'	,	20000.00	,	20000.00	,	20000.00	,	20000.00	,	20000.00	,	20000.00
union select	12	,	'GBP'	,	20000.00	,	20000.00	,	20000.00	,	20000.00	,	20000.00	,	20000.00
union select	13	,	'RMB'	,	160000.00	,	160000.00	,	160000.00	,	160000.00	,	160000.00	,	160000.00
union select	9	,	'AUD'	,	30000.00	,	30000.00	,	30000.00	,	30000.00	,	30000.00	,	30000.00
union select	1	,	'SD$'	,	30000.00	,	40000.00	,	40000.00	,	40000.00	,	40000.00	,	40000.00

--1854 customers affected
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
	SELECT custid from Dep_CustSuper with(nolock) where currency in (6,3,9,1,12,13) and site = 'vcasia'
)
AND custid <= @max_custid 