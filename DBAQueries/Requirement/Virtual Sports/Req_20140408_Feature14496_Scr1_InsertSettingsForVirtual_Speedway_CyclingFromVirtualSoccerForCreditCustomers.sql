  /*
	Created: Johnson
	Date: 2014-04-08
	Task: Insert settings for virtual speedway/cycling from virtual soccer for credit customers
	DB: DBTXN/CustDB
 */
 
 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo') AND type = 'U' ) <> 1
		RETURN
	
	UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
	SET maxpermatch183 = maxpermatch180, 
		maxpermatch185 = maxpermatch180
	WHERE srecommend = @srecommend
		AND custid <= @maxcustid
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('CustSetting3rd','CustOverride3rd') AND type = 'U' ) <> 2
		RETURN

	INSERT INTO [dbo].[CustSetting3rd]
			   ([custid]
			   ,[bettype]
			   ,[sporttype]
			   ,[apositiontaking]
			   ,[mpositiontaking]
			   ,[spositiontaking]
			   ,[playerdiscount]
			   ,[discount]
			   ,[adiscount]
			   ,[sdiscount]
			   ,[minbet]
			   ,[maxbet]
			   ,[autopositiontaking]
			   ,[isautopositiontaking]
			   ,[autompositiontaking]
			   ,[isautompositiontaking]
			   ,[alivepositiontaking]
			   ,[mlivepositiontaking]
			   ,[slivepositiontaking]
			   ,[autolivepositiontaking]
			   ,[isautolivepositiontaking]
			   ,[autolivempositiontaking]
			   ,[isautolivempositiontaking])
    SELECT [custid]
			   ,t.[bettype]
			   ,t.[sporttype]
			   ,[apositiontaking]
			   ,[mpositiontaking]
			   ,[spositiontaking]
			   ,[playerdiscount]
			   ,[discount]
			   ,[adiscount]
			   ,[sdiscount]
			   ,[minbet]
			   ,[maxbet]
			   ,[autopositiontaking]
			   ,[isautopositiontaking]
			   ,[autompositiontaking]
			   ,[isautompositiontaking]
			   ,[alivepositiontaking]
			   ,[mlivepositiontaking]
			   ,[slivepositiontaking]
			   ,[autolivepositiontaking]
			   ,[isautolivepositiontaking]
			   ,[autolivempositiontaking]
			   ,[isautolivempositiontaking]
	FROM CustSetting3rd	cs WITH(NOLOCK)
		INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		CROSS APPLY (
			SELECT 183 as sporttype, 1231 as bettype
			UNION SELECT 185, 1231
		) t
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND cs.sporttype = 180
		AND cs.bettype = 1231   


	INSERT INTO [dbo].[custOverride3rd]
			   ([custid]
			   ,[bettype]
			   ,[sporttype]
			   ,[minpositiontaking]
			   ,[maxpositiontaking]
			   ,[minlivepositiontaking]
			   ,[maxlivepositiontaking])
	SELECT 	[custid]
		   ,t.[bettype]
		   ,t.[sporttype]
		   ,[minpositiontaking]
		   ,[maxpositiontaking]
		   ,[minlivepositiontaking]
		   ,[maxlivepositiontaking]	
	FROM CustOverride3rd cs WITH(NOLOCK)
		INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		CROSS APPLY (
			SELECT 183 as sporttype, 1231 as bettype
			UNION SELECT 185, 1231
		) t
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND cs.sporttype = 180
		AND cs.bettype = 1231   		 	
    	
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
CREATE TABLE #Supers(Custid INT PRIMARY KEY, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xx

INSERT INTO #supers(custid)
SELECT custid
FROM custInfo WITH(NOLOCK)
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4
	AND custid <= @max_custid 

WHILE (1=1)
BEGIN
	UPDATE TOP(1) #Supers
	SET @srecommend = custid,
		isfinished = 1
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend				
		,@maxcustid = @max_custid
		,@target = 'REPLICATED'
		
	WAITFOR DELAY '00:00:00.280'
END
GO
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
------------------------------------------------------
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
CREATE TABLE #Supers(Custid INT PRIMARY KEY, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xx

INSERT INTO #supers(custid)
SELECT custid
FROM custInfo WITH(NOLOCK)
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4
	AND custid <= @max_custid 

WHILE (1=1)
BEGIN
	UPDATE TOP(1) #Supers
	SET @srecommend = custid,
		isfinished = 1
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend				
		,@maxcustid = @max_custid
		,@target = 'DBTRANS'
		
	WAITFOR DELAY '00:00:00.280'
END
GO
-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------

