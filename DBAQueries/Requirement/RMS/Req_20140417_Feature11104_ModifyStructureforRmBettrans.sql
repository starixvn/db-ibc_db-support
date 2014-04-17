 /*
	Created: Johnson
	Date: 2014-04-17
	Task: modify structure for rmBettrans
	DB: DBRMS/bodb_RMS
 */
 
 ALTER TABLE rmBettrans
ADD combo2 int NULL
GO

UPDATE rmBettrans WITH(UPDLOCK,ROWLOCK)
SET combo = CASE when matchid = 9 then RIGHT(betcheck,LEN(betcheck)-1) 
					else LEN(betteam) end