 /*
	Created: Johnson
	Date: 2014-11-06
	Task: Copy settings for bettype Others of tennis from xx bettype
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
	
	UPDATE cs1
	set cs1.spositiontaking = cs2.spositiontaking,
		cs1.mpositiontaking = cs2.mpositiontaking,
		cs1.apositiontaking = cs2.apositiontaking
	from CustSetting cs1 with(UPDLOCK,ROWLOCK)
		INNER JOIN custInfo ci with(nolock) on cs1.custid = ci.custid
		INNER JOIN CustSetting cs2 WITH(NOLOCK) ON cs2.custid = ci.custid
	where srecommend = @srecommend
		AND ci.custid <= @maxcustid		
		AND cs1.sporttype = 5 AND cs1.bettype = 9999
		AND cs2.sporttype = 1 AND cs2.bettype = 1
		
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
		AND cs2.sporttype = 1 AND cs2.bettype = 1		
		
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