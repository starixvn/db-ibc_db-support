 /*
	Created: Johnson
	Date: 2013-09-12
	Task: Enable virtual sports for VCAsia licensees
	DB: DBTXN/bodb02
 */


 --2121 customers affected
 
 UPDATE cs3
 SET cs3.minbet = r.minbet,
	cs3.maxbet = r.maxbet,
	cs3.spositiontaking = case when ci.roleid = 4 then 0.85 else 0 end,
	cs3.mpositiontaking = case when ci.roleid in (3,4) then 0.85 else 0 end,
	cs3.apositiontaking = case when ci.roleid in (1,2,4) then 0.85 else 0 end
 FROM Dep_CustSetting3rd cs3 WITH(NOLOCK)
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs3.custid = ci.custid AND cs3.sporttype IN (180,181,186)
	INNER JOIN (
			SELECT ds.currency, cs.minbet, cs.maxbet
			FROM  Dep_CustSetting cs WITH(NOLOCK) 
				INNER JOIN  Dep_CustSuper ds WITH(NOLOCK) ON cs.custid = ds.custid  AND cs.sporttype = 1 AND cs.bettype = 1 AND cs.islive = 0
				WHERE site = 'VCAsia') r ON ci.currency = r.currency
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

UPDATE ci
SET maxpermatch180 = r.maxpermatch,
	maxpermatch181 = r.maxpermatch,
	maxpermatch186 = r.maxpermatch,
	HideVirtualSports = 0,
	DisableVirtualSports = 0
FROM CustInfo ci 
	INNER JOIN 	(
			SELECT c.currency, maxpermatch
			FROM  custinfo c WITH(NOLOCK) 
				INNER JOIN  Dep_CustSuper ds WITH(NOLOCK) ON c.custid = ds.custid  
				WHERE site = 'VCAsia') r ON ci.currency = r.currency				
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
			ci.[custid]
           ,1201 as [bettype]
           ,180 as [sporttype]
           ,0 as [islive]
           ,case when roleid in (1,2,4) then 0.85 else 0 end as apositiontaking
           ,case when roleid in (3,4) then 0.85 else 0 end as mpositiontaking 
           ,case when roleid = 4 then 0.85 else 0 end as spositiontaking
           ,0 as [playerdiscount]
           ,0 as [discount]
           ,0 as [adiscount]
           ,0 as [sdiscount]
           ,r.[minbet]
           ,r.[maxbet]
FROM custinfo ci WITH(NOLOCK) 
	INNER JOIN (
			SELECT ds.currency, cs.minbet, cs.maxbet
			FROM  Dep_CustSetting cs WITH(NOLOCK) 
				INNER JOIN  Dep_CustSuper ds WITH(NOLOCK) ON cs.custid = ds.custid  AND cs.sporttype = 1 AND cs.bettype = 1 AND cs.islive = 0
				WHERE site = 'VCAsia') r ON ci.currency = r.currency
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
			ci.[custid]
           ,1231 as [bettype]
           ,181 as [sporttype]
           ,0 as [islive]
		   ,case when roleid in (1,2,4) then 0.85 else 0 end as apositiontaking
           ,case when roleid in (3,4) then 0.85 else 0 end as mpositiontaking 
           ,case when roleid = 4 then 0.85 else 0 end as spositiontaking
           ,0 as [playerdiscount]
           ,0 as [discount]
           ,0 as [adiscount]
           ,0 as [sdiscount]
           ,r.[minbet]
           ,r.[maxbet]
FROM custinfo ci WITH(NOLOCK) 
	INNER JOIN (
			SELECT ds.currency, cs.minbet, cs.maxbet
			FROM  Dep_CustSetting cs WITH(NOLOCK) 
				INNER JOIN  Dep_CustSuper ds WITH(NOLOCK) ON cs.custid = ds.custid  AND cs.sporttype = 1 AND cs.bettype = 1 AND cs.islive = 0
				WHERE site = 'VCAsia') r ON ci.currency = r.currency
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
			ci.[custid]
           ,1220 as [bettype]
           ,186 as [sporttype]
           ,0 as [islive]
		   ,case when roleid in (1,2,4) then 0.85 else 0 end as apositiontaking
           ,case when roleid in (3,4) then 0.85 else 0 end as mpositiontaking 
           ,case when roleid = 4 then 0.85 else 0 end as spositiontaking
           ,0 as [playerdiscount]
           ,0 as [discount]
           ,0 as [adiscount]
           ,0 as [sdiscount]
           ,r.[minbet]
           ,r.[maxbet]
FROM custinfo ci WITH(NOLOCK) 
	INNER JOIN (
			SELECT ds.currency, cs.minbet, cs.maxbet
			FROM  Dep_CustSetting cs WITH(NOLOCK) 
				INNER JOIN  Dep_CustSuper ds WITH(NOLOCK) ON cs.custid = ds.custid  AND cs.sporttype = 1 AND cs.bettype = 1 AND cs.islive = 0
				WHERE site = 'VCAsia') r ON ci.currency = r.currency
	LEFT JOIN [Dep_CustSetting3rd] cs3 WITH(NOLOCK) ON cs3.custid = ci.custid AND cs3.sporttype = 186
WHERE ci.srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE site = 'VCAsia')
AND cs3.custid IS NULL