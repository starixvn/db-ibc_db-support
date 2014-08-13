 /*
	Created: Johnson
	Date: 2014-08-13
	Task: copy missing settings for betradar
	DB: DBTXN/CustDB
 */
 
 DECLARE @tmpCust TABLE (custid INT, sporttype INT, bettype INT)
 
 INSERT INTO @tmpCust(custid, sporttype, bettype)
	 SELECT 	15674125	,	1	,	4
UNION SELECT 	15674148	,	5	,	1
UNION SELECT 	15674148	,	1	,	4
UNION SELECT 	15674171	,	5	,	1
UNION SELECT 	15674138	,	5	,	1
UNION SELECT 	883712	,	1	,	4
UNION SELECT 	15674124	,	5	,	1
UNION SELECT 	15674171	,	1	,	4
UNION SELECT 	883712	,	5	,	1
UNION SELECT 	15674125	,	5	,	1
UNION SELECT 	15674138	,	1	,	4
UNION SELECT 	15674124	,	1	,	4

	--settings for betradar	
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
		INNER JOIN @tmpCust t ON cs.custid = t.custid AND cs.sporttype = t.sporttype AND cs.bettype = t.bettype 
	WHERE t.sporttype = 1
	
	
	--settings for sportting solutions
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
	SELECT t.[custid]
		   ,9999 as [bettype]
		   ,t.[sporttype]
		   ,0 as [apositiontaking]
		   ,0 as [mpositiontaking]
		   ,0 as [spositiontaking]
		   ,0 as [alivepositiontaking]
		   ,0 as [mlivepositiontaking]
		   ,0 as [slivepositiontaking]
		   ,0 as [playerdiscount]
		   ,0 as [discount]
		   ,0 as [adiscount]
		   ,0 as [sdiscount]
		   ,0 as [groupa]
		   ,0 as [groupb]
		   ,0 as [groupc]
		   ,0 as [groupd]
		   ,0 as [groupe]
		   ,0 as [groupf]
		   ,0 as [minbet]
		   ,0 as [maxbet]
		   ,0 as [autopositiontaking]
		   ,0 as [autolivepositiontaking]
		   ,0 as [isautopositiontaking]
		   ,0 as [isautolivepositiontaking]
		   ,0 as [autompositiontaking]
		   ,0 as [autolivempositiontaking]
		   ,0 as [isautompositiontaking]
		   ,0 as [isautolivempositiontaking]
	FROM @tmpCust t
	WHERE t.sporttype = 5
GO


 DECLARE @tmpCust TABLE (custid INT, sporttype INT, bettype INT)
 
 INSERT INTO @tmpCust(custid, sporttype, bettype)
	SELECT 	883712	,	5	,	1
UNION SELECT 	883712	,	1	,	4
		
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
		INNER JOIN @tmpCust t ON co.custid = t.custid AND co.sporttype = t.sporttype AND co.bettype = t.bettype 
	WHERE t.sporttype = 1
	
	INSERT INTO [dbo].[custOverride]
				   ([custid]
				   ,[bettype]
				   ,[sporttype]
				   ,[minpositiontaking]
				   ,[maxpositiontaking]
				   ,[minlivepositiontaking]
				   ,[maxlivepositiontaking])
		SELECT
			t.[custid]
		   ,9999 as [bettype]
		   ,t.[sporttype]
		   ,0 as [minpositiontaking]
		   ,0 as [maxpositiontaking]
		   ,0 as [minlivepositiontaking]
		   ,0 as [maxlivepositiontaking]		
		FROM @tmpCust	   	 
		WHERE sporttype = 5