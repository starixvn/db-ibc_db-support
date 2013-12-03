/*
	Created: Lukas	
	Task: Insert PT setting, min max bet on HR FixOdds for credit customers
	DB: DBTXN/bodb02
*/ 


ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids varchar(max)
AS
BEGIN
	SET NOCOUNT ON

	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('Custsetting','custInfo') AND type = 'U') <> 2
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
	INSERT INTO [dbo].[CustSetting]( 
			   [custid]
			  ,[bettype]
			  ,[sporttype]
			  ,[apositiontaking]
			  ,[mpositiontaking]
			  ,[spositiontaking]
			  ,[alivepositiontaking]
			  ,[mlivepositiontaking]
			  ,[slivepositiontaking]
			  ,[playerdiscount]
			  ,[discount]
			  ,[adiscount]
			  ,[sdiscount]
			  ,[groupa]
			  ,[groupb]
			  ,[groupc]
			  ,[groupd]
			  ,[groupe]
			  ,[groupf]
			  ,[minbet]
			  ,[maxbet]
			  ,[autopositiontaking]
			  ,[autolivepositiontaking]
			  ,[isautopositiontaking]
			  ,[isautolivepositiontaking]
			  ,[autompositiontaking]
			  ,[autolivempositiontaking]
			  ,[isautompositiontaking]
			  ,[isautolivempositiontaking])
      SELECT  [custid]
			  ,[bettype]
			  ,154 [sporttype]
			  ,[apositiontaking]
			  ,[mpositiontaking]
			  ,[spositiontaking]
			  ,[alivepositiontaking]
			  ,[mlivepositiontaking]
			  ,[slivepositiontaking]
			  ,[playerdiscount]
			  ,[discount]
			  ,[adiscount]
			  ,[sdiscount]
			  ,[groupa]
			  ,[groupb]
			  ,[groupc]
			  ,[groupd]
			  ,[groupe]
			  ,[groupf]
			  ,[minbet]
			  ,[maxbet]
			  ,[autopositiontaking]
			  ,[autolivepositiontaking]
			  ,[isautopositiontaking]
			  ,[isautolivepositiontaking]
			  ,[autompositiontaking]
			  ,[autolivempositiontaking]
			  ,[isautompositiontaking]
			  ,[isautolivempositiontaking]
	FROM [dbo].[custSetting] WITH(NOLOCK)
	WHERE sporttype = 99 
		AND bettype = 20
		AND custid IN (SELECT * FROM @res)
		
				
	UPDATE custInfo WITH(UPDLOCK,ROWLOCK)
	SET	maxpermatch154 = maxpermatch99,
		DisableHRFixedOdds = 0
	WHERE custid IN (SELECT * FROM @res)					
	
END
GO



DECLARE @maxCustID INT

SET @maxCustID = xxx

create table #temp (custid int primary key, isfinished bit)

--3701342 rows affected
INSERT INTO #temp (custid, isfinished)
SELECT cs.custid , 0 
FROM CustSetting cs WITH(NOLOCK)
	INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid and cs.sporttype = 99 AND cs.bettype = 20
WHERE ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.roleid <= 4
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
