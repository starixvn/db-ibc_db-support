   /*
	Created: Johnson
	Date: 20131121
	Task: Insert virtual racing , virtual greyhound, virtual motor racing, virtual tennis setting for Alog Licensee	
		Copy minbet, maxbet setting from virtual soccer		
		PT = 85%
	DB: DBTXN/bodb02
 */
 
 --step 1: Delete existing customer setting on virtual racing , virtual greyhound, virtual motor racing, virtual tennis 
 --1587 rows on currency uus customers affected
DELETE cs
FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo ci with(nolock) on cs.custid = ci.custid and cs.sporttype in (181,182,184,186)
WHERE ci.srecommend in (select custid from Dep_CustSuper with(nolock) where site= 'Alog')
GO




--step 2: execrep custsetting

ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids varchar(max)
AS
SET NOCOUNT ON

/*
	Alog licensee customers 
	Insert virtual racing, tennis, greyhound, motor racing setting from virtual soccer 
*/
	
BEGIN
	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('Dep_Custsetting3rd','custinfo') AND type = 'U') <> 2
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
		 ,t.[sporttype]
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


DECLARE @maxCustID INT

SET @maxCustID = xxx

create table #temp (custid int primary key, isfinished bit)

--81618 rows affected
INSERT INTO #temp (custid, isfinished)
SELECT cs.custid , 0 
from Dep_CustSetting3rd cs with(nolock)
	inner join custInfo ci with(nolock) on cs.custid = ci.custid and cs.sporttype = 180
where ci.srecommend in (select custid from Dep_CustSuper with(nolock) where site= 'Alog')
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
