 /*
	Created: Johnson
	Date: 20131217
	Task: Remove setting for all disabled accounts in the systems.
	DB: DBTXN/bodb02
 */
 
 
 ALTER PROCEDURE [dbo].[Acc_ExecRep_09]
	@ids varchar(max)	
AS
SET NOCOUNT ON

IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('CustSetting','CustSetting3rd','CustSettingGame','P2PGameSetting','P2PGroupComm','custoverride','custoverride3rd','custoverrideGame','custinfo') AND type = 'U') <> 9 RETURN
BEGIN

	declare @string varchar(max), @splitter char(1), @xml XML
	select @splitter = ',' ,@string = @ids
	
	SET @XML = N'<root><r>' + REPLACE(@string, @splitter, '</r><r>') + '</r></root>'
	
	declare @res AS TABLE(custid INT)
	INSERT INTO @res(custid)
	SELECT r.value('.','INT')
	FROM @xml.nodes('//root/r') AS RECORDS(r)
	
	Delete custsetting with (ROWLOCK) 
	where custid in (SELECT custid from @res)
	
	Delete CustSetting3rd with (ROWLOCK) 
	where custid in (SELECT custid from @res)
	
	DELETE custoverride with (ROWLOCK) 
	where custid in (SELECT custid from @res)
	
	DELETE CustOverride3rd with (ROWLOCK) 
	where custid in (SELECT custid from @res)
	
	DELETE P2PGameSetting WITH (ROWLOCK) 
	where custid in (SELECT custid from @res)
	
	DELETE P2PGroupComm WITH (ROWLOCK) 
	where custid in (SELECT custid from @res)
	
	DELETE custsettingGame WITH (ROWLOCK) 
	where custid in (SELECT custid from @res)
	
	DELETE Custoverridegame WITH (ROWLOCK) 
	where custid in (SELECT custid from @res)
	
	UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
	SET credit = 0
	WHERE custid IN (SELECT custid from @res)
END
 GO
 
 
 
CREATE TABLE #customer (custid int)
DECLARE @max_custid INT,
		@running_cnt INT

SELECT @max_custid = xxxx,
	@running_cnt = 0
 
INSERT INTO #customer
SELECT custid
from custInfo with(nolock)
where srecommend not in (select custid from dbo.Dep_CustSuper with(nolock))
	and enabled = 0
	and roleid <=4
	and custid <=@max_custid 

DECLARE @subtable TABLE(custid int)
DECLARE @ids varchar(max)

WHILE (1 = 1)
BEGIN
	DELETE @subtable

	DELETE TOP (100) #customer
	OUTPUT deleted.custid
	INTO @subtable(custid)	

	IF @@ROWCOUNT = 0 BREAK
	
	SELECT @ids = STUFF((
		SELECT ',' + cast(custid as varchar(10)) 
		FROM @subtable 
		FOR XML PATH('')
	), 1,1,'')
	
	EXEC dbo.Acc_ExecRep_09 @ids = @ids
	
	IF @running_cnt = 30
	BEGIN
		WAITFOR DELAY '00:00:01'
		SET @running_cnt = 0
	END
	
	SET @running_cnt = @running_cnt + 1
END	


 
 