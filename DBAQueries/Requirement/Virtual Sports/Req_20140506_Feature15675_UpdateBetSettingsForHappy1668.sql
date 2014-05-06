 /*
	Created: Johnson
	Date: 2014-05-06
	Task: Update virtual sports bet settings for Happy1668  
	DB: DBTXN/CustDB
 */
 
 --STEP 1: Delete existing settings of virtual Speedway and Cycling
--6 rows affected
 DELETE cs
 from Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
	inner join custInfo ci (nolock) on cs.custid = ci.custid
where srecommend = 13853422 --Happy1668SuperRMB	
	and mrecommend <>13853425 --Happy1668ACCRMB
	and sporttype IN (183,185)
GO

--Step2: copy settings from virtual soccer for virtual speedway & cycling
--588 rows affected
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
SELECT	cs.[custid]
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
	INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	CROSS APPLY (
			select 	183	sporttype,	1231 bettype
		union select 	185	,	1231		
	)t
WHERE srecommend = 13853422 --Happy1668SuperRMB	
	and mrecommend <>13853425 --Happy1668ACCRMB
	AND cs.sporttype = 180
GO

--STEP 3: Update max per match for all virtual sports
--set maxpermatch = 2000
--588 rows affected
UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
SET maxpermatch180 = 2000, 
	maxpermatch181 = 2000, 
	maxpermatch182 = 2000, 
	maxpermatch183 = 2000, 
	maxpermatch184 = 2000, 
	maxpermatch185 = 2000, 
	maxpermatch186 = 2000
WHERE srecommend = 13853422 --Happy1668SuperRMB	
	and mrecommend <>13853425 --Happy1668ACCRMB
GO
	
--Step 4: update min bet, max bet for all vitual sports
--set minbet = 10, maxbet = 2000
UPDATE cs
SET minbet = 10,
	maxbet = 2000
FROM Dep_custSetting3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE srecommend = 13853422 --Happy1668SuperRMB	
	and mrecommend <>13853425 --Happy1668ACCRMB
	AND cs.sporttype BETWEEN 180 and 186
GO
