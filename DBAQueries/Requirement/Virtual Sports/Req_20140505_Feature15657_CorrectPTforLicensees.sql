/*
	Created: Johnson
	Date: 2014-05-05
	Task: Correct pt settings for licensees on virtual sports
	DB: DBTXN/CustDB
*/ 

 -- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting_03]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
		
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('custinfo','Dep_CustSetting3rd') AND type = 'U'
		) <> 2 RETURN	
	
	
	UPDATE cs
	set spositiontaking = CASE WHEN roleid = 4 THEN 0.85 ELSE 0 END,
		mpositiontaking = CASE WHEN roleid IN (3,4) then 0.85 else 0 END,
		apositiontaking = CASE WHEN roleid IN (1,2,4) then 0.85 else 0 END		
	from Dep_CustSetting3rd cs with(UPDLOCK,ROWLOCK)
		inner join custInfo ci with(nolock) on cs.custid = ci.custid
	where srecommend = @srecommend
		AND ci.custid <= @maxcustid		
		and sporttype between 180 and 186
		and 1 <> case when roleid in(1,2) and apositiontaking = 0.85 then 1 
					when roleid in (2,3,4) and mpositiontaking = 0.85 then 1 
					when roleid = 4 and spositiontaking = 0.85 then 1 else 0 end
	
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
 
CREATE TABLE #supers (custid int, isfinished bit default(0))
CREATE TABLE #DummyMasters(custid int)

INSERT INTO #DummyMasters(custid)
SELECT custid 
FROM Customer WITH(NOLOCK)
WHERE srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE currency <> 20)
AND roleid =3
AND (username LIKE '%ACC%' OR username LIKE '%AFF%')

INSERT INTO #supers(custid)
SELECT DISTINCT srecommend 
FROM Dep_CustSetting3rd cs with(NOLOCK)
	inner join custInfo ci with(nolock) on cs.custid = ci.custid
where srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE currency <> 20)	
	AND mrecommend NOT IN (SELECT custid from #DummyMasters)
	and sporttype between 180 and 186
	and 1 <> case when roleid in(1,2) and apositiontaking = 0.85 then 1 
				when roleid in (2,3,4) and mpositiontaking = 0.85 then 1 
				when roleid = 4 and spositiontaking = 0.85 then 1 else 0 end
	
DECLARE @max_custid INT, @srecommend INT
SET @max_custid = xxx 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.[Acc_CustSetting_03] @srecommend = @srecommend		
		,@maxcustid = @max_custid
		,@target = 'REPLICATED'
		
	WAITFOR DELAY '00:00:00.280'
END
GO

-- END STEP 2: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------

---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------

CREATE TABLE #supers (custid int, isfinished bit default(0))
CREATE TABLE #DummyMasters(custid int)

INSERT INTO #DummyMasters(custid)
SELECT custid 
FROM Customer WITH(NOLOCK)
WHERE srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE currency <> 20)
AND roleid =3
AND (username LIKE '%ACC%' OR username LIKE '%AFF%')

INSERT INTO #supers(custid)
SELECT DISTINCT srecommend 
FROM Dep_CustSetting3rd cs with(NOLOCK)
	inner join custInfo ci with(nolock) on cs.custid = ci.custid
where srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE currency <> 20)	
	AND mrecommend NOT IN (SELECT custid from #DummyMasters)
	and sporttype between 180 and 186
	and 1 <> case when roleid in(1,2) and apositiontaking = 0.85 then 1 
				when roleid in (2,3,4) and mpositiontaking = 0.85 then 1 
				when roleid = 4 and spositiontaking = 0.85 then 1 else 0 end
	
DECLARE @max_custid INT, @srecommend INT
SET @max_custid = xxx 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.[Acc_CustSetting_03] @srecommend = @srecommend		
		,@maxcustid = @max_custid
		,@target = 'DBTRANS'
		
	WAITFOR DELAY '00:00:00.280'
END
GO
