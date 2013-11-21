  /*
	Created: Johnson
	Date: 20131121
	Task: Insert virtual racing , virtual greyhound, virtual motor racing, virtual tennis setting for 12bet Licensee	
		Copy minbet, maxbet setting from virtual soccer		
		PT = 85%
	DB: DBTXN/bodb02
 */
 
 --step 1: Delete existing customer setting on virtual racing , virtual greyhound, virtual motor racing, virtual tennis 
 --1815 rows on currency uus customers affected
DELETE cs
FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo ci with(nolock) on cs.custid = ci.custid and cs.sporttype in (181,182,184,186)
WHERE ci.srecommend in (select custid from Dep_CustSuper with(nolock) where site= '12bet')
GO


--step 2: execrep custsetting

ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids varchar(max)
AS
SET NOCOUNT ON

/*
	12bet licensee customers 
	Insert virtual racing, tennis, greyhound, motor racing setting from virtual soccer 
*/
	
BEGIN
	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('Dep_Custsetting3rd') AND type = 'U') <> 1
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
		   ,1231 as [bettype]
		   ,181 as [sporttype]
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
	FROM Dep_CustSetting3rd WITH(NOLOCK) 
	WHERE custid IN (SELECT * FROM @res) AND sporttype = 180 and bettype = 1201			   
	
	--virtual greyhounds
	INSERT INTO [dbo].[Dep_CustSetting3rd]
		   ([custid],[bettype],[sporttype],[islive],[apositiontaking],[mpositiontaking]
		   ,[spositiontaking],[playerdiscount],[discount],[adiscount],[sdiscount],[minbet],[maxbet])
    SELECT  [custid]
		   ,1231 as [bettype]
		   ,182 as [sporttype]
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
	FROM Dep_CustSetting3rd WITH(NOLOCK) 
	WHERE custid IN (SELECT * FROM @res) AND sporttype = 180 and bettype = 1201	

	--virtual motor racing
	INSERT INTO [dbo].[Dep_CustSetting3rd]
		   ([custid],[bettype],[sporttype],[islive],[apositiontaking],[mpositiontaking]
		   ,[spositiontaking],[playerdiscount],[discount],[adiscount],[sdiscount],[minbet],[maxbet])
    SELECT  [custid]
		   ,1231 as [bettype]
		   ,184 as [sporttype]
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
	FROM Dep_CustSetting3rd WITH(NOLOCK) 
	WHERE custid IN (SELECT * FROM @res) AND sporttype = 180 and bettype = 1201	
	
	--virtual tennis
	INSERT INTO [dbo].[Dep_CustSetting3rd]
		   ([custid],[bettype],[sporttype],[islive],[apositiontaking],[mpositiontaking]
		   ,[spositiontaking],[playerdiscount],[discount],[adiscount],[sdiscount],[minbet],[maxbet])
    SELECT  [custid]
    		   ,1220 as [bettype]
			   ,186 as [sporttype]
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
	FROM Dep_CustSetting3rd WITH(NOLOCK) 
	WHERE custid IN (SELECT * FROM @res) AND sporttype = 180 and bettype = 1201	
	
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

--244347 rows affected
INSERT INTO #temp (custid, isfinished)
SELECT cs.custid , 0 
from Dep_CustSetting3rd cs with(nolock)
	inner join custInfo ci with(nolock) on cs.custid = ci.custid and cs.sporttype = 180
where ci.srecommend in (select custid from Dep_CustSuper with(nolock) where site= '12bet')
	and mrecommend not in (
		1255629	,--	12BETACCUUS
		791048	,--	12BETACCUS$
		791052	,--	12BETACCEURO
		832125	,--	12BETACCTB
		835094	,--	12BETACCGBP
		835036	,--	12BETACCRM
		835044	,--	12BETACCRMB
		1015436	,--	12BETACCAUD
		1015563	,--	12BETACCCHF
		1752427	,--	12BETACCSD$
		1813588	,--	12BETACCIN
		3167467	,--	12BETACCINH
		6006581	,--	12BETACCWON
		6006552	,--	12BETACCINR
		6006574	,--	12BETACCJPY
		7526067	--	12BETACCHK$
	)
	and mrecommend not in (
		927780	,--	12BETAFF
		857227	--	12BETTAFF
	)
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

	WAITFOR DELAY '00:00:02'
end
