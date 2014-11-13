  /*
	Created: Johnson
	Date: 2014-11-06
	Task: Copy settings for tennis others bettype from tennis handicap bettype
	DB: DBTXN/CustDB
 */
 
 UPDATE cs1
	set cs1.spositiontaking = cs2.spositiontaking,
		cs1.mpositiontaking = cs2.mpositiontaking,
		cs1.apositiontaking = cs2.apositiontaking,
		cs1.autopositiontaking = cs2.autopositiontaking,
		cs1.autompositiontaking = cs2.autompositiontaking,
		cs1.isautopositiontaking = cs2.isautopositiontaking,
		cs1.isautompositiontaking = cs2.isautompositiontaking,
		cs1.minbet = cs2.minbet,
		cs1.maxbet = cs2.maxbet,
		cs1.playerdiscount = cs2.playerdiscount,
		cs1.discount = cs2.discount,
		cs1.adiscount = cs2.adiscount,
		cs1.sdiscount = cs2.sdiscount, 
		cs1.groupa = cs2.groupa,  
		cs1.groupb = cs2.groupb,
		cs1.groupc = cs2.groupc,
		cs1.groupd = cs2.groupd, 
		cs1.groupe = cs2.groupe,
		cs1.groupf = cs2.groupf 
	from CustSetting cs1 with(UPDLOCK,ROWLOCK)
		INNER JOIN custInfo ci with(nolock) on cs1.custid = ci.custid
		INNER JOIN CustSetting cs2 WITH(NOLOCK) ON cs2.custid = ci.custid
	where srecommend NOT IN (SELECT custid FROM Dep_custSuper WITH(NOLOCK))
		AND cs1.sporttype = 5 AND cs1.bettype = 9999
		AND cs2.sporttype = 5 AND cs2.bettype = 1
		AND (
					cs1.spositiontaking <> cs2.spositiontaking
				OR	cs1.mpositiontaking <> cs2.mpositiontaking
				OR	cs1.apositiontaking <> cs2.apositiontaking
				OR	cs1.autopositiontaking <> cs2.autopositiontaking
				OR	cs1.autompositiontaking <> cs2.autompositiontaking
				OR	cs1.isautopositiontaking <> cs2.isautopositiontaking
				OR	cs1.isautompositiontaking <> cs2.isautompositiontaking
				
				OR	cs1.minbet <> cs2.minbet
				OR	cs1.maxbet <> cs2.maxbet
				
				OR	cs1.playerdiscount <> cs2.playerdiscount
				OR	cs1.discount <> cs2.discount
				OR	cs1.adiscount <> cs2.adiscount
				OR	cs1.sdiscount <> cs2.sdiscount 
				OR	cs1.groupa <> cs2.groupa
				OR 	cs1.groupb <> cs2.groupb
				OR 	cs1.groupc <> cs2.groupc
				OR 	cs1.groupd <> cs2.groupd
				OR 	cs1.groupe <> cs2.groupe
				OR 	cs1.groupf <> cs2.groupf 
		)
GO
		
	UPDATE cs1
	SET cs1.minpositiontaking = cs2.minpositiontaking,
		cs1.maxpositiontaking = cs2.maxpositiontaking		
	FROM CustOverride cs1 with(UPDLOCK,ROWLOCK)
		INNER JOIN custInfo ci WITH(NOLOCK) ON cs1.custid = ci.custid
		INNER JOIN CustOverride cs2 WITH(NOLOCK) ON cs2.custid = ci.custid
	WHERE srecommend NOT IN (SELECT custid FROM Dep_custSuper WITH(NOLOCK))		
		AND ci.roleid IN (2,3,4)	
		AND cs1.sporttype = 5 AND cs1.bettype = 9999
		AND cs2.sporttype = 5 AND cs2.bettype = 1		
		AND 
		(
			cs1.minpositiontaking <> cs2.minpositiontaking
			OR cs1.maxpositiontaking <> cs2.maxpositiontaking
		)