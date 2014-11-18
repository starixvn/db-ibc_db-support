 /*
	Created: Johnson
	Date: 2014-11-18
	Task: Update minbet for credit customers under TH and THB currencies
	DB: DBTXN/CustDB
 */
 
 -- BEGIN STEP 1: DEPLOY THIS SP @DBTRANS.CustDB ------
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@srecommend INT	
	,@maxcustid INT
	,@minbet	MONEY
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
		
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('custinfo','CustSetting') AND type = 'U'
		) <> 2 RETURN	
	
	UPDATE cs
	SET minbet = @Minbet
	from CustSetting cs with(UPDLOCK,ROWLOCK)
		INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid		
	WHERE srecommend = @srecommend
		AND ci.custid <= @maxcustid		
		AND (cs.sporttype <> 5 OR cs.bettype <> 9999)
				
END	
GO

-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
------------------------------------------------------	



---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
 
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT, @minbet money

SELECT @max_custid = xx,
		@minbet = 100

INSERT INTO #supers(custid)
SELECT custid
FROM custInfo ci with(nolock) 
where custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))	
	AND roleid = 4
	AND custid <= @max_custid
	AND currency IN (4,43)
	AND username NOT LIKE '3rdSuper%'
    AND username NOT LIKE 'STEST%'

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@minbet = @minbet
			,@target = 'REPLICATED'
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------


---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------	
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT, @minbet money

SELECT @max_custid = xx,
		@minbet = 100

INSERT INTO #supers(custid)
SELECT custid
FROM custInfo ci with(nolock) 
where custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))	
	AND roleid = 4
	AND custid <= @max_custid
	AND currency IN (4,43)
	AND username NOT LIKE '3rdSuper%'
    AND username NOT LIKE 'STEST%'

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@minbet = @minbet
			,@target = 'DBTRANS'
END			
GO

-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------		