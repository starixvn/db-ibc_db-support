/*
	Created: Johnson
	Date: 2013-06-19
	Task: import data into rptWinlost2 to support history data for 2a/2h
	DB: DBARC/bodb_Archive
	
*/
DECLARE @fromdate DATETIME,
		@todate	DATETIME

SELECT @fromdate = '2013-01-01',@todate = '2013-01-01'

CREATE TABLE #rptWinlost TABLE(
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
			matchid, bettype, liveindicator, Status,
			case when recommend = 52466 then 1 when recommend = 5707545 then 2 else 0 end ibc,
			sum((1-tpositiontaking)*abs(stake)*actualrate) as realturnover,
			sum((winlost-actual_stake)* actualrate)  realwinlost,
			sum((awinlost+mwinlost+swinlost)* actualrate) realpos,
			sum((scomm) * actualrate) realcomm,
			sum((winlost-actual_stake+swinlost+mwinlost+awinlost+scomm)*actualrate) as realLineTotal,
			sum((1-tpositiontaking)*abs(CASE WHEN bettype = 29 AND betid > 0 THEN actual_stake ELSE stake END)*virtualrate) as virtualTurnover,
			sum((winlost-actual_stake+awinlost+mwinlost+swinlost+scomm)*virtualrate) virtualLineTotal,			
			0, 0
		FROM
			bettrans_bk b with (nolock)
		WHERE
			bettype < 19999
			AND winlostdate between @fromdate and @todate
			AND statusID NOT IN (101, 102) --('VOID', 'REJECT')
		GROUP BY
			winlostdate, matchid, bettype, liveindicator, status,
			case when recommend = 52466 then 1 when recommend = 5707545 then 2 else 0 end

		UPDATE #rptWinlost
		SET SportType = CASE
			WHEN leaguename LIKE '%NFL%' AND l.sporttype = 2 THEN 3
			WHEN (leaguename LIKE '%NHL%' OR leaguename LIKE '%hockey%') AND l.sporttype = 2 THEN 4
			ELSE l.sporttype END, exrisk = m.exrisk
		FROM match_bk m with (nolock)
			inner join bodb02.dbo.league l with (nolock) ON m.leagueid = l.leagueid
		WHERE #rptWinlost.matchid = m.matchid		
		AND #rptWinlost.bettype not in (10,31,32,33)


		UPDATE #rptWinlost
		SET SportType = CASE
			WHEN leaguename LIKE '%NFL%' AND l.sporttype = 2 THEN 3
			WHEN (leaguename LIKE '%NHL%' OR leaguename LIKE '%hockey%') AND l.sporttype = 2 THEN 4
			ELSE l.sporttype END
		FROM outright_bk o with (nolock) 
			INNER JOIN league l with (nolock) ON o.leagueid = l.leagueid
		WHERE #rptWinlost.matchid = o.orid	
		AND #rptWinlost.bettype IN (10,31,32,33)
		
		INSERT INTO rptWinlost(
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

