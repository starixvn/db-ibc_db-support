 /*
	20131105@Lukas
	Enable Virtual Tennis and Virtual Horse Racing for UUS licensees below
	'12bet','W88','VCAsia','TLC','Sungame','asiabet88','Alog','Bodog'	
*/

	
	--1844 rows affected
	UPDATE vs WITH(ROWLOCK,UPDLOCK)
	SET  minbet = ng.minbet
		,maxbet = ng.maxbet
		,vs.apositiontaking = ng.apositiontaking			
		,vs.mpositiontaking = ng.mpositiontaking
		,vs.spositiontaking = ng.spositiontaking
	from custInfo c witH(nolock)
		inner join Dep_CustSetting3rd vs on c.custid = vs.custid and vs.sporttype in (181,186)
		inner join Dep_CustSetting3rd ng with(nolock) on c.custid = ng.custid and ng.sporttype = 161 and ng.bettype = 81
	where c.srecommend in (
							SELECT custid
							from Dep_CustSuper with(nolock) 
							where site in ('12bet','W88','VCAsia','TLC','Sungame','asiabet88','Alog','Bodog')
							and currency = 20
							)
	AND
		(		
			vs.minbet <> ng.minbet
			OR
			vs.maxbet <> ng.maxbet
			OR
			vs.apositiontaking <> ng.apositiontaking
			OR 
			vs.mpositiontaking <> ng.mpositiontaking
			OR 
			vs.spositiontaking <> ng.spositiontaking
		)
	
GO




--update maxpermatch, disableVirtualSports, HideVirtualSports	

-- 1001 rows affected	
	UPDATE custinfo WITH(ROWLOCK,UPDLOCK)
	SET  maxpermatch181 = maxpermatch161
		,maxpermatch186 = maxpermatch161
		,DisableVirtualSports = 0 
		,HideVirtualSports = 0	
	where srecommend in (
							SELECT custid
							from Dep_CustSuper with(nolock) 
							where site in ('12bet','W88','VCAsia','TLC','Sungame','asiabet88','Alog','Bodog')
							and currency = 20
							)
	AND (
		DisableVirtualSports = 1 
		OR HideVirtualSports = 1
		OR maxpermatch181 <> maxpermatch161 
		OR maxpermatch186 <> maxpermatch161 
		OR maxpermatch181 IS NULL
		OR maxpermatch186 IS NULL	
		)	
