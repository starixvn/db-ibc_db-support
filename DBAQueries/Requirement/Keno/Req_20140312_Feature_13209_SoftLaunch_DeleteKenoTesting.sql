/** SP to delete default setting of Keno game - soft launch **/
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09] 
	@ids VARCHAR(MAX)
	, @IsDisable BIT = 0 
AS
/*
	Created: Bobby
	Date: 20140312
	Task: Enable default setting of Keno game for credit customers
	DB: DBTRANS/CustDB

	Param's Explanation:
		• @ids: list custid
		• @IsDisable: 0:active|1:inactive
*/
BEGIN
	SET NOCOUNT ON	

	IF NOT EXISTS ( SELECT * FROM sys.objects WHERE NAME = 'custgametype' AND type = 'U' )
		OR @@SERVERNAME IN ('DBBingoAdmin','DBLVCasino','DBBingo01','DBCasinoAdmin','DBCasinoQA1','DBCasinoQA2','LiveCasinoAdminDB')
		RETURN

	DELETE cg
	FROM [dbo].[CustGameType] cg
	WHERE GameTypeID IN (1,2,3,4,5,6,7,8,9)

	IF NOT EXISTS ( SELECT * FROM sys.objects WHERE NAME = 'CustSettingGame' AND type = 'U' )
		RETURN

	DELETE cg
	FROM [dbo].[CustSettingGame] cg
	WHERE Sporttype = 202

END
GO

/*
	Created: Bobby
	Date: 20140303
	Task: Delete default setting of Keno game for deposit customers
	DB: DBTRANS/CustDB
*/
--USE CustDB
--GO

DECLARE @IsDelete BIT = 0

CREATE TABLE #temp (
	custid INT
	,isdeposit INT
)

INSERT INTO #temp (
	custid, isdeposit
	)
SELECT DISTINCT custid , 0
FROM dbo.CustGameType WITH(NOLOCK)
WHERE GameTypeID IN (1,2,3,4,5,6,7,8,9)
union
SELECT DISTINCT custid, 1
FROM dbo.CustSettingGame WITH(NOLOCK)
WHERE Sporttype = 202

--keep line super
select srecommend, isdeposit
from dbo.custinfo c with(nolock)
inner join #temp tmp on c.custid = tmp.custid
group by srecommend, isdeposit

IF(@IsDelete = 1)
BEGIN
	EXEC [Acc_ExecRep_Cust_09] @ids='0'
END

DROP TABLE #temp
print 'Completed'
GO
