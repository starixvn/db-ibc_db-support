 
 /*
	Clear old data - test currency
 */
-- 276
DELETE CustSetting3rd WITH(ROWLOCK,UPDLOCK)
WHERE --(bettype = 1220 AND sporttype = 186) OR
		(bettype = 1231 AND sporttype = 181)
	
	
-- 72
DELETE CustOverride3rd WITH(ROWLOCK,UPDLOCK)
WHERE --(bettype = 1220 AND sporttype = 186) OR
		(bettype = 1231 AND sporttype = 181)
