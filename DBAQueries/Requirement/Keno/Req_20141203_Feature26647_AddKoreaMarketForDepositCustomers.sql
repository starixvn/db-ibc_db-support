/*
	Created: Johnson
	Date: 2014-12-03
	Task: Copy country Korea(bettype : 1514) settings for Keno from Australia Market for deposit customers EXCEPT 12bet site		
	DB: DBTXN/CustDB
*/ 

 --Step 1: add customer settings into CustGameType
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
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','CustGameType') AND type = 'U' ) <> 2
	RETURN
	
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
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------	


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
 CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid= xx

INSERT INTO #supers(custid)
SELECT custid 
FROM Dep_CustSuper WITH(NOLOCK)
WHERE site <> '12bet'


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
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid= xx

INSERT INTO #supers(custid)
SELECT custid 
FROM Dep_CustSuper WITH(NOLOCK)
WHERE site <> '12bet'

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


-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------


