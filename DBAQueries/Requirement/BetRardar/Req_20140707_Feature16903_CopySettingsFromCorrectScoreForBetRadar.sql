/*
	Created: Johnson
	Date: 2014-07-07
	Task: Copy settings from soccer correct score's settings to betradar for credit customers
	DB: DBTXN/CustDB
*/ 

--Step 0: delete existing betradar's settings
DECLARE @max_custid INT
SELECT @max_custid= xx
 
DELETE CustSetting WITH(UPDLOCK,ROWLOCK)
WHERE sporttype = 1 AND bettype = 9999
	AND custid<= @max_custid
GO

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
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','CustSetting') AND type = 'U' ) <> 2
		RETURN
				

	INSERT INTO [dbo].[custSetting]
			   ([custid]
			   ,[bettype]
			   ,[sporttype]
			   ,[apositiontaking]
			   ,[mpositiontaking]
			   ,[spositiontaking]
			   ,[alivepositiontaking]
			   ,[mlivepositiontaking]
			   ,[slivepositiontaking]
			   ,[playerdiscount]
			   ,[discount]
			   ,[adiscount]
			   ,[sdiscount]
			   ,[groupa]
			   ,[groupb]
			   ,[groupc]
			   ,[groupd]
			   ,[groupe]
			   ,[groupf]
			   ,[minbet]
			   ,[maxbet]
			   ,[autopositiontaking]
			   ,[autolivepositiontaking]
			   ,[isautopositiontaking]
			   ,[isautolivepositiontaking]
			   ,[autompositiontaking]
			   ,[autolivempositiontaking]
			   ,[isautompositiontaking]
			   ,[isautolivempositiontaking])
	SELECT cs.[custid]
		   ,9999 as [bettype]
		   ,1 as [sporttype]
		   ,[apositiontaking]
		   ,[mpositiontaking]
		   ,[spositiontaking]
		   ,[alivepositiontaking]
		   ,[mlivepositiontaking]
		   ,[slivepositiontaking]
		   ,[playerdiscount]
		   ,[discount]
		   ,[adiscount]
		   ,[sdiscount]
		   ,[groupa]
		   ,[groupb]
		   ,[groupc]
		   ,[groupd]
		   ,[groupe]
		   ,[groupf]
		   ,[minbet]
		   ,[maxbet]
		   ,[autopositiontaking]
		   ,[autolivepositiontaking]
		   ,[isautopositiontaking]
		   ,[isautolivepositiontaking]
		   ,[autompositiontaking]
		   ,[autolivempositiontaking]
		   ,[isautompositiontaking]
		   ,[isautolivempositiontaking]
	FROM custSetting cs WITH(NOLOCK)
		INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.srecommend = @srecommend 
		AND ci.custid <= @maxcustid
		AND cs.sporttype = 1 
		AND cs.bettype = 4--correct score
		
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

	EXEC dbo.[Acc_CustSetting_03] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBTRANS'
END			
GO	

-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------	