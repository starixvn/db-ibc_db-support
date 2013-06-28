/*
	Create by: Jamie
	Date: 2013-06-28 
	Task: Increase PT for some SUPERs  
		+ OTHER Sheet 
*/

DECLARE	@pt	MONEY

SELECT	@pt = 0.8 

CREATE TABLE #tmpSrecommend(
	CustID	INT PRIMARY KEY 
)

-- 31 Supers 
INSERT INTO #tmpSrecommend(CustID)
		  SELECT 	4521633	----	ABB
UNION ALL SELECT 	1388381	----	ABS
UNION ALL SELECT 	1358405	----	BBBU
UNION ALL SELECT 	1593192	----	CKU
UNION ALL SELECT 	4578528	----	CT
UNION ALL SELECT 	5340153	----	FYU
UNION ALL SELECT 	6649511	----	HEA
UNION ALL SELECT 	3341773	----	HEU
UNION ALL SELECT 	2491562	----	JU
UNION ALL SELECT 	11550395	----	KKU
UNION ALL SELECT 	10507224	----	QQUS
UNION ALL SELECT 	1916469	----	S11U
UNION ALL SELECT 	4305839	----	S318U
UNION ALL SELECT 	2209644	----	S47U
UNION ALL SELECT 	9332492	----	S56US
UNION ALL SELECT 	1342541	----	S5BU
UNION ALL SELECT 	979564	----	S5U
UNION ALL SELECT 	1598401	----	S80U
UNION ALL SELECT 	2770628	----	S922U
UNION ALL SELECT 	4901252	----	S922US
UNION ALL SELECT 	1211012	----	SBSU
UNION ALL SELECT 	3145317	----	SBWU
UNION ALL SELECT 	2179621	----	SBZU
UNION ALL SELECT 	1811627	----	SHU
UNION ALL SELECT 	1358418	----	SHUS
UNION ALL SELECT 	11550438	----	SJU
UNION ALL SELECT 	1472433	----	SPEU
UNION ALL SELECT 	324619	----	SPUS
UNION ALL SELECT 	1104471	----	SS31U
UNION ALL SELECT 	1104455	----	SS32U
UNION ALL SELECT 	7945498	 ----	U311

--1. Sportsbook : 80% 
SELECT	@pt = 0.8 

UPDATE	custSetting WITH (UPDLOCK,ROWLOCK)
SET		 spositiontaking		= @pt
		,mpositiontaking		= @pt
		,apositiontaking		= @pt
		,slivepositiontaking	= CASE WHEN sporttype = 1 AND bettype IN (1,3,7,8) THEN @pt ELSE 0 END 
		,mlivepositiontaking	= CASE WHEN sporttype = 1 AND bettype IN (1,3,7,8) THEN @pt ELSE 0 END 
		,alivepositiontaking	= CASE WHEN sporttype = 1 AND bettype IN (1,3,7,8) THEN @pt ELSE 0 END 
WHERE	CustID IN (
			SELECT	CustID	FROM #tmpSrecommend WITH (NOLOCK)  
		)
		
UPDATE	custOverride WITH (UPDLOCK,ROWLOCK)
SET		 maxpositiontaking		= @pt
		,maxlivepositiontaking	= CASE WHEN sporttype = 1 AND bettype IN(1,3,7,8) THEN @pt ELSE maxlivepositiontaking END 
WHERE	CustID IN (
			SELECT	CustID	FROM #tmpSrecommend WITH (NOLOCK)  
		)
		
--2. Number Game 85%
SELECT	@pt = 0.85 

UPDATE	CustSetting3rd WITH (UPDLOCK,ROWLOCK)
SET		spositiontaking		= CASE WHEN bettype IN (81, 83, 86, 88) THEN @pt ELSE spositiontaking END 
		,mpositiontaking	= CASE WHEN bettype IN (81, 83, 86, 88) THEN @pt ELSE mpositiontaking END
		,apositiontaking	= CASE WHEN bettype IN (81, 83, 86, 88) THEN @pt ELSE apositiontaking END 
		,slivepositiontaking	= CASE WHEN bettype IN (85, 86, 87, 89, 90) THEN @pt ELSE slivepositiontaking END 
		,mlivepositiontaking	= CASE WHEN bettype IN (85, 86, 87, 89, 90) THEN @pt ELSE mlivepositiontaking END 
		,alivepositiontaking	= CASE WHEN bettype IN (85, 86, 87, 89, 90) THEN @pt ELSE alivepositiontaking END 
WHERE	sporttype = 161 
		AND bettype BETWEEN 81 AND 90 
		AND CustID IN (
			SELECT	CustID	FROM #tmpSrecommend WITH (NOLOCK)  
		)
		
UPDATE	custOverride3rd WITH (UPDLOCK,ROWLOCK)
SET		 maxpositiontaking		= CASE WHEN bettype IN (81, 83, 86, 88) THEN @pt ELSE maxpositiontaking END  
		,maxlivepositiontaking	= CASE WHEN bettype IN (85, 86, 87, 89, 90) THEN @pt ELSE maxlivepositiontaking END
WHERE	sporttype = 161 
		AND bettype BETWEEN 81 AND 90 
		AND CustID IN (
			SELECT	CustID	FROM #tmpSrecommend WITH (NOLOCK)  
		)
		
--3. Live Casino 93%
SELECT	@pt = 0.93

UPDATE	CustSettingGame WITH (UPDLOCK,ROWLOCK)
SET		spositiontaking = @pt 
WHERE	Sporttype = 162 
		AND Bettype = 1101 
		AND CustID IN (
			SELECT	CustID	FROM #tmpSrecommend WITH (NOLOCK)  
		)

--4. Virtual Sports 85% 
SELECT	@pt = 0.85 

UPDATE	CustSetting3rd WITH (UPDLOCK,ROWLOCK)
SET		spositiontaking		= @pt  
		,mpositiontaking	= @pt
		,apositiontaking	= @pt
WHERE	sporttype = 180  
		AND bettype = 1201 
		AND CustID IN (
			SELECT	CustID	FROM #tmpSrecommend WITH (NOLOCK)  
		)
		
UPDATE	custOverride3rd WITH (UPDLOCK,ROWLOCK)
SET		 maxpositiontaking	= @pt 	
WHERE	sporttype = 180  
		AND bettype = 1201 
		AND CustID IN (
			SELECT	CustID	FROM #tmpSrecommend WITH (NOLOCK)  
		)
	

DROP TABLE #tmpSrecommend	