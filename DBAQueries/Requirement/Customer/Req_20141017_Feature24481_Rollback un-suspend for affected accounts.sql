/*
CREATE TABLE ##CustIDs (custid int, isfinished bit)

INSERT INTO ##CustIDs (custid, isfinished)
select distinct custid, 0 
from DB052.bodb_customerLog.dbo.CustInfo_history WITH(NOLOCK)
where UpdateTime between '2014-10-17 01:45' AND '2014-10-17 02:03:30.763'
and reject = 0

*/

ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]	
	@CustIDs VARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('custinfo') AND type = 'U'
		) <> 1 RETURN
		
	declare @string varchar(max), @splitter char(1), @xml XML
	select @splitter = ',' ,@string = @CustIDs

	SET @XML = N'<root><r>' + REPLACE(@string, @splitter, '</r><r>') + '</r></root>'
	declare @res AS TABLE(custid INT)
	INSERT INTO @res(custid)
	SELECT r.value('.','INT')
	FROM @xml.nodes('//root/r') AS RECORDS(r)

	UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)	
	SET reject = 0
	WHERE custid IN (select custid FROM @res)
END

GO
GRANT VIEW DEFINITION ON [dbo].[Acc_ExecRep_Cust_09] TO [vnDBA] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_ExecRep_Cust_09] TO [vnteam] AS [dbo]
GO

DECLARE @CustIDs varchar(MAX)

WHILE (1 = 1)
BEGIN
	SET @CustIDs = ''
	
	UPDATE TOP (100) ##CustIDs
		SET isfinished = 1
			,@CustIDs = @CustIDs + CONVERT(VARCHAR(12), custid) + ','
	WHERE isfinished = 0
	
	IF @@ROWCOUNT < 100 BREAK
	
	SET @CustIDs = LEFT(@CustIDs, LEN(@CustIDs) - 1)
	EXEC dbo.Acc_ExecRep_Cust_09 @CustIDs = @CustIDs
	PRINT @CustIDs
	
	WAITFOR DELAY '00:00:00.100'
	
	--BREAK
END
