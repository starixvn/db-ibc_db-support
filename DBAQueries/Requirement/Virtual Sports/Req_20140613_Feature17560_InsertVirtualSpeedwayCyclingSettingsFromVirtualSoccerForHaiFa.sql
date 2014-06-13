  /*
	Created: Johnson
	Date: 2014-06-13
	Task: Insert virtual speedway and cycling settings from virtual soccer for Haifa
	DB: DBTXN/CustDB
 */
 
 --STEP 0: delete existing virtual speedway and cycling settings
 DECLARE @max_custid INT
 SELECT @max_custid= xx
 
 --33686 rows affected
 DELETE cs
 FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend IN (SELECT custid 
						FROM Dep_CustSuper WITH(NOLOCK)
						WHERE site IN('Haifa')
						)
	AND sporttype IN (183,185)
	AND ci.custid <= @max_custid
GO
							
 -- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
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
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Dep_CustSetting3rd') AND type = 'U' ) <> 1
		RETURN
		
	INSERT INTO [dbo].[Dep_CustSetting3rd]
           ([custid]
           ,[bettype]
           ,[sporttype]
           ,[islive]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[minbet]
           ,[maxbet])
	SELECT cs.[custid]
           ,t.[bettype]
           ,t.[sporttype]
           ,[islive]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[minbet]
           ,[maxbet]	   
	FROM Dep_CustSetting3rd cs WITH(NOLOCK)
		INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		CROSS APPLY (
			SELECT 183 as sporttype, 1231 as bettype
			UNION SELECT 185, 1231
		)t
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND cs.sporttype = 180
		AND cs.bettype = 1201	        
	
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

INSERT INTO #Supers(custid)
SELECT custid 
FROM Dep_CustSuper WITH(NOLOCK)
WHERE site = 'haifa'

WHILE (1=1)
BEGIN
	UPDATE TOP (1) #Supers
	SET @srecommend = custid,
		isfinished = 1
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC [Acc_ExecRep_Cust_09] @srecommend = @srecommend
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

INSERT INTO #Supers(custid)
SELECT custid 
FROM Dep_CustSuper WITH(NOLOCK)
WHERE site = 'haifa'

WHILE (1=1)
BEGIN
	UPDATE TOP (1) #Supers
	SET @srecommend = custid,
		isfinished = 1
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC [Acc_ExecRep_Cust_09] @srecommend = @srecommend
		,@maxcustid = @max_custid
		,@target = 'DBTRANS'
						
	WAITFOR DELAY '00:00:00.280'
END
-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------