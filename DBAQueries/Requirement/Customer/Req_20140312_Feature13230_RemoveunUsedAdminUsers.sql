 /*
	Created: Johnson
	Date: 2014-03-12
	Task: Remove un-used admin users
	DB: DBTXN/CustDB
 */
 
 CREATE TABLE #tmpUsers (custid INT)
 
 --80 rows affected
 INSERT INTO #tmpUsers(custid)
 SELECT custid 
 FROM customers WITH(NOLOCK)
 WHERE username IN ('dbaJamieYen','dbaJamieNTD','pgmWilliamTHAI','pgmpaladintest2','pgmAccReport','pgmpaladintest3','pgmpaladintest4','pgmpaladintest5','pgmAndrew1','pgmbob1','pgmlewis','pgmtest','dbaAdmin','pgmchien','pgmkiwitest','pgmtai1','dbaVinh2','pgmkiwi7','dbaJamieUUS','pgmandrew5','pgmedward2','pgmtai3','pgmson','pgmedward1','pgmoperatortesting','pgmkiwi9','pgmtesting','pgmandrew3','pgmtest2','pgmIqcTest','pgmkhoa2','pgmedward3','pgmtest1','dbaThienYEN789','pgmiqctest1','pgmphuong2','pgmdaniel','pgmtaitest','pgmAndrew11','pgmtai2','pgmandrew2','pgmAndy2','pgmTai','dbaThienYEN889','pgmMartin2','pgmShifu','dbaJamieYEN789','pgmWilliamINDO','pgmAndy5','dbaJamie3','pgmDon','pgmWilliamDDD','dbaJamieIRR','dbaThienUSD','dbaJamieDDD','pgmtai4','dbaVinh3','PgmIQCTesting','Pgmtesting06','pgmta123','dbaJamieYEN889','dbaThienNTD','pgmCasey2','pgmtest111','dbaThienYEN','dbaThienTHAI','PgmIQCTesting01','pgmtesting3','pgmandrew4','PgmTesting05','dbaVinhTHAI','pgmJustinDoan','pgmkiwi8','dbaVinhINDO','pgmarthur','pgmtesting04','pgmAndy3','dbaThienINDO','pgmNhu','pgmkiwi6')

---DBA_AccAdminPolicyDel

DELETE FROM DBPOLICY.bodb02.dboAcc_MemberPolicy_1 WITH(ROWLOCK) WHERE Custid IN (SELECT custid FROM #tempUsers)
DELETE FROM DBPOLICY.bodb02.dboAccCustomer_1 WITH(ROWLOCK) WHERE Custid IN (SELECT custid FROM #tempUsers)

--DBA_AccAdminPolicyDel_RMS
DELETE FROM DBRMS.bodb_RMS.dbo.rmUserInfo WITH(ROWLOCK) WHERE userid IN (SELECT custid FROM #tempUsers)
DELETE FROM DBRMS.bodb_RMS.dbo.rmUserPolicy WITH(ROWLOCK) WHERE userid IN (SELECT custid FROM #tempUsers)

--Delete IBC tables
DELETE FROM dbo.CustInfo WITH(ROWLOCK) WHERE Custid IN (SELECT custid FROM #tempUsers)
DELETE FROM dbo.Customer WITH(ROWLOCK) WHERE Custid IN (SELECT custid FROM #tempUsers)
 