/*
	Created: Logan
	Date: 2014-08-04
	Task: Insert Keno default settings for credit customers (only customers without Keno setting or missing setting)
	DB: DBTXN/CustDB
*/ 

DECLARE @max_custid INT
SELECT @max_custid = xx

--STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
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
	     WHERE NAME IN ('Custinfo', 'CustSettingGame', 'CustOverrideGame')
	       AND type = 'U'
       ) <> 3
		RETURN


	INSERT INTO [dbo].[CustSettingGame]
	(
	    [custid]
	  , [bettype]
	  , [sporttype]
	  , [apositiontaking]
	  , [mpositiontaking]
	  , [spositiontaking]
	  , [playerdiscount]
	  , [discount]
	  , [adiscount]
	  , [sdiscount]
	  , [autopositiontaking]
	  , [isautopositiontaking]
	  , [autompositiontaking]
	  , [isautompositiontaking]
    )
    SELECT ci.custid
		 , ps.Bettype
		 , 202
		 , 0 --apos
		 , 0 --mpos
		 , 0 --spos
	     , 0 --pdis
		 , 0 --dis
		 , 0 --adis
		 , 0 --sdis
		 , 0 --autopos
         , 0 --isautopos
		 , 0 --autompos
		 , 0 --isautompos
	FROM custInfo ci WITH(NOLOCK)
CROSS JOIN ProductGlobalSetting ps WITH(NOLOCK)
   WHERE ci.srecommend = @srecommend
     AND NOT EXISTS (SELECT 1
                       FROM CustSettingGame cg
                      WHERE cg.CustID = ci.custid
                        AND cg.Sporttype = 202
                        AND cg.Bettype = ps.Bettype)

    
    INSERT INTO [dbo].[CustOverrideGame]
	(
	    [custid]
	  , [bettype]
	  , [sporttype]
	  , [minpositiontaking]
    )
    SELECT ci.custid
		 , ps.Bettype
		 , 202
		 , 0 --minpos
	FROM custInfo ci WITH(NOLOCK)
CROSS JOIN ProductGlobalSetting ps WITH(NOLOCK)
   WHERE ci.srecommend = @srecommend
     AND NOT EXISTS (SELECT 1
                       FROM CustOverrideGame cg
                      WHERE cg.CustID = ci.custid
                        AND cg.Sporttype = 202
                        AND cg.Bettype = ps.Bettype
                    )

END
GO

-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------	

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
CREATE TABLE #CustomersKenoSetting(Custid INT , isfinished bit default(0))	
DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid= xx

INSERT INTO #CustomersKenoSetting(custid)
SELECT DISTINCT ci.srecommend
  FROM custinfo ci WITH(NOLOCK)
 WHERE ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
   AND 9 > (SELECT COUNT(*)
               FROM CustSettingGame csg WITH(NOLOCK)
         INNER JOIN CustOverrideGame cog WITH(NOLOCK) ON csg.CustID = cog.CustID
                                                     AND csg.Sporttype = cog.Sporttype
                                                     AND csg.Bettype = cog.Bettype
              WHERE csg.custid = ci.custid
                AND csg.Sporttype = 202
           ) --missing Keno setting in CustSettingGame or CustOverrideGame
   AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #CustomersKenoSetting
	   SET isfinished = 1
		 , @srecommend = custid			
	 WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting_03]
	    @srecommend = @srecommend
	  , @maxcustid = @max_custid
	  , @target = 'REPLICATED'
END

DROP TABLE #CustomersKenoSetting

GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
CREATE TABLE #CustomersKenoSetting(Custid INT , isfinished bit default(0))	
DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xx

INSERT INTO #CustomersKenoSetting(custid)
SELECT DISTINCT ci.srecommend
  FROM custinfo ci WITH(NOLOCK)
 WHERE ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
   AND 9 > (SELECT COUNT(*)
               FROM CustSettingGame csg WITH(NOLOCK)
         INNER JOIN CustOverrideGame cog WITH(NOLOCK) ON csg.CustID = cog.CustID
                                                     AND csg.Sporttype = cog.Sporttype
                                                     AND csg.Bettype = cog.Bettype
              WHERE csg.custid = ci.custid
                AND csg.Sporttype = 202
           ) --missing Keno setting in CustSettingGame or CustOverrideGame
   AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #CustomersKenoSetting
	   SET isfinished = 1
		 , @srecommend = custid			
	 WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting_03]
	    @srecommend = @srecommend
	  , @maxcustid = @max_custid
	  , @target = 'DBTRANS'
END

DROP TABLE #CustomersKenoSetting

GO	

-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------	