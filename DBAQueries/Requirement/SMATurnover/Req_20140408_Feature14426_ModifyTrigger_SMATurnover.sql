/*
	Created by: Elodie
	Date: 2014-04-08
	Task: Modify trigger for SMA Turnover [Redmine:#14426]	
	Database: DBAGE/bodb02
*/
----------------------------------------------------------------
-----Modify trigger bettrans_DownlineTurnOver_Setting-----------
----------------------------------------------------------------
USE bodb02
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
	
	SET NOCOUNT ON
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
		INSERT INTO dbo.DownlineTurnOver_Trigger (srecommend, mrecommend, recommend, matchid, sumstake)
		SELECT srecommend, mrecommend, recommend, matchid, 
			SUM(CASE
				WHEN statusid IN (101,102,103) THEN 0
				ELSE stake
				END)
		FROM inserted		
		GROUP BY srecommend, mrecommend, recommend, matchid
	END
	
	ELSE IF @Action = 'U'
	BEGIN
		INSERT INTO dbo.DownlineTurnOver_Trigger (srecommend, mrecommend, recommend, matchid, sumstake)
		SELECT i.srecommend, i.mrecommend, i.recommend, i.matchid, 
			SUM(CASE
				WHEN i.statusid IN (101,102,103) AND d.statusid IN (0,1,111,112,113) THEN -i.stake --delete ticket
				WHEN i.statusid = 0 AND d.statusid = 102 THEN i.stake --recover ticket
				WHEN d.statusid  = 103 AND i.statusid IN (0,111,112,113) THEN i.stake -- undo or calculate after refund
				ELSE 0
				END)
		FROM inserted i INNER JOIN deleted d ON i.transid = d.transid		
		GROUP BY i.srecommend, i.mrecommend, i.recommend, i.matchid
	END

	ELSE IF @Action = 'D'
	BEGIN
		INSERT INTO dbo.DownlineTurnOver_Trigger (srecommend, mrecommend, recommend, matchid, sumstake)
		SELECT srecommend, mrecommend, recommend, matchid, 
			SUM(CASE
				WHEN statusid IN (101,102,103) THEN 0
				ELSE -stake
				END)
		FROM deleted		
		GROUP BY srecommend, mrecommend, recommend, matchid
	END	
END

GO
----------------------------------------------------------------
-----Disable trigger dto_setting_afterDelete--------------------
----------------------------------------------------------------
USE bodb02
GO
DISABLE TRIGGER dto_setting_afterDelete ON DownlineTurnover_Setting
GO


----------------------------------------------------------------
-----Disable trigger dto_setting_afterInsert--------------------
----------------------------------------------------------------
USE bodb02
GO
DISABLE TRIGGER dto_setting_afterInsert ON DownlineTurnover_Setting
GO

----------------------------------------------------------------
-----Add trigger DownlineTo_SportControl_afterInsert------------
----------------------------------------------------------------
USE [bodb_Age]
GO
/****** Object:  Trigger [dbo].[DownlineTo_SportControl_afterInsert]    Script Date: 4/24/2014 4:42:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[DownlineTo_SportControl_afterInsert]
   ON  [dbo].[DownlineTo_SportControl]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	
	DELETE D
	FROM bodb02.dbo.DownlineTurnOver_Trigger D WITH(ROWLOCK,UPDLOCK)
	INNER JOIN bodb02.dbo.match m WITH (NOLOCK) ON D.matchid = m.matchid
	INNER JOIN inserted i ON i.SportID = m.sporttype
	WHERE NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = m.matchid AND (s.SMAID = D.srecommend OR s.SMAID = D.mrecommend OR s.SMAID = D.recommend))
	
	DELETE T
	FROM bodb02.dbo.DownlineTurnOver_Trigger_tmp T WITH(ROWLOCK,UPDLOCK)
	INNER JOIN bodb02.dbo.match m WITH (NOLOCK) ON T.matchid = m.matchid
	INNER JOIN inserted i ON i.SportID = m.sporttype
	WHERE NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = m.matchid AND (s.SMAID = T.srecommend OR s.SMAID = T.mrecommend OR s.SMAID = T.recommend))
	
    -- Insert statements for trigger here
    INSERT INTO bodb02.dbo.DownlineTurnOver_Trigger (srecommend, mrecommend, recommend, matchid, sumstake)
    SELECT b.srecommend, mrecommend, recommend, b.matchid, SUM(b.stake) sumstake
    FROM bodb02.dbo.bettrans b with (nolock)
		INNER JOIN bodb02.dbo.match m WITH (NOLOCK) ON b.matchid = m.matchid
		INNER JOIN inserted i ON i.SportID = m.sporttype
	WHERE
		b.statusid NOT IN (101, 102, 103) AND
		NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = b.matchid AND (s.SMAID = b.srecommend OR s.SMAID = b.mrecommend OR s.SMAID = b.recommend))
	GROUP BY b.srecommend, mrecommend, recommend, b.matchid

END
GO

----------------------------------------------------------------
-----Add trigger DownlineTo_LeagueControl_afterInsert-----------
----------------------------------------------------------------
USE [bodb_Age]
GO
/****** Object:  Trigger [dbo].[DownlineTo_LeagueControl_afterInsert]    Script Date: 4/24/2014 3:46:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[DownlineTo_LeagueControl_afterInsert]
   ON  [dbo].[DownlineTo_LeagueControl]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	IF NOT EXISTS (	SELECT 1 
					FROM DownlineTo_SportControl sc WITH (NOLOCK) 
						INNER JOIN bodb02.dbo.league l WITH (NOLOCK) ON l.sporttype = sc.sportID
						INNER JOIN inserted i ON l.leagueID = i.LeagueID
						WHERE i.Value <> 0) --sport setting
	BEGIN
		DELETE D
		FROM bodb02.dbo.DownlineTurnOver_Trigger D WITH(ROWLOCK,UPDLOCK)
		INNER JOIN bodb02.dbo.match m WITH (NOLOCK) ON D.matchid = m.matchid
		INNER JOIN inserted i ON i.LeagueID = m.LeagueID
		WHERE NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = m.matchid AND (s.SMAID = D.srecommend OR s.SMAID = D.mrecommend OR s.SMAID = D.recommend))
	
		DELETE T
		FROM bodb02.dbo.DownlineTurnOver_Trigger_tmp T WITH(ROWLOCK,UPDLOCK)
		INNER JOIN bodb02.dbo.match m WITH (NOLOCK) ON T.matchid = m.matchid
		INNER JOIN inserted i ON i.LeagueID = m.LeagueID
		WHERE NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = m.matchid AND (s.SMAID = T.srecommend OR s.SMAID = T.mrecommend OR s.SMAID = T.recommend))
	
		-- Insert statements for trigger here
		INSERT INTO bodb02.dbo.DownlineTurnOver_Trigger (srecommend, mrecommend, recommend, matchid, sumstake)
		SELECT b.srecommend, mrecommend, recommend, b.matchid, SUM(b.stake) sumstake
		FROM bodb02.dbo.bettrans b with (nolock)
			INNER JOIN bodb02.dbo.match m WITH (NOLOCK) ON b.matchid = m.matchid
			INNER JOIN inserted i ON i.LeagueID = m.LeagueID
		WHERE
			b.statusid NOT IN (101, 102, 103) AND
			NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = b.matchid AND (s.SMAID = b.srecommend OR s.SMAID = b.mrecommend OR s.SMAID = b.recommend))
		GROUP BY b.srecommend, mrecommend, recommend, b.matchid
	END
END
GO

----------------------------------------------------------------
-----Add trigger DownlineTo_LeagueControl_afterUpdate-----------
----------------------------------------------------------------
USE [bodb_Age]
GO
/****** Object:  Trigger [dbo].[DownlineTo_LeagueControl_afterUpdate]    Script Date: 4/25/2014 5:13:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[DownlineTo_LeagueControl_afterUpdate]
   ON  [dbo].[DownlineTo_LeagueControl]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	DECLARE @OldValue INT, @NewValue INT
	SELECT @OldValue = Value FROM deleted
	SELECT @NewValue = Value FROM inserted

	IF @OldValue = 0 AND @NewValue <> 0		
	BEGIN
		DELETE D
		FROM bodb02.dbo.DownlineTurnOver_Trigger D WITH(ROWLOCK,UPDLOCK)
		INNER JOIN bodb02.dbo.match m WITH (NOLOCK) ON D.matchid = m.matchid
		INNER JOIN inserted i ON i.LeagueID = m.LeagueID
		WHERE NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = m.matchid AND (s.SMAID = D.srecommend OR s.SMAID = D.mrecommend OR s.SMAID = D.recommend))

		DELETE T
		FROM bodb02.dbo.DownlineTurnOver_Trigger_tmp T WITH(ROWLOCK,UPDLOCK)
		INNER JOIN bodb02.dbo.match m WITH (NOLOCK) ON T.matchid = m.matchid
		INNER JOIN inserted i ON i.LeagueID = m.LeagueID
		WHERE NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = m.matchid AND (s.SMAID = T.srecommend OR s.SMAID = T.mrecommend OR s.SMAID = T.recommend))

		-- Insert statements for trigger here
		INSERT INTO bodb02.dbo.DownlineTurnOver_Trigger (srecommend, mrecommend, recommend, matchid, sumstake)
		SELECT b.srecommend, mrecommend, recommend, b.matchid, SUM(b.stake) sumstake
		FROM bodb02.dbo.bettrans b with (nolock)
			INNER JOIN bodb02.dbo.match m WITH (NOLOCK) ON b.matchid = m.matchid
			INNER JOIN inserted i ON i.LeagueID = m.LeagueID
		WHERE
			b.statusid NOT IN (101, 102, 103) AND
			NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = b.matchid AND (s.SMAID = b.srecommend OR s.SMAID = b.mrecommend OR s.SMAID = b.recommend))
		GROUP BY b.srecommend, mrecommend, recommend, b.matchid
	END
END
GO

----------------------------------------------------------------
-----Add trigger DownlineTo_LeagueControl_afterDelete-----------
----------------------------------------------------------------
USE [bodb_Age]
GO
/****** Object:  Trigger [dbo].[DownlineTo_LeagueControl_afterDelete]    Script Date: 4/25/2014 4:13:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[DownlineTo_LeagueControl_afterDelete]
   ON  [dbo].[DownlineTo_LeagueControl]
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	IF EXISTS (	SELECT 1 
				FROM DownlineTo_SportControl sc WITH (NOLOCK) 
					INNER JOIN bodb02.dbo.league l WITH (NOLOCK) ON l.sporttype = sc.sportID
					INNER JOIN deleted d ON l.leagueID = d.LeagueID AND d.Value = 0) --sport setting
	BEGIN
		DELETE DT
		FROM bodb02.dbo.DownlineTurnOver_Trigger DT WITH(ROWLOCK,UPDLOCK)
		INNER JOIN bodb02.dbo.match m WITH (NOLOCK) ON DT.matchid = m.matchid
		INNER JOIN deleted d ON m.leagueID = d.LeagueID
		WHERE NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = m.matchid AND (s.SMAID = DT.srecommend OR s.SMAID = DT.mrecommend OR s.SMAID = DT.recommend))

		DELETE T
		FROM bodb02.dbo.DownlineTurnOver_Trigger_tmp T WITH(ROWLOCK,UPDLOCK)
		INNER JOIN bodb02.dbo.match m WITH (NOLOCK) ON T.matchid = m.matchid
		INNER JOIN deleted d ON m.leagueID = d.LeagueID
		WHERE NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = m.matchid AND (s.SMAID = T.srecommend OR s.SMAID = T.mrecommend OR s.SMAID = T.recommend))

		-- Insert statements for trigger here
		INSERT INTO bodb02.dbo.DownlineTurnOver_Trigger (srecommend, mrecommend, recommend, matchid, sumstake)
		SELECT b.srecommend, mrecommend, recommend, b.matchid, SUM(b.stake) sumstake
		FROM bodb02.dbo.bettrans b with (nolock)
			INNER JOIN bodb02.dbo.match m WITH (NOLOCK) ON b.matchid = m.matchid
			INNER JOIN deleted d ON m.leagueID = d.LeagueID
		WHERE
			b.statusid NOT IN (101, 102, 103) AND
			NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = b.matchid AND (s.SMAID = b.srecommend OR s.SMAID = b.mrecommend OR s.SMAID = b.recommend))
		GROUP BY b.srecommend, mrecommend, recommend, b.matchid
	END
END
GO

----------------------------------------------------------------
-----Add trigger DownlineTo_MatchControl_afterInsert------------
----------------------------------------------------------------
USE [bodb_Age]
GO
/****** Object:  Trigger [dbo].[DownlineTo_MatchControl_afterInsert]    Script Date: 4/25/2014 11:25:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[DownlineTo_MatchControl_afterInsert]
   ON  [dbo].[DownlineTo_MatchControl]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	IF EXISTS (SELECT 1 FROM inserted WHERE Value <> 0)
	BEGIN
		DECLARE @SportID INT, @LeagueID INT
		SELECT @SportID = m.sporttype, @LeagueID = m.leagueid 
		FROM bodb02.dbo.match m WITH (NOLOCK) 
			INNER JOIN inserted i ON m.matchID = i.MatchID

		IF NOT EXISTS (	SELECT 1 
						FROM DownlineTo_SportControl sc WITH (NOLOCK) WHERE sc.SportID = @SportID)
		AND NOT EXISTS (SELECT 1 
						FROM DownlineTo_LeagueControl lc WITH (NOLOCK) WHERE lc.leagueID = @LeagueID)			
		BEGIN
			DELETE D
			FROM bodb02.dbo.DownlineTurnOver_Trigger D WITH(ROWLOCK,UPDLOCK)
			INNER JOIN inserted i ON i.MatchID = D.MatchID
			WHERE NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = D.matchid AND (s.SMAID = D.srecommend OR s.SMAID = D.mrecommend OR s.SMAID = D.recommend))
	
			DELETE T
			FROM bodb02.dbo.DownlineTurnOver_Trigger_tmp T WITH(ROWLOCK,UPDLOCK)
			INNER JOIN inserted i ON i.MatchID = T.MatchID
			WHERE NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = T.matchid AND (s.SMAID = T.srecommend OR s.SMAID = T.mrecommend OR s.SMAID = T.recommend))

			-- Insert statements for trigger here
			INSERT INTO bodb02.dbo.DownlineTurnOver_Trigger (srecommend, mrecommend, recommend, matchid, sumstake)
			SELECT b.srecommend, mrecommend, recommend, b.matchid, SUM(b.stake) sumstake
			FROM bodb02.dbo.bettrans b with (nolock)
				INNER JOIN inserted i ON i.MatchID = b.MatchID
			WHERE
				b.statusid NOT IN (101, 102, 103) AND
				NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = b.matchid AND (s.SMAID = b.srecommend OR s.SMAID = b.mrecommend OR s.SMAID = b.recommend))
			GROUP BY b.srecommend, mrecommend, recommend, b.matchid
		END
	END
END
GO

----------------------------------------------------------------
-----Add trigger DownlineTo_MatchControl_afterUpdate------------
----------------------------------------------------------------
USE [bodb_Age]
GO
/****** Object:  Trigger [dbo].[DownlineTo_MatchControl_afterUpdate]    Script Date: 4/25/2014 5:14:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[DownlineTo_MatchControl_afterUpdate]
   ON  [dbo].[DownlineTo_MatchControl]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	DECLARE @OldValue INT, @NewValue INT
	SELECT @OldValue = Value FROM deleted
	SELECT @NewValue = Value FROM inserted

	IF @OldValue = 0 AND @NewValue <> 0
	BEGIN
		DELETE D
		FROM bodb02.dbo.DownlineTurnOver_Trigger D WITH(ROWLOCK,UPDLOCK)
		INNER JOIN inserted i ON i.MatchID = D.MatchID
		WHERE NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = D.matchid AND (s.SMAID = D.srecommend OR s.SMAID = D.mrecommend OR s.SMAID = D.recommend))
	
		DELETE T
		FROM bodb02.dbo.DownlineTurnOver_Trigger_tmp T WITH(ROWLOCK,UPDLOCK)
		INNER JOIN inserted i ON i.MatchID = T.MatchID
		WHERE NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = T.matchid AND (s.SMAID = T.srecommend OR s.SMAID = T.mrecommend OR s.SMAID = T.recommend))

		-- Insert statements for trigger here
		INSERT INTO bodb02.dbo.DownlineTurnOver_Trigger (srecommend, mrecommend, recommend, matchid, sumstake)
		SELECT b.srecommend, mrecommend, recommend, b.matchid, SUM(b.stake) sumstake
		FROM bodb02.dbo.bettrans b with (nolock)
			INNER JOIN inserted i ON i.MatchID = b.MatchID
		WHERE
			b.statusid NOT IN (101, 102, 103) AND
			NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = b.matchid AND (s.SMAID = b.srecommend OR s.SMAID = b.mrecommend OR s.SMAID = b.recommend))
		GROUP BY b.srecommend, mrecommend, recommend, b.matchid		
	END
END
GO

----------------------------------------------------------------
-----Add trigger DownlineTo_MatchControl_afterDelete------------
----------------------------------------------------------------
USE [bodb_Age]
GO
/****** Object:  Trigger [dbo].[DownlineTo_MatchControl_afterUpdate]    Script Date: 4/25/2014 4:12:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[DownlineTo_MatchControl_afterDelete]
   ON  [dbo].[DownlineTo_MatchControl]
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	DECLARE @Value INT
	SELECT @Value = Value FROM deleted

	IF @Value = 0
	BEGIN
		DECLARE @SportID INT, @LeagueID INT
		SELECT @SportID = m.sporttype, @LeagueID = m.leagueid 
		FROM bodb02.dbo.match m WITH (NOLOCK) 
			INNER JOIN deleted d ON m.matchID = d.MatchID

		IF EXISTS (	SELECT 1 
						FROM DownlineTo_SportControl sc WITH (NOLOCK) WHERE sc.SportID = @SportID)
		OR EXISTS (SELECT 1 
						FROM DownlineTo_LeagueControl lc WITH (NOLOCK) WHERE lc.leagueID = @LeagueID)			
		BEGIN
			DELETE DT
			FROM bodb02.dbo.DownlineTurnOver_Trigger DT WITH(ROWLOCK,UPDLOCK)
			INNER JOIN deleted d ON d.MatchID = DT.MatchID
			WHERE NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = DT.matchid AND (s.SMAID = DT.srecommend OR s.SMAID = DT.mrecommend OR s.SMAID = DT.recommend))
	
			DELETE T
			FROM bodb02.dbo.DownlineTurnOver_Trigger_tmp T WITH(ROWLOCK,UPDLOCK)
			INNER JOIN deleted d ON d.MatchID = T.MatchID
			WHERE NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = T.matchid AND (s.SMAID = T.srecommend OR s.SMAID = T.mrecommend OR s.SMAID = T.recommend))

			-- Insert statements for trigger here
			INSERT INTO bodb02.dbo.DownlineTurnOver_Trigger (srecommend, mrecommend, recommend, matchid, sumstake)
			SELECT b.srecommend, mrecommend, recommend, b.matchid, SUM(b.stake) sumstake
			FROM bodb02.dbo.bettrans b with (nolock)
				INNER JOIN deleted d ON d.MatchID = b.MatchID
			WHERE
				b.statusid NOT IN (101, 102, 103) AND
				NOT EXISTS (SELECT 1 FROM bodb02.dbo.DownlineTurnOver_Setting s WITH (NOLOCK) WHERE s.matchid = b.matchid AND (s.SMAID = b.srecommend OR s.SMAID = b.mrecommend OR s.SMAID = b.recommend))
			GROUP BY b.srecommend, mrecommend, recommend, b.matchid
		END
	END
END
GO

----------------------------------------------------------------
-----Add trigger DownlineTo_Match_SMAControl_afterInsert--------
----------------------------------------------------------------
USE [bodb_Age]
GO
/****** Object:  Trigger [dbo].[DownlineTo_Match_SMAControl_afterInsert]    Script Date: 4/25/2014 4:30:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[DownlineTo_Match_SMAControl_afterInsert]
   ON  [dbo].[DownlineTo_Match_SMAControl]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	IF EXISTS (SELECT 1 FROM inserted WHERE Value <> 0)
	BEGIN
		DECLARE @SportID INT, @LeagueID INT, @MatchID INT
		SELECT @SportID = m.sporttype, @LeagueID = m.leagueid, @MatchID = m.matchID
		FROM bodb02.dbo.match m WITH (NOLOCK) 
			INNER JOIN inserted i ON m.matchID = i.MatchID

		IF NOT EXISTS (	SELECT 1 
						FROM DownlineTo_SportControl sc WITH (NOLOCK) WHERE sc.SportID = @SportID)
		AND NOT EXISTS (SELECT 1 
						FROM DownlineTo_LeagueControl lc WITH (NOLOCK) WHERE lc.leagueID = @LeagueID)			
		AND NOT EXISTS (SELECT 1 
						FROM DownlineTo_MatchControl mc WITH (NOLOCK) WHERE mc.MatchID = @MatchID)

		BEGIN
			DELETE D
			FROM bodb02.dbo.DownlineTurnOver_Trigger D WITH(ROWLOCK,UPDLOCK)
			INNER JOIN inserted i ON i.MatchID = D.MatchID AND (D.srecommend = i.SMAID OR D.mrecommend = i.SMAID AND D.recommend = i.SMAID)
	
			DELETE T
			FROM bodb02.dbo.DownlineTurnOver_Trigger_tmp T WITH(ROWLOCK,UPDLOCK)
			INNER JOIN inserted i ON i.MatchID = T.MatchID AND (T.srecommend = i.SMAID OR T.mrecommend = i.SMAID AND T.recommend = i.SMAID)
	
			-- Insert statements for trigger here
			INSERT INTO bodb02.dbo.DownlineTurnOver_Trigger (srecommend, mrecommend, recommend, matchid, sumstake)
			SELECT b.srecommend, mrecommend, recommend, b.matchid, SUM(b.stake) sumstake
			FROM bodb02.dbo.bettrans b with (nolock)
				INNER JOIN inserted i ON i.MatchID = b.MatchID AND (b.srecommend = i.SMAID OR b.mrecommend = i.SMAID AND b.recommend = i.SMAID)
			WHERE
				b.statusid NOT IN (101, 102, 103) 
			GROUP BY b.srecommend, mrecommend, recommend, b.matchid
		END
	END
END
GO

----------------------------------------------------------------
-----Add trigger DownlineTo_Match_SMAControl_afterUpdate--------
----------------------------------------------------------------
USE [bodb_Age]
GO
/****** Object:  Trigger [dbo].[DownlineTo_Match_SMAControl_afterInsert]    Script Date: 4/25/2014 6:26:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[DownlineTo_Match_SMAControl_afterUpdate]
   ON  [dbo].[DownlineTo_Match_SMAControl]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	DECLARE @OldValue INT, @NewValue INT
	SELECT @OldValue = Value FROM deleted
	SELECT @NewValue = Value FROM inserted

	IF @OldValue = 0 AND @NewValue <> 0
	BEGIN
		DELETE D
		FROM bodb02.dbo.DownlineTurnOver_Trigger D WITH(ROWLOCK,UPDLOCK)
		INNER JOIN inserted i ON i.MatchID = D.MatchID AND (D.srecommend = i.SMAID OR D.mrecommend = i.SMAID AND D.recommend = i.SMAID)
	
		DELETE T
		FROM bodb02.dbo.DownlineTurnOver_Trigger_tmp T WITH(ROWLOCK,UPDLOCK)
		INNER JOIN inserted i ON i.MatchID = T.MatchID AND (T.srecommend = i.SMAID OR T.mrecommend = i.SMAID AND T.recommend = i.SMAID)
	
		-- Insert statements for trigger here
		INSERT INTO bodb02.dbo.DownlineTurnOver_Trigger (srecommend, mrecommend, recommend, matchid, sumstake)
		SELECT b.srecommend, mrecommend, recommend, b.matchid, SUM(b.stake) sumstake
		FROM bodb02.dbo.bettrans b with (nolock)
			INNER JOIN inserted i ON i.MatchID = b.MatchID AND (b.srecommend = i.SMAID OR b.mrecommend = i.SMAID AND b.recommend = i.SMAID)
		WHERE
			b.statusid NOT IN (101, 102, 103) 
		GROUP BY b.srecommend, mrecommend, recommend, b.matchid
	END
END
GO

----------------------------------------------------------------
-----Add trigger DownlineTo_Match_SMAControl_afterDelete--------
----------------------------------------------------------------
USE [bodb_Age]
GO
/****** Object:  Trigger [dbo].[DownlineTo_Match_SMAControl_afterUpdate]    Script Date: 4/25/2014 6:33:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[DownlineTo_Match_SMAControl_afterDelete]
   ON  [dbo].[DownlineTo_Match_SMAControl]
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	DECLARE @Value INT
	SELECT @Value = Value FROM deleted

	IF @Value = 0
	BEGIN
		DECLARE @SportID INT, @LeagueID INT, @MatchID INT
		SELECT @SportID = m.sporttype, @LeagueID = m.leagueid, @MatchID = m.matchID 
		FROM bodb02.dbo.match m WITH (NOLOCK) 
			INNER JOIN deleted d ON m.matchID = d.MatchID

		IF EXISTS (	SELECT 1 
					FROM DownlineTo_SportControl sc WITH (NOLOCK) WHERE sc.SportID = @SportID)
		OR EXISTS (	SELECT 1 
					FROM DownlineTo_LeagueControl lc WITH (NOLOCK) WHERE lc.leagueID = @LeagueID)			
		OR EXISTS (	SELECT 1 
					FROM DownlineTo_MatchControl mc WITH (NOLOCK) WHERE mc.MatchID = @MatchID)	
		BEGIN
			DELETE D
			FROM bodb02.dbo.DownlineTurnOver_Trigger D WITH(ROWLOCK,UPDLOCK)
			INNER JOIN inserted i ON i.MatchID = D.MatchID AND (D.srecommend = i.SMAID OR D.mrecommend = i.SMAID AND D.recommend = i.SMAID)
	
			DELETE T
			FROM bodb02.dbo.DownlineTurnOver_Trigger_tmp T WITH(ROWLOCK,UPDLOCK)
			INNER JOIN inserted i ON i.MatchID = T.MatchID AND (T.srecommend = i.SMAID OR T.mrecommend = i.SMAID AND T.recommend = i.SMAID)
	
			-- Insert statements for trigger here
			INSERT INTO bodb02.dbo.DownlineTurnOver_Trigger (srecommend, mrecommend, recommend, matchid, sumstake)
			SELECT b.srecommend, mrecommend, recommend, b.matchid, SUM(b.stake) sumstake
			FROM bodb02.dbo.bettrans b with (nolock)
				INNER JOIN inserted i ON i.MatchID = b.MatchID AND (b.srecommend = i.SMAID OR b.mrecommend = i.SMAID AND b.recommend = i.SMAID)
			WHERE
				b.statusid NOT IN (101, 102, 103) 
			GROUP BY b.srecommend, mrecommend, recommend, b.matchid
		END
	END
END
