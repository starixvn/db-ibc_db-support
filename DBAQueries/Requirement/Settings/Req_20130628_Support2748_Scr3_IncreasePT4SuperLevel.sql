/*
	Create by: Jamie
	Date: 2013-06-28 
	Task: Increase PT for some SUPERs  
		+ YAT KO Sheet 
*/

DECLARE	@pt	MONEY

SELECT	@pt = 0.8 

CREATE TABLE #tmpSrecommend(
	CustID	INT PRIMARY KEY 
)

-- 60 Supers 
INSERT INTO #tmpSrecommend(CustID)
		  SELECT 	7932892	----	AAB
UNION ALL SELECT 	7902402	----	SDA
UNION ALL SELECT 	5800564	----	SDB
UNION ALL SELECT 	5800577	----	SDC
UNION ALL SELECT 	262641	----	SDD
UNION ALL SELECT 	1174759	----	SDE
UNION ALL SELECT 	5824370	----	SDF
UNION ALL SELECT 	5824374	----	SDG
UNION ALL SELECT 	5871571	----	SDI
UNION ALL SELECT 	5375392	----	SDJ
UNION ALL SELECT 	5362504	----	SDK
UNION ALL SELECT 	5362508	----	SDL
UNION ALL SELECT 	5871590	----	SDN
UNION ALL SELECT 	10181770	----	SDN1
UNION ALL SELECT 	10181790	----	SDN2
UNION ALL SELECT 	10558395	----	SDN3
UNION ALL SELECT 	5394907	----	SDO
UNION ALL SELECT 	5419321	----	SDP
UNION ALL SELECT 	9285643	----	SDQ
UNION ALL SELECT 	9285744	----	SDS
UNION ALL SELECT 	3115624	----	SDU
UNION ALL SELECT 	5226628	----	SDV
UNION ALL SELECT 	5226641	----	SDW
UNION ALL SELECT 	5226650	----	SDX
UNION ALL SELECT 	5213502	----	SDY
UNION ALL SELECT 	5915537	----	SDY1
UNION ALL SELECT 	8265079	----	SDY2
UNION ALL SELECT 	8812070	----	SDY3
UNION ALL SELECT 	9020799	----	SDY5
UNION ALL SELECT 	9432645	----	SDY6
UNION ALL SELECT 	9659841	----	SDY7
UNION ALL SELECT 	10223418	----	SDY8
UNION ALL SELECT 	10675880	----	SDY9
UNION ALL SELECT 	5226659	----	SDZ
UNION ALL SELECT 	8394258	----	SQY
UNION ALL SELECT 	342710	----	SY1B
UNION ALL SELECT 	6087439	----	SYA
UNION ALL SELECT 	6087443	----	SYB
UNION ALL SELECT 	6714757	----	SYC
UNION ALL SELECT 	9579809	----	SYC2
UNION ALL SELECT 	7124243	----	SYD
UNION ALL SELECT 	7209880	----	SYE
UNION ALL SELECT 	7263508	----	SYF
UNION ALL SELECT 	7545783	----	SYG
UNION ALL SELECT 	7596465	----	SYH
UNION ALL SELECT 	7596486	----	SYJ
UNION ALL SELECT 	7596503	----	SYK
UNION ALL SELECT 	7596522	----	SYL
UNION ALL SELECT 	7596533	----	SYN
UNION ALL SELECT 	7596541	----	SYO
UNION ALL SELECT 	7596578	----	SYP
UNION ALL SELECT 	7596597	----	SYQ
UNION ALL SELECT 	7596613	----	SYS
UNION ALL SELECT 	7596636	----	SYU
UNION ALL SELECT 	7651563	----	SYV
UNION ALL SELECT 	7651639	----	SYW
UNION ALL SELECT 	7703331	----	SYY
UNION ALL SELECT 	8211131	----	SYZ
UNION ALL SELECT 	8594867	----	SYZ1
UNION ALL SELECT 	10279904	----	UZA

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
		
--2. Number Game 80%
SELECT	@pt = 0.8 

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
		
--3. Live Casino 80%
SELECT	@pt = 0.8

UPDATE	CustSettingGame WITH (UPDLOCK,ROWLOCK)
SET		spositiontaking = @pt 
WHERE	Sporttype = 162 
		AND Bettype = 1101 
		AND CustID IN (
			SELECT	CustID	FROM #tmpSrecommend WITH (NOLOCK)  
		)

--4. Virtual Sports 80% 
SELECT	@pt = 0.8 

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