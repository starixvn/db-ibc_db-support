 /*
	Created: Johnson
	Date: 2014-03-28
	Task: Script to turn HideKeno off for SMA & all downlines
	DB: DBTXN/CustDB
*/ 

-- STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
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
		WHERE custid IN (@custid, @srecommend, @mrecommend, @recommend)			
	END	
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
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

	EXEC dbo.[Acc_ExecRep_Cust_09] @custid = @custid
			,@roleid = @roleid		
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
END			
GO		
-- END STEP 2: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------

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

	EXEC dbo.[Acc_ExecRep_Cust_09] @custid = @custid
			,@roleid = @roleid		
			,@maxcustid = @max_custid
			,@target = 'DBTRANS'
END			
GO	


-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------	