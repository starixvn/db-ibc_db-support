 /*
	Created: Johnson
	Date: 2014-05-02
	Task: Update virtual sports settings for Boma365
	DB: DBTXN/CustDB
 */
 
 --STEP 1: Insert missing settings for virtual sports
 
INSERT INTO [Dep_CustSetting3rd]
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
SELECT	[custid]
       ,t.[bettype]
       ,t.[sporttype]
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
FROM Dep_CustSetting3rd cs WITH(NOLOCK)
	CROSS APPLY (
			select 	181	sporttype,	1231 bettype
		union select 	182	,	1231
		union select 	184	,	1231
		union select 	186	,	1220
	)t
WHERE custid IN (12910607, --Boma365SuperRMB
12910608, --Boma365RMB
12910609  --Boma365RMB01
)
	AND sporttype = 180	      
GO

--STEP 2: UPDATE max per match for all virtual sports
--set maxpermatch = 60000
--343 rows affected
UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
SET maxpermatch180 = 60000, 
	maxpermatch181 = 60000, 
	maxpermatch182 = 60000, 
	maxpermatch184 = 60000, 
	maxpermatch186 = 60000
WHERE srecommend = 12910607--Boma365SuperRMB
	AND mrecommend <> 12910726 --Boma365ACCRMB
GO

--STEP 3: Update Dep_CustSetting3rd
--PT: 85%, minbet = 1, maxbet = 20000
--1703 rows affected
UPDATE cs
SET spositiontaking = CASE WHEN roleid = 4 THEN 0.85 ELSE 0 END,
	mpositiontaking = CASE WHEN roleid IN (3,4) then 0.85 else 0 END,
	apositiontaking = CASE WHEN roleid IN (1,2,4) then 0.85 else 0 END,
	minbet = 1,
	maxbet = 20000
FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend = 12910607
	AND ci.mrecommend <> 12910726
	AND cs.sporttype IN (180,181,182,184,186) 

	
