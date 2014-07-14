/*
	Created: Johnson
	Date: 2014-07-14
	Task: update virtual rate for some licensees
	DB: DBTXN/CustDB
*/ 



--STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]	
	@srecommend INT,
	@maxcustid INT,
	@virtualrate smallmoney,
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
	SET VirtualMultiplier = @virtualrate
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

DECLARE @tmpSuper TABLE (custid INT, isfinished bit default (0))

DECLARE @max_custid INT, @srecommend INT, @virtualrate smallmoney

SELECT @max_custid= xx, @virtualrate = 0.4--(-60)

INSERT INTO @tmpSuper(custid)
SELECT 3287311--MS88SuperINH
UNION 
SELECT 1574008--MS88SuperRMB
UNION 
SELECT 4359240--HAIFASuperRMB


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) @tmpSuper
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@virtualrate = @virtualrate
			,@target = 'REPLICATED'
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------

DECLARE @tmpSuper TABLE (custid INT, isfinished bit default (0))

DECLARE @max_custid INT, @srecommend INT, @virtualrate smallmoney

SELECT @max_custid= xx, @virtualrate = 0.4--(-60)

INSERT INTO @tmpSuper(custid)
SELECT 3287311--MS88SuperINH
UNION 
SELECT 1574008--MS88SuperRMB
UNION 
SELECT 4359240--HAIFASuperRMB


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) @tmpSuper
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@virtualrate = @virtualrate
			,@target = 'DBTRANS'
END			
GO			