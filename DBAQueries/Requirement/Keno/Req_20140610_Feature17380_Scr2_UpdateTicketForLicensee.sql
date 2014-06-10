/*
	Created: Elodie
	Date: 2014-06-10
	Task: Update pt for ticket'Keno of licensees
	DB: DBTXN/bodb02
*/ 

-- BEGIN STEP 1: DEPLOY THIS SP @DBTRANS.bodb02 ------
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_09]
	@srecommend INT	
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
		
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('translog') AND type = 'U'
		) <> 1 RETURN	
	
	
	UPDATE b
	set tpositiontaking = 0.9, apositiontaking = 0.9
	from translog b with(UPDLOCK,ROWLOCK)
	where srecommend = @srecommend
		AND winlostdate = '2014-06-11' OR winlostdate = '2014-06-12'
		AND statusid = 0
END
GO
-- END STEP 1: DEPLOY THIS SP @DBTRANS.bodb02 --------
------------------------------------------------------

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
 
CREATE TABLE #supers (custid int, isfinished bit default(0))

INSERT INTO #supers(custid)
SELECT DISTINCT srecommend 
FROM translog with(NOLOCK)
where srecommend IN (SELECT custid FROM dbo.Dep_CustSuper WITH(NOLOCK) WHERE currency <> 20)	
	AND winlostdate = '2014-06-11' OR winlostdate = '2014-06-12'
	AND statusid = 0
	
DECLARE @srecommend INT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.[Acc_ExecRep_09] @srecommend = @srecommend		
		,@target = 'REPLICATED'
		
	WAITFOR DELAY '00:00:00.280'
END
GO

-- END STEP 2: -------
------------------------------------------------------

---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT @DBTRANS.bodb02 -----
-------------------------------------------------

CREATE TABLE #supers (custid int, isfinished bit default(0))

INSERT INTO #supers(custid)
SELECT DISTINCT srecommend 
FROM translog with(NOLOCK)
where srecommend IN (SELECT custid FROM CustDB.dbo.Dep_CustSuper WITH(NOLOCK) WHERE currency <> 20)	
	AND winlostdate = '2014-06-11' OR winlostdate = '2014-06-12'
	AND statusid = 0
	
DECLARE @srecommend INT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.[Acc_ExecRep_09] @srecommend = @srecommend		
		,@target = 'DBTRANS'
		
	WAITFOR DELAY '00:00:00.280'
END
GO
 