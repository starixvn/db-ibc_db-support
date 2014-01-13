 /*
	Created: Johnson
	Date: 20140110
	Task: Update bet settings for horse racing fixed odds for all licensees
	DB: DBTXN/CustDB
 */
 
 
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
    @ids varchar(max)
AS
BEGIN
	SET NOCOUNT ON

	IF (SELECT count(1) FROM dbo.sysobjects WHERE name IN('Custinfo','Dep_CustSetting')) <> 2 RETURN

	declare @string varchar(max), @splitter char(1), @xml XML
	select @splitter = ',' ,@string = @ids

	SET @XML = N'<root><r>' + REPLACE(@string, @splitter, '</r><r>') + '</r></root>'
	declare @res AS TABLE(custid INT)
	INSERT INTO @res(custid)
	SELECT r.value('.','VARCHAR(12)')
	FROM @xml.nodes('//root/r') AS RECORDS(r)
	
	
	INSERT INTO [CustDB].[dbo].[Dep_CustSetting]
           ([custid]
           ,[bettype]
           ,[sporttype]
           ,[islive]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[minbet]
           ,[maxbet])
     
     SELECT 
		[custid]
	   ,20 as [bettype]
	   ,154 as [sporttype]
	   ,[islive]
	   ,[apositiontaking]
	   ,[mpositiontaking]
	   ,[spositiontaking]
	   ,[playerdiscount]
	   ,[discount]
	   ,[adiscount]
	   ,[sdiscount]
	   ,1 as [minbet]
	   ,100000 as [maxbet]
     FROM Dep_CustSetting WITH(NOLOCK)
     WHERE custid IN( SELECT custid FROM @res)
		 AND sporttype = 99
		 AND bettype = 20
	

	UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
	SET maxpermatch154 = 1000000
	WHERE custid IN (SELECT custid FROM @res)
END
GO
 
 
 CREATE TABLE #temp(custid INT PRIMARY KEY, isfinished bit default(0))
 DECLARE @max_custid INT
 
 SELECT @max_custid = xxx
 
 --17466 rows affected
 INSERT INTO #temp(custid)
 SELECT custid
 FROM custinfo with(NOLOCK)
 WHERE srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE currency = 20)
 AND custid <= @max_custid
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

	EXEC [Acc_ExecRep_Cust_09] @ids = @ids

	if @rowcnt < 10000 RETURN

	WAITFOR DELAY '00:00:01'
end



