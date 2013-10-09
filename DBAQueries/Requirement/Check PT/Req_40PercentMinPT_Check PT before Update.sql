

-- check Master
CREATE TABLE #masterList (custid INT)

--- check if m3 < 0.4 for master
SELECT COUNT(1)
FROM CustSetting cs WITH(NOLOCK)
WHERE custid IN (SELECT * FROM #masterList)
AND mpositiontaking < 0.4

SELECT COUNT(1)
FROM CustSetting cs WITH(NOLOCK)
WHERE custid IN (SELECT * FROM #masterList)
AND mlivepositiontaking < 0.4
AND sporttype = 1 AND bettype IN (1,3,7,8)


-- check if m3 + s3 > s4 (m3 = 0.4)
SELECT COUNT(1)
FROM custInfo c WITH(NOLOCK)
	INNER JOIN CustSetting cm WITH(NOLOCK) ON c.custid = cm.custid 
	INNER JOIN CustSetting cs WITH(NOLOCK) ON cs.custid = c.srecommend 
			AND cs.sporttype = cm.sporttype AND cs.bettype = cm.bettype
WHERE cm.custid IN (SELECT * FROM #masterList)
AND cm.spositiontaking + 0.4 > cs.spositiontaking

SELECT COUNT(1)
FROM custInfo c WITH(NOLOCK)
	INNER JOIN CustSetting cm WITH(NOLOCK) ON c.custid = cm.custid 
	INNER JOIN CustSetting cs WITH(NOLOCK) ON cs.custid = c.srecommend 
			AND cs.sporttype = cm.sporttype AND cs.bettype = cm.bettype
WHERE cm.custid IN (SELECT * FROM #masterList)
AND cm.slivepositiontaking + 0.4 > cs.slivepositiontaking
AND cm.sporttype = 1 AND cm.bettype IN (1,3,7,8)



-----------------------------------------------
-- check Agent
CREATE TABLE #agentList (custid INT)

--- check if a2 < 0.4 for master
SELECT COUNT(1)
FROM CustSetting cs WITH(NOLOCK)
WHERE custid IN (SELECT * FROM #agentList)
AND apositiontaking < 0.4

SELECT COUNT(1)
FROM CustSetting cs WITH(NOLOCK)
WHERE custid IN (SELECT * FROM #agentList)
AND alivepositiontaking < 0.4
AND sporttype = 1 AND bettype IN (1,3,7,8)


-- check if m2 + a2 > m3 (a2 = 0.4)
SELECT COUNT(1)
FROM custInfo c WITH(NOLOCK)
	INNER JOIN CustSetting ca WITH(NOLOCK) ON c.custid = ca.custid 
	INNER JOIN CustSetting cm WITH(NOLOCK) ON cm.custid = c.mrecommend 
			AND ca.sporttype = cm.sporttype AND ca.bettype = cm.bettype
WHERE ca.custid IN (SELECT * FROM #agentList)
AND ca.mpositiontaking + 0.4 > cm.mpositiontaking

SELECT COUNT(1)
FROM custInfo c WITH(NOLOCK)
	INNER JOIN CustSetting ca WITH(NOLOCK) ON c.custid = ca.custid 
	INNER JOIN CustSetting cm WITH(NOLOCK) ON cm.custid = c.mrecommend 
			AND ca.sporttype = cm.sporttype AND ca.bettype = cm.bettype
WHERE ca.custid IN (SELECT * FROM #agentList)
AND ca.mlivepositiontaking + 0.4 > cm.mlivepositiontaking
AND ca.sporttype = 1 AND ca.bettype IN (1,3,7,8)
