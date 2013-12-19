 /*
	Created: Johnson
	Date: 2013-12-19
	Task: enbale virtual sports for members under Vwin licensee
	DB: DBTXN/bodb02
 */
 
 
 --step 1: delete old settings for virtual Horse Racing, Greyhounds, Motor Racing, Tennis

 --1256 rows affected
DELETE ds
 from Dep_CustSetting3rd ds with(ROWLOCK)
inner join custInfo ci with(nolock) on ds.custid = ci.custid 
 where sporttype between 181  and 186
 and ci.srecommend in (
	select custid from Dep_CustSuper with(nolock) where site = 'Vwin'
	and currency IN (2,3,4,13,15,51)
)
GO


--step 2: update bet settings for virtual soccer
-- and insert setting for  virtual Horse Racing, Greyhounds, Motor Racing, Tennis
DECLARE @tmpBet TABLE (currency INT, minbet MONEY, maxbet MONEY, maxpermatch MONEY)
CREATE TABLE #tmpCust (custid INT, roleid INT)

DECLARE @currency INT, 
		@minbet MONEY, 
		@maxbet MONEY, 
		@maxpermatch MONEY,
		@max_custid INT

SELECT @max_custid = xxx		
		

INSERT INTO @tmpBet (currency, minbet, maxbet, maxpermatch)
SELECT 2, 1, 4000, 20000 --RM, 9 customers
UNION ALL
SELECT 3, 2, 45000, 225000 --USD, 8 customers
UNION ALL 
SELECT 4, 15, 40000, 200000--TB, 13 customers
UNION ALL
SELECT 13, 10, 300000, 1500000--RMB, 1445 customers
UNION ALL
SELECT 15, 5, 14000, 70000--IN, 9 customers
UNION ALL
SELECT 51, 10, 28000, 140000--INH, 452 customers
UNION ALL 
SELECT 20, 10, 20000, 100000--UUS, 319 customers

WHILE (1=1)
BEGIN
	SELECT TOP(1) @currency = currency, @minbet = minbet, @maxbet = maxbet, @maxpermatch = maxpermatch
	FROM @tmpBet
	
	IF @@ROWCOUNT = 0 BREAK
	
	TRUNCATE TABLE #tmpCust
	
	INSERT INTO #tmpCust(custid, roleid)
	SELECT custid, roleid 
	FROM custInfo WITH(NOLOCK)
	WHERE srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE site = 'Vwin' AND currency = @currency)
		AND custid <= @max_custid
	
	UPDATE ds
	SET	minbet = @minbet,
		maxbet = @maxbet,
		spositiontaking = CASE WHEN roleid = 4 THEN 0.85 ELSE 0 END,
		mpositiontaking = CASE WHEN roleid IN (3,4) THEN 0.85 ELSE 0 END,
		apositiontaking = CASE WHEN roleid IN (1,2,4) THEN 0.85 ELSE 0 END
	FROM dbo.Dep_CustSetting3rd ds WITH(ROWLOCK, UPDLOCK)
		INNER JOIN #tmpCust c ON ds.custid = c.custid AND sporttype = 180
		
		
	INSERT INTO [dbo].[Dep_CustSetting3rd]
           ([custid]
           ,[bettype]
           ,[sporttype]
           ,[islive]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[minbet]
           ,[maxbet])
     SELECT [custid]
           ,t.[bettype]
           ,t.[sporttype]
           ,[islive]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[minbet]
           ,[maxbet]
	FROM Dep_CustSetting3rd ds WITH(NOLOCK)           
		CROSS JOIN (
			SELECT 181 as sporttype, 1231 as bettype
			UNION ALL
			SELECT 182 as sporttype, 1231 as bettype
			UNION ALL
			SELECT 184 as sporttype, 1231 as bettype
			UNION ALL
			SELECT 186 as sporttype, 1220 as bettype
		) t
	WHERE ds.sporttype = 180		
		and custid in (select custid from #tmpCust)
		

	UPDATE dbo.CustInfo WITH(ROWLOCK,UPDLOCK)
	SET MaxPerMatch180 = @maxpermatch
		,MaxPerMatch181 = @maxpermatch
		,MaxPerMatch182 = @maxpermatch
		,MaxPerMatch184 = @maxpermatch
		,MaxPerMatch186 = @maxpermatch		
	WHERE custid in (select custid from #tmpCust)
	
	DELETE @tmpBet WHERE currency = @currency

	waitfor delay '0:00:01'
END
 
 