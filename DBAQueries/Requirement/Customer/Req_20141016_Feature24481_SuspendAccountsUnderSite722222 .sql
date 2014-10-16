 /*
	Created: Johnson
	Date: 2014-10-16
	Task: Suspend all accounts under site 722222
	DB: DBTXN/CustDB
 */
 
 
--STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]	
	@recommend INT,
	@maxcustid INT,	
	@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('custinfo') AND type = 'U'
		) <> 1 RETURN
		
	UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)	
	SET reject = 1
	WHERE recommend = @recommend 
		AND custid <= @maxcustid
		AND NOT (reject = 1	OR closed = 1 OR enabled = 0)
END
GO


-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------	

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------
 CREATE TABLE #Agents (custid INT, isfinished BIT DEFAULT(0))
 DECLARE @recommend INT, @max_custid INT
 
SELECT @max_custid = xxx
 
 INSERT INTO #Agents(custid)
 SELECT custid
 FROM customer WITH(NOLOCK)
 WHERE site = '722222' AND roleid = 2
 
 
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Agents
	SET isfinished = 1
		,@recommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @recommend = @recommend
			,@maxcustid = @max_custid		
			,@target = 'REPLICATED'
END			
GO	
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
 CREATE TABLE #Agents (custid INT, isfinished BIT DEFAULT(0))
 DECLARE @recommend INT, @max_custid INT
 
SELECT @max_custid = xxx
 
 INSERT INTO #Agents(custid)
 SELECT custid
 FROM customer WITH(NOLOCK)
 WHERE site = '722222' AND roleid = 2
 
 
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Agents
	SET isfinished = 1
		,@recommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @recommend = @recommend
			,@maxcustid = @max_custid		
			,@target = 'DBTRANS'
END			
GO		