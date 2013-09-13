   /*
	Created: Johnson
	Date: 2013-09-12
	Task: Enable live casino for UUS currency under 67bet licensee
	DB: DBTXN/bodb02
 */
 
--SET PT = 93%

--2135 customers affected
UPDATE cs
SET spositiontaking = CASE WHEN roleid =4 THEN 0.93  ELSE 0 END,
	mpositiontaking = CASE WHEN roleid =3 THEN 0.93 ELSE 0 END,
	apositiontaking = CASE WHEN roleid IN (1,2) THEN 0.93 ELSE 0 END
FROM CustSettingGame cs
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid and Sporttype = 162 AND Bettype = 1101
WHERE srecommend IN (select custid from Dep_CustSuper with(nolock) where site = 'vcasia')
AND mrecommend NOT IN (
	4846113	,--	VCasiaACCUUS
	7140579	,--	VCasiaAccGBP
	7140724	,--	VcasiaAccEuro
	7140783	,--	VcasiaAccUS$
	7140847	,--	VcasiaAccAUD
	7141003	,--	VcasiaAccSD$
	7141071	--	VcasiaAccRMB	
)


GO

UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
SET SyncLiveCasino = 1
WHERE srecommend IN (select custid from Dep_CustSuper with(nolock) where site = 'vcasia')
AND mrecommend NOT IN (
	4846113	,--	VCasiaACCUUS
	7140579	,--	VCasiaAccGBP
	7140724	,--	VcasiaAccEuro
	7140783	,--	VcasiaAccUS$
	7140847	,--	VcasiaAccAUD
	7141003	,--	VcasiaAccSD$
	7141071	--	VcasiaAccRMB	
)