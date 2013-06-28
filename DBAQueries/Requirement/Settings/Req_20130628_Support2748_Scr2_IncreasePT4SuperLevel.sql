/*
	Create by: Jamie
	Date: 2013-06-28 
	Task: Increase PT for some SUPERs  
		+ KOEN KO Sheet 
*/

DECLARE	@pt	MONEY

SELECT	@pt = 0.8 

CREATE TABLE #tmpSrecommend(
	CustID	INT PRIMARY KEY 
)

-- 68 Supers 
INSERT INTO #tmpSrecommend(CustID)
		  SELECT 	3390616	----	QHN
UNION ALL SELECT 	3390621	----	QVN
UNION ALL SELECT 	262637	----	SCK
UNION ALL SELECT 	3412762	----	SHB
UNION ALL SELECT 	3508886	----	SHD
UNION ALL SELECT 	2198456	----	SKA
UNION ALL SELECT 	2793195	----	SKAA
UNION ALL SELECT 	2798869	----	SKAB
UNION ALL SELECT 	2798950	----	SKAC
UNION ALL SELECT 	2850839	----	SKAD
UNION ALL SELECT 	2853316	----	SKAE
UNION ALL SELECT 	2877199	----	SKAF
UNION ALL SELECT 	2975866	----	SKAG
UNION ALL SELECT 	3024023	----	SKAH
UNION ALL SELECT 	3024027	----	SKAI
UNION ALL SELECT 	3024035	----	SKAJ
UNION ALL SELECT 	3390623	----	SKAN
UNION ALL SELECT 	3472707	----	SKAO
UNION ALL SELECT 	3472732	----	SKAP
UNION ALL SELECT 	3535165	----	SKAR
UNION ALL SELECT 	3675856	----	SKAS
UNION ALL SELECT 	3675859	----	SKAT
UNION ALL SELECT 	4166219	----	skau
UNION ALL SELECT 	4166221	----	skav
UNION ALL SELECT 	4664102	----	skaw
UNION ALL SELECT 	4664106	----	skax
UNION ALL SELECT 	4664111	----	skay
UNION ALL SELECT 	5208493	----	skaz
UNION ALL SELECT 	2198458	----	SKB
UNION ALL SELECT 	5208504	----	skba
UNION ALL SELECT 	5208528	----	skbb
UNION ALL SELECT 	5881765	----	SKBC
UNION ALL SELECT 	5881771	----	SKBD
UNION ALL SELECT 	5933382	----	SKBE
UNION ALL SELECT 	5933395	----	SKBF
UNION ALL SELECT 	6000983	----	skbg
UNION ALL SELECT 	6001004	----	skbh
UNION ALL SELECT 	6660090	----	SKBI
UNION ALL SELECT 	6660095	----	SKBJ
UNION ALL SELECT 	7164448	----	SKBK
UNION ALL SELECT 	7164462	----	SKBL
UNION ALL SELECT 	7164469	----	SKBM
UNION ALL SELECT 	8296284	----	skbn
UNION ALL SELECT 	1727939	----	SKD
UNION ALL SELECT 	1977102	----	SKE
UNION ALL SELECT 	1977147	----	SKF
UNION ALL SELECT 	1977150	----	SKG
UNION ALL SELECT 	1978806	----	SKH
UNION ALL SELECT 	2113740	----	SKI
UNION ALL SELECT 	2126540	----	SKJ
UNION ALL SELECT 	2462931	----	SKK
UNION ALL SELECT 	3122695	----	SKKA
UNION ALL SELECT 	731165	----	SKKS
UNION ALL SELECT 	2198461	----	SKL
UNION ALL SELECT 	2793182	----	skn
UNION ALL SELECT 	2503678	----	SKO
UNION ALL SELECT 	2793190	----	skp
UNION ALL SELECT 	2198868	----	SKQ
UNION ALL SELECT 	923727	----	SKS
UNION ALL SELECT 	1727945	----	SKV
UNION ALL SELECT 	1898175	----	SKW
UNION ALL SELECT 	1940367	----	SKX
UNION ALL SELECT 	1999503	----	SKY
UNION ALL SELECT 	2075785	----	SKZ
UNION ALL SELECT 	3286734	----	U2
UNION ALL SELECT 	1435478	----	VID
UNION ALL SELECT 	391471	----	VIP
UNION ALL SELECT 	2470330	 ----	VIU

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
		
--3. Live Casino 90%
SELECT	@pt = 0.9

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