 /*
	Created: Johnson
	Date: 20131119
	Task: Insert virtual horse racing , virtual tennis setting for SunGame Licensee	
		Copy minbet, maxbet setting from virtual soccer		
		PT = 85%
	DB: DBTXN/bodb02
 */
 
 --step 1: clear old setting of virtual horse racing, virtual tennis for SUGSuperUUS
 --3544528,	--	SUGSuperUUS
 
 --274 rows affected
 DELETE cs
 FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid AND cs.sporttype IN (181,182,184,186)
WHERE ci.srecommend in (select custid from Dep_CustSuper with(nolock) where site = 'SunGame')
GO	

 
 --step 2: correct pt on virtual soccer
 --7596152	,--	SUGSuperEURO pt = 80%
 UPDATE Dep_CustSetting3rd WITH(UPDLOCK,ROWLOCK)
 SET spositiontaking = 0.85,
	mpositiontaking = 0.85,
	apositiontaking = 0.85
WHERE custid = 7596152 AND sporttype = 180 AND bettype = 1201
GO


--step 3: Copy setting from virtual soccer for virtual horse racing
GO

ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids varchar(max)
AS
SET NOCOUNT ON

/*
	licensee customers 
	Insert virtual racing, tennis, greyhound, motor racing setting from virtual soccer 
*/
	
BEGIN
	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('Dep_Custsetting3rd','custInfo') AND type = 'U') <> 2
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

	--virtual racing
	INSERT INTO [dbo].[Dep_CustSetting3rd]
			   ([custid],[bettype],[sporttype],[islive],[apositiontaking],[mpositiontaking]
			   ,[spositiontaking],[playerdiscount],[discount],[adiscount],[sdiscount],[minbet],[maxbet])
      SELECT  [custid]
		   ,t.[bettype]
		   ,t. [sporttype]
		   ,[islive]
		   ,[apositiontaking]
		   ,[mpositiontaking]
		   ,[spositiontaking]
		   ,[playerdiscount]
		   ,[discount]
		   ,[adiscount]
		   ,[sdiscount]
		   ,[minbet]
		   ,[maxbet]
	FROM Dep_CustSetting3rd cs3 WITH(NOLOCK) 
		CROSS JOIN (
					SELECT 181 as sporttype, 1231 as bettype 
					UNION ALL
					SELECT 182 as sporttype, 1231 as bettype 
					UNION ALL
					SELECT 184 as sporttype, 1231 as bettype 
					UNION ALL 
					SELECT 186 as sporttype, 1220 as bettype 
					) t 
	WHERE cs3.sporttype = 180 and cs3.bettype = 1201	
		AND custid IN (SELECT * FROM @res)
	
	UPDATE custInfo WITH(UPDLOCK,ROWLOCK)
	SET maxpermatch181 = maxpermatch180,
		maxpermatch182 = maxpermatch180,
		maxpermatch184 = maxpermatch180,
		maxpermatch186 = maxpermatch180,
		HideVirtualSports = 0,
		DisableVirtualSports = 0
	WHERE custid IN (SELECT * FROM @res)					
	
END
GO


GO




DECLARE @maxCustID INT

SET @maxCustID = XXX

create table #temp (custid int primary key, isfinished bit)

--6737 rows affected
INSERT INTO #temp (custid, isfinished)
SELECT cs.custid , 0 
from Dep_CustSetting3rd cs with(nolock)
	inner join custInfo ci with(nolock) on cs.custid = ci.custid and cs.sporttype = 180
where ci.srecommend in (select custid from Dep_CustSuper with(nolock) where site= 'sungame')
	AND ci.custid <= @maxCustID

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
