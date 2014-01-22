/*
	Created : Johnson
	Date: 20140122
	Task: Insert rmTransaction for system parlay
	DB: DBRMS/bodb_RMS
*/ 

DECLARE @max_transid BIGINT

SELECT @max_transid = xxx

INSERT INTO [dbo].[rmTransaction]
           ([transid]
           ,[refno]
           ,[custid]
           ,[combo])
 SELECT s.transid,s.refno,s.custid,LEN(s.betteam))
 FROM rmBettrans with(NOLOCK)
 WHERE matchid = 29
 and transid <= @max_transid 