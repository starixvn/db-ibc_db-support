  /*
	Created: Johnson
	Date: 2013-09-12
	Task: Enable live casino for UUS currency under 67bet licensee
	DB: DBTXN/bodb02
 */
 
 --11232121	67BetSuperUUS
--11232297  67BetAccUUS	: dummy master
--SET PT = 93%

--23 customers affected
UPDATE cs
SET spositiontaking = CASE WHEN roleid =4 THEN 0.93  ELSE 0 END,
	mpositiontaking = CASE WHEN roleid =3 THEN 0.93 ELSE 0 END,
	apositiontaking = CASE WHEN roleid IN (1,2) THEN 0.93 ELSE 0 END
FROM CustSettingGame cs
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid and Sporttype = 162 AND Bettype = 1101
WHERE srecommend = 11232121
AND mrecommend <> 11232297


GO

UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
SET SyncLiveCasino = 1
WHERE srecommend = 11232121
AND mrecommend <> 11232297
