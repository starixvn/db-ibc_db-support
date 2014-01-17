/*
	Created: Johnson
	Date: 2014-01-15
	Task: Update max bet, max per match setting for all credit customers on AUS racing
	DB: DBTXN/CustDB
*/ 

-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT
	,@minbet MONEY
	,@maxbet MONEY
	,@maxpermatch MONEY
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
		
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('CustSetting3rd', 'custinfo') AND type = 'U'
		) <> 2 RETURN	

	UPDATE dbo.CustSetting3rd WITH(ROWLOCK, UPDLOCK)
	SET minbet = @minbet
		,maxbet = @maxbet
	WHERE sporttype IN (151, 152, 153)
		AND bettype IN (51, 52)
		AND custid IN (
			SELECT custid 
			FROM dbo.Custinfo WITH(NOLOCK) 
			WHERE srecommend = @srecommend 
				AND custid <= @maxcustid
			)		

	UPDATE dbo.CustInfo WITH (ROWLOCK, UPDLOCK)
	SET MaxPerMatch151_AU = @maxpermatch
		,MaxPerMatch152_AU = @maxpermatch
		,MaxPerMatch153_AU = @maxpermatch
	WHERE srecommend = @srecommend
		AND custid <= @maxcustid
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------

DECLARE @tmp_betsetting TABLE(currencyname VARCHAR(20),currency INT PRIMARY KEY, minbet money, maxbet money, maxpermatch money)
CREATE TABLE #supers (custid int, currency int, isfinished bit)

INSERT INTO #supers (custid, currency, isfinished)
SELECT custid, currency, 0
FROM dbo.custInfo WITH (NOLOCK)
WHERE roleid = 4

insert into @tmp_Betsetting(currencyname ,currency , minbet, maxbet ,maxpermatch)
		 SELECT 	'RM'	,	2	,	10	,	20000	,	100000
UNION ALL SELECT 	'AUD'	,	9	,	5	,	6000	,	30000
UNION ALL SELECT 	'BND'	,	46	,	5	,	6000	,	30000
UNION ALL SELECT 	'CAD'	,	21	,	5	,	2000	,	10000
UNION ALL SELECT 	'CHF'	,	41	,	10	,	10000	,	20000
UNION ALL SELECT 	'CZK'	,	57	,	100	,	16000	,	80000
UNION ALL SELECT 	'DDD'	,	47	,	50	,	48000	,	200000
UNION ALL SELECT 	'DKK'	,	52	,	20	,	32000	,	200000
UNION ALL SELECT 	'EURO'	,	6	,	5	,	4000	,	30000
UNION ALL SELECT 	'GBP'	,	12	,	5	,	3000	,	20000
UNION ALL SELECT 	'HK$'	,	5	,	30	,	40000	,	200000
UNION ALL SELECT 	'IDD'	,	33	,	50	,	48000	,	300000
UNION ALL SELECT 	'IDR'	,	34	,	50	,	48000	,	300000
UNION ALL SELECT 	'IN'	,	15	,	50	,	48000	,	300000
UNION ALL SELECT 	'IND'	,	22	,	50	,	48000	,	300000
UNION ALL SELECT 	'IRR'	,	40	,	5	,	4000	,	20000
UNION ALL SELECT 	'INH'	,	51	,	70	,	100000	,	300000
UNION ALL SELECT 	'INR'	,	61	,	300	,	1000000	,	2000000
UNION ALL SELECT 	'JPY'	,	32	,	500	,	500000	,	4000000
UNION ALL SELECT 	'KW'	,	62	,	5	,	30000	,	60000
UNION ALL SELECT 	'MXN'	,	49	,	50	,	48000	,	240000
UNION ALL SELECT 	'NOK'	,	54	,	20	,	32000	,	160000
UNION ALL SELECT 	'NT'	,	30	,	100	,	200000	,	1000000
UNION ALL SELECT 	'NTD'	,	17	,	5	,	6000	,	30000
UNION ALL SELECT 	'P'	,	37	,	5	,	6000	,	30000
UNION ALL SELECT 	'PE'	,	42	,	300	,	800000	,	1600000
UNION ALL SELECT 	'PLN'	,	56	,	10	,	16000	,	80000
UNION ALL SELECT 	'PT'	,	44	,	100	,	48000	,	200000
UNION ALL SELECT 	'Pts'	,	31	,	600	,	1600000	,	8000000
UNION ALL SELECT 	'RMB'	,	13	,	30	,	32000	,	160000
UNION ALL SELECT 	'RON'	,	58	,	10	,	20000	,	100000
UNION ALL SELECT 	'RUB'	,	55	,	300	,	160000	,	800000
UNION ALL SELECT 	'SD$'	,	1	,	5	,	6000	,	40000
UNION ALL SELECT 	'SEK'	,	53	,	20	,	32000	,	160000
UNION ALL SELECT 	'TB'	,	4	,	300	,	200000	,	1000000
UNION ALL SELECT 	'THB'	,	43	,	300	,	200000	,	1000000
UNION ALL SELECT 	'US$'	,	3	,	5	,	3000	,	30000
UNION ALL SELECT 	'Won'	,	45	,	7000	,	6400000	,	30000000
UNION ALL SELECT 	'Y$US'	,	36	,	5	,	6000	,	30000
UNION ALL SELECT 	'Yen'	,	16	,	5	,	6000	,	30000
UNION ALL SELECT 	'ZAR'	,	48	,	30	,	32000	,	160000

-- DO NOT update for deposit customers
DELETE #supers
WHERE custid IN (SELECT custid FROM dbo.Dep_CustSuper WITH (NOLOCK)) 
OR currency NOT IN (SELECT currency FROM @tmp_betsetting)

--begin update bet setting
DECLARE @currency INT, @minbet money, @maxbet money, @maxpermatch money, @max_custid int, @srecommend INT
SET @max_custid = 13726506 -- SELECT max(custid) from dbo.custinfo WITH(NOLOCK)
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
		,@currency = currency
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SELECT @minbet = minbet
		,@maxbet = maxbet
		,@maxpermatch = maxpermatch
	FROM @tmp_betsetting
	WHERE currency = @currency
		
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
		,@minbet = @minbet
		,@maxbet = @maxbet
		,@maxpermatch = @maxpermatch
		,@maxcustid = @max_custid
		,@target = 'REPLICATED'
		
	WAITFOR DELAY '00:00:00.280'
END
-- END STEP 2: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------

DECLARE @tmp_betsetting TABLE(currencyname VARCHAR(20),currency INT PRIMARY KEY, minbet money, maxbet money, maxpermatch money)
CREATE TABLE #supers (custid int, currency int, isfinished bit)

INSERT INTO #supers (custid, currency, isfinished)
SELECT custid, currency, 0
FROM dbo.custInfo WITH (NOLOCK)
WHERE roleid = 4

insert into @tmp_Betsetting(currencyname ,currency , minbet, maxbet ,maxpermatch)
		 SELECT 	'RM'	,	2	,	10	,	20000	,	100000
UNION ALL SELECT 	'AUD'	,	9	,	5	,	6000	,	30000
UNION ALL SELECT 	'BND'	,	46	,	5	,	6000	,	30000
UNION ALL SELECT 	'CAD'	,	21	,	5	,	2000	,	10000
UNION ALL SELECT 	'CHF'	,	41	,	10	,	10000	,	20000
UNION ALL SELECT 	'CZK'	,	57	,	100	,	16000	,	80000
UNION ALL SELECT 	'DDD'	,	47	,	50	,	48000	,	200000
UNION ALL SELECT 	'DKK'	,	52	,	20	,	32000	,	200000
UNION ALL SELECT 	'EURO'	,	6	,	5	,	4000	,	30000
UNION ALL SELECT 	'GBP'	,	12	,	5	,	3000	,	20000
UNION ALL SELECT 	'HK$'	,	5	,	30	,	40000	,	200000
UNION ALL SELECT 	'IDD'	,	33	,	50	,	48000	,	300000
UNION ALL SELECT 	'IDR'	,	34	,	50	,	48000	,	300000
UNION ALL SELECT 	'IN'	,	15	,	50	,	48000	,	300000
UNION ALL SELECT 	'IND'	,	22	,	50	,	48000	,	300000
UNION ALL SELECT 	'IRR'	,	40	,	5	,	4000	,	20000
UNION ALL SELECT 	'INH'	,	51	,	70	,	100000	,	300000
UNION ALL SELECT 	'INR'	,	61	,	300	,	1000000	,	2000000
UNION ALL SELECT 	'JPY'	,	32	,	500	,	500000	,	4000000
UNION ALL SELECT 	'KW'	,	62	,	5	,	30000	,	60000
UNION ALL SELECT 	'MXN'	,	49	,	50	,	48000	,	240000
UNION ALL SELECT 	'NOK'	,	54	,	20	,	32000	,	160000
UNION ALL SELECT 	'NT'	,	30	,	100	,	200000	,	1000000
UNION ALL SELECT 	'NTD'	,	17	,	5	,	6000	,	30000
UNION ALL SELECT 	'P'	,	37	,	5	,	6000	,	30000
UNION ALL SELECT 	'PE'	,	42	,	300	,	800000	,	1600000
UNION ALL SELECT 	'PLN'	,	56	,	10	,	16000	,	80000
UNION ALL SELECT 	'PT'	,	44	,	100	,	48000	,	200000
UNION ALL SELECT 	'Pts'	,	31	,	600	,	1600000	,	8000000
UNION ALL SELECT 	'RMB'	,	13	,	30	,	32000	,	160000
UNION ALL SELECT 	'RON'	,	58	,	10	,	20000	,	100000
UNION ALL SELECT 	'RUB'	,	55	,	300	,	160000	,	800000
UNION ALL SELECT 	'SD$'	,	1	,	5	,	6000	,	40000
UNION ALL SELECT 	'SEK'	,	53	,	20	,	32000	,	160000
UNION ALL SELECT 	'TB'	,	4	,	300	,	200000	,	1000000
UNION ALL SELECT 	'THB'	,	43	,	300	,	200000	,	1000000
UNION ALL SELECT 	'US$'	,	3	,	5	,	3000	,	30000
UNION ALL SELECT 	'Won'	,	45	,	7000	,	6400000	,	30000000
UNION ALL SELECT 	'Y$US'	,	36	,	5	,	6000	,	30000
UNION ALL SELECT 	'Yen'	,	16	,	5	,	6000	,	30000
UNION ALL SELECT 	'ZAR'	,	48	,	30	,	32000	,	160000

-- DO NOT update for deposit customers
DELETE #supers
WHERE custid IN (SELECT custid FROM dbo.Dep_CustSuper WITH (NOLOCK)) 
OR currency NOT IN (SELECT currency FROM @tmp_betsetting)

--begin update bet setting
DECLARE @currency INT, @minbet money, @maxbet money, @maxpermatch money, @max_custid int, @srecommend INT
SET @max_custid = 13726506 -- SELECT max(custid) from dbo.custinfo WITH(NOLOCK)
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
		,@currency = currency
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SELECT @minbet = minbet
		,@maxbet = maxbet
		,@maxpermatch = maxpermatch
	FROM @tmp_betsetting
	WHERE currency = @currency
		
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
		,@minbet = @minbet
		,@maxbet = @maxbet
		,@maxpermatch = @maxpermatch
		,@maxcustid = @max_custid
		,@target = 'DBTRANS'
		
	WAITFOR DELAY '00:00:00.280'
END
-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
------------------------------------------------