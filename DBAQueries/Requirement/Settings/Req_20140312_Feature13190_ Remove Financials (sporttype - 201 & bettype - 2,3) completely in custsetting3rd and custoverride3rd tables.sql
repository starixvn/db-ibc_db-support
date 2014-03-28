---#Step1: Build SP
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]	
	@ids varchar(max)
AS
SET NOCOUNT ON
/*
	Created: Sophia
	Date: 20140312
	Task: Remove Financials (sporttype - 201 & bettype - 2,3) completely in custsetting3rd and custoverride3rd tables
	DB: DBTXN/CUSTDB
*/ 

BEGIN
	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('CustSetting3rd','CustOverride3rd') AND type = 'U') <> 2
		RETURN

	DECLARE @res AS TABLE (CustId INT)
	DECLARE @splitter CHAR(1), @string VARCHAR(MAX)

	SELECT @splitter = ',', @string = @ids

	IF SUBSTRING (@string, LEN (@string), 1) <> @splitter
		  SET @string= @string+@splitter

	DECLARE @START INT, @word NVARCHAR(4000), @CHARINDEX INT, @i INT
	SET @i=1
	SET @START=1
	SET @CHARINDEX= CHARINDEX( @splitter, @string, @START)
	WHILE (@CHARINDEX <> 0)BEGIN
		SET @word= SUBSTRING( @string, @START, @CHARINDEX - @START)
		SET @START= @CHARINDEX +1
		SET @CHARINDEX= CHARINDEX( @splitter, @string, @START)
		INSERT INTO @res  VALUES(CAST(@word AS INT))
		SET @i=@i+1
	END	
	 

	DELETE [dbo].CustSetting3rd WITH(UPDLOCK,ROWLOCK)			 
	WHERE  sporttype = 201 and bettype IN (2,3)
		   AND CustId IN (SELECT CustId FROM @res)

	DELETE [dbo].CustOverride3rd WITH(UPDLOCK,ROWLOCK) 			 
	WHERE  sporttype = 201 and bettype IN (2,3)		
		   AND CustId IN (SELECT CustId FROM @res)		
	
END
GO



---- #Step2: Execute

DECLARE @maxCustId INT
SELECT @maxCustId = MAX(CustId) FROM CustInfo WITH (NOLOCK) 

CREATE TABLE #temp (CustId INT PRIMARY KEY, IsFinished BIT)

 
INSERT INTO #temp (CustId, IsFinished)

SELECT DISTINCT cs.CustId , 0 
FROM   CustSetting3rd cs WITH (NOLOCK)	
WHERE  cs.sporttype = 201 and bettype IN (2,3)
	   AND CustId <= @maxCustId


SELECT DISTINCT cs.CustId , 0 
FROM   CustOverride3rd cs WITH (NOLOCK)	
LEFT JOIN #temp T 
		ON cs.CustId = T.CustID
WHERE  cs.sporttype = 201 and bettype IN (2,3)
	   AND cs.CustId <= @maxCustId
	   AND T.CustId IS NULL

GO

DECLARE @ids VARCHAR(max), @rowcnt INT

WHILE (1 = 1)
BEGIN
	SELECT @ids = ''

	UPDATE TOP(10000) #temp
	SET		@ids = @ids +CASE @ids
							WHEN '' THEN ''
							ELSE ','
						 END + cast(CustId AS VARCHAR(12))
			,IsFinished = 1
	FROM	#temp
	WHERE	IsFinished = 0

	SELECT @rowcnt = @@rowcount

	EXEC [Acc_ExecRep_Cust_09] @ids = @ids

	IF @rowcnt < 10000 RETURN

	WAITFOR DELAY '00:00:01'
END



DROP TABLE #temp
GO