/*
	Created: Johnson
	Date: 20140924
	Task: Adjust wrong pt settings for customers
	DB: DBTXN/CustDB
*/ 
--Wrong Number game
--S2R3289001(2522974) ,S2R3289015 (4249266)
--SET m1= 0
UPDATE custsetting3rd WITH(UPDLOCK,ROWLOCK)
SET mpositiontaking = CASE WHEN mpositiontaking < 0 THEN 0.15 ELSE mpositiontaking END,
	mlivepositiontaking = CASE WHEN mlivepositiontaking < 0 THEN 0.15 ELSE mlivepositiontaking END
WHERE custid IN (2522974, 4249266)
	AND sporttype = 161
GO

--JSCZ5 (5582220)
-- us3> s4 -> set us3 = 0.7
--no have members
UPDATE custsetting3rd WITH(UPDLOCK,ROWLOCK)
SET autolivepositiontaking = 0.7
WHERE custid = 5582220
	AND sporttype = 161
	AND bettype IN (89,90)
	AND isautolivepositiontaking = 1
GO
--AA12 (1596664)
--m3<n3 -> set m3 =0.7
UPDATE custsetting3rd WITH(UPDLOCK,ROWLOCK)
SET mpositiontaking = CASE WHEN bettype IN (81,83,86,88) AND mpositiontaking = 0 THEN 0.7 ELSE mpositiontaking END,
	mlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND mlivepositiontaking = 0 THEN 0.7 ELSE mlivepositiontaking END
WHERE custid = 1596664
	AND sporttype = 161
GO

--BA01 (1587352)
--m3<n3 -> set m3=0.72
UPDATE custsetting3rd WITH(UPDLOCK,ROWLOCK)
SET mpositiontaking = CASE WHEN bettype IN (81,83,86,88) AND mpositiontaking = 0 THEN 0.72 ELSE mpositiontaking END,
	mlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND mlivepositiontaking = 0 THEN 0.72 ELSE mlivepositiontaking END
WHERE custid = 1587352
	AND sporttype = 161
GO

--BA75 (1587333), BA76 (1587346), BA79 (1587335),BA80 (1587339)
--m3<n3 -> set m3=0.67
UPDATE custsetting3rd WITH(UPDLOCK,ROWLOCK)
SET mpositiontaking = CASE WHEN bettype IN (81,83,86,88) AND mpositiontaking = 0 THEN 0.67 ELSE mpositiontaking END,
	mlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND mlivepositiontaking = 0 THEN 0.67 ELSE mlivepositiontaking END
WHERE custid IN (1587333,1587346, 1587335, 1587339)
	AND sporttype = 161
GO

--BA90 (2377991)
--m3<n3 -> set m3=0.75

UPDATE custsetting3rd WITH(UPDLOCK,ROWLOCK)
SET mpositiontaking = CASE WHEN bettype IN (81,83,86,88) AND mpositiontaking = 0 THEN 0.75 ELSE mpositiontaking END,
	mlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND mlivepositiontaking = 0 THEN 0.75 ELSE mlivepositiontaking END
WHERE custid IN (2377991)
	AND sporttype = 161
GO

--BASY (1607963)	
--m3<n3 -> set m3=0.7	
UPDATE custsetting3rd WITH(UPDLOCK,ROWLOCK)
SET mpositiontaking = CASE WHEN bettype IN (81,83,86,88) AND mpositiontaking = 0 THEN 0.7 ELSE mpositiontaking END,
	mlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND mlivepositiontaking = 0 THEN 0.7 ELSE mlivepositiontaking END
WHERE custid IN (1607963)
	AND sporttype = 161
GO

--SWWMM (11640137)
--m3<n3 -> set m3=0.4
UPDATE custsetting3rd WITH(UPDLOCK,ROWLOCK)
SET mpositiontaking = CASE WHEN bettype IN (81,83,86,88) AND mpositiontaking = 0 THEN 0.4 ELSE mpositiontaking END,
	mlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND mlivepositiontaking = 0 THEN 0.4 ELSE mlivepositiontaking END
WHERE custid IN (11640137)
	AND sporttype = 161
GO

--BA9000 (2379097)
--a2<n2 -> set a2 = 0.6
UPDATE custsetting3rd WITH(UPDLOCK,ROWLOCK)
SET apositiontaking = CASE WHEN bettype IN (81,83,86,88) AND apositiontaking = 0 THEN 0.6 ELSE apositiontaking END,
	alivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND alivepositiontaking = 0 THEN 0.6 ELSE alivepositiontaking END
WHERE custid IN (2379097)
	AND sporttype = 161
GO
	
--BA9103 (2501950),BA9104 (2502007),BA9111 (2500418)
--a2<n2 -> set a2 = 0.4
UPDATE custsetting3rd WITH(UPDLOCK,ROWLOCK)
SET apositiontaking = CASE WHEN bettype IN (81,83,86,88) AND apositiontaking = 0 THEN 0.4 ELSE apositiontaking END,
	alivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND alivepositiontaking = 0 THEN 0.4 ELSE alivepositiontaking END
WHERE custid IN (2501950,2502007,2500418)
	AND sporttype = 161
GO

--Wrong RACING setting
--B25TBK05 (8279902)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04
    @srecommend = 1588145,
    @mrecommend = 2186892,
    @recommend  = 8279902,
    @mode		= 'horse',   
    @roleid		= 2
GO

--B29TAB14 (9643190)   
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 7815141,@mrecommend = 8981934,@recommend = 9643190,@mode = 'horse', @roleid = 2
GO

--B4T3299 (2059760)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 1528413,@mrecommend = 1536510,@recommend = 2059760,@mode = 'horse', @roleid = 2
GO

--B4T33C1 (10853518)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 1528413,@mrecommend = 1536516,@recommend = 10853518,@mode = 'horse', @roleid = 2
GO

--B6T7Y5S (8283528)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 1528414,@mrecommend = 7275859,@recommend = 8283528,@mode = 'horse', @roleid = 2
GO

--B6T7Y61 (7706131)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 1528414,@mrecommend = 7275859,@recommend = 7706131,@mode = 'horse', @roleid = 2
GO

--B6T7Y71 (7706190)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 1528414,@mrecommend = 7275859,@recommend = 7706190,@mode = 'horse', @roleid = 2
GO

--YI5517 (10855517)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 2270259,@mrecommend = 10848695,@recommend = 10855517,@mode = 'horse', @roleid = 2
GO

--ZZUSSS (10357760)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 5532706,@mrecommend = 10357719,@recommend = 10357760,@mode = 'horse', @roleid = 2
GO


--B6T7Y82 (10487595)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 1528414,@mrecommend = 7275859,@recommend = 10487595,@mode = 'horse', @roleid = 2
GO

--BT5102 (1778227)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 1517030,@mrecommend = 1521543,@recommend = 1778227,@mode = 'horse', @roleid = 2
GO

--CS0250 (10348397)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 2131553,@mrecommend = 2275826,@recommend = 10348397,@mode = 'horse', @roleid = 2
GO

--HIKK22 (10854387)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 641918,@mrecommend = 3611277,@recommend = 10854387,@mode = 'horse', @roleid = 2
GO

--HT1ZZ11 (10191613)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 9931047,@mrecommend = 10191527,@recommend = 10191613,@mode = 'horse', @roleid = 2
GO

--IIQQ01 (10925040)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 689767,@mrecommend = 9415944,@recommend = 10925040,@mode = 'horse', @roleid = 2
GO

--KKT3377 (11318590)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 9933512,@mrecommend = 11318222,@recommend = 11318590,@mode = 'horse', @roleid = 2
GO

--LHC999 (8100297)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 2749224,@mrecommend = 8100145,@recommend = 8100297,@mode = 'horse', @roleid = 2
GO

--LVV100 (10667839)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 4006796,@mrecommend = 10665345,@recommend = 10667839,@mode = 'horse', @roleid = 2
GO

--M36ERMB11 (2419583)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 324559,@mrecommend = 127268,@recommend = 2419583,@mode = 'horse', @roleid = 2
GO

--M36ERMB13 (1009065)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 324559,@mrecommend = 127268,@recommend = 1009065,@mode = 'horse', @roleid = 2
GO

--M36ERMB24 (453396)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 324559,@mrecommend = 127268,@recommend = 453396,@mode = 'horse', @roleid = 2
GO

--M36ERMB67 (6092554)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 324559,@mrecommend = 127268,@recommend = 6092554,@mode = 'horse', @roleid = 2
GO


--M36ERMB76 (937662)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 324559,@mrecommend = 127268,@recommend = 937662,@mode = 'horse', @roleid = 2
GO

--M36ERMB98 (1258846)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 324559,@mrecommend = 127268,@recommend = 1258846,@mode = 'horse', @roleid = 2
GO

--S47DR2272 (8663618)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 8553985,@mrecommend = 8579821,@recommend = 8663618,@mode = 'horse', @roleid = 2
GO

--S47DR7777 (8664482)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 8553985,@mrecommend = 8579986,@recommend = 8664482,@mode = 'horse', @roleid = 2
GO

--S7KW0107 (11312927)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 10910070,@mrecommend = 10918662,@recommend = 11312927,@mode = 'horse', @roleid = 2
GO

--SHHK1FA11 (2442631)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 2019286,@mrecommend = 2442624,@recommend = 2442631,@mode = 'horse', @roleid = 2
GO

--SHHK1FA11 (2442631)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 2019286,@mrecommend = 2442624,@recommend = 2442631,@mode = 'horse', @roleid = 2
GO

--HRMBAK18 (9341263)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 838053,@mrecommend = 5698021,@recommend = 9341263,@mode = 'horse', @roleid = 2
GO

--SHRMBAK80 (8559095)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 838053,@mrecommend = 5698021,@recommend = 8559095,@mode = 'horse', @roleid = 2
GO

--STEB8810 (11907670)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 2388779,@mrecommend = 2533795,@recommend = 11907670,@mode = 'horse', @roleid = 2
GO

--STEBTT22 (7241523)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 2388779,@mrecommend = 2549753,@recommend = 7241523,@mode = 'horse', @roleid = 2
GO

--WIKKSU (2142759)
--wrong a1<n2
EXEC Acc_CustSetting3rd_04 @srecommend = 1124040,@mrecommend = 1124126,@recommend = 2142759,@mode = 'horse', @roleid = 2
GO

--VM (5938255)
--wrong L4 < S1 + M1 + A1-> set l4 =0.5
UPDATE CustOverride3rd WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = 0.5
WHERE custid = 5938255
	AND sporttype = 152
	AND bettype IN (51,52)
GO

--IF28 (5918775)
--wrong MIN (S4-M1-A1, (IS1?US1,US3)) > S1
EXEC dbo.Acc_CustSetting3rd_07 @srecommend = 5880048, @mrecommend = 5918775, @roleid = 3, @mode = 'horse'
GO

--S71HUU (3215406)
--wrong MIN (S4-M1-A1, (IS1?US1,US3)) > S1
EXEC dbo.Acc_CustSetting3rd_07 @srecommend = 993226, @mrecommend = 3215406, @roleid = 3, @mode = 'horse'
GO

--UA88 (4679956)
--wrong MIN (S4-M1-A1, (IS1?US1,US3)) > S1
EXEC dbo.Acc_CustSetting3rd_07 @srecommend = 4677011, @mrecommend = 4679956, @roleid = 3, @mode = 'horse'
GO

--B15TV799 (1793259)
--wrong MIN (M4-A1, M3-A1, (IM1?UM1,UM2)) > M1
EXEC Acc_CustSetting3rd_04 @srecommend = 1538183,@mrecommend = 1774430,@recommend = 1793259,@mode = 'horse', @roleid = 2
GO

--UA8801 (4683040)
--wrong MIN (M4-A1, M3-A1, (IM1?UM1,UM2)) > M1
EXEC Acc_CustSetting3rd_04 @srecommend = 4677011,@mrecommend = 4679956,@recommend = 4683040,@mode = 'horse', @roleid = 2
GO

--S47RRB11 (1275136)
--wrong MIN (M4-A1, M3-A1, (IM1?UM1,UM2)) > M1
EXEC Acc_CustSetting3rd_04 @srecommend = 838051,@mrecommend = 838328,@recommend = 1275136,@mode = 'horse', @roleid = 2
GO

