
ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids VARCHAR(MAX)
AS
/*	
	 update maxpermatch (custinfo)
*/
BEGIN	
	SET NOCOUNT ON 
	
	IF (SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('custinfo') AND TYPE = 'u') <> 1
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
    				
	UPDATE custinfo WITH(ROWLOCK,UPDLOCK)
	SET maxpermatch181 = maxpermatch180  --- virtual racing
		,maxpermatch186 = maxpermatch180 -- virtual tennis		
	WHERE custid IN (SELECT * FROM @res)
	
END
 
GO

DECLARE @maxcustid INT
SET @maxcustid = xxx

	
CREATE TABLE #temp (custid INT PRIMARY KEY, isfinished BIT)

INSERT INTO #temp (custid, isfinished)
SELECT custid, 0
FROM dbo.custinfo c WITH (NOLOCK)
WHERE custid <= @maxcustid
	AND srecommend NOT IN (SELECT custid FROM dbo.f_DepSuper_1('all'))
	AND (maxpermatch180 <> maxpermatch181 OR maxpermatch180 <> maxpermatch186)
GO

DECLARE @ids VARCHAR(MAX), @rowcnt INT

WHILE (1=1)
BEGIN
	SELECT @ids = ''
    
    UPDATE TOP (10000) #temp
    SET @ids = @ids + CASE @ids WHEN '' THEN '' ELSE ',' END + CAST(custid AS VARCHAR(12))
        ,isfinished = 1
    FROM #temp
    WHERE isfinished = 0
 
	SELECT @rowcnt = @@ROWCOUNT    

    EXEC [Acc_ExecRep_09] @ids = @ids
    
    IF @rowcnt < 10000 RETURN

    WAITFOR DELAY '00:00:01'   
END

GO

 