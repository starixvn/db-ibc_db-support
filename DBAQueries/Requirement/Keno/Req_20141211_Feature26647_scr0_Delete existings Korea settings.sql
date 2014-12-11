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
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('CustInfo','Dep_custSuper','CustGameType','CustSettingGame','CustOverrideGame') AND type = 'U' ) <> 5
		RETURN
	
	DELETE cs
	FROM [CustSettingGame] cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE sporttype = 202
		AND bettype = 1514		
		AND ci.srecommend NOT IN (SELECT custid 
									FROM Dep_CustSuper WITH(NOLOCK) 
									WHERE site ='12bet'
								)
			
	
	DELETE cs
	FROM [CustOverrideGame] cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE sporttype = 202
		AND bettype = 1514	
		AND ci.srecommend NOT IN (SELECT custid 
									FROM Dep_CustSuper WITH(NOLOCK) 
									WHERE site ='12bet'
								)
	
	DELETE cs
	FROM [CustGameType] cs WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE GameTypeID = 14
		AND ci.srecommend NOT IN (SELECT custid 
									FROM Dep_CustSuper WITH(NOLOCK) 
									WHERE site ='12bet'
								)
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

-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
EXEC dbo.[Acc_CustSetting3rd_19] @target = 'DBTRANS' 	
GO

--END STEP 3