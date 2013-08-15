/*
	Created: Johnson
	Date: 2013-08-15
	Task: Import old data for RMSumWinloss_Old2
	DB: DBARC/bodb_Archive
*/

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

	INSERT INTO #tmpSumWinloss (winlostdate
					,custid
					,sporttype
					,statusid
					,combo					
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
			,currency
			,SUM(stake)
			,SUM(winlost)
			,SUM(stake*(1-tpositiontaking))
			,SUM(-(winlost-stake)*(1-tpositiontaking))
			,actualrate
			,SUM(modds)
			,count(1)
	FROM	bettrans_bk b WITH(NOLOCK) 
	WHERE	b.winlostdate between '2013-01-01' and '2013-01-01'			
			AND matchid = 9
			AND b.statusid IN (111,112,113)
	GROUP BY winlostdate, b.custid, liveawayscore, statusid, currency, actualrate, CASE WHEN RIGHT(betcheck,len(betcheck)-1) >= 6 then 6 else RIGHT(betcheck,len(betcheck)-1) END
	
	UPDATE t
	SET t.username = c.username
	FROM #tmpSumWinloss t
		INNER JOIN bodb02.dbo.custinfo c WITH(NOLOCK) ON t.custid = c.custid
	
	INSERT INTO DBRMS.bodb_RMS.dbo.RMSumWinloss_Old2 (winlostdate
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
								