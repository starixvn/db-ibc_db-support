 /*
	Created: Johnson
	Date: 2014-07-17
	Task: insert virtual greyhound , motorsports settings for haifa uus licensee
	DB: DBTXN/CustDB
 */
 
--STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting_03]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','Dep_CustSetting3rd') AND type = 'U' ) <> 2
		RETURN

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
	FROM Dep_custSetting3rd cs WITH(NOLOCK)		   
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		CROSS APPLY(
			SELECT 182 as sporttype, 1231 as bettype
			UNION SELECT 184, 1231
		)t
	WHERE ci.srecommend = @srecommend
		and ci.custid <= @maxcustid
		and cs.sporttype = 180
		and cs.bettype = 1201
		
END			   
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------	

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------

DECLARE @max_custid INT, @srecommend INT

SELECT @srecommend = custid FROM dep_custsuper with(NOLOCK) where site = 'haifa' AND currency = 20
	
SELECT @max_custid = xxx

EXEC dbo.[Acc_CustSetting_03] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------				

DECLARE @max_custid INT, @srecommend INT

SELECT @srecommend = custid FROM dep_custsuper with(NOLOCK) where site = 'haifa' AND currency = 20
	
SELECT @max_custid = xxx

EXEC dbo.[Acc_CustSetting_03] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBTRANS'

-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------