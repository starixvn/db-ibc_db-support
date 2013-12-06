    /*
	Created: Johnson
	Date: 2013-11-08
	Task: Enable RNG casino, live casino for all currencies under zzun88 licensee
	DB: DBTXN/bodb02
 */
 
 --SET PT = 93%
 
 --2049 customers affected
 
UPDATE cs
SET spositiontaking = CASE WHEN roleid =4 THEN 0.93  ELSE 0 END,
	mpositiontaking = CASE WHEN roleid =3 THEN 0.93 ELSE 0 END,
	apositiontaking = CASE WHEN roleid IN (1,2) THEN 0.93 ELSE 0 END
FROM CustSettingGame cs
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid and Sporttype = 162 AND Bettype = 1101
WHERE srecommend IN (select custid from Dep_CustSuper with(nolock) where site = 'ZZun88')
AND mrecommend NOT IN (			
		3544919,	--	Z88ACCUUS
		3762050,	--	Z88ACCRMB
		3762113,	--	Z88ACCUS$
		7596373,	--	Z88ACCEURO
		9432191	--	Z88ACCRM	
)


GO


UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
SET SyncLiveCasino = 1, DisableLiveCasino = 0,
	SyncCasino = 1, DisableCasino = 0
WHERE srecommend IN (select custid from Dep_CustSuper with(nolock) where site = 'ZZun88')
AND mrecommend NOT IN (
	3544919,	--	Z88ACCUUS
		3762050,	--	Z88ACCRMB
		3762113,	--	Z88ACCUS$
		7596373,	--	Z88ACCEURO
		9432191	--	Z88ACCRM	
)