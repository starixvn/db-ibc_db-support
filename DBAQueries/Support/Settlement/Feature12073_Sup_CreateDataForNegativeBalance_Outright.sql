ALTER PROCEDURE Sup_CreateDataForNegativeBalance_Outright
	@Licenssee VARCHAR(50),
	@matchid INT,
	@Case INT = 1 -- 1: Settle 2: Refund

AS
/*
	--Step 1: -------------------------------------------------------------------------------------------------------------------------
	--Select HAIFA customer whose balance is negative:
	DECLARE @CustNegativeBalance TABLE (CustID INT, srecommend INT, mrecommend INT, recommend INT, username VARCHAR(30), Balance MONEY)
	INSERT INTO @CustNegativeBalance (CustID, srecommend, mrecommend, recommend, username, Balance)
	SELECT custid, srecommend, mrecommend, recommend, username, SUM(winlost - actual_stake + playercomm)
	FROM bettrans WITH (NOLOCK)
	WHERE custid IN (
			SELECT custid
			FROM CustDB.dbo.custinfo WITH (NOLOCK)
			WHERE Recommend IN (4345531,4359430,7262800,8362823)
				AND roleid = 1 
			) 
	GROUP BY custid, srecommend, mrecommend, recommend, username
	HAVING SUM(winlost - actual_stake + playercomm) < 0 

	SELECT * from @CustNegativeBalance
	
	--Select HAIFA customer's ticket outright
	DECLARE @transid BIGINT,  @matchid INT
	SELECT top 1 @transid = transid,  @matchid = matchid
	from bettrans b with (nolock) 
		INNER JOIN outright o with (nolock) on o.orid = b.matchid
	where srecommend IN (SELECT custid FROM f_depsuper_1('haifa')) and b.status = 'running'			
		--and o.orid in (SELECT matchid FROM match with (nolock))
		--and custid in (SELECT custid from @CustNegativeBalance)
	order by o.leagueid

	SELECT @transid as transid, @matchid as matchid

	UPDATE bettrans with (rowlock, updlock)
	set custid = c.CustID, srecommend = c.srecommend, mrecommend = c.mrecommend, recommend = c.recommend, Username = c.username
	FROM @CustNegativeBalance c
	where transid = @transid and c.custid in (SELECT top 1 custid FROM @CustNegativeBalance)

	--Create data:
	EXEC Sup_CreateDataForNegativeBalance_Outright @Licenssee = 'haifa', @matchid = @matchid, @Case = 1

	--End Step 1: -------------------------------------------------------------------------------------------------------------------------

	--Step 2: -------------------------------------------------------------------------------------------------------------------------
	--Select Result:
	DECLARE @matchid INT
	SELECT @matchid = 2732216
	SELECT bn.* 
	from BalanceNegative bn with (nolock)
		INNER JOIN CustDB.dbo.CustInfo c with (nolock) on bn.custid = c.custid
	where matchid = @matchid 
		and srecommend IN (SELECT custid FROM f_depsuper_1('haifa'))

	SELECT * from BalanceNegativeHistory where matchid = @matchid order by logid desc 

	--End Step 2: -------------------------------------------------------------------------------------------------------------------------
*/
BEGIN		
	DECLARE @ErrCode int, @ErrMsg nvarchar(200), @ErrCode1 int, @ErrMsg1 nvarchar(200)

	IF @Case = 1
	BEGIN
		--Step 1: Settle with status = 'WON'
		exec Dot_Admin_SettleOutright_Event @matchid = @matchid, @status = 'WON', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT
		exec Dot_Admin_SettleOutright_Trans @matchid = @matchid, @status = 'WON', @ErrCode = @ErrCode1 OUTPUT, @ErrMsg = @ErrMsg1 OUTPUT
	
		--Step 2: Settle with status = 'LOSE'
		exec Dot_Admin_SettleOutright_Event @matchid = @matchid, @status = 'LOSE', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT
		exec Dot_Admin_SettleOutright_Trans @matchid = @matchid, @status = 'LOSE', @ErrCode = @ErrCode1 OUTPUT, @ErrMsg = @ErrMsg1 OUTPUT
	END
	ELSE 
	BEGIN
		--Step 1: Settle with status = 'WON'
		exec Dot_Admin_SettleOutright_Event @matchid = @matchid, @status = 'WON', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT
		exec Dot_Admin_SettleOutright_Trans @matchid = @matchid, @status = 'WON', @ErrCode = @ErrCode1 OUTPUT, @ErrMsg = @ErrMsg1 OUTPUT
	
		--Step 2: Settle with status = 'Refund'
		exec Dot_Admin_SettleOutright_Event @matchid = @matchid, @status = 'Refund', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT
		exec Dot_Admin_SettleOutright_Trans @matchid = @matchid, @status = 'Refund', @ErrCode = @ErrCode1 OUTPUT, @ErrMsg = @ErrMsg1 OUTPUT
	END

	SELECT @ErrCode, @ErrMsg, @ErrCode1, @ErrMsg1

	SELECT * from BalanceNegative where matchid = @matchid	
END