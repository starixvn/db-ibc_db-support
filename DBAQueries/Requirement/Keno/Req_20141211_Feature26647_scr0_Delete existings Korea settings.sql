/*
	Created: Johnson
	Date: 2014-12-11
	Task: delete existing Korea settings
	DB: DBTXN/CustDB
*/  

--STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@target VARCHAR(20)
AS
BEGIN	
	SET NOCOUNT ON
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('CustGameType','CustSettingGame','CustOverrideGame') AND type = 'U' ) <> 3
		RETURN
	
	DELETE [CustSettingGame] WITH(UPDLOCK,ROWLOCK)
	WHERE sporttype = 202
		AND bettype = 1514	
	
	DELETE [CustOverrideGame] WITH(UPDLOCK,ROWLOCK)
	WHERE sporttype = 202
		AND bettype = 1514	
	
	DELETE [CustGameType] WITH(UPDLOCK,ROWLOCK)
	WHERE GameTypeID = 14
END
GO

-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------	


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
EXEC dbo.[Acc_CustSetting3rd_19] @target = 'REPLICATED' 	
GO

EXEC dbo.[Acc_CustSetting3rd_19] @target = 'DBTRANS' 	
GO
