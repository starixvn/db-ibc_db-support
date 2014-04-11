


/*
	
	-- Update maxpermatch for virtual soccer
*/

DECLARE @maxCustID INT

SET @maxCustID = xx

-- 2948 rows
UPDATE custinfo WITH(ROWLOCK,UPDLOCK)
SET maxpermatch180 = maxpermatch161
WHERE srecommend IN (SELECT custid FROM f_depsuper_1('SunGame'))
	AND maxpermatch180 <> maxpermatch161
	AND custid <= @maxCustID