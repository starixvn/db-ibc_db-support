/*
	Created: Johnson
	Date: 2014-12-04
	Task: Adjust pt for keno for wrong customers
	DB: DBTXN/CustDB
*/ 

--AHF3802 (15465396)
--Keno (Slovakia)    [202-1503]
--set a2 = n2 = 0.7
UPDATE CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET apositiontaking = 0.7
WHERE custid = 15465396
	AND sporttype = 202
	AND bettype = 1503
GO

--2DHYJ (16556414)
--wrong m3< n3
--set m3 = n3 =0.7, s3 =0
--set m2 = 0.7
--set m1 = 0.7, s1 = 0
--CUSTOMER	2DHYJ00000 (16556940)
--AGENT	2DHYJ00 (16556859)
--MASTER	2DHYJ (16556414)

--Keno (West Canada )    [202-1505]
--Keno (Massachusetts)    [202-1507]	
--Keno (Ohio)    [202-1508]
--Keno (Malta)    [202-1509]
--Keno (Kentucky)    [202-1511]
--Keno (Michigan)    [202-1513]
UPDATE CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = 0,
	mpositiontaking = 0.7
WHERE custid IN (16556414,16556859,16556940)
	AND sporttype = 202
	AND bettype IN (1505,1507,1508,1509,1511,1513)