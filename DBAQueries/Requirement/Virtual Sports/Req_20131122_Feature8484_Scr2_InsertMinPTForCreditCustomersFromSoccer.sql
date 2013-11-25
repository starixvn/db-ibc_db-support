  /*
	Created: Johnson
	Date: 20131125
	Task: Insert Min PT setting on virtual greyhound and virtual motor racing for credit customers
	DB: DBTXN/bodb02
*/ 



ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids varchar(max)
AS
SET NOCOUNT ON

/*
	credit customers 
	Insert min pt virtual greyhound, motor racing setting from virtual soccer 
*/
	
BEGIN
	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('CustOverride3rd','custInfo') AND type = 'U') <> 2
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

	--virtual greyhound, motor racing
	INSERT INTO [dbo].[CustOverride3rd]
			   ([custid] ,[bettype] ,[sporttype] ,[minpositiontaking] ,[maxpositiontaking] ,[minlivepositiontaking] ,[maxlivepositiontaking])
      SELECT  [custid]
			   ,t.[bettype]
			   ,t.[sporttype]
			   ,[minpositiontaking] 
			   ,[maxpositiontaking] 
			   ,[minlivepositiontaking] 
			   ,[maxlivepositiontaking]
	FROM CustOverride3rd cs3 WITH(NOLOCK) 
		CROSS JOIN (					
					SELECT 182 as sporttype, 1231 as bettype 
					UNION ALL
					SELECT 184 as sporttype, 1231 as bettype 
				) t 
	WHERE cs3.sporttype = 180 and cs3.bettype = 1201	
		AND custid IN (SELECT * FROM @res)
						
	
END
GO





DECLARE @maxCustID INT

SET @maxCustID = xxx

create table #temp (custid int primary key, isfinished bit)

--743988 rows affected
INSERT INTO #temp (custid, isfinished)
SELECT cs.custid , 0 
from CustOverride3rd cs with(nolock)
	inner join custInfo ci with(nolock) on cs.custid = ci.custid and cs.sporttype = 180 AND cs.bettype = 1201
where ci.srecommend not in (select custid from Dep_CustSuper with(nolock))
	AND ci.roleid IN (2,3,4)
	AND ci.custid <= @maxCustID

GO

declare @ids varchar(max), @rowcnt int

while (1=1)begin
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
