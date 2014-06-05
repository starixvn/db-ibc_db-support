/*
	Created by: Elodie
	Date: 2014-06-04
	Task: Modify trigger for SMA Turnover in phrase 3 [Redmine:#14426]	
	Database: DBAGE/bodb02
*/
----------------------------------------------------------------
-----Modify trigger bettrans_DownlineTurnOver_Setting-----------
----------------------------------------------------------------
USE [bodb02]
GO
/****** Object:  Trigger [dbo].[bettrans_DownlineTurnOver_Setting]    Script Date: 6/4/2014 3:23:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[bettrans_DownlineTurnOver_Setting]
   ON  [dbo].[bettrans]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @rc int
	SET @rc = @@ROWCOUNT
	
	SET NOCOUNT ON;
    -- Insert statements for trigger here

	--Determine if this is an INSERT,UPDATE, or DELETE Action or a "failed delete".
	DECLARE @Action as char(1)
    SET @Action = (CASE WHEN EXISTS(SELECT * FROM DELETED)
							THEN
								CASE WHEN EXISTS(SELECT * FROM INSERTED)
									THEN 'U'  -- Set Action to Updated.
									ELSE 'D'  -- Set Action to Deleted.
								END
						WHEN EXISTS(SELECT * FROM INSERTED)
	                        THEN 'I'  -- Set Action to Insert.
                        ELSE '' -- Skip. It may have been a "failed delete".   
                    END)
                    	

	IF @Action = 'I'
	BEGIN
		INSERT INTO dbo.DownlineTurnOver_Trigger (srecommend, matchid, sumstake)
		SELECT srecommend, matchid, 
			SUM(CASE
				WHEN statusid IN (101,102,103) THEN 0
				ELSE stake
				END)
		FROM inserted		
		GROUP BY srecommend, matchid
	END
	
	ELSE IF @Action = 'U'
	BEGIN
		INSERT INTO dbo.DownlineTurnOver_Trigger (srecommend, matchid, sumstake)
		SELECT i.srecommend, i.matchid, 
			SUM(CASE
				WHEN i.statusid IN (101,102,103) AND d.statusid IN (0,1,111,112,113) THEN -i.stake --delete ticket
				WHEN i.statusid = 0 AND d.statusid = 102 THEN i.stake --recover ticket
				WHEN d.statusid  = 103 AND i.statusid IN (0,111,112,113) THEN i.stake -- undo or calculate after refund
				ELSE 0
				END)
		FROM inserted i INNER JOIN deleted d ON i.transid = d.transid		
		GROUP BY i.srecommend, i.matchid
	END

	ELSE IF @Action = 'D'
	BEGIN
		INSERT INTO dbo.DownlineTurnOver_Trigger (srecommend, matchid, sumstake)
		SELECT srecommend, matchid, 
			SUM(CASE
				WHEN statusid IN (101,102,103) THEN 0
				ELSE -stake
				END)
		FROM deleted		
		GROUP BY srecommend, matchid
	END
	
END

GO
----------------------------------------------------------------
-----Modify trigger dto_setting_afterInsert---------------------
----------------------------------------------------------------
USE [bodb02]
GO
/****** Object:  Trigger [dbo].[dto_setting_afterInsert]    Script Date: 6/4/2014 3:25:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[dto_setting_afterInsert]
   ON  [dbo].[DownlineTurnOver_Setting]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DELETE D
	FROM dbo.DownlineTurnOver_Trigger D WITH(ROWLOCK,UPDLOCK)
	INNER JOIN inserted i ON i.custid = D.srecommend AND i.matchid = D.matchid
	
	DELETE T
	FROM dbo.DownlineTurnOver_Trigger_tmp T WITH(ROWLOCK,UPDLOCK)
	INNER JOIN inserted i ON i.custid = T.srecommend AND i.matchid = T.matchid
	
    -- Insert statements for trigger here
    INSERT INTO dbo.DownlineTurnOver_Trigger (srecommend, matchid, sumstake)
    SELECT b.srecommend, b.matchid, SUM(b.stake) sumstake
    FROM dbo.bettrans b with (nolock)
		INNER JOIN inserted i ON b.srecommend = i.custid AND b.matchid = i.matchid
	WHERE
		b.statusid NOT IN (101, 102, 103)
	GROUP BY b.srecommend, b.matchid

END

GO
----------------------------------------------------------------
-----Modify trigger dto_setting_afterDelete---------------------
----------------------------------------------------------------
USE [bodb02]
GO
/****** Object:  Trigger [dbo].[dto_setting_afterDelete]    Script Date: 6/4/2014 3:26:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[dto_setting_afterDelete]
   ON  [dbo].[DownlineTurnOver_Setting]
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
    INSERT INTO dbo.DownlineTurnOver_Setting_Delete (custid, matchid)
    SELECT custid, matchid
    FROM deleted

END