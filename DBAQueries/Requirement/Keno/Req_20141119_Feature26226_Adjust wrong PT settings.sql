/*
	Created: Johnson
	Date: 2014-11-19
	Task: adjust wrong pt setting for Keno, LiveCasino
	DB: DBTXN/CustDB
*/ 

---Live casino
--M797RMAG018(2845939)
--set m1 = 0.23
UPDATE CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET mpositiontaking = 0.23
WHERE custid = 2845939
	AND sporttype = 162
	AND bettype = 1101
GO

--SCHQC99666(8660262)
--set s1= 0.13,m1= 0, a1= 0.7
UPDATE CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = 0.13,
	mpositiontaking = 0,
	apositiontaking = 0.7
WHERE custid = 8660262
	AND sporttype = 162
	AND bettype = 1101
	
--Downlines of agent M797RMAG (1428265)
EXEC dbo.Acc_CustSetting3rd_07 @recommend = 1428265, @roleid = 2, @mode = 'LiveCasino'
GO

--Downlines of AGENT MMYBH02 (3360763)	
EXEC dbo.Acc_CustSetting3rd_07 @recommend = 3360763, @roleid = 2, @mode = 'LiveCasino'
GO	

--Downlines of AGENT M797RM71 (2933575)
EXEC dbo.Acc_CustSetting3rd_07 @recommend = 2933575, @roleid = 2, @mode = 'LiveCasino'
GO	

--Agent AHU0159 (12049607)
--Set m2 = 0.6
UPDATE CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET mpositiontaking = 0.6
WHERE custid = 12049607
	AND sporttype = 162
	AND bettype = 1101
GO

--Correct downlines of agent AHU0159
EXEC dbo.Acc_CustSetting3rd_07 @recommend = 12049607, @roleid = 2, @mode = 'LiveCasino'
GO	
---------------------------------------------------

--Keno
--SBKR (613094)
--set s4,m4,a4 = 0.85
UPDATE CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = 0.85,
	mpositiontaking = 0.85,
	apositiontaking = 0.85
WHERE custid = 613094
	AND sporttype = 202
GO

--S11HH (951650)	
--set s4,m4,a4 = 0.8
UPDATE CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = 0.8,
	mpositiontaking = 0.8,
	apositiontaking = 0.8
WHERE custid = 951650
	AND sporttype = 202
GO

--K988RR (16300335)
--set a2 = 0.7, m2=0 for bettype 1503(Slovakia Eklub)
UPDATE CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET mpositiontaking = 0,
	apositiontaking = 0.7
WHERE custid = 16300335
	AND sporttype = 202
	AND bettype = 1503
GO

--Downlines of agent MG1666 (16247499)
EXEC dbo.Acc_CustSetting3rd_07 @recommend = 16247499, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1501
GO
EXEC dbo.Acc_CustSetting3rd_07 @recommend = 16247499, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1503
GO
EXEC dbo.Acc_CustSetting3rd_07 @recommend = 16247499, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1504
GO
EXEC dbo.Acc_CustSetting3rd_07 @recommend = 16247499, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1505
GO
EXEC dbo.Acc_CustSetting3rd_07 @recommend = 16247499, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1507
GO
EXEC dbo.Acc_CustSetting3rd_07 @recommend = 16247499, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1508
GO
EXEC dbo.Acc_CustSetting3rd_07 @recommend = 16247499, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1509
GO
EXEC dbo.Acc_CustSetting3rd_07 @recommend = 16247499, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1511
GO
EXEC dbo.Acc_CustSetting3rd_07 @recommend = 16247499, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1513
GO

--sa-pppp (1090001)
--set s4,m4,a4= 0.85
UPDATE CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = 0.85,
	mpositiontaking = 0.85,
	apositiontaking = 0.85
WHERE custid = 1090001
	AND sporttype = 202	