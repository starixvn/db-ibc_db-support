

/*
	
	-- Update maxpermatch for virtual soccer
*/

DECLARE @maxCustID INT

SET @maxCustID = xxx

-- 0 rows  --- just for preparing in case of existing
UPDATE custinfo WITH(ROWLOCK,UPDLOCK)
SET maxpermatch180 = maxpermatch161
WHERE srecommend IN (SELECT custid FROM f_depsuper_1('Asiabet88'))
	AND (maxpermatch180 <> maxpermatch161 OR maxpermatch180 IS NULL)
	AND custid <= @maxCustID
	
	
