/*
	Created: Johnson
	Date: 2014-06-13
	Task: Correct pt settings virtual sports for licensees
	DB: DBTXN/CustDB
*/ 

DECLARE @tmpCust TABLE (custid INT, sporttype INT, bettype INT)

--72 rows affected
INSERT INTO @tmpCust(custid,sporttype,bettype)
	 select 	14670776	,	183	,	1231	--	12BETIN0118187
union select 	14670776	,	185	,	1231	--	12BETIN0118187
union select 	14670730	,	183	,	1231	--	12BETINH0224253
union select 	14670730	,	185	,	1231	--	12BETINH0224253
union select 	14670843	,	183	,	1231	--	12BETINH0224254
union select 	14670843	,	185	,	1231	--	12BETINH0224254
union select 	14670830	,	183	,	1231	--	12BETRMB0228652
union select 	14670830	,	185	,	1231	--	12BETRMB0228652
union select 	14670836	,	185	,	1231	--	12BETRMB0228653
union select 	14670836	,	183	,	1231	--	12BETRMB0228653
union select 	14670719	,	183	,	1231	--	12BETUS$016841
union select 	14670719	,	185	,	1231	--	12BETUS$016841
union select 	14670606	,	183	,	1231	--	AlogINR013945
union select 	14670606	,	185	,	1231	--	AlogINR013945
union select 	14670660	,	185	,	1231	--	ALogRMB0124906
union select 	14670660	,	183	,	1231	--	ALogRMB0124906
union select 	14670659	,	183	,	1231	--	ALogTB0136165
union select 	14670659	,	185	,	1231	--	ALogTB0136165
union select 	14670802	,	185	,	1231	--	AlogWON016300
union select 	14670802	,	183	,	1231	--	AlogWON016300
union select 	14670815	,	185	,	1231	--	AlogWON016301
union select 	14670815	,	183	,	1231	--	AlogWON016301
union select 	14670685	,	183	,	1231	--	TLCRMB0125579
union select 	14670685	,	185	,	1231	--	TLCRMB0125579
union select 	14670858	,	183	,	1231	--	TLCRMB0125580
union select 	14670858	,	185	,	1231	--	TLCRMB0125580
union select 	14670599	,	185	,	1231	--	MFRMB0132955
union select 	14670599	,	183	,	1231	--	MFRMB0132955
union select 	14670620	,	185	,	1231	--	BODOGRMB0133881
union select 	14670620	,	183	,	1231	--	BODOGRMB0133881
union select 	14670763	,	183	,	1231	--	BODOGRMB0133882
union select 	14670763	,	185	,	1231	--	BODOGRMB0133882
union select 	14670612	,	183	,	1231	--	W88IN0117403
union select 	14670612	,	185	,	1231	--	W88IN0117403
union select 	14670713	,	183	,	1231	--	W88IN0117404
union select 	14670713	,	185	,	1231	--	W88IN0117404
union select 	14670735	,	185	,	1231	--	W88IN0117405
union select 	14670735	,	183	,	1231	--	W88IN0117405
union select 	14670767	,	183	,	1231	--	W88IN0117406
union select 	14670767	,	185	,	1231	--	W88IN0117406
union select 	14670787	,	185	,	1231	--	W88IN0117407
union select 	14670787	,	183	,	1231	--	W88IN0117407
union select 	14670575	,	183	,	1231	--	W88INH0122317
union select 	14670575	,	185	,	1231	--	W88INH0122317
union select 	14670559	,	185	,	1231	--	W88RMB019584
union select 	14670559	,	183	,	1231	--	W88RMB019584
union select 	14670562	,	185	,	1231	--	W88RMB019585
union select 	14670562	,	183	,	1231	--	W88RMB019585
union select 	14670616	,	185	,	1231	--	W88RMB019586
union select 	14670616	,	183	,	1231	--	W88RMB019586
union select 	14670631	,	185	,	1231	--	W88RMB019587
union select 	14670631	,	183	,	1231	--	W88RMB019587
union select 	14670781	,	185	,	1231	--	W88RMB019588
union select 	14670781	,	183	,	1231	--	W88RMB019588
union select 	14670794	,	185	,	1231	--	W88RMB019589
union select 	14670794	,	183	,	1231	--	W88RMB019589
union select 	14670808	,	183	,	1231	--	W88RMB019590
union select 	14670808	,	185	,	1231	--	W88RMB019590
union select 	14670842	,	185	,	1231	--	W88RMB019591
union select 	14670842	,	183	,	1231	--	W88RMB019591
union select 	14670851	,	185	,	1231	--	W88RMB019592
union select 	14670851	,	183	,	1231	--	W88RMB019592
union select 	14670852	,	183	,	1231	--	W88RMB019593
union select 	14670852	,	185	,	1231	--	W88RMB019593
union select 	14670674	,	185	,	1231	--	W88TB013464
union select 	14670674	,	183	,	1231	--	W88TB013464
union select 	14670758	,	183	,	1231	--	W88TB013465
union select 	14670758	,	185	,	1231	--	W88TB013465
union select 	14670835	,	185	,	1231	--	W88TB013466
union select 	14670835	,	183	,	1231	--	W88TB013466
union select 	14670819	,	185	,	1231	--	Happy1668RMB01886
union select 	14670819	,	183	,	1231	--	Happy1668RMB01886

UPDATE cs
SET apositiontaking = 0.85
FROM dep_custsetting3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN @tmpCust t ON cs.custid = t.custid AND cs.sporttype = t.sporttype  AND cs.bettype = t.bettype