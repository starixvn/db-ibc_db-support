  /*
	Created: Johnson
	Date: 2014-02-06
	Task: Update Settings for all licensees
	DB: DBTXN/CustDB
 */
 --STEP 0: remove settings of all UUS licensees
 --17525 rows
 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
AS
BEGIN
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('Dep_CustSetting', 'custinfo','Dep_CustSuper') AND type = 'U'
		) <> 3 RETURN	
		
	 DELETE Dep_CustSetting WITH(UPDLOCK,ROWLOCK)
	 WHERE custid IN (SELECT custid FROM custinfo WITH(NOLOCK) 
						WHERE srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE currency = 20)
					)
		AND sporttype = 154
		AND bettype = 20
END 
GO



  -- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
		
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('Dep_CustSetting', 'custinfo') AND type = 'U'
		) <> 2 RETURN	

	INSERT INTO [dbo].[Dep_CustSetting]
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
	SELECT [custid]
		   ,20 as [bettype]
		   ,154 as [sporttype]
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
	FROM Dep_CustSetting with(NOLOCK)
	WHERE custid IN (SELECT custid 
					FROM custinfo with(NOLOCK)
					WHERE srecommend = @srecommend 
						AND custid <= @maxcustid
				)	
		AND sporttype = 99
		AND bettype = 20
		
	UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
	SET maxpermatch154 = maxpermatch99,
		DisableHRFixedOdds = 1
	WHERE srecommend = @srecommend 
		AND custid <= @maxcustid		 
   
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
 

CREATE TABLE #Supers (custid INT PRIMARY KEY, isfinished bit default(0))

INSERT INTO #Supers(custid)
SELECT custid 
FROM Dep_CustSuper with(NOLOCK)

DECLARE @max_custid INT, @srecommend INT
SET @max_custid = xxx 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend		
		,@maxcustid = @max_custid
		,@target = 'REPLICATED'
		
	WAITFOR DELAY '00:00:00.280'
END
GO

-- END STEP 2: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------


CREATE TABLE #Supers (custid INT PRIMARY KEY, isfinished bit default(0))

INSERT INTO #Supers(custid)
SELECT custid 
FROM Dep_CustSuper with(NOLOCK)

DECLARE @max_custid INT, @srecommend INT
SET @max_custid = xxx 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend		
		,@maxcustid = @max_custid
		,@target = 'DBTRANS'
		
	WAITFOR DELAY '00:00:00.280'
END
GO