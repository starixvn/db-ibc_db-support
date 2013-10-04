 /*
	Created: Johnson
	Date: 2013-09-12
	Task: Enable live casino for UUS currency under 3Star88 licensee
	DB: DBTXN/bodb02
 */
 
 --11325271 3star88SuperUUS
--11325274 3star88ACCUUS : dummy master
--SET PT = 93%

UPDATE CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = 0.93
WHERE CustID = 11325271
and Sporttype = 162
AND Bettype = 1101

GO

UPDATE cs
SET mpositiontaking = 0.93
FROM CustSettingGame cs
	inner join custInfo ci WITH(NOLOCK) ON cs.CustID = ci.custid and Sporttype = 162 AND Bettype = 1101
WHERE ci.srecommend = 11325271
AND ci.custid <> 11325274 --3star88ACCUUS
and ci.roleid = 3


GO

UPDATE cs
SET apositiontaking = 0.93
FROM CustSettingGame cs
	inner join custInfo ci WITH(NOLOCK) ON cs.CustID = ci.custid and Sporttype = 162 AND Bettype = 1101
WHERE ci.srecommend = 11325271
AND ci.mrecommend <> 11325274 --3star88ACCUUS
and ci.roleid IN (1, 2)

GO 

UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
SET syncLiveCasino = 1
WHERE srecommend = 11325271
and mrecommend <> 11325274

