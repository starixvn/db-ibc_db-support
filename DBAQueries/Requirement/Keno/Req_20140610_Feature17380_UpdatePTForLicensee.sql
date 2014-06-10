/*
	Created: Elodie
	Date: 2014-06-10
	Task: Update pt settings for licensees on Keno
	DB: DBTXN/CustDB
*/ 

-- BEGIN STEP 1: DEPLOY THIS SP @DBTRANS.CustDB ------
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
		WHERE NAME IN ('custinfo','CustSettingGame') AND type = 'U'
		) <> 2 RETURN	
	
	
	UPDATE cs
	set spositiontaking = CASE WHEN roleid = 4 THEN 0.9 ELSE 0 END,
		mpositiontaking = CASE WHEN roleid IN (4,3) then 0.9 else 0 END,
		apositiontaking = CASE WHEN roleid IN (4,2,1) then 0.9 else 0 END		
	from CustSettingGame cs with(UPDLOCK,ROWLOCK)
		inner join custInfo ci with(nolock) on cs.custid = ci.custid
	where srecommend = @srecommend
		AND ci.custid <= @maxcustid		
		AND sporttype = 202 AND bettype = 1501
		AND 1 <> case	when roleid in(4,2,1) AND apositiontaking = 0.9 then 1 
						when roleid in (4,3) AND mpositiontaking = 0.9 then 1 
						when roleid = 4 AND spositiontaking = 0.9 then 1 else 0 end
	
END
GO
-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
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
FROM CustSettingGame cs with(NOLOCK)
	inner join custInfo ci with(nolock) on cs.custid = ci.custid
where srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE currency <> 20)	
	AND mrecommend NOT IN (SELECT custid from #DummyMasters)
	and sporttype = 202 AND bettype = 1501
	and 1 <> case	when roleid in(4,2,1) and apositiontaking = 0.9 then 1 
					when roleid in (4,3) and mpositiontaking = 0.9 then 1 
					when roleid = 4 and spositiontaking = 0.9 then 1 else 0 end
	
DECLARE @max_custid INT, @srecommend INT
SET @max_custid = xxx 

--2500163 row affected
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

-- END STEP 2: -------
------------------------------------------------------

---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT @DBTRANS.CUSTDB -----
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
FROM CustSettingGame cs with(NOLOCK)
	inner join custInfo ci with(nolock) on cs.custid = ci.custid
where srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE currency <> 20)	
	AND mrecommend NOT IN (SELECT custid from #DummyMasters)
	and sporttype = 202 AND bettype = 1501
	and 1 <> case	when roleid in(4,2,1) and apositiontaking = 0.9 then 1 
					when roleid in (4,3) and mpositiontaking = 0.9 then 1 
					when roleid = 4 and spositiontaking = 0.9 then 1 else 0 end
	
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


/*
	Created: Elodie
	Date: 2014-06-10
	Task: Update pt for ticket'Keno of licensees
	DB: DBTXN/bodb02
*/ 

-- BEGIN STEP 1: DEPLOY THIS SP @DBTRANS.bodb02 ------
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_09]
	@srecommend INT	
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
		
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('translog') AND type = 'U'
		) <> 1 RETURN	
	
	
	UPDATE b
	set tpositiontaking = 0.9, apositiontaking = 0.9
	from translog b with(UPDLOCK,ROWLOCK)
	where srecommend = @srecommend
		AND winlostdate = '2014-06-11' OR winlostdate = '2014-06-12'
		AND statusid = 0
END
GO
-- END STEP 1: DEPLOY THIS SP @DBTRANS.bodb02 --------
------------------------------------------------------

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
 
CREATE TABLE #supers (custid int, isfinished bit default(0))

INSERT INTO #supers(custid)
SELECT DISTINCT srecommend 
FROM translog with(NOLOCK)
where srecommend IN (SELECT custid FROM dbo.Dep_CustSuper WITH(NOLOCK) WHERE currency <> 20)	
	AND winlostdate = '2014-06-11' OR winlostdate = '2014-06-12'
	AND statusid = 0
	
DECLARE @srecommend INT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.[Acc_ExecRep_09] @srecommend = @srecommend		
		,@target = 'REPLICATED'
		
	WAITFOR DELAY '00:00:00.280'
END
GO

-- END STEP 2: -------
------------------------------------------------------

---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT @DBTRANS.bodb02 -----
-------------------------------------------------

CREATE TABLE #supers (custid int, isfinished bit default(0))

INSERT INTO #supers(custid)
SELECT DISTINCT srecommend 
FROM translog with(NOLOCK)
where srecommend IN (SELECT custid FROM CustDB.dbo.Dep_CustSuper WITH(NOLOCK) WHERE currency <> 20)	
	AND winlostdate = '2014-06-11' OR winlostdate = '2014-06-12'
	AND statusid = 0
	
DECLARE @srecommend INT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.[Acc_ExecRep_09] @srecommend = @srecommend		
		,@target = 'DBTRANS'
		
	WAITFOR DELAY '00:00:00.280'
END
GO
