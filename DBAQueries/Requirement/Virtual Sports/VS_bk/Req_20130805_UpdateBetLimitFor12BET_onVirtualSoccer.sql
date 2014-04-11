

/*
Update betting limit for 12BET on virtual soccer
*/



CREATE TABLE #betsetting (currency INT, maxbet MONEY, maxpermatch MONEY)

INSERT INTO #betsetting (currency,maxbet, maxpermatch)
		  SELECT 51, 60000, 180000 -- INH  
UNION ALL SELECT 15, 30000, 90000-- IN
UNION ALL SELECT 4, 100000, 300000 -- TB  
UNION ALL SELECT 2, 10000, 30000 -- RM  
UNION ALL SELECT 13, 20000, 60000  -- RMB 



UPDATE c WITH(ROWLOCK,UPDLOCK) 
SET maxpermatch180 = b.maxpermatch
FROM custinfo c 
	INNER JOIN #betsetting b ON c.currency = b.currency
WHERE srecommend IN (SELECT * FROM f_DepSuper_1('12BET'))
	AND roleid > 1
	AND c.currency IN (
						51, -- INH  
						15, -- IN
						4, -- TB  
						2, -- RM  
						13  -- RMB 
					)


UPDATE cs3 WITH(ROWLOCK,UPDLOCK) 
SET cs3.maxbet = b.maxbet
FROM Dep_custsetting3rd cs3 
	INNER JOIN custinfo c WITH(NOLOCK) ON cs3.custid = c.custid
	INNER JOIN #betsetting b ON c.currency = b.currency
WHERE srecommend IN (SELECT * FROM f_DepSuper_1('12BET'))
	AND roleid > 1
	AND cs3.sporttype = 180 AND cs3.bettype = 1201
	AND c.currency IN (
						51, -- INH  
						15, -- IN
						4, -- TB  
						2, -- RM  
						13  -- RMB 
					)
	