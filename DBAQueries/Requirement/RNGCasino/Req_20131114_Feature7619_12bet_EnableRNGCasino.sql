     /*
	Created: Johnson
	Date: 2013-11-14
	Task: Enable RNG casino for all currencies under 12bet licensee
	DB: DBTXN/bodb02
 */
ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids varchar(max)
AS
SET NOCOUNT ON

/*
	script 2: enable RNG casino for 12Bet customers
*/
	
BEGIN
	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('custinfo') AND type = 'U') <> 1
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
	
	 
	update custInfo with(rowlock,updlock)
	set SyncCasino=1,
		DisableCasino = 0
	where custid IN (SELECT custid FROM @res)

END   
GO

--234635 customers

DECLARE @maxCustID INT
SET @maxCustID = xxx

CREATE TABLE #temp (custid INT PRIMARY KEY, isfinished BIT DEFAULT(0))

INSERT INTO #temp(custid)
SELECT custid 
from custinfo with(nolock)
where srecommend in (
	179457	,--	ITSA
	--791080	,--	12BETSuperUS$
	791081	,--	12BETSuperEURO
	836203	,--	12BETSuperTB
	836212	,--	12BETSuperGBP
	836218	,--	12BETSuperRM
	836226	,--	12BETSuperRMB
	--916498	,--	12BETSuperUUS
	1015419	,--	12BETSuperAUD
	1015427	,--	12BETSuperCHF
	1752415	,--	12BETSuperSD$
	1813575	,--	12BETSuperIN
	3167631	,--	12BETSuperINH
	6006276	,--	12BETSuperWON
	6006409	,--	12BETSuperINR
	6006478	,--	12BETSuperJPY
	7526048	--	12BETSuperHK$
)

and (
        SyncCasino = 0
        or
        DisableCasino = 1
    )
and custid <= @maxCustID    


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