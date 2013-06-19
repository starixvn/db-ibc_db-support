 ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	

	@ids varchar(max)

AS

SET NOCOUNT ON

/*

	script 2: Update Min Bet for whole super line

*/

BEGIN

	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('Custsetting','custinfo') AND type = 'U') <> 2

		RETURN

	DECLARE @res AS TABLE (custid INT)

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

	--UPDATE MIN BET
	
		UPDATE csd WITH (ROWLOCK,UPDLOCK)
		SET csd.minbet=cs.minbet
		FROM Custsetting csd
		INNER JOIN custinfo c WITH (NOLOCK) ON c.custid=csd.custid		
		INNER JOIN Custsetting cs WITH(NOLOCK) ON c.srecommend = cs.custid AND cs.sporttype=csd.sporttype AND cs.bettype=csd.bettype		
		WHERE c.custid in (SELECT * from @res) 
			AND csd.minbet <> cs.minbet
			AND c.roleid in (1,2,3)

END

------------------------------------------------------------------------------------------------------


CREATE TABLE #SuperIds (custid int)
INSERT INTO #SuperIds
			SELECT 576313 -- SUPERTEST2
UNION ALL SELECT 1176070 -- SUPERTEST1
	

CREATE TABLE #temp (custid INT PRIMARY KEY, isfinished BIT)

INSERT INTO #temp (custid, isfinished)

SELECT DISTINCT c.custid, 0
FROM custinfo c WITH(NOLOCK)
INNER JOIN Custsetting cs WITH(NOLOCK) ON c.srecommend = cs.custid			
INNER JOIN Custsetting csd ON c.custid = csd.custid AND cs.sporttype=csd.sporttype and cs.bettype=csd.bettype
WHERE	c.srecommend in (SELECT custid from #SuperIds) 
		AND csd.minbet <> cs.minbet
		AND c.roleid in (1,2,3)


------------------------------------------------------------------------------------------------------

DECLARE @ids VARCHAR(max), @rowcnt INT

WHILE (1=1)
BEGIN

	SELECT @ids = ''	

	UPDATE TOP (5000) #temp

	SET @ids = @ids + CASE @ids WHEN '' THEN '' ELSE ',' END + cast(custid as varchar(12))

		,isfinished = 1

	FROM #temp

	WHERE isfinished = 0	

	SELECT @rowcnt = @@rowcount	

	EXEC [Acc_ExecRep_09] @ids = @ids	

	IF @rowcnt < 5000 RETURN
	WAITFOR DELAY '00:00:01'
END

--DROP TABLE #SuperIds
--DROP TABLE #temp