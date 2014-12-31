/*
	Created: Johnson
	Date: 2014-12-31
	Task: Virtual Rate - Separate setting into sport types and bet types
	DB: DBTXN/CustDB
	
	Steps:
		Customers having VirtualMultiplier = 1
			Update VirtualMultiplier = 0
		Customers having VirtualMultiplier > 0
        ​​	Step 1: Copy current VirtualMultiplier value to all bet types of each sport type
			Step 2: Update VirtualMultiplier = 1

*/ 

 -- BEGIN STEP 1: DEPLOY THIS SP @DBTRANS.CustDB ------
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@target		VARCHAR(20)='',
	@srecommend INT,
	@maxcustid	INT	
AS
BEGIN	 
	SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
		
		
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('CustInfo','CustVirtualRate') AND type = 'U'
		) = 2
	BEGIN	
		INSERT INTO [dbo].[CustVirtualRate]
			   ([custid]
			   ,[sporttype]
			   ,[bettype]
			   ,[isLive]
			   ,[virtualMultiplier])		
		SELECT custid,
			t.sporttype,
			t.bettype,
			b.isLive,
			ci.virtualMultiplier
		FROM CustInfo ci WITH(NOLOCK)
			CROSS APPLY 
			(
			SELECT 1 as sporttype, 1 as bettype
			UNION 
			SELECT 1 as sporttype, 2 as bettype
			UNION 
			SELECT 1 as sporttype, 3 as bettype
			UNION 
			SELECT 1 as sporttype, 7 as bettype
			UNION 
			SELECT 1 as sporttype, 8 as bettype
			UNION 
			SELECT 1 as sporttype, 12 as bettype
			UNION 
			SELECT 99 as sporttype, 1 as bettype
			UNION 
			SELECT 99 as sporttype, 2 as bettype
			UNION 
			SELECT 99 as sporttype, 3 as bettype
			UNION 
			SELECT 99 as sporttype, 7 as bettype
			UNION 
			SELECT 99 as sporttype, 8 as bettype
			UNION 
			SELECT 99 as sporttype, 12 as bettype 
			) t
			CROSS APPLY (
			SELECT 0 as isLive
			UNION 
			SELECT 1 as isLive
			)b
		WHERE ci.custid <= @maxcustid
			AND ci.srecommend = @srecommend
	END
	
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('CustInfo') AND type = 'U'
		) <> 1 RETURN
	
	UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
	SET VirtualMultiplier = CASE WHEN VirtualMultiplier = 1 THEN 0 ELSE 1 END
	WHERE srecommend = @srecommend
		AND custid <= @maxcustid
	
END
GO

-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
------------------------------------------------------	


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
 

CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = xx
INSERT INTO #supers(custid)
SELECT custid
FROM custInfo ci with(nolock) 
where roleid = 4
	AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
--------------------------------------------------------------------------------------
 

CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = xx

INSERT INTO #supers(custid)
SELECT custid
FROM custInfo ci with(nolock) 
where roleid = 4
	AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBTRANS'
END			
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-----------------------------------------------------------------------------------
