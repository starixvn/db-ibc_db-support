 
CREATE TABLE #rptWinlost (
	[winlostdate] [smalldatetime] NULL,
	[matchid] [int] NULL,
	[bettype] [smallint] NULL,
	[liveindicator] [bit] NULL,
	[Status] [nvarchar](10) NULL,
	[IBC] [tinyint] NULL,
	[RealTurnover] [money] NULL,
	[RealWinLost] [money] NULL,
	[RealPosition] [money] NULL,
	[RealCommission] [money] NULL,
	[RealLineTotal] [money] NULL,
	[VirtualTurnover] [money] NULL,
	[VirtualLineTotal] [money] NULL,
	[SportType] [smallint] NULL,
	[exrisk] [smallmoney] NULL
)

--comm setting for racing
DECLARE @CommSetting TABLE 
	(	MatchID			int,
		IBCFee			bit,
		ToteCommWin		smallmoney,
		ToteCommPlace	smallmoney,
		ToteCommWP		smallmoney,
		ToteFee			smallmoney	
	)


CREATE TABLE #bettransm (
		refno bigint primary key,
		TOIBC	money,
		WLIBC money,
		TOPhum money
	)
	
DECLARE @fromdate DATETIME,
		@todate	DATETIME

SELECT @fromdate = '2011-01-01',@todate = '2011-01-01'

DELETE bodb_report.dbo.rptWinlost2 WITH(UPDLOCK,ROWLOCK)
WHERE winlostdate BETWEEN @fromdate AND @todate
and bettype IN (31,32,33)

--calculate racing winlost
INSERT INTO @CommSetting (MatchID, IBCFee, ToteCommWin, ToteCommPlace, ToteCommWP, ToteFee)
SELECT	DISTINCT o.orid as matchid, CASE WHEN r.partnerID IN (2,3,4) THEN 0 ELSE 1 END, p.ToteCommWin, p.ToteCommPlace, (p.ToteCommWin + p.ToteCommPlace)/2 ToteCommWP, p.ToteFee 
FROM	outright_bk o WITH (NOLOCK)
		INNER JOIN bodb02.dbo.LeagueDetail p WITH (NOLOCK) ON o.leagueID = p.LeagueID AND p.programDate = isnull(o.programDate,o.eventdate)
		INNER JOIN bodb02.dbo.RacingMeeting r WITH(NOLOCK) ON r.meetingID = p.leagueid				
WHERE	o.eventdate between @fromdate and @todate

INSERT INTO #bettransm (refno,TOIBC,WLIBC,TOPhum)
SELECT refno,
	sum(case when bettype = 32 and liveawayscore =0 then 0 else stake*isnull(oddsspread,0) end),
	-sum((winlost - stake)*isnull(oddsspread,0)),
	sum(case when bettype = 32 and liveawayscore = 0 then 0 when bettype = 31 or (bettype = 32 and liveawayscore <> 0) then stake*(1 -tpositiontaking - isnull(oddsspread,0)) else 0 end)
FROM bettransm WITH(NOLOCK)
WHERE winlostdate BETWEEN @fromdate and @todate
GROUP BY refno


--import racing data
INSERT INTO #rptWinlost(
					[winlostdate]
				   ,[matchid]
				   ,[bettype]
				   ,[liveindicator]
				   ,[Status]
				   ,[IBC]
				   ,[RealTurnover]
				   ,[RealWinLost]
				   ,[RealPosition]
				   ,[RealCommission]
				   ,[RealLineTotal]
				   ,[VirtualTurnover]
				   ,[VirtualLineTotal]
				   ,[SportType]
				   ,[exrisk]
				)
	SELECT
			winlostdate,
			b.matchid, bettype, liveindicator, Status,
			case when recommend = 52466 then 1 when recommend = 5707545 then 2 else 0 end ibc,
			sum(case when b.bettype = 33 then bm.TOPhum*actualrate ELSE actual_stake*isnull(b.oddsspread,0)*actualrate END) as realturnover,
			sum((winlost-actual_stake)* actualrate)  realwinlost,
			sum((awinlost+mwinlost+swinlost)* actualrate) realpos,
			sum((scomm) * actualrate) realcomm,
			-(sum((case when bettype = 33 then bm.WLIBC else -(b.winlost -b.actual_stake)*isnull(b.oddsspread,0) end)*b.actualrate) 
								- sum( case when cs.IBCFee = 0 then 0 else (case when b.bettype = 33 then bm.TOPhum when bettype in (31,32) then b.actual_stake*(1 -b.tpositiontaking - isnull(b.oddsspread,0)) else 0 end)*b.actualrate*cs.ToteFee end) --FeeDue2 
								+ sum((case bettype when 31 then b.actual_stake*cs.ToteCommWin*(1 - b.tpositiontaking - isnull(oddsspread,0))
													when 32 then b.actual_stake*cs.ToteCommPlace*(1 - b.tpositiontaking - isnull(oddsspread,0))
													when 33 then bm.TOPhum*cs.ToteCommWP  
													else 0 end)*b.actualrate) --commIncomeIBC
								- sum(b.scomm*b.actualrate)) as realLineTotal,
			0 as virtualTurnover,
			0 virtualLineTotal,			
			0, 0
	FROM
		bettrans_bk b with (nolock)
		INNER JOIN @CommSetting as cs ON b.matchid = cs.matchid 
		LEFT JOIN #bettransm bm ON b.transid = bm.refno
	WHERE
		bettype in (31,32,33)
		AND winlostdate between @fromdate and @todate
		AND statusID NOT IN (101,102,103,121)	 --('VOID','REJECT','DONE','REFUND')
	GROUP BY
		winlostdate, b.matchid, bettype, liveindicator, status,
		case when recommend = 52466 then 1 when recommend = 5707545 then 2 else 0 end

	UPDATE #rptWinlost
	SET SportType = CASE
		WHEN leaguename LIKE '%NFL%' AND l.sporttype = 2 THEN 3
		WHEN (leaguename LIKE '%NHL%' OR leaguename LIKE '%hockey%') AND l.sporttype = 2 THEN 4
		ELSE l.sporttype END
	FROM outright_bk o with (nolock) 
		INNER JOIN bodb02.dbo.league l with (nolock) ON o.leagueid = l.leagueid
	WHERE #rptWinlost.matchid = o.orid	
	AND #rptWinlost.bettype IN (31,32,33)

INSERT INTO bodb_report.dbo.rptWinlost2(
					[winlostdate]
				   ,[matchid]
				   ,[bettype]
				   ,[liveindicator]
				   ,[Status]
				   ,[IBC]
				   ,[RealTurnover]
				   ,[RealWinLost]
				   ,[RealPosition]
				   ,[RealCommission]
				   ,[RealLineTotal]
				   ,[VirtualTurnover]
				   ,[VirtualLineTotal]
				   ,[SportType]
				   ,[exrisk]
				)
			SELECT
				[winlostdate]
				   ,[matchid]
				   ,[bettype]
				   ,[liveindicator]
				   ,[Status]
				   ,[IBC]
				   ,[RealTurnover]
				   ,[RealWinLost]
				   ,[RealPosition]
				   ,[RealCommission]
				   ,[RealLineTotal]
				   ,[VirtualTurnover]
				   ,[VirtualLineTotal]
				   ,[SportType]
				   ,[exrisk]
			FROM #rptWinlost

	DROP TABLE #rptWinlost 
	DROP TABLE #bettransm