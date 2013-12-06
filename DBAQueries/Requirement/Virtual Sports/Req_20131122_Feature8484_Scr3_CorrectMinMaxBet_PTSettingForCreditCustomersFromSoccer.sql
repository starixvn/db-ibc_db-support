/*
	Created: Johnson
	Date: 2013-11-26
	Task: Correct min max bet, pt setting after insert setting from soccer
	DB: DBTNX/bodb02
*/ 

---step 1: update min , max bet, pt setting for customers have changed setting
DECLARE @maxCustID INT
SELECT @maxCustID = xxx

--2972 rows affected
UPDATE cs1
SET cs1.spositiontaking = cs2.spositiontaking
	,cs1.mpositiontaking = cs2.mpositiontaking
	,cs1.apositiontaking = cs2.apositiontaking
	,cs1.minbet = cs2.minbet
	,cs1.maxbet = cs2.maxbet
	,cs1.playerdiscount = cs2.playerdiscount 
	,cs1.discount = cs2.discount
	,cs1.adiscount = cs2.adiscount
	,cs1.sdiscount = cs2.sdiscount
	,cs1.autopositiontaking = cs2.autopositiontaking
	,cs1.isautopositiontaking = cs2.isautopositiontaking
	,cs1.autompositiontaking = cs2.autompositiontaking
	,cs1.isautompositiontaking = cs2.isautompositiontaking	
FROM CustSetting3rd cs1 WITH(UPDLOCK,ROWLOCK)
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs1.custid = ci.custid AND cs1.sporttype IN (182,184) AND cs1.bettype = 1231
	INNER JOIN CustSetting3rd cs2 WITH(NOLOCK) ON cs2.custid = ci.custid AND cs2.sporttype = 180 AND cs2.bettype = 1201
WHERE ci.srecommend NOT IN (SELECT custID FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.custid <= @maxCustID
	AND ( cs1.spositiontaking <> cs2.spositiontaking
		OR cs1.mpositiontaking <> cs2.mpositiontaking
		OR cs1.apositiontaking <> cs2.apositiontaking
		OR cs1.minbet <> cs2.minbet
		OR cs1.maxbet <> cs2.maxbet
		OR cs1.playerdiscount <> cs2.playerdiscount 
		OR cs1.discount <> cs2.discount
		OR cs1.adiscount <> cs2.adiscount
		OR cs1.sdiscount <> cs2.sdiscount
		OR cs1.autopositiontaking <> cs2.autopositiontaking
		OR cs1.isautopositiontaking <> cs2.isautopositiontaking
		OR cs1.autompositiontaking <> cs2.autompositiontaking
		OR cs1.isautompositiontaking <> cs2.isautompositiontaking
	)	
GO



---step 2: update min pt setting for customers have changed setting
DECLARE @maxCustID INT
SELECT @maxCustID = xxx

--22 rows affected
UPDATE cs1
SET cs1.minpositiontaking = cs2.minpositiontaking
	,cs1.maxpositiontaking = cs2.maxpositiontaking
FROM CustOverride3rd cs1 WITH(UPDLOCK,ROWLOCK)
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs1.custid = ci.custid AND cs1.sporttype IN (182,184) AND cs1.bettype = 1231
	INNER JOIN CustOverride3rd cs2 WITH(NOLOCK) ON cs2.custid = ci.custid AND cs2.sporttype = 180 AND cs2.bettype = 1201
WHERE ci.srecommend NOT IN (SELECT custID FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.custid <= @maxCustID
	AND ci.roleid iN (2,3,4)
	AND ( cs1.minpositiontaking <> cs2.minpositiontaking
		 OR cs1.maxpositiontaking <> cs2.maxpositiontaking
			
	)	
GO


--step 3: update max per match for customers have changed setting
DECLARE @maxCustID INT
SELECT @maxCustID = xxx

--23 rows affected
UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
SET maxpermatch182 = maxpermatch180 
	,maxpermatch184 = maxpermatch180 
WHERE srecommend NOT IN (SELECT custID FROM Dep_CustSuper WITH(NOLOCK))
	AND custid <= @maxCustID
	AND ( maxpermatch182 <> maxpermatch180 
		OR  maxpermatch184 <> maxpermatch180 			
	)	