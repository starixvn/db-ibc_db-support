 /*
	Created: Johnson
	Date: 20131119
	Task: Insert virtual horse racing , virtual tennis setting for SunGame Licensee	
		Copy minbet, maxbet setting from virtual soccer		
		PT = 85%
	DB: DBTNX/bodb02
 */
 
 --step 1: clear old setting of virtual horse racing, virtual tennis for SUGSuperUUS
 --3544528,	--	SUGSuperUUS
 
 --128 rows affected
 DELETE cs
 FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid AND cs.sporttype IN (181,186)
WHERE ci.srecommend = 3544528
GO	
 
 
 --step 2: correct pt on virtual soccer
 --7596152	,--	SUGSuperEURO pt = 80%
 UPDATE Dep_CustSetting3rd WITH(UPDLOCK,ROWLOCK)
 SET spositiontaking = 0.85,
	mpositiontaking = 0.85,
	apositiontaking = 0.85
WHERE custid = 7596152 AND sporttype = 180 AND bettype = 1201
GO


--step 3: Copy setting from virtual soccer for virtual horse racing
--6633 rows affected

INSERT INTO [dbo].[Dep_CustSetting3rd]
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
SELECT cs.[custid]
           ,1231 as [bettype]
           ,181 as [sporttype]
           ,[islive]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[minbet]
           ,[maxbet]
FROM Dep_CustSetting3rd cs with(nolock)
	INNER JOIN custInfo ci with(nolock) on cs.custid = ci.custid and sporttype = 180
WHERE ci.srecommend IN(	
	3544528	,--	SUGSuperUUS
	3544695	,--	SUGSuperTB
	3544783	,--	SUGSuperIN
	3578505	,--	SUGSuperRM
	4899808	,--	SUGSuperRMB
	4899913	,--	SUGSuperUS$
	4900001	,--	SUGSuperINH
	7596152	,--	SUGSuperEURO
	12931098	--	SUGSuperJPY
)
AND mrecommend NOT IN (
	3544588	,--	SUGACCUUS
	3544751	,--	SUGACCTB
	3544821	,--	SUGACCIN
	3544669	,--	SUGACCRM
	4900819	,--	SUGACCRMB
	4900864	,--	SUGACCUS$
	4900911	,--	SUGACCINH
	7596159	,--	SUGACCEURO
	12931147	--	SUGACCJPY
)
GO


-- Copy setting from virtual soccer for virtual tennis
--6633 rows affected
INSERT INTO [dbo].[Dep_CustSetting3rd]
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
SELECT cs.[custid]
           ,1220 as [bettype]
           ,186 as [sporttype]
           ,[islive]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[minbet]
           ,[maxbet]
FROM Dep_CustSetting3rd cs with(nolock)
	INNER JOIN custInfo ci with(nolock) on cs.custid = ci.custid and sporttype = 180
WHERE ci.srecommend IN(	
	3544695	,--	SUGSuperTB
	3544783	,--	SUGSuperIN
	3578505	,--	SUGSuperRM
	4899808	,--	SUGSuperRMB
	4899913	,--	SUGSuperUS$
	4900001	,--	SUGSuperINH
	7596152	,--	SUGSuperEURO
	12931098	--	SUGSuperJPY
)
AND mrecommend NOT IN (
	3544751	,--	SUGACCTB
	3544821	,--	SUGACCIN
	3544669	,--	SUGACCRM
	4900819	,--	SUGACCRMB
	4900864	,--	SUGACCUS$
	4900911	,--	SUGACCINH
	7596159	,--	SUGACCEURO
	12931147	--	SUGACCJPY
)
GO

--step 4: Copy maxpermatch from virtual soccer for virtual horse racing , virtual tennis
--and enable virtual sports for sungame
---6633 rows affected

UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
SET maxpermatch181 = maxpermatch180, 
	maxpermatch186 = maxpermatch180,
	HideVirtualSports = 0, 
	DisableVirtualSports = 0
WHERE srecommend IN(	
	3544695	,--	SUGSuperTB
	3544783	,--	SUGSuperIN
	3578505	,--	SUGSuperRM
	4899808	,--	SUGSuperRMB
	4899913	,--	SUGSuperUS$
	4900001	,--	SUGSuperINH
	7596152	,--	SUGSuperEURO
	12931098	--	SUGSuperJPY
)
AND mrecommend NOT IN (
	3544751	,--	SUGACCTB
	3544821	,--	SUGACCIN
	3544669	,--	SUGACCRM
	4900819	,--	SUGACCRMB
	4900864	,--	SUGACCUS$
	4900911	,--	SUGACCINH
	7596159	,--	SUGACCEURO
	12931147	--	SUGACCJPY
)	 