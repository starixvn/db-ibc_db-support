 /*
	-- W88 licensee customers
	-- Update maxpermatch for virtual soccer
*/

DECLARE @maxCustID INT

SET @maxCustID = xxx

-- 76 rows  
UPDATE custinfo WITH(ROWLOCK,UPDLOCK)
SET maxpermatch180 = maxpermatch161
WHERE srecommend IN (SELECT custid FROM f_depsuper_1('W88'))
	AND (maxpermatch180 <> maxpermatch161 OR maxpermatch180 IS NULL)
	AND custid <= @maxCustID
	