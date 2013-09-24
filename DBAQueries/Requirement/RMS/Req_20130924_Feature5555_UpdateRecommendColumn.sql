USE bodb_RMS
GO

DECLARE @fromdate datetime, @todate datetime

select @fromdate = '2013-01-01',
@todate = '2013-09-30'

UPDATE s
SET s.recommend = ci.recommend
from rmSumWinloss_Old s with(UPDLOCK,ROWLOCK)
INNER join bodb02.dbo.custInfo ci WITH(NOLOCK) ON s.custid = ci.custid
where winlostdate BETWEEN @fromdate and @todate
