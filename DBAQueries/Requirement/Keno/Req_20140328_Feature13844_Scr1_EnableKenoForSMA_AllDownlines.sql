/*
	Created: Johnson
	Date: 2014-03-28
	Task: Script to enable keno's games for SMA & all downlines
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
	
	DECLARE @srecommend INT, @mrecommend INT, @recommend INT
		
	IF @roleid = 4
	BEGIN
		--enable keno's games super & all downlines
		UPDATE cg
		SET cg.IsDisabled = 0
		FROM CustGameType cg WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON cg.custid = ci.custid
		WHERE ci.srecommend = @custid
			AND ci.custid <= @maxcustid
			AND cg.gametypeid NOT IN (2,6)
	END
	ELSE IF @roleid = 3
	BEGIN
		SELECT @srecommend = srecommend FROM CustInfo WITH(NOLOCK) WHERE custid = @custid
		
		--update upline & all downlines of master
		UPDATE cg
		SET cg.IsDisabled = 0
		FROM CustGameType cg WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON cg.custid = ci.custid
		WHERE ( ci.mrecommend = @custid OR ci.custid = @srecommend)
			AND ci.custid <= @maxcustid
			AND cg.gametypeid NOT IN (2,6)					
	END
	ELSE IF @roleid = 2
	BEGIN
		SELECT @srecommend = srecommend, @mrecommend = mrecommend FROM CustInfo WITH(NOLOCK) WHERE custid = @custid
		
		--update uplines & all downlines of agent
		UPDATE cg
		SET cg.IsDisabled = 0
		FROM CustGameType cg WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON cg.custid = ci.custid
		WHERE ( ci.recommend = @custid OR ci.custid IN (@srecommend,@mrecommend))
			AND ci.custid <= @maxcustid
			AND cg.gametypeid NOT IN (2,6)
	END	
END	
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
DECLARE @custid INT, @max_custid INT, @roleid INT

SELECT @custid = xxx--custid of SMA want to disable
SELECT @roleid = xx--roleid of SMA

SELECT @max_custid = xx--max custid in system

EXEC dbo.[Acc_CustSetting_03] @custid = @custid
		,@roleid = @roleid		
		,@maxcustid = @max_custid
		,@target = 'REPLICATED'
		
-- END STEP 2: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
DECLARE @custid INT, @max_custid INT, @roleid INT

SELECT @custid = xxx--custid of SMA want to disable
SELECT @roleid = xx--roleid of SMA

SELECT @max_custid = xx--max custid in system

EXEC dbo.[Acc_CustSetting_03] @custid = @custid
		,@roleid = @roleid		
		,@maxcustid = @max_custid
		,@target = 'DBTRANS'

-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------		