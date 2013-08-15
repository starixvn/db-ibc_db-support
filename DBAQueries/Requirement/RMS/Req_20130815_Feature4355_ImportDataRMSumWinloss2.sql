 /*
	Created: Johnson
	Date: 2013-08-15
	Task: Import old data for RMSumWinloss2
	DB: DBRMS/bodb_RMS
*/
	DECLARE @fromdate DATETIME, 
			@todate	DATETIME

	CREATE TABLE #tmpSumWinloss
		[winlostdate] [smalldatetime] NOT NULL,
		[custid] [int] NOT NULL,
		[sporttype] [tinyint] NOT NULL,
		[statusid] [tinyint] NOT NULL,
		[combo] [tinyint] NOT NULL,
		[username] [varchar](30) NULL,
		[currency] [tinyint] NULL,
		[stake] [money] NULL,
		[winlost] [money] NULL,
		[company_stake] [money] NULL,
		[company_winlost] [money] NULL,
		[actualrate] [float] NULL,
		[odds] [smallmoney] NULL,
		[betcount] [int] NULL
	) 
	
	SELECT @fromdate = '2013-08-15',
			@todate = '2013-08-15'

	INSERT INTO #tmpSumWinloss (winlostdate
					,custid
					,sporttype
					,statusid
					,combo	
					,username				
					,currency
					,stake
					,winlost
					,company_stake
					,company_winlost
					,actualrate
					,odds
					,betcount)
	SELECT	 winlostdate
			,b.custid
			,liveawayscore
			,statusid
			,CASE WHEN RIGHT(betcheck,len(betcheck)-1) >= 6 then 6 else RIGHT(betcheck,len(betcheck)-1) END as combo		
			,username
			,currency
			,SUM(stake)
			,SUM(winlost)
			,SUM(stake*(1-tpositiontaking))
			,SUM(-(winlost-stake)*(1-tpositiontaking))
			,actualrate
			,SUM(modds)
			,count(1)
	FROM	bodb02.dbo.bettrans14 b WITH(NOLOCK) 
	WHERE	b.winlostdate between @fromdate and @todate			
			AND matchid = 9
			AND bettype = 9
			AND b.statusid IN (111,112,113)
	GROUP BY winlostdate, b.custid, username, liveawayscore, statusid, currency, actualrate, CASE WHEN RIGHT(betcheck,len(betcheck)-1) >= 6 then 6 else RIGHT(betcheck,len(betcheck)-1) END
	
	INSERT INTO RMSumWinloss2 (winlostdate
					,custid
					,sporttype
					,statusid
					,combo		
					,username			
					,currency
					,stake
					,winlost
					,company_stake
					,company_winlost
					,actualrate
					,odds
					,betcount)	
	SELECT winlostdate
					,custid
					,sporttype
					,statusid
					,combo		
					,username			
					,currency
					,stake
					,winlost
					,company_stake
					,company_winlost
					,actualrate
					,odds
					,betcount
	FROM #tmpSumWinloss
								