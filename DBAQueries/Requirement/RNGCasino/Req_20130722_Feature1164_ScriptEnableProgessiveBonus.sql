/*
	created: Johnson
	Date: 2013-07-22
	Task: enable RNG progessive bonus for customer
*/ 

DECLARE @tmpCust TABLE(custid int)

--acguus3838: agentid = 1382167
--u3s :superid = 1426163

--downlines acguus3838 
INSERT INTO @tmpCust (custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE recommend = 1382167

--upline acguus3838
DECLARE @srecommend int, @mrecommend int

SELECT @srecommend = srecommend , @mrecommend = mrecommend
FROM custinfo WITH(NOLOCK)
WHERE custid = 1382167

INSERT INTO @tmpCust (custid)
SELECT @srecommend
UNION 
SELECT @mrecommend

--downlines u3s
--INSERT INTO @tmpcust(custid)
--SELECT custid 
--FROM custinfo WITH(NOLOCK)
--WHERE srecommend = 1426163

--update status of progressive bonus RNG

UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
SET DisableCasinoBonus = 1
WHERE custid NOT IN (SELECT custid FROM @tmpCust)
AND srecommend = @srecommend