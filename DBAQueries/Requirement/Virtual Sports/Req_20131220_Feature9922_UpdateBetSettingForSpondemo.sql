   /*
	Created: Johnson
	Date: 2013-12-20
	Task: enbale virtual sports for members under spondemo licensee
	DB: DBTXN/bodb02
 */
 
 
 --step 1: delete old settings for virtual Horse Racing, Greyhounds, Motor Racing, Tennis

 --26 rows affected
DELETE ds
 from Dep_CustSetting3rd ds with(ROWLOCK)
inner join custInfo ci with(nolock) on ds.custid = ci.custid 
 where sporttype between 181  and 186
 and ci.srecommend in (
	select custid from Dep_CustSuper with(nolock) where site = 'spondemo'
)
GO

--step 2: update settings for virtual soccer
-- and insert setting for  virtual Horse Racing, Greyhounds, Motor Racing, Tennis
CREATE TABLE #tmpCust (custid INT, roleid INT)

DECLARE	@minbet MONEY, 
		@maxbet MONEY, 
		@maxpermatch MONEY,
		@max_custid INT

SELECT @max_custid = xxx
		@minbet = 10,
		@maxbet = 10000,
		@maxpermatch = 100000

--609 rows affected	
INSERT INTO #tmpCust(custid, roleid)
SELECT custid, roleid 
FROM custInfo WITH(NOLOCK)
WHERE srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE site = 'spondemo')
	AND custid <= @max_custid

--update setting for virtual soccer
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
	