/*
	Created: Johnson
	Date: 2014-01-15
	Task: Update max bet, max per match setting for all credit customers on AUS racing
	DB: DBTXN/CustDB
*/ 


 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@ids varchar(max), 
	@minbet money,
	@maxbet money,
	@maxpermatch money
AS
SET NOCOUNT ON

IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('CustSetting3rd','custinfo') AND type = 'U') <> 2 RETURN
BEGIN

	declare @string varchar(max), @splitter char(1), @xml XML
	select @splitter = ',' ,@string = @ids
	
	SET @XML = N'<root><r>' + REPLACE(@string, @splitter, '</r><r>') + '</r></root>'
	
	declare @res AS TABLE(custid INT)
	INSERT INTO @res(custid)
	SELECT r.value('.','INT')
	FROM @xml.nodes('//root/r') AS RECORDS(r)
	
	UPDATE dbo.CustSetting3rd WITH(ROWLOCK, UPDLOCK)
	SET minbet = @minbet,
		maxbet = @maxbet
	WHERE sporttype IN (151,152,153)
		and bettype in (51,52)
		and custid in (select custid from @res)

	UPDATE dbo.CustInfo WITH(ROWLOCK,UPDLOCK)
	SET MaxPerMatch151_AU = @maxpermatch
		,MaxPerMatch152_AU = @maxpermatch
		,MaxPerMatch153_AU = @maxpermatch
	WHERE custid in (select custid from @res)
END
 
GO



DECLARE @tmp_betsetting TABLE(currencyname VARCHAR(20),currency INT PRIMARY KEY, minbet money, maxbet money, maxpermatch money, isfinished bit default(0))

DECLARE @currency INT, @minbet money, @maxbet money, @maxpermatch money, @running_cnt int, @max_custid int

SELECT @max_custid = xxxx
SELECT @running_cnt = 0

CREATE TABLE #customer (custid int)


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



--begin update bet setting

DECLARE @subtable TABLE(custid int)
DECLARE @ids varchar(max)
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) @tmp_betsetting
	SET isfinished = 1
		,@currency = currency
		,@minbet = minbet
		,@maxbet = maxbet
		,@maxpermatch = maxpermatch
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK -- no more to update
	
	TRUNCATE TABLE #customer
	INSERT INTO #customer
	SELECT custid
	from custInfo with(nolock)
	where srecommend not in (select custid from dbo.Dep_CustSuper with(nolock))
		and currency = @currency 
		and roleid <=4
		and custid <=@max_custid 
		
	WHILE (1 = 1)
	BEGIN
		DELETE @subtable
		SELECT @ids = ''

		DELETE TOP (100) #customer
		OUTPUT deleted.custid
		INTO @subtable(custid)	

		IF @@ROWCOUNT = 0 BREAK
		
		SELECT @ids = STUFF((
			SELECT ',' + cast(custid as varchar(10)) 
			FROM @subtable 
			FOR XML PATH('')
		), 1,1,'')
		
		EXEC dbo.Acc_ExecRep_Cust_09 @ids = @ids, @minbet = @minbet, @maxbet = @maxbet, @maxpermatch = @maxpermatch	
		
		IF @running_cnt = 30
		BEGIN
			WAITFOR DELAY '00:00:01'
			SET @running_cnt = 0
		END
		
		SET @running_cnt = @running_cnt + 1
	END	
END

--DROP TABLE #customer