 /*
	Created: Johnson
	Date: 2013-12-19
	Task: enbale virtual sports for members under MayFair licensee
	DB: DBTXN/bodb02
 */
 
 
 --step 1: delete old settings for virtual Horse Racing, Greyhounds, Motor Racing, Tennis

 --1892 rows affected
DELETE ds
 from Dep_CustSetting3rd ds with(ROWLOCK)
inner join custInfo ci with(nolock) on ds.custid = ci.custid 
 where sporttype between 181  and 186
 and ci.srecommend in (
select custid from Dep_CustSuper with(nolock) where site = 'MayFair'
and currency IN (13,20)
)
GO


--step 2: update bet settings for virtual soccer
-- and insert setting for  virtual Horse Racing, Greyhounds, Motor Racing, Tennis

 ALTER PROCEDURE [dbo].[Acc_ExecRep_09]
	@ids varchar(max), 
	@minbet money,
	@maxbet money,
	@maxpermatch money
AS
SET NOCOUNT ON

IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('Dep_CustSetting3rd','custinfo') AND type = 'U') <> 2 RETURN
BEGIN

	declare @string varchar(max), @splitter char(1), @xml XML
	select @splitter = ',' ,@string = @ids
	
	SET @XML = N'<root><r>' + REPLACE(@string, @splitter, '</r><r>') + '</r></root>'
	
	declare @res AS TABLE(custid INT)
	INSERT INTO @res(custid)
	SELECT r.value('.','INT')
	FROM @xml.nodes('//root/r') AS RECORDS(r)
	
	UPDATE dbo.Dep_CustSetting3rd WITH(ROWLOCK, UPDLOCK)
	SET	minbet = @minbet,
		maxbet = @maxbet
	WHERE sporttype = 180		
		and custid in (select custid from @res)
		
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
		and custid in (select custid from @res)
		

	UPDATE dbo.CustInfo WITH(ROWLOCK,UPDLOCK)
	SET MaxPerMatch180 = @maxpermatch
		,MaxPerMatch181 = @maxpermatch
		,MaxPerMatch182 = @maxpermatch
		,MaxPerMatch184 = @maxpermatch
		,MaxPerMatch186 = @maxpermatch		
	WHERE custid in (select custid from @res)
END
 
GO


CREATE TABLE #tmpCust (custid INT PRIMARY KEY, isfinshed bit DEFAULT(0))

DECLARE @max_custid INT

SELECT @max_custid = xxx

--30266 rows affected
INSERT INTO #tmpCust(custid)
SELECT custid
FROM custInfo ci with(nolock) 
WHERE srecommend in (
	select custid from Dep_CustSuper with(nolock) where site = 'MayFair'
	and currency IN (13, 20)
)
AND custid <= @max_custid 
GO


DECLARE @subtable TABLE(custid int)
DECLARE @ids varchar(max)

DECLARE @running_cnt INT,
		@minbet MONEY,
		@maxbet MONEY,
		@maxpermatch MONEY

SELECT @running_cnt = 0,
		@minbet = 10,
		@maxbet = 500000,
		@maxpermatch = 1000000


WHILE (1 = 1)
BEGIN
	DELETE @subtable
	SELECT @ids = ''

	DELETE TOP (100) #tmpCust
	OUTPUT deleted.custid
	INTO @subtable(custid)	

	IF @@ROWCOUNT = 0 BREAK
	
	SELECT @ids = STUFF((
		SELECT ',' + cast(custid as varchar(10)) 
		FROM @subtable 
		FOR XML PATH('')
	), 1,1,'')
	
	EXEC dbo.Acc_ExecRep_09 @ids = @ids, @minbet = @minbet, @maxbet = @maxbet, @maxpermatch = @maxpermatch	
	
	IF @running_cnt = 30
	BEGIN
		WAITFOR DELAY '00:00:01'
		SET @running_cnt = 0
	END
	
	SET @running_cnt = @running_cnt + 1
END	

 