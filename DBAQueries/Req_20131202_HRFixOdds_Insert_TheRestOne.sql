

DECLARE @maxCustID INT
SET @maxCustID = xxx

SELECT custid, roleid INTO #customer
FROM custInfo ci WITH(NOLOCK) 
WHERE ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.roleid <= 4
	AND ci.custid > @maxCustID

--103 rows affected
DELETE CustSetting WITH(UPDLOCK,ROWLOCK)	
WHERE sporttype = 154 AND bettype = 20	
	AND custid IN (SELECT custid FROM #customer)

GO


DELETE CustOverride WITH(UPDLOCK,ROWLOCK)	
WHERE sporttype = 154 AND bettype = 20
	AND custid IN (SELECT custid FROM #customer WHERE roleid IN (2,3,4))
				


GO

-- insert min PT setting
	INSERT INTO [dbo].[CustOverride]
			   ( 
			   [custid]
			  ,[bettype]
			  ,[sporttype]
			  ,[minpositiontaking]
			  ,[maxpositiontaking]
			  ,[minlivepositiontaking]
			  ,[maxlivepositiontaking]
			  )
    SELECT	   [custid]
			  ,[bettype]
			  ,154 [sporttype]
			  ,[minpositiontaking]
			  ,[maxpositiontaking]
			  ,[minlivepositiontaking]
			  ,[maxlivepositiontaking]
	FROM [dbo].[custOverride] WITH(NOLOCK) 		
	WHERE sporttype = 99 AND bettype = 20
		AND custid IN (SELECT custid FROM #customer WHERE roleid IN (2,3,4))



-- insert PT setting 
INSERT INTO [dbo].[CustSetting]( 
			   [custid]
			  ,[bettype]
			  ,[sporttype]
			  ,[apositiontaking]
			  ,[mpositiontaking]
			  ,[spositiontaking]
			  ,[alivepositiontaking]
			  ,[mlivepositiontaking]
			  ,[slivepositiontaking]
			  ,[playerdiscount]
			  ,[discount]
			  ,[adiscount]
			  ,[sdiscount]
			  ,[groupa]
			  ,[groupb]
			  ,[groupc]
			  ,[groupd]
			  ,[groupe]
			  ,[groupf]
			  ,[minbet]
			  ,[maxbet]
			  ,[autopositiontaking]
			  ,[autolivepositiontaking]
			  ,[isautopositiontaking]
			  ,[isautolivepositiontaking]
			  ,[autompositiontaking]
			  ,[autolivempositiontaking]
			  ,[isautompositiontaking]
			  ,[isautolivempositiontaking])
      SELECT  [custid]
			  ,[bettype]
			  ,154 [sporttype]
			  ,[apositiontaking]
			  ,[mpositiontaking]
			  ,[spositiontaking]
			  ,[alivepositiontaking]
			  ,[mlivepositiontaking]
			  ,[slivepositiontaking]
			  ,[playerdiscount]
			  ,[discount]
			  ,[adiscount]
			  ,[sdiscount]
			  ,[groupa]
			  ,[groupb]
			  ,[groupc]
			  ,[groupd]
			  ,[groupe]
			  ,[groupf]
			  ,[minbet]
			  ,[maxbet]
			  ,[autopositiontaking]
			  ,[autolivepositiontaking]
			  ,[isautopositiontaking]
			  ,[isautolivepositiontaking]
			  ,[autompositiontaking]
			  ,[autolivempositiontaking]
			  ,[isautompositiontaking]
			  ,[isautolivempositiontaking]
	FROM [dbo].[custSetting] WITH(NOLOCK)
	WHERE sporttype = 99 
		AND bettype = 20
		AND custid IN (SELECT custid FROM #customer)
		
				
	-- update maxpermatch & disabled
	UPDATE custInfo WITH(UPDLOCK,ROWLOCK)
	SET	maxpermatch154 = maxpermatch99,
		DisableHRFixedOdds = 0
	WHERE custid IN (SELECT custid FROM #customer)		
