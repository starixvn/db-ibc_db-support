/*
	Created: Johnson
	Date: 2014-06-13
	Task: Correct pt settings HR Fixed Odds for licensees
	DB: DBTXN/CustDB
*/ 

DECLARE @tmpCust TABLE(custid INT)

INSERT INTO @tmpCust(custid)
	  select 	1125616	--	AB88RMB012528
union select 	1683243	--	AB88RMB019813
union select 	10413002	--	ALogRMB018779
union select 	12031909	--	AlogWON012095
union select 	12681866	--	AlogWON013302
union select 	12707652	--	AlogWON013371
union select 	12718389	--	AlogWON013408
union select 	11186037	--	AlogWON01949
union select 	12708555	--	AoncashIN012737
union select 	12917540	--	AoncashIN012878
union select 	13213484	--	AoncashIN013141
union select 	13215944	--	AoncashIN013147
union select 	13329432	--	AoncashIN013240
union select 	13333453	--	AoncashIN013253
union select 	13384353	--	AoncashIN013285
union select 	13542554	--	AoncashIN013427
union select 	13631285	--	AoncashIN013543
union select 	13644768	--	AoncashIN013561
union select 	13759389	--	AoncashIN013782
union select 	13789258	--	AoncashIN013869
union select 	13814108	--	AoncashIN013981
union select 	13818385	--	AoncashIN014004
union select 	13837400	--	AoncashIN014062
union select 	13868930	--	AoncashIN014183
union select 	13872265	--	AoncashIN014206
union select 	13881729	--	AoncashIN014236
union select 	13898174	--	AoncashIN014287
union select 	13938794	--	AoncashIN014429
union select 	14049571	--	AoncashIN014737
union select 	10662604	--	MFRMB0125882
union select 	11733611	--	MFRMB0127743
union select 	13512040	--	MFRMB0130412
union select 	13827885	--	MFRMB0130974

UPDATE Dep_custsetting WITH(UPDLOCK,ROWLOCK)
SET apositiontaking = 0.85
WHERE custid IN (SELECT custid FROM @tmpCust)
AND sporttype = 154 AND bettype = 20