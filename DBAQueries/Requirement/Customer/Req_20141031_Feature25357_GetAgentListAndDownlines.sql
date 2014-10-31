 /*
	Created: Johnson
	Date: 20141031
	Task: Get agent list and calculate total members of direct agents and normal agents
	DB: DBACC/bodb02
 */
 
--get report for direct agents
SELECT ci.recommend as custid, COUNT(1) as cnt
INTO #tmp
from custInfo ci WITH(NOLOCK)
WHERE ci.recommend IN (SELECT custid FROM Acc_CustDirect (NOLOCK) WHERE roleid = 2)
	AND ci.roleid = 1
	AND ci.closed = 0 and ci.Enabled = 1 AND ci.reject = 0
GROUP BY ci.recommend

SELECT su.username as 'super', ma.username as 'master', ag.username as 'agent', ag.site, e.currency,t.cnt as 'total members'
FROM customer ag (NOLOCK)
INNER JOIN custInfo ci ON ag.custid = ci.custid
INNER JOIN #tmp t ON ag.custid = t.custid
INNER JOIN exchange e (NOLOCK) ON ag.currency = e.exchangeid
INNER JOIN custinfo su(NOLOCK) ON ag.srecommend = su.custid
INNER JOIN custinfo ma(NOLOCK) ON ag.mrecommend = ma.custid
WHERE ci.closed = 0 and ci.Enabled = 1
and ci.currency <> 20
and ag.custid not IN (select custid FROM CustAgent (NOLOCK) where IsInternal = 1)
AND su.custid not IN (select custid from CustSuper (NOLOCK) where IsInternal = 1)
AND ma.custid not IN (select custid from CustMaster (NOLOCK) where IsInternal = 1)
ORDER BY e.currency, ag.site, su.username, ma.username


--get report for normal agents
SELECT ci.recommend as custid, COUNT(1) as cnt
INTO #tmp
from custInfo ci WITH(NOLOCK)
WHERE ci.recommend NOT IN (SELECT custid FROM Acc_CustDirect (NOLOCK) WHERE roleid = 2)
	AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper (NOLOCK))
	AND ci.currency <> 20
	AND ci.roleid = 1
	AND ci.closed = 0 and ci.Enabled = 1 AND ci.reject = 0
GROUP BY ci.recommend

SELECT su.username as 'super', ma.username as 'master', ag.username as 'agent', ag.site, e.currency,t.cnt as 'total members'
FROM customer ag (NOLOCK)
INNER JOIN custInfo ci ON ag.custid = ci.custid
INNER JOIN #tmp t ON ag.custid = t.custid
INNER JOIN exchange e (NOLOCK) ON ag.currency = e.exchangeid
INNER JOIN custinfo su(NOLOCK) ON ag.srecommend = su.custid
INNER JOIN custinfo ma(NOLOCK) ON ag.mrecommend = ma.custid
WHERE ci.closed = 0 and ci.Enabled = 1 AND ci.reject = 0
and ag.custid not IN (select custid FROM CustAgent (NOLOCK) where IsInternal = 1)
AND su.custid not IN (select custid from CustSuper (NOLOCK) where IsInternal = 1)
AND ma.custid not IN (select custid from CustMaster (NOLOCK) where IsInternal = 1)
and su.username not LIKE '3rdSuper%'
    AND su.username NOT LIKE 'STEST%'    
ORDER BY e.currency, ag.site, su.username, ma.username

