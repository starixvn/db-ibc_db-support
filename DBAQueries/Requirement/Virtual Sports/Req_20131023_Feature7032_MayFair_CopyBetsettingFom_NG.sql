/*
	20131023@Johnson
	MayFair licensee customers 
	Virtual soccer: copy bet setting from NG 
*/

	DECLARE @maxCustID INT

	SET @maxCustID = xxx

	--1189 rows affected
	UPDATE vs WITH(ROWLOCK,UPDLOCK)
	SET  minbet = ng.minbet
		,maxbet = ng.maxbet
		,vs.apositiontaking = ng.apositiontaking			
		,vs.mpositiontaking = ng.mpositiontaking
		,vs.spositiontaking = ng.spositiontaking
	FROM Dep_Custsetting3rd vs
		INNER JOIN custinfo c WITH(NOLOCK) ON c.custid = vs.custid 		
		INNER JOIN Dep_Custsetting3rd ng WITH(NOLOCK) ON vs.custid = ng.custid
			AND vs.sporttype = 180 AND vs.bettype = 1201 AND ng.sporttype = 161 AND ng.bettype = 81
	WHERE vs.custid <= @maxCustID
		AND
		(		
			vs.minbet <> ng.minbet
			OR
			vs.maxbet <> ng.maxbet
			OR
			vs.apositiontaking <> ng.apositiontaking
			OR 
			vs.mpositiontaking <> ng.mpositiontaking
			OR 
			vs.spositiontaking <> ng.spositiontaking
		)
		AND srecommend IN (SELECT custid 
							from Dep_CustSuper with(nolock) 
							where site = 'Mayfair' and currency IN  (2, 4, 15, 13, 3, 32)
						)
GO






--update maxpermatch, disableVirtualSports, HideVirtualSports


ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids varchar(max)
AS
SET NOCOUNT ON

/*
	MayFair licensee customers 
	Virtual soccer: enable virtual soccer
*/
	
BEGIN
	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('CustInfo') AND type = 'U') <> 1
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
	SET maxpermatch180 = maxpermatch161
		,DisableVirtualSports = 0 
		,HideVirtualSports = 0
	WHERE custid IN (SELECT * FROM @res)		
END

GO

	
DECLARE @maxCustID INT

SET @maxCustID = xxx

create table #temp (custid int primary key, isfinished bit)

-- 29232 rows affected
INSERT INTO #temp (custid, isfinished)
SELECT custid, 0
FROM custinfo WITH(NOLOCK)
WHERE srecommend IN (SELECT custid 
							from Dep_CustSuper with(nolock) 
							where site = 'Mayfair' and currency IN  (2, 4, 15, 13, 3, 32)
						)
AND (maxpermatch180 <> maxpermatch161 OR maxpermatch180 IS NULL
			OR DisableVirtualSports = 1 OR HideVirtualSports = 1
		)
AND custid <= @maxCustID 	
				
GO

declare @ids varchar(max), @rowcnt int

while (1=1)
begin
	select @ids = ''
	
	update TOP (10000) #temp
	set @ids = @ids + case @ids when '' then '' else ',' end + cast(custid as varchar(12))
		,isfinished = 1
	from #temp
	where isfinished = 0

	select @rowcnt = @@rowcount	

	EXEC [Acc_ExecRep_09] @ids = @ids

	if @rowcnt < 10000 RETURN

	WAITFOR DELAY '00:00:01'
end