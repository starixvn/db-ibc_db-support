/*
	Created: Johnson
	Date: 2014-03-28
	Task: Script to enable keno's games for SMA only
	DB: DBTXN/CustDB
*/ 

--Step 1: Enable Keno's games on CustGameType for SMA only & upline if upline not enabled yet
--run @DBTXN/CustDB
-----------------------------------------------------------------
DECLARE @custid INT, @roleid INT, @srecommend INT, @mrecommend INT

SELECT @custid = xxx--custid of SMA to enable Keno's games
SELECT @roleid = xx--roleid of SMA

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
ELSE IF @roleid = 3
BEGIN
	SELECT @srecommend = srecommend, @mrecommend = mrecommend FROM custInfo WITH(NOLOCK) WHERE custid = @custid
	
	UPDATE CustGameType WITH(UPDLOCK,ROWLOCK)
	SET isDisabled = 0
	WHERE custid IN (@custid,@srecommend, @mrecommend)
		AND gametypeid NOT IN (2,6)
END
GO
--
-----End step 1
------------------------------------------------------------------
--
--Begin step 2:check HideKeno is on or off for downlines before turn off HideKeno
------------------------------------------------------------------


DECLARE @custid INT, @roleid INT

SELECT @custid = xxx--custid of SMA to enable Keno's games
SELECT @roleid = xx--roleid of SMA

IF @roleid = 4
BEGIN
	IF EXISTS (SELECT TOP(1) 1 FROM custInfo WITH(NOLOCK) WHERE srecommend = @custid AND HideKeno = 1)
		PRINT 'HideKeno''s status of downlines is on. Please move to step 3.'
	ELSE 
		PRINT 'Enable Keno''s games for super only done.'	
END
ELSE IF @roleid = 3
BEGIN
	IF EXISTS (SELECT TOP(1) 1 FROM custInfo WITH(NOLOCK) WHERE mrecommend = @custid AND HideKeno = 1)
		PRINT 'HideKeno''s status of downlines is on. Please move to step 3.'
	ELSE 
		PRINT 'Enable Keno''s games for master only done.'	
END
ELSE IF @roleid = 2
BEGIN
	IF EXISTS (SELECT TOP(1) 1 FROM custInfo WITH(NOLOCK) WHERE mrecommend = @custid AND HideKeno = 1)
		PRINT 'HideKeno''s status of downlines is on. Please move to step 3.'
	ELSE 
		PRINT 'Enable Keno''s games for agent only done.'	
END
GO

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
END
GO

-- END STEP 3: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------

---
---
-- BEGIN STEP 4: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------

DECLARE @custid INT, @max_custid INT, @roleid INT

SELECT @custid = xxx--custid of SMA want to disable
SELECT @roleid = xx--roleid of SMA

SELECT @max_custid = xx--max custid in system

EXEC dbo.[Acc_ExecRep_Cust_09] @custid = @custid
		,@roleid = @roleid		
		,@maxcustid = @max_custid
		,@target = 'REPLICATED'

-- END STEP 4: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
---

---
-- BEGIN STEP 5: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------

DECLARE @custid INT, @max_custid INT, @roleid INT

SELECT @custid = xxx--custid of SMA want to disable
SELECT @roleid = xx--roleid of SMA

SELECT @max_custid = xx--max custid in system

EXEC dbo.[Acc_ExecRep_Cust_09] @custid = @custid
		,@roleid = @roleid		
		,@maxcustid = @max_custid
		,@target = 'DBTRANS'


-- END STEP 5: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------