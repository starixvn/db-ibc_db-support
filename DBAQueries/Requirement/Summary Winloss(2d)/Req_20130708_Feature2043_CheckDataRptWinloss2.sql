  /*
	Created: Johnson
	Date: 2013-07-08
	Task: check data in rptWinlost2 with rptWinlost
	DB: DBRPT/bodb_Report
	
*/


DECLARE @fromdate datetime, @todate datetime

select @fromdate = '2013-07-08 00:00:00',
		@todate = '2013-07-08 00:00:00'

SELECT r1.*, r2.*
FROM
(
	SELECT winlostdate, matchid, bettype, IBC , sum(winlost) as winlost, sum([Position]) as position, sum(Commission) as commission
	FROM rptWinLost with(NOLOCK)
	where winlostdate BETWEEN @fromdate AND @todate
	GROUP BY winlostdate, matchid, bettype, IBC 
) r1 LEFT JOIN 
(
SELECT winlostdate, matchid, bettype, IBC , sum(realwinlost) as winlost, sum([realPosition]) as position, sum(realCommission) as commission
FROM rptWinLost2 with(NOLOCK)
where winlostdate BETWEEN @fromdate AND @todate
GROUP BY winlostdate, matchid, bettype, IBC 
) r2 on r1.winlostdate = r2.winlostdate and r1.matchid = r2.matchid and r1.bettype = r2.bettype and r1.ibc = r2.ibc
where ISNULL(r1.winlost,0) - ISNULL(r2.winlost,0) <>0 or isnull(r1.position,0) - isnull(r2.position,0) <>0 OR isnull(r1.commission,0) - isnull(r2.commission,0) <>0





