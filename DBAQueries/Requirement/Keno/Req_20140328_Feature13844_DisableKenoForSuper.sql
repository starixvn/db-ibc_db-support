/*
	Created: Johnson
	Date: 2014-03-28
	Task: Script to disable keno for SMA
	DB: DBTXN/CustDB
*/ 

 -- STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting_03]
	@custid INT
	,@roleid INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
		
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','CustGameType') AND type = 'U' ) <> 2
		RETURN
	
	IF @roleid = 4
	BEGIN
		--disable keno's games for super & all downlines
		UPDATE cg
		SET cg.IsDisabled = 1
		FROM CustGameType cg WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON cg.custid = ci.custid
		WHERE ci.srecommend = @custid
			AND ci.custid <= @maxcustid
			AND cg.gametypeid NOT IN (2,6)
	END
	ELSE IF @roleid = 3
	BEGIN
		--disable keno's games for master & all downlines
		UPDATE cg
		SET cg.IsDisabled = 1
		FROM CustGameType cg WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON cg.custid = ci.custid
		WHERE ci.mrecommend = @custid
			AND ci.custid <= @maxcustid
			AND cg.gametypeid NOT IN (2,6)					
	END
	ELSE IF @roleid = 2
	BEGIN	
		--disable keno's games for agent & all downlines
		UPDATE cg
		SET cg.IsDisabled = 1
		FROM CustGameType cg WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON cg.custid = ci.custid
		WHERE ci.recommend = @custid 
			AND ci.custid <= @maxcustid
			AND cg.gametypeid NOT IN (2,6)
	END	
	ELSE IF @roleid = 1
	BEGIN
		--disable keno's games for agent & all downlines
		UPDATE cg
		SET cg.IsDisabled = 1
		FROM CustGameType cg WITH(UPDLOCK,ROWLOCK)			
		WHERE custid = @custid 			
			AND gametypeid NOT IN (2,6)
	END
END
GO

-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
--enable for any SMA 
CREATE TABLE #tmpCust(custid INT PRIMARY KEY, roleid INT, isfinished bit default(0))

DECLARE @max_custid INT, @custid INT, @roleid INT

SET @max_custid = xxx 

INSERT INTO #tmpCust(custid, roleid)
	SELECT custid, roleid
	FROM customer with(NOLOCK)
	WHERE username IN ('master1','agent1','super1')


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #tmpCust
	SET isfinished = 1
		,@custid = custid	
		,@roleid = roleid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
				
	EXEC dbo.[Acc_CustSetting_03] @custid = @custid
			,@roleid = @roleid		
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
CREATE TABLE #tmpCust(custid INT PRIMARY KEY, roleid INT, isfinished bit default(0))

DECLARE @max_custid INT, @custid INT, @roleid INT

SET @max_custid = xxx 

INSERT INTO #tmpCust(custid, roleid)
	SELECT custid, roleid
	FROM customer with(NOLOCK)
	WHERE username IN ('master1','agent1','super1')


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #tmpCust
	SET isfinished = 1
		,@custid = custid	
		,@roleid = roleid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
				
	EXEC dbo.[Acc_CustSetting_03] @custid = @custid
			,@roleid = @roleid		
			,@maxcustid = @max_custid
			,@target = 'DBTRANS'
		
	WAITFOR DELAY '00:00:00.280'
END
GO	

-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------		