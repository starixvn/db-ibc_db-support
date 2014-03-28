/*
	Created: Johnson
	Date: 2014-03-28
	Task: Script to enable keno's games for SMA only
	DB: DBTXN/CustDB
*/ 

--Step 1: Enable Keno's games on CustGameType for SMA only & upline if upline not enabled yet
--run @DBTXN/CustDB
-----------------------------------------------------------------
CREATE TABLE #tmpCust(custid INT PRIMARY KEY, roleid INT, isfinished bit default(0))

DECLARE @custid INT, @roleid INT, @srecommend INT, @mrecommend INT, @recommend INT

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
	
	IF @roleid = 4
	BEGIN
		UPDATE CustGameType WITH(UPDLOCK,ROWLOCK)
		SET isDisabled = 0
		WHERE custid = @custid
			AND gametypeid NOT IN (2,6)
	END
	ELSE IF @roleid = 3
	BEGIN
		SELECT @srecommend = srecommend FROM custInfo WITH(NOLOCK) WHERE custid = @custid
		
		UPDATE CustGameType WITH(UPDLOCK,ROWLOCK)
		SET isDisabled = 0
		WHERE custid IN (@custid,@srecommend)
			AND gametypeid NOT IN (2,6)
	END
	ELSE IF @roleid = 2
	BEGIN
		SELECT @srecommend = srecommend, @mrecommend = mrecommend FROM custInfo WITH(NOLOCK) WHERE custid = @custid
		
		UPDATE CustGameType WITH(UPDLOCK,ROWLOCK)
		SET isDisabled = 0
		WHERE custid IN (@custid,@srecommend, @mrecommend)
			AND gametypeid NOT IN (2,6)
	END
	ELSE IF @roleid = 1
	BEGIN
		SELECT @srecommend = srecommend, @mrecommend = mrecommend, @recommend = recommend FROM custInfo WITH(NOLOCK) WHERE custid = @custid
		
		UPDATE CustGameType WITH(UPDLOCK,ROWLOCK)
		SET isDisabled = 0
		WHERE custid IN (@custid,@srecommend, @mrecommend, @recommend)
			AND gametypeid NOT IN (2,6)
	END	
END	

GO
--
-----End step 1
------------------------------------------------------------------
--
--Begin step 2:check HideKeno is on or off for downlines before turn off HideKeno
------------------------------------------------------------------
--get list SMA have downlines not turned HideKeno = 0

CREATE TABLE #tmpCust(custid INT PRIMARY KEY, roleid INT, isfinished bit default(0))
DECLARE @B TABLE(custid INT, roleid INT, isFinished bit default(0))

DECLARE @custid INT, @roleid INT, @srecommend INT, @mrecommend INT, @recommend INT

INSERT INTO @B(custid, roleid)
	SELECT custid, roleid
	FROM customer with(NOLOCK)
	WHERE username IN ('master1','agent1','super1')

	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) @B
	SET isfinished = 1
		,@custid = custid	
		,@roleid = roleid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	IF @roleid = 4
	BEGIN	
		IF EXISTS (SELECT TOP(1) 1 FROM custinfo WITH(NOLOCK) WHERE srecommend = @custid AND HideKeno = 1)
			INSERT INTO #tmpCust(custid,roleid)
			SELECT @custid, 4
	END
	ELSE IF @roleid = 3
	BEGIN	
		IF EXISTS (SELECT TOP(1) 1 FROM custinfo WITH(NOLOCK) WHERE mrecommend = @custid AND HideKeno = 1)
			INSERT INTO #tmpCust(custid,roleid)
			SELECT @custid, 3
	END
	ELSE IF @roleid = 2
	BEGIN	
		IF EXISTS (SELECT TOP(1) 1 FROM custinfo WITH(NOLOCK) WHERE recommend = @custid AND HideKeno = 1)
			INSERT INTO #tmpCust(custid,roleid)
			SELECT @custid, 2
	END
	ELSE IF @roleid = 1
	BEGIN	
		IF EXISTS (SELECT TOP(1) 1 FROM custinfo WITH(NOLOCK) WHERE custid = @custid AND HideKeno = 1)
			INSERT INTO #tmpCust(custid,roleid)
			SELECT @custid, 1
	END
END


SELECT * from #tmpCust
--if row count = 0 -> update done
--else this is list SMA need turn HideKeno for downlines off(=0)	
--move to step 3 deploy sp execrep & update list
--
--end step 2:check HideKeno is on or off for downlines before turn off HideKeno
-----------------------------------------------------------------

--
--Begin Step 3: Turn HideKeno is off for donwlines if not turned off yet.
--DEPLOY THIS SP @ DBTRANS.CustDB -------
-----------------------------------------------------
 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@custid INT	
	,@roleid INT
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo') AND type = 'U' ) <> 1
		RETURN
	
	DECLARE @srecommend INT, @mrecommend INT, @recommend INT
		
	IF @roleid = 4
	BEGIN		
		UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
		SET HideKeno = 0
		WHERE srecommend = @custid 
			AND custid <= @maxcustid
	END
	ELSE IF @roleid = 3
	BEGIN
		SELECT @srecommend = srecommend FROM CustInfo WITH(NOLOCK) WHERE custid = @custid
		
		UPDATE custInfo WITH(UPDLOCK,ROWLOCK)
		SET hideKeno = 0
		WHERE (mrecommend = @custid OR custid = @srecommend)
			AND custid <= @maxcustid
	END
	ELSE IF @roleid = 2
	BEGIN
		SELECT @srecommend = srecommend, @mrecommend = mrecommend FROM CustInfo WITH(NOLOCK) WHERE custid = @custid
		
		UPDATE custInfo WITH(UPDLOCK,ROWLOCK)
		SET hideKeno = 0
		WHERE (recommend = @custid OR custid IN (@srecommend, @mrecommend))
			AND custid <= @maxcustid
	END		
	ELSE IF @roleid = 1
	BEGIN
		SELECT @srecommend = srecommend, @mrecommend = mrecommend, @recommend = recommend FROM CustInfo WITH(NOLOCK) WHERE custid = @custid
		
		UPDATE custInfo WITH(UPDLOCK,ROWLOCK)
		SET hideKeno = 0
		WHERE custid IN (@custid, @srecommend, @mrecommend,@recommend)
	END	
END
GO

-- END STEP 3: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------

---
---
-- BEGIN STEP 4: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------

CREATE TABLE #tmpCust(custid INT PRIMARY KEY, roleid INT, isfinished bit default(0))
DECLARE @B TABLE(custid INT, roleid INT, isFinished bit default(0))

DECLARE @custid INT, @roleid INT, @srecommend INT, @mrecommend INT, @recommend INT

INSERT INTO @B(custid, roleid)
	SELECT custid, roleid
	FROM customer with(NOLOCK)
	WHERE username IN ('master1','agent1','super1')

	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) @B	
	SET isfinished = 1
		,@custid = custid	
		,@roleid = roleid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	IF @roleid = 4
	BEGIN	
		IF EXISTS (SELECT TOP(1) 1 FROM custinfo WITH(NOLOCK) WHERE srecommend = @custid AND HideKeno = 1)
			INSERT INTO #tmpCust(custid,roleid)
			SELECT @custid, 4
	END
	ELSE IF @roleid = 3
	BEGIN	
		IF EXISTS (SELECT TOP(1) 1 FROM custinfo WITH(NOLOCK) WHERE mrecommend = @custid AND HideKeno = 1)
			INSERT INTO #tmpCust(custid,roleid)
			SELECT @custid, 3
	END
	ELSE IF @roleid = 2
	BEGIN	
		IF EXISTS (SELECT TOP(1) 1 FROM custinfo WITH(NOLOCK) WHERE recommend = @custid AND HideKeno = 1)
			INSERT INTO #tmpCust(custid,roleid)
			SELECT @custid, 2
	END
	ELSE IF @roleid = 1
	BEGIN	
		IF EXISTS (SELECT TOP(1) 1 FROM custinfo WITH(NOLOCK) WHERE custid = @custid AND HideKeno = 1)
			INSERT INTO #tmpCust(custid,roleid)
			SELECT @custid, 1
	END
END

DECLARE @max_custid INT

SET @max_custid = xxx 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #tmpCust
	SET isfinished = 1
		,@custid = custid	
		,@roleid = roleid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @custid = @custid
			,@roleid = @roleid		
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
END
GO		

-- END STEP 4: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
---

---
-- BEGIN STEP 5: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------

CREATE TABLE #tmpCust(custid INT PRIMARY KEY, roleid INT, isfinished bit default(0))
DECLARE @B TABLE(custid INT, roleid INT, isFinished bit default(0))

DECLARE @custid INT, @roleid INT, @srecommend INT, @mrecommend INT, @recommend INT

INSERT INTO @B(custid, roleid)
	SELECT custid, roleid
	FROM customer with(NOLOCK)
	WHERE username IN ('master1','agent1','super1')

	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) @B
	SET isfinished = 1
		,@custid = custid	
		,@roleid = roleid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	IF @roleid = 4
	BEGIN	
		IF EXISTS (SELECT TOP(1) 1 FROM custinfo WITH(NOLOCK) WHERE srecommend = @custid AND HideKeno = 1)
			INSERT INTO #tmpCust(custid,roleid)
			SELECT @custid, 4
	END
	ELSE IF @roleid = 3
	BEGIN	
		IF EXISTS (SELECT TOP(1) 1 FROM custinfo WITH(NOLOCK) WHERE mrecommend = @custid AND HideKeno = 1)
			INSERT INTO #tmpCust(custid,roleid)
			SELECT @custid, 3
	END
	ELSE IF @roleid = 2
	BEGIN	
		IF EXISTS (SELECT TOP(1) 1 FROM custinfo WITH(NOLOCK) WHERE recommend = @custid AND HideKeno = 1)
			INSERT INTO #tmpCust(custid,roleid)
			SELECT @custid, 2
	END
	ELSE IF @roleid = 1
	BEGIN	
		IF EXISTS (SELECT TOP(1) 1 FROM custinfo WITH(NOLOCK) WHERE custid = @custid AND HideKeno = 1)
			INSERT INTO #tmpCust(custid,roleid)
			SELECT @custid, 1
	END
END

DECLARE @max_custid INT

SET @max_custid = xxx 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #tmpCust
	SET isfinished = 1
		,@custid = custid	
		,@roleid = roleid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @custid = @custid
			,@roleid = @roleid		
			,@maxcustid = @max_custid
			,@target = 'DBTRANS'
END
GO	

-- END STEP 5: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------