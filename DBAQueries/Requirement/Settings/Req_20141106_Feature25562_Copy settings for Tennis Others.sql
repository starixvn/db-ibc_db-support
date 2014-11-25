 /*
	Created: Johnson
	Date: 2014-11-06
	Task: Copy pt and bet settings for tennis others bettype from tennis handicap bettype
		copy comm settings from tennis other comm group
	DB: DBTXN/CustDB
 */
 
 -- BEGIN STEP 1: DEPLOY THIS SP @DBTRANS.CustDB ------
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
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
		WHERE NAME IN ('custinfo','CustSetting','CustOverride') AND type = 'U'
		) <> 3 RETURN	
	
	--copy pt and bet settings from tennis handicap
	UPDATE cs1
	set cs1.spositiontaking = cs2.spositiontaking,
		cs1.mpositiontaking = cs2.mpositiontaking,
		cs1.apositiontaking = cs2.apositiontaking,
		cs1.autopositiontaking = cs2.autopositiontaking,
		cs1.autompositiontaking = cs2.autompositiontaking,
		cs1.isautopositiontaking = cs2.isautopositiontaking,
		cs1.isautompositiontaking = cs2.isautompositiontaking,
		cs1.minbet = cs2.minbet,
		cs1.maxbet = cs2.maxbet 
	from CustSetting cs1 with(UPDLOCK,ROWLOCK)
		INNER JOIN custInfo ci with(nolock) on cs1.custid = ci.custid
		INNER JOIN CustSetting cs2 WITH(NOLOCK) ON cs2.custid = ci.custid
	where srecommend = @srecommend
		AND ci.custid <= @maxcustid		
		AND cs1.sporttype = 5 AND cs1.bettype = 9999
		AND cs2.sporttype = 5 AND cs2.bettype = 1

	--copy comm settings from tennis Other comm group		
	UPDATE cs1
	SET cs1.playerdiscount = cs2.playerdiscount,
		cs1.discount = cs2.discount,
		cs1.adiscount = cs2.adiscount,
		cs1.sdiscount = cs2.sdiscount, 
		cs1.groupa = cs2.groupa,  
		cs1.groupb = cs2.groupb,
		cs1.groupc = cs2.groupc,
		cs1.groupd = cs2.groupd, 
		cs1.groupe = cs2.groupe,
		cs1.groupf = cs2.groupf	
	from CustSetting cs1 with(UPDLOCK,ROWLOCK)
		INNER JOIN custInfo ci with(nolock) on cs1.custid = ci.custid
		INNER JOIN CustSetting cs2 WITH(NOLOCK) ON cs2.custid = ci.custid
	where srecommend = @srecommend
		AND ci.custid <= @maxcustid		
		AND cs1.sporttype = 5 AND cs1.bettype = 9999
		AND cs2.sporttype = 5 AND cs2.bettype = 20
		
			
		
	UPDATE cs1
	SET cs1.minpositiontaking = cs2.minpositiontaking,
		cs1.maxpositiontaking = cs2.maxpositiontaking		
	FROM CustOverride cs1 with(UPDLOCK,ROWLOCK)
		INNER JOIN custInfo ci WITH(NOLOCK) ON cs1.custid = ci.custid
		INNER JOIN CustOverride cs2 WITH(NOLOCK) ON cs2.custid = ci.custid
	WHERE srecommend = @srecommend
		AND ci.custid <= @maxcustid	
		AND ci.roleid IN (2,3,4)	
		AND cs1.sporttype = 5 AND cs1.bettype = 9999
		AND cs2.sporttype = 5 AND cs2.bettype = 1		
		
END	
GO

-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
------------------------------------------------------	


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
 
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = xx

INSERT INTO #supers(custid)
SELECT custid
FROM custInfo ci with(nolock) 
where custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))	
	AND roleid = 4
	AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------


---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------	
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = xx

INSERT INTO #supers(custid)
SELECT custid
FROM custInfo ci with(nolock) 
where custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))	
	AND roleid = 4
	AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBTRANS'
END			
GO		

-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------		