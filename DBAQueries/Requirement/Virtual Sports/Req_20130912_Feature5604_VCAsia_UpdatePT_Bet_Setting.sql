 /*
	Created: Johnson
	Date: 2013-09-12
	Task: Enable virtual sports for VCAsia licensees
	DB: DBTXN/bodb02
 */


 --2121 customers affected
 
 UPDATE cs3
 SET cs3.minbet = cs.minbet,
	cs3.maxbet = cs.maxbet,
	cs3.spositiontaking = cs.spositiontaking,
	cs3.mpositiontaking = cs.mpositiontaking,
	cs3.apositiontaking = cs.apositiontaking
 FROM Dep_CustSetting3rd cs3 WITH(NOLOCK)
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs3.custid = ci.custid
	INNER JOIN Dep_CustSetting cs WITH(NOLOCK)  ON cs.custid = cs3.custid  AND cs.sporttype = 1 AND cs.bettype = 1 AND cs.islive = 0
											AND cs3.sporttype IN (180,181,186)
WHERE srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE site = 'VCAsia')												
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
SET maxpermatch180 = maxpermatch,
	maxpermatch181 = maxpermatch,
	maxpermatch186 = maxpermatch,
	HideVirtualSports = 0,
	DisableVirtualSports = 0
WHERE srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE site = 'VCAsia')												
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
	

--Insert setting for customers have not yet setting on Virtual soccer, racing, tennis
--virtual soccer
INSERT INTO [bodb02].[dbo].[Dep_CustSetting3rd]
           ([custid]
           ,[bettype]
           ,[sporttype]
           ,[islive]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[minbet]
           ,[maxbet])
SELECT 
			cs.[custid]
           ,1201 as [bettype]
           ,180 as [sporttype]
           ,0 as [islive]
           ,cs.[apositiontaking]
           ,cs.[mpositiontaking]
           ,cs.[spositiontaking]
           ,0 as [playerdiscount]
           ,0 as [discount]
           ,0 as [adiscount]
           ,0 as [sdiscount]
           ,cs.[minbet]
           ,cs.[maxbet]
FROM [Dep_CustSetting] cs WITH(NOLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid AND cs.sporttype =1 and cs.bettype = 1 and cs.islive = 0
	LEFT JOIN [Dep_CustSetting3rd] cs3 WITH(NOLOCK) ON cs3.custid = ci.custid AND cs3.sporttype = 180
WHERE ci.srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE site = 'VCAsia')
AND cs3.custid IS NULL

GO
--virtual racing
INSERT INTO [bodb02].[dbo].[Dep_CustSetting3rd]
           ([custid]
           ,[bettype]
           ,[sporttype]
           ,[islive]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[minbet]
           ,[maxbet])
SELECT 
			cs.[custid]
           ,1231 as [bettype]
           ,181 as [sporttype]
           ,0 as [islive]
           ,cs.[apositiontaking]
           ,cs.[mpositiontaking]
           ,cs.[spositiontaking]
           ,0 as [playerdiscount]
           ,0 as [discount]
           ,0 as [adiscount]
           ,0 as [sdiscount]
           ,cs.[minbet]
           ,cs.[maxbet]
FROM [Dep_CustSetting] cs WITH(NOLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid AND cs.sporttype =1 and cs.bettype = 1 and cs.islive = 0
	LEFT JOIN [Dep_CustSetting3rd] cs3 WITH(NOLOCK) ON cs3.custid = ci.custid AND cs3.sporttype = 181
WHERE ci.srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE site = 'VCAsia')
AND cs3.custid IS NULL
 
 
 GO
--virtual tennis
INSERT INTO [bodb02].[dbo].[Dep_CustSetting3rd]
           ([custid]
           ,[bettype]
           ,[sporttype]
           ,[islive]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[minbet]
           ,[maxbet])
SELECT 
			cs.[custid]
           ,1220 as [bettype]
           ,186 as [sporttype]
           ,0 as [islive]
           ,cs.[apositiontaking]
           ,cs.[mpositiontaking]
           ,cs.[spositiontaking]
           ,0 as [playerdiscount]
           ,0 as [discount]
           ,0 as [adiscount]
           ,0 as [sdiscount]
           ,cs.[minbet]
           ,cs.[maxbet]
FROM [Dep_CustSetting] cs WITH(NOLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid AND cs.sporttype =1 and cs.bettype = 1 and cs.islive = 0
	LEFT JOIN [Dep_CustSetting3rd] cs3 WITH(NOLOCK) ON cs3.custid = ci.custid AND cs3.sporttype = 186
WHERE ci.srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE site = 'VCAsia')
AND cs3.custid IS NULL
       		      		