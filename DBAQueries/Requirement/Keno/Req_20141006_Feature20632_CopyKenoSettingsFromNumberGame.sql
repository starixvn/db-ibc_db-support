/*
	Created: Logan
	Date: 2014-10-06
	Task: Copy Keno settings for credit customers from Number Game
	DB: DBTXN/CustDB
*/ 

DECLARE @max_custid INT
SELECT @max_custid = xx

--STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
-----------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
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
	     WHERE NAME IN ('Custinfo', 'CustSettingGame', 'CustOverrideGame', 'CustGameType', 'CustSetting3rd', 'custOverride3rd')
	       AND type = 'U'
       ) <> 6
		RETURN

    --CustSettingGame
	UPDATE csk WITH(ROWLOCK, UPDLOCK)
       SET csk.apositiontaking = csn.apositiontaking
	     , csk.mpositiontaking = csn.mpositiontaking
	     , csk.spositiontaking = csn.spositiontaking
	     , csk.autopositiontaking    = csn.autopositiontaking
	     , csk.isautopositiontaking  = csn.isautopositiontaking
	     , csk.autompositiontaking   = csn.autompositiontaking
	     , csk.isautompositiontaking = csn.isautompositiontaking
      FROM CustSettingGame csk
INNER JOIN CustSetting3rd csn WITH(NOLOCK) ON csk.CustID = csn.CustID
INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid = csk.CustID
     WHERE csk.Sporttype = 202
       AND csn.Sporttype = 161
       AND csn.bettype   = 81
       AND ci.srecommend = @srecommend

    --CustOverrideGame
    UPDATE cok WITH(ROWLOCK, UPDLOCK)
       SET cok.minpositiontaking = con.minpositiontaking
      FROM custoverrideGame cok
INNER JOIN custOverride3rd con WITH(NOLOCK) ON cok.custid = con.custid
INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid = con.CustID
     WHERE ci.srecommend = @srecommend
       AND ci.roleid <> 1
       AND cok.Sporttype = 202
       AND con.Sporttype = 161
       AND con.bettype   = 81

    --CustGameType
    UPDATE csg WITH(ROWLOCK, UPDLOCK)
       SET csg.MinBet = csn.minbet
         , csg.MaxBet = csn.maxbet
         , csg.MaxPerGameType = ci.maxpermatch161
      FROM CustGameType csg
INNER JOIN CustSetting3rd csn WITH(NOLOCK) ON csg.CustID = csn.CustID
INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid = csg.CustID
     WHERE csn.Sporttype = 161
       AND csn.bettype   = 81
       AND ci.srecommend = @srecommend
END
GO

-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------	

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP -----
--------------------------------------------------------------------------------------
CREATE TABLE #CustomersKenoSetting(srecommend INT , isfinished bit default(0))	
DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid= xx

INSERT INTO #CustomersKenoSetting(srecommend)
SELECT ci.custid
FROM custinfo ci WITH(NOLOCK)
WHERE ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))	
	AND ci.custid <= @max_custid
	AND roleid = 4

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #CustomersKenoSetting
	   SET isfinished = 1
		 , @srecommend = srecommend
	 WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19]
	    @srecommend = @srecommend
	  , @max_custid = @max_custid
	  , @target = 'REPLICATED'
END

DROP TABLE #CustomersKenoSetting

GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
CREATE TABLE #CustomersKenoSetting(srecommend INT , isfinished bit default(0))	
DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xx

INSERT INTO #CustomersKenoSetting(srecommend)
SELECT ci.custid
  FROM custinfo ci WITH(NOLOCK)
 WHERE ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))  
   AND ci.custid <= @max_custid
   AND roleid = 4

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #CustomersKenoSetting
	   SET isfinished = 1
		 , @srecommend = srecommend			
	 WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19]
	    @srecommend = @srecommend
	  , @max_custid = @max_custid
	  , @target = 'DBTRANS'
END

DROP TABLE #CustomersKenoSetting

GO	

-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------	
