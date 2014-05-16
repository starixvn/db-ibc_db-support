/*
	Created: Johnson
	Date: 2014-05-13
	Task: Zerorise 12bet Dormant Accounts
	DB: DBTXN/bodb02
*/ 
CREATE TABLE #tmpCust(custid INT PRIMARY KEY, currency INT,closingBalance MONEY, isfinished BIT DEFAULT(0))

INSERT INTO #tmpCust(custid,currency)
SELECT custid,currency
FROM CustDB.dbo.CustInfo WITH(NOLOCK)
WHERE custid IN (SELECT custid FROM DB054.bodb02.dbo.Cust12bet_tmp WITH(NOLOCK))

--Get closing balance for dormant accounts
UPDATE t
SET t.closingBalance = b.balance
FROM #tmpCust t
INNER JOIN 
(
	SELECT custid,ISNULL(SUM(winlost-actual_stake+playercomm),0) as balance
	FROM bettrans b WITH(NOLOCK) 
	WHERE custid IN (SELECT custid from #tmpCust)
	GROUP BY custid
)b ON b.custid = t.custid

--Get the list dummy dormant accounts for transfering balance
CREATE TABLE #DomAccounts (custid INT, currency TINYINT, isfinished BIT DEFAULT(0))
INSERT INTO #DomAccounts(custid,currency)
SELECT 9512908,    9--12BETAUDDOM
UNION ALL
SELECT 9512918,    6--12BETEURDOM
UNION ALL
SELECT 9512922,    12--12BETGBPDOM
UNION ALL
SELECT 9512926,    15--12BETINDOM
UNION ALL
SELECT 9512933,    51--12BETINHDOM
UNION ALL
SELECT 9512945,    13--12BETRMBDOM
UNION ALL
SELECT 9512941,    2--12BETRMDOM
UNION ALL
SELECT 9512949,    4--12BETTBDOM
UNION ALL
SELECT 9512959,    3--12BETUS$DOM
GO

--Clear balance for dormant accounts
SELECT 'EXEC Dot_Dep_BettransInsTransaction_Cust
			@amount	=	'+ convert(varchar(12),-ClosingBalance)+',
			@custid	=	'+ convert(varchar(12),t.custid)+',
			@bal_custid	=	'+ convert(varchar(12),c.custid)+',
			@transdesc = ''clear member balance'''
FROM #tmpCust t
	INNER JOIN #DomAccounts c ON t.currency = c.currency		
where closingBalance <> 0			
