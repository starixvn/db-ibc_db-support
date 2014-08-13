 /*
	Created: Johnson
	Date: 2014-08-13
	Task: Insert betradar's settings for newly created customers
	DB: DBTXN/CustDB
 */
 
 --STEP 0: Delete existing settings of newly created customers
 DECLARE @max_custid INT, @old_maxCustID INT
SELECT @max_custid= xx, @old_maxCustID = 15666916
 
DELETE CustSetting WITH(UPDLOCK,ROWLOCK)
WHERE sporttype IN (1,5) AND bettype = 9999
	AND custid<= @max_custid
	AND custid > @old_maxCustid 

DELETE custOverride WITH(UPDLOCK,ROWLOCK)
WHERE sporttype IN (1,5) AND bettype = 9999
	AND custid<= @max_custid
	AND custid > @old_maxCustid 
GO

--STEP 1: Insert settings for newly created customers
DECLARE @max_custid INT, @old_maxCustID INT
SELECT @max_custid= xx, @old_maxCustID = 15666916

--4k rows affected
INSERT INTO [dbo].[custSetting]
			   ([custid]
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
	SELECT cs.[custid]
		   ,9999 as [bettype]
		   ,cs.[sporttype]
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
	FROM custSetting cs WITH(NOLOCK)		
		INNER JOIN (
			SELECT 1 as sporttype, 4 as bettype
			UNION 
			SELECT 5, 1  
		) t ON cs.sporttype = t.sporttype and cs.bettype = t.bettype
	WHERE custid<= @max_custid
		AND custid > @old_maxCustid
		
	--500 rows affected
	INSERT INTO [dbo].[custOverride]
			   ([custid]
			   ,[bettype]
			   ,[sporttype]
			   ,[minpositiontaking]
			   ,[maxpositiontaking]
			   ,[minlivepositiontaking]
			   ,[maxlivepositiontaking])
	SELECT
		co.[custid]
	   ,9999 as [bettype]
	   ,co.[sporttype]
	   ,[minpositiontaking]
	   ,[maxpositiontaking]
	   ,[minlivepositiontaking]
	   ,[maxlivepositiontaking]
	FROM [custOverride] co WITH(NOLOCK)
		INNER JOIN (
			SELECT 1 as sporttype, 4 as bettype
			UNION 
			SELECT 5, 1  
		) t ON co.sporttype = t.sporttype and co.bettype = t.bettype
	WHERE custid<= @max_custid
		AND custid > @old_maxCustid	   
  	