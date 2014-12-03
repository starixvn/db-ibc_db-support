/*
	Created: Johnson
	Date: 2014-12-03
	Task: Copy country Korea(bettype : 1514) settings for Keno from Australia Market for credit customers
	DB: DBTXN/CustDB
*/ 

--step 1: Add setting into ProductGlobalSetting
USE [CustDB]
GO

INSERT INTO [dbo].[ProductGlobalSetting]
           ([Sporttype]
           ,[Bettype]
           ,[MaxPositiontaking]
           ,[Maxsdiscount]
           ,[IsDep])
VALUES(202,1514,0.85,0,0)    
GO
----------------------------------------------

--step 2: Add settings into ProductBetSetting

INSERT INTO [dbo].[ProductBetSetting]
           ([Sporttype]
           ,[Bettype]
           ,[Currency]
           ,[MinBet]
           ,[IsDep])
SELECT[Sporttype]
       ,1514 as [Bettype]
       ,[Currency]
       ,[MinBet]
       ,[IsDep]
FROM [ProductBetSetting] WITH(NOLOCK)
WHERE sporttype = 202
	AND bettype = 1501
GO
-------------------------------------------

--Step 3: add customer settings into CustGameType, CustSettingGame
-- DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN	
	SET NOCOUNT ON
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','CustGameType','CustSettingGame','CustOverrideGame') AND type = 'U' ) <> 4
		RETURN
	
	INSERT INTO [dbo].[CustSettingGame]
			   ([CustID]
			   ,[Bettype]
			   ,[Sporttype]
			   ,[apositiontaking]
			   ,[mpositiontaking]
			   ,[spositiontaking]
			   ,[playerdiscount]
			   ,[discount]
			   ,[adiscount]
			   ,[sdiscount]
			   ,[autopositiontaking]
			   ,[isautopositiontaking]
			   ,[autompositiontaking]
			   ,[isautompositiontaking])
	SELECT cs.[CustID]
		   ,1514 as [Bettype]
		   ,[Sporttype]
		   ,[apositiontaking]
		   ,[mpositiontaking]
		   ,[spositiontaking]
		   ,[playerdiscount]
		   ,[discount]
		   ,[adiscount]
		   ,[sdiscount]
		   ,[autopositiontaking]
		   ,[isautopositiontaking]
		   ,[autompositiontaking]
		   ,[isautompositiontaking]
	FROM [CustSettingGame] cs WITH(NOLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK)	ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND sporttype = 202
		AND bettype = 1501		   
 
	INSERT INTO [dbo].[CustOverrideGame]
			   ([CustID]
			   ,[Bettype]
			   ,[Sporttype]
			   ,[minpositiontaking])
	SELECT co.[CustID]
		   ,1514 as [Bettype]
		   ,[Sporttype]
		   ,[minpositiontaking]
	FROM [CustOverrideGame] co WITH(NOLOCK)	
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = co.custid	 
	WHERE ci.srecommend = @srecommend 
		AND ci.custid <= @maxcustid
		AND sporttype = 202
		AND bettype = 1501
		
	INSERT INTO [dbo].[CustGameType]
			   ([CustID]
			   ,[GameTypeID]
			   ,[StakeLevelList]
			   ,[MaxPerGameType]
			   ,[MinBet]
			   ,[MaxBet]
			   ,[IsDisabled])
    SELECT cg.[CustID]
		   ,14 as [GameTypeID]
		   ,[StakeLevelList]
		   ,[MaxPerGameType]
		   ,[MinBet]
		   ,[MaxBet]
		   ,[IsDisabled]
    FROM [CustGameType] cg WITH(NOLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cg.custid = ci.custid
    WHERE ci.srecommend = @srecommend
		 AND ci.custid <= @maxcustid
		 AND gameTypeID = 1
		
END
GO

-- END STEP 3: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------	


---
---
-- BEGIN STEP 4: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
 
CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid= xx

INSERT INTO #supers(custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4
	AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
	
	WAITFOR DELAY '00:00:00.280'			
END			
GO		
-- END STEP 4: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 5: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid= xx

INSERT INTO #supers(custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4
	AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBTRANS'
	
	WAITFOR DELAY '00:00:00.280'			
END			
GO		


-- END STEP 5: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------