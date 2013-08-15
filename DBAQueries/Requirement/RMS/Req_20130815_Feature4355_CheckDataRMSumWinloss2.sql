/*
	Created: Johnson
	Date: 2013-08-15
	Task: check data in RMSumWinloss2 with RMSumWinloss
	DB: DBRMS/bodb_RMS
*/

DECLARE @fromdate DATETIME,
		@todate	DATETIME

SELECT @fromdate = '2013-08-15',
		@todate = '2013-08-15'
		
SELECT s1.*, s2.stake, s2.winlost, s2.company_stake, s2.company_winlost
FROM 
	(SELECT winlostdate
		,custid
		,sporttype
		,statusid
		,username
		,SUM(stake) as stake
		,SUM(winlost) as winlost
		,SUM(company_stake) as company_stake
		,SUM(company_winlost) as company_winlost
		,SUM(betcount) as betcount 
	FROM RMSumWinloss2 WITH(NOLOCK)
	WHERE winlostdate BETWEEN @fromdate AND @todate
	GROUP BY winlostdate
		,custid
		,sporttype
		,statusid
		,username
	)s1
INNER JOIN
(
	SELECT winlostdate
		,custid
		,sporttype
		,statusid
		,username
		,stake
		,winlost
		,company_stake
		,company_winlost
		,betcount
	FROM RMSumWinloss WITH(NOLOCK)
	WHERE winlostdate BETWEEN @fromdate AND @todate
) s2 ON s1.winlostdate = s2.winlostdate AND s1.custid = s2.custid AND s1.sporttype = s2.sporttype AND s1.statusid = s2.statusid
WHERE s1.stake - s2.stake not between -0.01 and 0.01
	OR s1.winlost - s2.winlost not between -0.01 and 0.01
	OR s1.company_stake - s2.company_stake not between -0.01 and 0.01
	OR s1.company_winlost - s2.company_winlost not between -0.01 and 0.01
	OR s1.betcount <> s2.betcount
