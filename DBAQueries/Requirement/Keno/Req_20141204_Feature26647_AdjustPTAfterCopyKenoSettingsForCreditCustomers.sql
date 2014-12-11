 /*
	Created: Johnson
	Date: 2014-12-04
	Task: adjust Keno settings after copying for credit customers
	DB: DBTXN/CustDB
 */
 
--STEP 1: Adjust settings for credit customers

CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4
GO

	
--adjust [CustSettingGame]
UPDATE cs1
SET cs1.[apositiontaking] = cs2.[apositiontaking]
   ,cs1.[mpositiontaking] = cs2.[mpositiontaking]
   ,cs1.[spositiontaking] = cs2.[spositiontaking]
   ,cs1.[playerdiscount] = cs1.[playerdiscount]
   ,cs1.[discount] = cs2.[discount]
   ,cs1.[adiscount] = cs2.[adiscount]
   ,cs1.[sdiscount] = cs2.[sdiscount]
   ,cs1.[autopositiontaking] = cs2.[autopositiontaking]
   ,cs1.[isautopositiontaking] = cs2.[isautopositiontaking]
   ,cs1.[autompositiontaking] = cs2.[autompositiontaking]
   ,cs1.[isautompositiontaking] = cs2.[isautompositiontaking]
FROM [CustSettingGame] cs1 WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK)	ON ci.custid = cs1.custid
	INNER JOIN [CustSettingGame] cs2 WITH(NOLOCK) ON cs2.custid = ci.custid
WHERE ci.srecommend IN (SELECT custid FROM #supers)
	AND cs2.sporttype = 202	AND cs2.bettype = 1501		
	AND cs1.sporttype = 202	AND cs1.bettype = 1514		
	AND (
		cs1.[apositiontaking] <> cs2.[apositiontaking]
	   OR cs1.[mpositiontaking] <> cs2.[mpositiontaking]
	   OR cs1.[spositiontaking] <> cs2.[spositiontaking]
	   OR cs1.[playerdiscount] <> cs1.[playerdiscount]
	   OR cs1.[discount] <> cs2.[discount]
	   OR cs1.[adiscount] <> cs2.[adiscount]
	   OR cs1.[sdiscount] <> cs2.[sdiscount]
	   OR cs1.[autopositiontaking] <> cs2.[autopositiontaking]
	   OR cs1.[isautopositiontaking] <> cs2.[isautopositiontaking]
	   OR cs1.[autompositiontaking] <> cs2.[autompositiontaking]
	   OR cs1.[isautompositiontaking] <> cs2.[isautompositiontaking]
	)
GO
	
--adjust CustOverrideGame
UPDATE co1
SET co1.minpositiontaking = co2.minpositiontaking
FROM [CustOverrideGame] co1 WITH(UPDLOCK,ROWLOCK)	
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = co1.custid	 
		INNER JOIN [CustOverrideGame] co2 WITH(NOLOCK) ON co2.custid = ci.custid
WHERE ci.srecommend  IN (SELECT custid FROM #supers)
	AND co2.sporttype = 202	AND co2.bettype = 1501		
	AND co1.sporttype = 202	AND co1.bettype = 1514		
	AND co2.minpositiontaking <> co1.minpositiontaking
GO

--adjust [CustGameType]
UPDATE cg1
SET cg1.[StakeLevelList] = cg2.[StakeLevelList]
   ,cg1.[MaxPerGameType] = cg2.[MaxPerGameType]
   ,cg1.[MinBet] = cg2.[MinBet]
   ,cg1.[MaxBet] = cg2.[MaxBet]
   ,cg1.[IsDisabled] = cg2.[IsDisabled]
FROM [CustGameType] cg1 WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cg1.custid = ci.custid
	INNER JOIN [CustGameType] cg2 WITH(NOLOCK) ON cg2.custid = ci.custid
WHERE ci.srecommend IN (SELECT custid FROM #supers)
	AND cg1.gameTypeID = 14	
	AND cg2.GameTYpeID = 1
	AND ( cg1.[StakeLevelList] <> cg2.[StakeLevelList]
		   OR cg1.[MaxPerGameType] <> cg2.[MaxPerGameType]
		   OR cg1.[MinBet] <> cg2.[MinBet]
		   OR cg1.[MaxBet] <> cg2.[MaxBet]
		   OR cg1.[IsDisabled] <> cg2.[IsDisabled]
		 )
GO
--------------------------------------------------------------------


--STEP 2: Adjust settings for deposit customers
--adjust [CustGameType]


UPDATE cg1
SET cg1.[StakeLevelList] = cg2.[StakeLevelList]
   ,cg1.[MaxPerGameType] = cg2.[MaxPerGameType]
   ,cg1.[MinBet] = cg2.[MinBet]
   ,cg1.[MaxBet] = cg2.[MaxBet]
   ,cg1.[IsDisabled] = cg2.[IsDisabled]
FROM [CustGameType] cg1 WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cg1.custid = ci.custid
	INNER JOIN [CustGameType] cg2 WITH(NOLOCK) ON cg2.custid = ci.custid
WHERE ci.srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND cg1.gameTypeID = 14	
	AND cg2.GameTYpeID = 1
	AND ( cg1.[StakeLevelList] <> cg2.[StakeLevelList]
		   OR cg1.[MaxPerGameType] <> cg2.[MaxPerGameType]
		   OR cg1.[MinBet] <> cg2.[MinBet]
		   OR cg1.[MaxBet] <> cg2.[MaxBet]
		   OR cg1.[IsDisabled] <> cg2.[IsDisabled]
		 )
GO
		 