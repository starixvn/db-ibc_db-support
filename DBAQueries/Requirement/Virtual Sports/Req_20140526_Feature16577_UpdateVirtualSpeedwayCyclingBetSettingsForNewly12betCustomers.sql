/*
	Created: Johnson
	Date: 2014-05-26
	Task: Update virtual speedway, virtual cycling bet settings for newly 12bet's customers
	DB: DBTXN/CustDB
*/ 

DECLARE @tmpSettings TABLE (currency int, maxbet money, maxpermatch money, isfinished bit default(0))
DECLARE @tmpCust TABLE(custid int, currency int)
DECLARE @max_custid INT

--lastest custid has been updated
SELECT @max_custid = 14670555

INSERT INTO @tmpSettings(currency, maxbet, maxpermatch)
SELECT 13, 3000, 10000 -- RMB  
UNION SELECT 2, 2000, 5000 -- RM  
UNION SELECT 4, 20000, 50000 -- TB 
UNION SELECT 15, 5000, 15000 -- IN 
UNION SELECT 45, 200000, 700000 --WON
UNION SELECT 51, 10000, 30000 -- INH  

--282 rows affected
INSERT INTO @tmpCust(custid, currency)
SELECT custid, currency
FROM custinfo WITH(NOLOCK)
WHERE srecommend IN (SELECT custid 
					FROM Dep_CustSuper WITH(NOLOCK)
					WHERE site = '12bet'
						And currency IN (13,2,4,15,45,51)
					)
	AND custid> @max_custid
	AND roleid = 1					


UPDATE cs
SET cs.maxbet = s.maxbet
FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN @tmpCust ci ON cs.custid = ci.custid
	INNER JOIN @tmpSettings s ON ci.currency = s.currency
WHERE cs.sporttype IN (183,185)
	AND cs.maxbet <> s.maxbet	

UPDATE ci
SET ci.maxpermatch183 = s.maxpermatch,
	ci.maxpermatch185 = s.maxpermatch
FROM custinfo ci WITH(UPDLOCK,ROWLOCK)
	INNER JOIN @tmpCust c ON ci.custid = c.custid	
	INNER JOIN @tmpSettings s ON c.currency = s.currency
WHERE ci.maxpermatch183 <> s.maxpermatch OR ci.maxpermatch185 <> s.maxpermatch	