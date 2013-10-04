DECLARE @tmp_betsetting TABLE(currencyname VARCHAR(20),currency INT PRIMARY KEY, maxbet money, maxpermatch money, isfinished bit default(0))

DECLARE @currency INT, @running_cnt int, @maxbet money, @maxpermatch money, @old_maxCustid int, @new_maxCustID int

SELECT @old_maxCustid = xxxx,
		@new_maxCustid = yyyy,
		 @running_cnt = 0

CREATE TABLE #customer (custid int)

insert into @tmp_Betsetting(currencyname ,currency ,maxbet ,maxpermatch)
		SELECT	'RM'	,	2	,	10000	,	50000
union SELECT	'$US'	,	35	,	3000	,	15000
union SELECT	'AUD'	,	9	,	3000	,	15000
union SELECT	'BND'	,	46	,	3000	,	15000
union SELECT	'CAD'	,	21	,	1000	,	5000
union SELECT	'CHF'	,	41	,	5000	,	10000
union SELECT	'CZK'	,	57	,	8000	,	40000
union SELECT	'DDD'	,	47	,	24000	,	100000
union SELECT	'DKK'	,	52	,	16000	,	100000
union SELECT	'EURO'	,	6	,	2000	,	15000
union SELECT	'GBP'	,	12	,	1500	,	10000
union SELECT	'HK$'	,	5	,	20000	,	100000
union SELECT	'IDD'	,	33	,	24000	,	150000
union SELECT	'IDR'	,	34	,	24000	,	150000
union SELECT	'IN'	,	15	,	24000	,	150000
union SELECT	'IND'	,	22	,	24000	,	150000
union SELECT	'IRR'	,	40	,	2000	,	10000
union SELECT	'INH'	,	51	,	50000	,	150000
union SELECT	'INR'	,	61	,	500000	,	1000000
union SELECT	'JPY'	,	32	,	250000	,	2000000
union SELECT	'KW'	,	62	,	15000	,	30000
union SELECT	'MXN'	,	49	,	24000	,	120000
union SELECT	'NOK'	,	54	,	16000	,	80000
union SELECT	'NT'	,	30	,	100000	,	500000
union SELECT	'NTD'	,	17	,	3000	,	15000
union SELECT	'P'		,	37	,	3000	,	15000
union SELECT	'PE'	,	42	,	400000	,	800000
union SELECT	'PLN'	,	56	,	8000	,	40000
union SELECT	'PT'	,	44	,	24000	,	100000
union SELECT	'Pts'	,	31	,	800000	,	4000000
union SELECT	'RMB'	,	13	,	16000	,	80000
union SELECT	'RON'	,	58	,	10000	,	50000
union SELECT	'RUB'	,	55	,	80000	,	400000
union SELECT	'SD$'	,	1	,	3000	,	20000
union SELECT	'SEK'	,	53	,	16000	,	80000
union SELECT	'TB'	,	4	,	100000	,	500000
union SELECT	'THB'	,	43	,	100000	,	500000
union SELECT	'US$'	,	3	,	1500	,	15000
union SELECT	'Won'	,	45	,	3200000	,	15000000
union SELECT	'Y$US'	,	36	,	3000	,	15000
union SELECT	'Yen'	,	16	,	3000	,	15000
union SELECT	'ZAR'	,	48	,	16000	,	80000

 
 
--begin update bet setting
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) @tmp_betsetting
	SET isfinished = 1
		,@currency = currency
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
		and custid > @old_maxCustid 
		and custid <= @new_maxCustid
	
	DECLARE @subtable TABLE(custid int)
	DECLARE @ids varchar(max)
	
	WHILE (1 = 1)
	BEGIN
		DELETE @subtable

		DELETE TOP (100) #customer
		OUTPUT deleted.custid
		INTO @subtable(custid)	

		IF @@ROWCOUNT = 0 BREAK
		
		SELECT @ids = STUFF((
			SELECT ',' + cast(custid as varchar(10)) 
			FROM @subtable 
			FOR XML PATH('')
		), 1,1,'')
		
		EXEC dbo.Acc_ExecRep_09 @ids = @ids, @maxbet = @maxbet, @maxpermatch = @maxpermatch	
		
		IF @running_cnt = 30
		BEGIN
			WAITFOR DELAY '00:00:01'
			SET @running_cnt = 0
		END
		
		SET @running_cnt = @running_cnt + 1
	END	
END

--DROP TABLE #customer