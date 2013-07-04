


/*
	
	-- Update status for virtual soccer
*/

DECLARE @maxCustID INT

SET @maxCustID = xxx

-- 2955 rows
UPDATE custinfo WITH(ROWLOCK,UPDLOCK)
SET HideVirtualSports = 0,
	DisableVirtualSports = 0
WHERE srecommend IN (SELECT custid FROM f_depsuper_1('SunGame'))
	AND (HideVirtualSports = 1 or  DisableVirtualSports=1)
	AND custid <= @maxCustID
	
