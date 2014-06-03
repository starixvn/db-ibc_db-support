/*
	Created by: Elodie
	Date: 2014-04-08
	Task: Modify trigger for SMA Turnover in phrase 2 [Redmine:#14426]	
	Database: DBAGE/bodb_Age
*/
----------------------------------------------------------------
-----Modify trigger DownlineTo_Match_SMAControl_afterInsert-----
---------------------------------------------------------------- 
USE [bodb_Age]
GO
/****** Object:  Trigger [dbo].[DownlineTo_Match_SMAControl_afterInsert]    Script Date: 6/2/2014 2:50:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[DownlineTo_Match_SMAControl_afterInsert]
   ON  [dbo].[DownlineTo_Match_SMAControl]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	IF EXISTS (SELECT 1 FROM inserted WHERE Value <> 0)
	BEGIN
		--DECLARE @SportID INT, @LeagueID INT, @MatchID INT, @SMAOffset INT, @SMAID INT
		--SELECT @SportID = m.sporttype, @LeagueID = m.leagueid, @MatchID = m.matchID, @SMAID = i.SMAID
		--FROM bodb02.dbo.match m WITH (NOLOCK) 
		--	INNER JOIN inserted i ON m.matchID = i.MatchID
		
		--DECLARE @SportValue INT, @LeagueValue INT, @MatchValue INT
		--SELECT @SportValue = NULL, @LeagueValue = NULL, @MatchValue = NULL, @SMAOffset = NULL

		--SELECT @SportValue = Value FROM DownlineTo_SportControl sc WITH (NOLOCK) WHERE sc.SportID = @SportID
		--SELECT @LeagueValue = Value FROM DownlineTo_LeagueControl lc WITH (NOLOCK) WHERE lc.leagueID = @LeagueID
		--SELECT @MatchValue = Value FROM DownlineTo_MatchControl mc WITH (NOLOCK) WHERE mc.MatchID = @MatchID
		--SELECT @SMAOffset = Offset FROM DownlineTo_SMAControl sma WITH (NOLOCK) WHERE sma.SMAID = @SMAID

		--IF  NOT ((@MatchValue IS NOT NULL AND @MatchValue <> 0) 
		--OR (@LeagueValue IS NOT NULL AND @LeagueValue <> 0 AND (@MatchValue <> 0 OR @MatchValue IS NULL))
		--OR (@SportValue IS NOT NULL AND (@LeagueValue <> 0 OR @LeagueValue IS NULL) AND (@MatchValue <> 0 OR @MatchValue IS NULL)))
		--OR (@SMAOffset IS NOT NULL AND @SMAOffset = 0)
		--BEGIN
			DELETE D
			FROM bodb02.dbo.DownlineTurnOver_Trigger D WITH(ROWLOCK,UPDLOCK)
			INNER JOIN inserted i ON i.MatchID = D.MatchID AND (D.srecommend = i.SMAID OR D.mrecommend = i.SMAID OR D.recommend = i.SMAID)
	
			DELETE T
			FROM bodb02.dbo.DownlineTurnOver_Trigger_tmp T WITH(ROWLOCK,UPDLOCK)
			INNER JOIN inserted i ON i.MatchID = T.MatchID AND (T.srecommend = i.SMAID OR T.mrecommend = i.SMAID OR T.recommend = i.SMAID)
	
			-- Insert statements for trigger here
			INSERT INTO bodb02.dbo.DownlineTurnOver_Trigger (srecommend, mrecommend, recommend, matchid, sumstake)
			SELECT b.srecommend, mrecommend, recommend, b.matchid, SUM(b.stake) sumstake
			FROM bodb02.dbo.bettrans b with (nolock)
				INNER JOIN inserted i ON i.MatchID = b.MatchID AND (b.srecommend = i.SMAID OR b.mrecommend = i.SMAID OR b.recommend = i.SMAID)
			WHERE
				b.statusid NOT IN (101, 102, 103) 
			GROUP BY b.srecommend, mrecommend, recommend, b.matchid
		--END
	END
END

--Disable trigger
--DBAGE
USE bodb_Age
GO
DISABLE TRIGGER DownlineTo_Match_SMAControl_afterDelete ON DownlineTo_Match_SMAControl