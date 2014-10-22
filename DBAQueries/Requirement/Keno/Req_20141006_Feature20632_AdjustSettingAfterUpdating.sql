/*
	Created: Logan
	Date: 2014-10-06
	Task: Adjust Keno settings for credit customers after finish updating
	DB: DBTXN/CustDB
*/ 
    --CustSettingGame
	UPDATE csk WITH(ROWLOCK, UPDLOCK)
       SET csk.apositiontaking = csn.apositiontaking
	     , csk.mpositiontaking = csn.mpositiontaking
	     , csk.spositiontaking = csn.spositiontaking
	     , csk.playerdiscount  = csn.playerdiscount
	     , csk.discount        = csn.discount
	     , csk.adiscount       = csn.adiscount
	     , csk.sdiscount       = csn.sdiscount
	     , csk.autopositiontaking    = csn.autopositiontaking
	     , csk.isautopositiontaking  = csn.isautopositiontaking
	     , csk.autompositiontaking   = csn.autompositiontaking
	     , csk.isautompositiontaking = csn.isautompositiontaking
      FROM CustSettingGame csk
INNER JOIN CustSetting3rd csn WITH(NOLOCK) ON csk.CustID = csn.CustID
INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid = csn.CustID
     WHERE csk.Sporttype = 202
       AND csn.Sporttype = 161
       AND csn.bettype   = 81
       AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
       AND (csk.apositiontaking <> csn.apositiontaking
            OR csk.mpositiontaking <> csn.mpositiontaking
	        OR csk.spositiontaking <> csn.spositiontaking
	        OR csk.playerdiscount  <> csn.playerdiscount
	        OR csk.discount        <> csn.discount
	        OR csk.adiscount       <> csn.adiscount
	        OR csk.sdiscount       <> csn.sdiscount
	        OR csk.autopositiontaking    <> csn.autopositiontaking
	        OR csk.isautopositiontaking  <> csn.isautopositiontaking
	        OR csk.autompositiontaking   <> csn.autompositiontaking
	        OR csk.isautompositiontaking <> csn.isautompositiontaking)

    --CustOverrideGame
    UPDATE cok WITH(ROWLOCK, UPDLOCK)
       SET cok.minpositiontaking = con.minpositiontaking
      FROM custoverrideGame cok
INNER JOIN custOverride3rd con WITH(NOLOCK) ON cok.custid = con.custid
INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid = cok.CustID
     WHERE cok.Sporttype = 202
       AND con.Sporttype = 161
       AND con.bettype   = 81
       AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
       AND ci.roleid <> 1
       AND cok.minpositiontaking <> con.minpositiontaking

    --CustSettingGame
    UPDATE csg WITH(ROWLOCK, UPDLOCK)
       SET csg.MinBet = csn.minbet
         , csg.MaxBet = csn.maxbet
         , csg.MaxPerGameType = ci.maxpermatch161
      FROM CustGameType csg
INNER JOIN CustSetting3rd csn WITH(NOLOCK) ON csg.CustID = csn.CustID
INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid = csg.CustID
     WHERE csn.Sporttype = 161
       AND csn.bettype   = 81
       AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
       AND (csg.MinBet <> csn.minbet
            OR csg.MaxBet <> csn.maxbet
            OR csg.MaxPerGameType <> ci.maxpermatch161
           )