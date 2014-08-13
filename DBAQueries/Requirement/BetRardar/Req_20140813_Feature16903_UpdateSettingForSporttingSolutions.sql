/*
	Created: Johnson
	Date: 2014-08-13
	Task: reset settings for sportting solutions others bettype
	DB: DBTXN/CustDB
*/ 

ALTER PROCEDURE [dbo].[Acc_CustSetting_03]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','CustSetting','custOverride') AND type = 'U' ) <> 3
		RETURN
				

	UPDATE cs
	SET [apositiontaking]			= 0
	   ,[mpositiontaking]			= 0
	   ,[spositiontaking]			= 0
	   ,[alivepositiontaking]		= 0
	   ,[mlivepositiontaking]		= 0
	   ,[slivepositiontaking]		= 0
	   ,[playerdiscount]			= 0
	   ,[discount]					= 0
	   ,[adiscount]					= 0
	   ,[sdiscount]					= 0
	   ,[groupa]					= 0
	   ,[groupb]					= 0
	   ,[groupc]					= 0
	   ,[groupd]					= 0
	   ,[groupe]					= 0
	   ,[groupf]					= 0
	   ,[minbet]					= 0
	   ,[maxbet]					= 0
	   ,[autopositiontaking]		= 0	
	   ,[autolivepositiontaking]	= 0
	   ,[isautopositiontaking]		= 0
	   ,[isautolivepositiontaking]	= 0
	   ,[autompositiontaking]		= 0
	   ,[autolivempositiontaking]	= 0
	   ,[isautompositiontaking]		= 0
	   ,[isautolivempositiontaking] = 0
	FROM custSetting cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid		
	WHERE ci.srecommend = @srecommend 
		AND ci.custid <= @maxcustid
		AND sporttype = 5 
		AND bettype = 9999
	
	UPDATE co
	SET [minpositiontaking]		= 0
	   ,[maxpositiontaking]		= 0
	   ,[minlivepositiontaking]	= 0
	   ,[maxlivepositiontaking]	= 0
	FROM [custOverride] co WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custInfo ci WITH(NOLOCK) ON co.custid = ci.custid
	WHERE ci.srecommend = @srecommend 
		AND ci.custid <= @maxcustid	
		AND sporttype = 5
		AND bettype = 9999
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