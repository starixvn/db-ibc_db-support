 /*
	1. check negative balance ( make sure no affected customers) before run step 1
	2. perform delete
*/

-- step 1 
	--- if return any row, exclude this customer's tickets
	exec [dbo].[Acc_BettransCheckNegativeBetCredit]    
							@transids	= '5640210320,5640210326,5640210334,5640210343,5640210352,5640210399,5640210402,5640210443,5640210451,5640210457,5640210358,5640210364,5640210407,5640210419,5640210439,5640210447',
							@Type		= 0,
							@ExcludeRunning = 0



-- step 2

	DECLARE @UserID INT 
	SET @UserID = 862400---pgmViet

	--	SELECT * FROM custdb.dbo.CUSTINFO WITH(NOLOCk) WHERE USERNAME = 'pgmviet'

	CREATE TABLE #BetDelete (transid BIGINT, custid INT, recommend INT, mrecommend INT, srecommend INT, betfrom NVARCHAR(1),statusID INT)
	

	INSERT INTO #BetDelete (transid, custid, recommend, mrecommend, srecommend, betfrom, statusID)			
			SELECT DISTINCT transid, custid, recommend, mrecommend, srecommend, betfrom, statusID
			FROM bettrans b WITH (nolock)
			WHERE				
				b.transid IN (5640210320,5640210326,5640210334,5640210343,5640210352,5640210399,5640210402,5640210443,5640210451,5640210457,5640210358,5640210364,5640210407,5640210419,5640210439,5640210447)

		
	-- STEP 1 : BackUp
	INSERT INTO zzzbettrans
		(transid, custid, transdate, oddsid, hdp1, hdp2, odds, stake, status, winlost, livehomescore, liveawayscore, liveindicator, betteam, creator , refno, winlostdate, betfrom, betcheck, checktime, matchid, bettype)
	SELECT
		 transid, custid, CURRENT_TIMESTAMP, oddsid, hdp1, hdp2, odds, stake, status, winlost, livehomescore, liveawayscore, liveindicator, betteam, creator , refno, winlostdate, betfrom, betcheck, checktime, matchid, bettype
	FROM
		bettrans b WITH (nolock)
	WHERE
		b.transid IN (SELECT transid FROM #BetDelete)		 

	
	-- balance table
	CREATE TABLE #BeforeUpd (
				custid		 INT,
				winlostdate	 DATETIME,
				balance		 MONEY,
				winlost		 MONEY)
		
	CREATE TABLE #AfterUpd(
				custid		 INT,
				winlostdate	 DATETIME,
				balance		 MONEY,
				winlost		 MONEY)
	
	-- Get data before update
	INSERT INTO #BeforeUpd (custid, winlostdate, balance, winlost)
	SELECT	b.custid, winlostdate, SUM (b.winlost - b.actual_stake + b.playercomm), SUM(CASE WHEN ruben = 1 THEN winlost - actual_stake + playercomm ELSE 0 END)
	FROM	bettrans b WITH (NOLOCK)
	WHERE	b.transid in (SELECT transid FROM #BetDelete)
	GROUP BY b.CustID, winlostdate	
	

	
	-- STEP 2 : Update
	--    begin tran
	UPDATE 
		bettrans WITH (ROWLOCK, UPDLOCK)
	SET winlost=actual_stake,ruben=1,statuswinlost=6, status = 'Void', creator = @UserID,
		awinlost = 0, mwinlost = 0, swinlost = 0, playercomm = 0, comm  = 0, acomm = 0, scomm = 0, statusID = 102,
		transdesc = 'void manually'
	WHERE
		transid in (SELECT transid FROM #BetDelete)	

	--Get data after update
	INSERT INTO #AfterUpd (custid, winlostdate, balance, winlost)
	SELECT	b.custid, winlostdate, SUM (b.winlost - b.actual_stake + b.playercomm), SUM(CASE WHEN ruben = 1 THEN winlost - actual_stake + playercomm ELSE 0 END)
	FROM	bettrans b WITH (NOLOCK)
	WHERE	b.transid in (SELECT transid FROM #BetDelete)
	GROUP BY b.CustID, winlostdate

	---insert data into pending balance table 
	INSERT INTO BalancePendingCredit (custid,Balance)
	SELECT		a.custid, (a.balance - b.balance) as Balance
	FROM		#BeforeUpd b
	INNER JOIN	#AfterUpd a 	
			ON	a.custid = b.custid
	WHERE	    (a.balance - b.balance) > 0

	INSERT INTO BalancePendingDebit (custid,Balance)
	SELECT		a.custid, ABS(a.balance - b.balance) as Balance
	FROM		#BeforeUpd b
	INNER JOIN	#AfterUpd a 	
			ON	a.custid = b.custid
	WHERE	    (a.balance - b.balance) < 0

	

	DROP TABLE #BetDelete	
	DROP TABLE #BeforeUpd
	DROP TABLE #AfterUpd
	


