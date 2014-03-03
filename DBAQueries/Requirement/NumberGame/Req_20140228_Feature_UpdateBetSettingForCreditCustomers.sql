   /*
	Created: Johnson
	Date: 2014-02-28
	Task: Update number game bet Settings for all SMA credit customers
	DB: DBTXN/CustDB
 */
 -- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT	
	,@maxcustid INT
	,@minbet MONEY
	,@maxbet MONEY
	,@maxperball MONEY
	,@maxpermatch MONEY
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('custinfo') AND type = 'U'
		) <> 1 RETURN 
	 					
	UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
	SET MaxPerBall161 = @maxperball,
		maxpermatch161 = @maxpermatch
	WHERE srecommend = @srecommend 
		AND custid <= @maxcustid
		AND roleid IN (2,3,4)
	
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('custsetting3rd') AND type = 'U'
		) <> 1 RETURN 
	
	UPDATE cs
	SET cs.minbet = @minbet,
		cs.maxbet = @maxbet
	FROM custsetting3rd cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid AND cs.sporttype = 161
	WHERE ci.srecommend = @srecommend 
		AND ci.custid <= @maxcustid
		AND ci.roleid IN (2,3,4)
END
GO

 
---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
 
 DECLARE @tmp_settings table(
	currency int,
	minbet money,
	maxbet money,
	maxperball money,
	maxpermatch money,
	isfinished bit default(0)
)

INSERT INTO @tmp_settings(currency,minbet,maxbet,maxperball,maxpermatch)
		SELECT 	35	,	2	,	1150	,	4800	,	19800	--	$US
UNION ALL SELECT 	47	,	18	,	13460	,	56000	,	230220	--	DDD
UNION ALL SELECT 	6	,	1	,	840	,	3500	,	14000	--	EURO
UNION ALL SELECT 	12	,	1	,	690	,	2900	,	11800	--	GBP
UNION ALL SELECT 	5	,	13	,	8900	,	37860	,	153000	--	HK$
UNION ALL SELECT 	33	,	18	,	13460	,	56000	,	230220	--	IDD
UNION ALL SELECT 	15	,	18	,	13460	,	56000	,	230220	--	IN
UNION ALL SELECT 	22	,	18	,	13460	,	56000	,	230220	--	IND
UNION ALL SELECT 	40	,	2	,	1150	,	4800	,	19800	--	IRR
UNION ALL SELECT 	17	,	2	,	1150	,	4800	,	19800	--	NTD
UNION ALL SELECT 	2	,	5	,	3800	,	16000	,	65000	--	RM
UNION ALL SELECT 	13	,	11	,	7090	,	29000	,	121000	--	RMB
UNION ALL SELECT 	1	,	3	,	1460	,	6100	,	25000	--	SD$
UNION ALL SELECT 	4	,	100	,	37700	,	158000	,	644000	--	TB
UNION ALL SELECT 	43	,	60	,	37700	,	158000	,	644000	--	THB
UNION ALL SELECT 	3	,	2	,	1150	,	4800	,	19800	--	US$
UNION ALL SELECT 	45	,	10000	,	1236000	,	5200000	,	21000000	--	Won
UNION ALL SELECT 	16	,	2	,	1150	,	4800	,	19800	--	Yen
UNION ALL SELECT 	64	,	2	,	1150	,	4800	,	19800	--	UT

CREATE TABLE #supers(custid INT)

DECLARE @srecommend INT, @max_custid INT, @currency INT, @minbet MONEY, @maxbet MONEY, @maxperball MONEY, @maxpermatch MONEY
SELECT @max_custid = xxxx

WHILE (1=1)
BEGIN
	UPDATE TOP(1) t
	SET @currency = currency,
		@minbet = minbet,
		@maxbet = maxbet,
		@maxperball = maxperball,
		@maxpermatch = maxpermatch, 
		isfinished = 1
	FROM @tmp_settings t
	WHERE t.isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK;
	
	DELETE #supers
	
	INSERT INTO #supers(custid)
	SELECT custid
	FROM custinfo WITH(NOLOCK)
	WHERE custid <= @max_custid
		AND roleid = 4
		AND currency = @currency
		AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	
	WHILE (1 = 1)
	BEGIN
		SELECT TOP (1) @srecommend = custid
		FROM #supers
		
		IF @@ROWCOUNT = 0 BREAK;
				
		EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend		
			,@maxcustid = @max_custid
			,@minbet = @minbet
			,@maxbet = @maxbet
			,@maxperball = @maxperball
			,@maxpermatch = @maxpermatch
			,@target = 'REPLICATED'
		
		DELETE #supers WHERE custid = @srecommend
		WAITFOR DELAY '00:00:00.280'
	END
END
-- END STEP 2: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------

 DECLARE @tmp_settings table(
	currency int,
	minbet money,
	maxbet money,
	maxperball money,
	maxpermatch money,
	isfinished bit default(0)
)

INSERT INTO @tmp_settings(currency,minbet,maxbet,maxperball,maxpermatch)
		SELECT 	35	,	2	,	1150	,	4800	,	19800	--	$US
UNION ALL SELECT 	47	,	18	,	13460	,	56000	,	230220	--	DDD
UNION ALL SELECT 	6	,	1	,	840	,	3500	,	14000	--	EURO
UNION ALL SELECT 	12	,	1	,	690	,	2900	,	11800	--	GBP
UNION ALL SELECT 	5	,	13	,	8900	,	37860	,	153000	--	HK$
UNION ALL SELECT 	33	,	18	,	13460	,	56000	,	230220	--	IDD
UNION ALL SELECT 	15	,	18	,	13460	,	56000	,	230220	--	IN
UNION ALL SELECT 	22	,	18	,	13460	,	56000	,	230220	--	IND
UNION ALL SELECT 	40	,	2	,	1150	,	4800	,	19800	--	IRR
UNION ALL SELECT 	17	,	2	,	1150	,	4800	,	19800	--	NTD
UNION ALL SELECT 	2	,	5	,	3800	,	16000	,	65000	--	RM
UNION ALL SELECT 	13	,	11	,	7090	,	29000	,	121000	--	RMB
UNION ALL SELECT 	1	,	3	,	1460	,	6100	,	25000	--	SD$
UNION ALL SELECT 	4	,	100	,	37700	,	158000	,	644000	--	TB
UNION ALL SELECT 	43	,	60	,	37700	,	158000	,	644000	--	THB
UNION ALL SELECT 	3	,	2	,	1150	,	4800	,	19800	--	US$
UNION ALL SELECT 	45	,	10000	,	1236000	,	5200000	,	21000000	--	Won
UNION ALL SELECT 	16	,	2	,	1150	,	4800	,	19800	--	Yen
UNION ALL SELECT 	64	,	2	,	1150	,	4800	,	19800	--	UT

CREATE TABLE #supers(custid INT)

DECLARE @srecommend INT, @max_custid INT, @currency INT, @minbet MONEY, @maxbet MONEY, @maxperball MONEY, @maxpermatch MONEY
SELECT @max_custid = xxxx

WHILE (1=1)
BEGIN
	UPDATE TOP(1) t
	SET @currency = currency,
		@minbet = minbet,
		@maxbet = maxbet,
		@maxperball = maxperball,
		@maxpermatch = maxpermatch, 
		isfinished = 1
	FROM @tmp_settings t
	WHERE t.isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK;
	
	DELETE #supers
	
	INSERT INTO #supers(custid)
	SELECT custid
	FROM custinfo WITH(NOLOCK)
	WHERE custid <= @max_custid
		AND roleid = 4
		AND currency = @currency
		AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	
	WHILE (1 = 1)
	BEGIN
		SELECT TOP (1) @srecommend = custid
		FROM #supers
		
		IF @@ROWCOUNT = 0 BREAK;
				
		EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend		
			,@maxcustid = @max_custid
			,@minbet = @minbet
			,@maxbet = @maxbet
			,@maxperball = @maxperball
			,@maxpermatch = @maxpermatch
			,@target = 'DBTRANS'
		
		DELETE #supers WHERE custid = @srecommend
		WAITFOR DELAY '00:00:00.280'
	END
END