/*
	Created: Lukas	
	Task: Clear old setting on HR FixOdds for credit customers
	DB: DBTXN/bodb02
*/



/*
select ci.custid, ', --' + ci.username
FROM CustSetting cs with(nolock)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid AND cs.sporttype IN (154)
WHERE ci.srecommend NOT IN (SELECT custid from Dep_CustSuper WITH(NOLOCK))
	and roleid <= 4
*/

--103 rows affected
DELETE CustSetting WITH(UPDLOCK,ROWLOCK)	
WHERE sporttype = 154 AND bettype = 20	
	AND custid IN (
						12956763	, --SUPERTESTHRF02
						12972540	, --SUPERTESTHRF000000A
						5219409	, --ITK998Q13
						582423	, --ITK998005
						12963040	, --SUPERTESTHRF0000005
						12972531	, --SUPERTESTHRF07
						9391588	, --ITK998Q22
						12972549	, --SUPERTESTHRF000A
						12955022	, --SUPERTESTHRF00
						12955635	, --SUPERTESTHRF0000
						12972563	, --SUPERTESTHRF000B
						3764929	, --ITK998Q03
						12969652	, --supertestbobFixOdds07
						12962024	, --SUPERTESTHRF0005
						73103	, --ITk998001
						12972703	, --supertest1UUSHRFixOdd01
						12957266	, --supertestUAT5
						3529774	, --ITK998AS2
						12969528	, --SUPERTESTHRF0008
						12957261	, --supertestUAT4
						3529772	, --ITK998AS1
						12969252	, --supertestbobFixOdds03
						12931842	, --supertestUAT101
						12972674	, --SUPERTESTHRF000000E
						12961712	, --SUPERTESTHRF06
						12972583	, --SUPERTESTHRF000000D
						12955809	, --SUPERTESTHRF0000001
						3529769	, --ITK998JC2
						13109087	, --supertest16201002002
						12969527	, --SUPERTESTHRF0007
						73104	, --ITibc001
						12962027	, --SUPERTESTHRF0006
						13111551	, --supertest16201002003
						12957272	, --supertestUAT501
						582427	, --ITK998007
						10608497	, --ITK998Q24
						12969629	, --supertestbobFixOdds0101003
						12957304	, --supertestUAT60101001
						3529786	, --ITK998MT1
						12957284	, --supertestUAT6
						12956292	, --supertestUAT201
						12931856	, --supertestUAT10101
						12969554	, --SUPERTESTHRF0000008
						621059	, --ITK998009
						12956645	, --supertestUAT20101
						12956866	, --SUPERTESTHRF0002
						12972570	, --SUPERTESTHRF000000C
						12961622	, --SUPERTESTHRF05
						12972533	, --SUPERTESTHRF0009
						709008	, --ITK998010
						12956477	, --supertestUAT3
						12969475	, --supertestbobFixOdds0102
						12972754	, --supertest1UUSHRFixOdds1
						12931878	, --supertestUAT10101001
						12931803	, --supertestUAT1
						5610296	, --ITK998Q09
						13105611	, --supertest162
						12956728	, --supertestUAT20101001
						12931653	, --supertestbobFixOdds
						13105644	, --supertest16201
						12972537	, --SUPERTESTHRF0000009
						3529216	, --ITK998JH1
						12956543	, --supertestHRODD
						12956902	, --SUPERTESTHRF0003
						12972544	, --SUPERTESTHRF000000B
						5219470	, --ITK998Q17
						8249775	, --ITK998Q19
						12963051	, --SUPERTESTHRF0000006
						12962062	, --SUPERTESTHRF0000002
						3529795	, --ITK998TY2
						12969622	, --supertestbobFixOdds01003
						12969603	, --supertestbobFixOdds0109
						12962076	, --SUPERTESTHRF0000003
						12957184	, --SupertestHRF09
						12956270	, --supertestUAT2
						13107694	, --supertest16201002
						12969618	, --supertestbobFixOdds05
						12962103	, --SUPERTESTHRF0000004
						12956781	, --SUPERTESTHRF03
						3529788	, --ITK998MT2
						12957294	, --supertestUAT601
						12955782	, --SUPERTESTHRF0001
						12957302	, --supertestUAT60101
						12931663	, --supertestbobFixOdds0101
						12973771	, --SUPERTESTHRF000000F
						12969262	, --supertestbobFixOdds04
						582429	, --ITK998008
						12931658	, --SupertestHRF
						12955107	, --SUPERTESTHRF01
						12969674	, --supertestbobFixOdds0104
						3529792	, --ITK998TY1
						12969507	, --supertestbobFixOdds0101002
						12969223	, --supertestbobFixOdds02
						12962008	, --SUPERTESTHRF0004
						12956738	, --supertestUAT202
						12931670	, --supertestbobFixOdds0101001
						12973300	, --supertest1UUSHRFixOdd0101
						12969552	, --SUPERTESTHRF0000007
						5008107	, --ITK998Q07
						12931662	, --supertestbobFixOdds01
						12956827	, --SUPERTESTHRF04
						12969681	, --supertestbobFixOdds0104001
						12955722	 --SUPERTESTHRF0000000
					)

GO


/*
select ci.custid, ', --' + ci.username
FROM CustOverride cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid AND cs.sporttype IN (154)
WHERE ci.srecommend NOT IN (SELECT custid from Dep_CustSuper WITH(NOLOCK))
AND ci.roleid IN (2,3,4)
*/

-- 55 rows affected
DELETE CustOverride WITH(UPDLOCK,ROWLOCK)	
WHERE sporttype = 154 AND bettype = 20
	AND custid IN (
					12931856	, --supertestUAT10101
					12957284	, --supertestUAT6
					12972754	, --supertest1UUSHRFixOdds1
					12955022	, --SUPERTESTHRF00
					12957294	, --supertestUAT601
					12973300	, --supertest1UUSHRFixOdd0101
					12955782	, --SUPERTESTHRF0001
					12961712	, --SUPERTESTHRF06
					12969223	, --supertestbobFixOdds02
					13107694	, --supertest16201002
					12955107	, --SUPERTESTHRF01
					12957302	, --supertestUAT60101
					13105611	, --supertest162
					12955635	, --SUPERTESTHRF0000
					12961622	, --SUPERTESTHRF05
					13105644	, --supertest16201
					12956292	, --supertestUAT201
					12962024	, --SUPERTESTHRF0005
					12969262	, --supertestbobFixOdds04
					12956477	, --supertestUAT3
					12962027	, --SUPERTESTHRF0006
					12969475	, --supertestbobFixOdds0102
					12956270	, --supertestUAT2
					12962008	, --SUPERTESTHRF0004
					12969252	, --supertestbobFixOdds03
					12956543	, --supertestHRODD
					12969527	, --SUPERTESTHRF0007
					12956645	, --supertestUAT20101
					12969528	, --SUPERTESTHRF0008
					12956763	, --SUPERTESTHRF02
					12969618	, --supertestbobFixOdds05
					12956781	, --SUPERTESTHRF03
					12969622	, --supertestbobFixOdds01003
					12931658	, --SupertestHRF
					12956902	, --SUPERTESTHRF0003
					12972531	, --SUPERTESTHRF07
					12956827	, --SUPERTESTHRF04
					12969652	, --supertestbobFixOdds07
					12931653	, --supertestbobFixOdds
					12956866	, --SUPERTESTHRF0002
					12969674	, --supertestbobFixOdds0104
					12931803	, --supertestUAT1
					12957266	, --supertestUAT5
					12972563	, --SUPERTESTHRF000B
					12931663	, --supertestbobFixOdds0101
					12957261	, --supertestUAT4
					12972549	, --SUPERTESTHRF000A
					12931662	, --supertestbobFixOdds01
					12957184	, --SupertestHRF09
					12972533	, --SUPERTESTHRF0009
					12931842	, --supertestUAT101
					12957272	, --supertestUAT501
					12972703	, --supertest1UUSHRFixOdd01
					12956738	, --supertestUAT202
					12969603	 --supertestbobFixOdds0109
				)
				

