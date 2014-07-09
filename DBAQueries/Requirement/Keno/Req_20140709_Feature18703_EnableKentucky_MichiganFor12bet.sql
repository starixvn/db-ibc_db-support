 /*
	Created: Johnson
	Date: 2014-07-09
	Task: Enable Keno markets: Kentucky & Michigan for 12bet.
	DB: DBTXN/CustDB
 */
 
 
--STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting_03]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN	
	SET NOCOUNT ON
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','CustGameType') AND type = 'U' ) <> 2
		RETURN
	
	UPDATE cg
	SET isDisabled = 0
	FROM CustGameType cg WITH(UPDLOCK,ROWLOCK)
		INNER JOIN CustInfo ci WITH(NOLOCK) ON cg.custid = ci.custid
	WHERE cg.gametypeid IN (11,13)
		AND ci.srecommend = @srecommend 
		AND ci.custid <= @maxcustid		
	
END
GO


-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------	

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
CREATE TABLE #Supers(Custid INT , isfinished bit default(0))	
DECLARE @max_custid INT, @srecommend INT


SELECT @max_custid= xx

INSERT INTO #supers(custid)
SELECT custid
FROM Dep_CustSuper WITH(NOLOCK)
WHERE site = '12bet'

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
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
CREATE TABLE #Supers(Custid INT , isfinished bit default(0))	
DECLARE @max_custid INT, @srecommend INT


SELECT @max_custid= xx

INSERT INTO #supers(custid)
SELECT custid
FROM Dep_CustSuper WITH(NOLOCK)
WHERE site = '12bet'

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
END	
-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------	