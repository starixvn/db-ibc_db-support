/*
	Created: Logan
	Date: 2014-09-12
	Task: Update DisableEsports = 0 for real accounts
	DB: DBTXN/CustDB
*/ 

--STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
-----------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting_03]
	@srecommend INT
  , @max_custid INT
  , @target     VARCHAR(20)
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF (SELECT COUNT(1)
	      FROM sys.objects
	     WHERE NAME IN ('custInfo')
	       AND type = 'U'
       ) <> 1
		RETURN

    --custInfo
	UPDATE custInfo WITH(ROWLOCK, UPDLOCK)
	   SET DisableEsports = 0
	 WHERE srecommend = @srecommend
	   AND custid <= @max_custid
	   AND DisableEsports IS NULL
END
GO

-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------	

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP -----
--------------------------------------------------------------------------------------
CREATE TABLE #CustSuper(srecommend INT , isfinished BIT DEFAULT(0))	

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xx

INSERT INTO #CustSuper(srecommend)
SELECT ci.custid
  FROM custinfo ci WITH(NOLOCK)
 WHERE ci.custid <= @max_custid
   AND roleid = 4


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #CustSuper
	   SET isfinished = 1
		 , @srecommend = srecommend
	 WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting_03]
	    @srecommend = @srecommend
	  , @max_custid = @max_custid
	  , @target = 'REPLICATED'
END

DROP TABLE #CustSuper

GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
CREATE TABLE #CustSuper(srecommend INT , isfinished BIT DEFAULT(0))	

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xx

INSERT INTO #CustSuper(srecommend)
SELECT ci.custid
  FROM custinfo ci WITH(NOLOCK)
 WHERE ci.custid <= @max_custid
   AND roleid = 4


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #CustSuper
	   SET isfinished = 1
		 , @srecommend = srecommend			
	 WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting_03]
	    @srecommend = @srecommend
	  , @max_custid = @max_custid
	  , @target = 'DBTRANS'
END

DROP TABLE #CustSuper

GO	

-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -------
-------------------------------------------------