/*
	Created: Johnson
	Date: 2014-09-18
	Task: Adjust PT settings for wrong customers
	DB: DBTXn/CustDB
*/  
--wrong pt S4 < S3 + M3
--MP2RMB(15003), MP7RMB(92131), MP9RMB (117405), MP1RMB (119927)
--MP10RMB (150089), MP12RMB (215901)

UPDATE mcs
SET mcs.spositiontaking = CASE WHEN mcs.spositiontaking + mcs.mpositiontaking > scs.spositiontaking THEN scs.spositiontaking - mcs.mpositiontaking ELSE mcs.spositiontaking END,
	mcs.slivepositiontaking = CASE WHEN mcs.slivepositiontaking + mcs.mlivepositiontaking > scs.slivepositiontaking THEN scs.slivepositiontaking - mcs.mlivepositiontaking ELSE mcs.slivepositiontaking END
FROM CustSetting mcs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN CustSetting scs WITH(NOLOCK) ON mcs.sporttype = scs.sporttype AND mcs.bettype = scs.bettype
WHERE mcs.custid IN (15003, 92131, 117405, 119927, 150089, 215901)
	AND scs.custid = 261425--SPR 
	AND (mcs.spositiontaking + mcs.mpositiontaking > scs.spositiontaking
	OR mcs.slivepositiontaking + mcs.mlivepositiontaking > scs.slivepositiontaking)
GO

UPDATE mcs
SET mcs.spositiontaking = CASE WHEN mcs.spositiontaking + mcs.mpositiontaking > scs.spositiontaking THEN scs.spositiontaking - mcs.mpositiontaking ELSE mcs.spositiontaking END,
	mcs.slivepositiontaking = CASE WHEN mcs.slivepositiontaking + mcs.mlivepositiontaking > scs.slivepositiontaking THEN scs.slivepositiontaking - mcs.mlivepositiontaking ELSE mcs.slivepositiontaking END
FROM CustSetting3rd mcs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN CustSetting3rd scs WITH(NOLOCK) ON mcs.sporttype = scs.sporttype AND mcs.bettype = scs.bettype
WHERE mcs.sporttype = 161
	AND mcs.custid IN (15003, 92131, 117405, 119927, 150089, 215901)
	AND scs.custid = 261425--SPR 
	AND (mcs.spositiontaking + mcs.mpositiontaking > scs.spositiontaking
	OR mcs.slivepositiontaking + mcs.mlivepositiontaking > scs.slivepositiontaking)
GO

--wrong M3 < N3
--VIA30 (423074), VIA31 (597212),VIA50 (614993),VIA32 (640117),VIA33 (690112)
UPDATE mcs
SET mcs.mpositiontaking = CASE WHEN mcs.mpositiontaking < mco.minpositiontaking THEN mco.minpositiontaking ELSE mcs.mpositiontaking END,
	mcs.mlivepositiontaking = CASE WHEN mcs.mlivepositiontaking < mco.minlivepositiontaking THEN mco.minlivepositiontaking ELSE mcs.mlivepositiontaking END
FROM CustSetting mcs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN CustOverride mco WITH(NOLOCK) ON mcs.custid = mco.custid AND mcs.sporttype = mco.sporttype AND mcs.bettype = mco.bettype
WHERE mcs.custid IN (423074,597212,614993,640117,690112)	
	AND (mcs.mpositiontaking < mco.minpositiontaking
	OR mcs.mlivepositiontaking < mco.minlivepositiontaking)
GO

--corect wrong m2+a2< n3
--VIA30 (423074), VIA31 (597212),VIA50 (614993),VIA32 (640117)
UPDATE acs
SET acs.mpositiontaking = CASE WHEN acs.isautompositiontaking = 0 AND acs.mpositiontaking + acs.apositiontaking < mco.minpositiontaking THEN mco.minpositiontaking - acs.apositiontaking ELSE acs.mpositiontaking END,
	acs.mlivepositiontaking = CASE WHEN acs.isautolivempositiontaking = 0 AND acs.mlivepositiontaking + acs.alivepositiontaking < mco.minlivepositiontaking THEN mco.minlivepositiontaking - acs.alivepositiontaking ELSE acs.mlivepositiontaking END
FROM CustSetting acs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON acs.custid = ci.custid
	INNER JOIN CustOverride mco WITH(NOLOCK) ON mco.custid = ci.mrecommend AND acs.sporttype = mco.sporttype AND acs.bettype = mco.bettype
WHERE ci.mrecommend IN (423074, 597212,614993,640117,690112)
	AND ci.roleid = 2	
	AND ((acs.isautompositiontaking = 0 AND acs.mpositiontaking + acs.apositiontaking < mco.minpositiontaking)
	OR (acs.isautolivempositiontaking = 0 AND acs.mlivepositiontaking + acs.alivepositiontaking < mco.minlivepositiontaking))
GO

--wrong N4 > S1 + M1 + A1
--Correct B26T downlines
--B26T (2508822)
EXEC Acc_CustSetting_04 @srecommend = 2508822, @roleid = 4


