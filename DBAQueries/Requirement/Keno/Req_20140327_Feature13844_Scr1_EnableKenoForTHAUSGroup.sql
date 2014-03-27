 /*
	Created: Johnson
	Date: 2014-03-27
	Task: Enable Keno for THAUS group only super level except some special members
	DB: DBTXN/CustDB
 */
 
 
 CREATE TABLE #tmpCust (custid INT)
 
 --for 217 supers
 INSERT INTO #tmpCust
	 select 	11742953	--	TV1
union select 	11743087	--	TV2
union select 	11743112	--	TV3
union select 	11743132	--	TV4
union select 	11743161	--	TV5
union select 	11743182	--	TV6
union select 	11743211	--	TV7
union select 	11743225	--	TV8
union select 	11743279	--	TV9
union select 	11743311	--	TV10
union select 	11743322	--	TV11
union select 	11743380	--	TV12
union select 	11743398	--	TV13
union select 	11743411	--	TV14
union select 	11743425	--	TV15
union select 	11746534	--	TV16
union select 	11746581	--	TV17
union select 	11746613	--	TV18
union select 	11746658	--	TV19
union select 	11746685	--	TV20
union select 	12035377	--	TV30
union select 	12035456	--	TV31
union select 	12059147	--	TV91
union select 	12059263	--	TV92
union select 	12063498	--	TV80
union select 	12064601	--	TV46
union select 	12065413	--	TV81
union select 	12140347	--	TVA1
union select 	12141433	--	TVA2
union select 	12141434	--	TVA3
union select 	12141435	--	TVA4
union select 	12141436	--	TVA5
union select 	12141437	--	TVA6
union select 	12141438	--	TVA7
union select 	12141439	--	TVA8
union select 	12141440	--	TVA9
union select 	12141441	--	TVA10
union select 	12141442	--	TVA11
union select 	12141443	--	TVA12
union select 	12141444	--	TVA13
union select 	12141446	--	TVA14
union select 	12141447	--	TVA15
union select 	12141448	--	TVA16
union select 	12141449	--	TVA17
union select 	12141450	--	TVA18
union select 	12141451	--	TVA19
union select 	12141452	--	TVA20
union select 	12141453	--	TVA21
union select 	12141454	--	TVA22
union select 	12141455	--	TVA23
union select 	12141456	--	TVA24
union select 	12141457	--	TVA25
union select 	12141459	--	TVA26
union select 	12141460	--	TVA27
union select 	12141461	--	TVA28
union select 	12141462	--	TVA29
union select 	12141463	--	TVA30
union select 	12141464	--	TVA31
union select 	12141465	--	TVA32
union select 	12141466	--	TVA33
union select 	12141467	--	TVA34
union select 	12141468	--	TVA35
union select 	12141469	--	TVA36
union select 	12141470	--	TVA37
union select 	12141471	--	TVA38
union select 	12141472	--	TVA39
union select 	12141473	--	TVA40
union select 	12141474	--	TVA41
union select 	12141475	--	TVA42
union select 	12141476	--	TVA43
union select 	12141477	--	TVA44
union select 	12141478	--	TVA45
union select 	12141479	--	TVA46
union select 	12141480	--	TVA47
union select 	12141481	--	TVA48
union select 	12141482	--	TVA49
union select 	12141483	--	TVA50
union select 	12141484	--	TVA51
union select 	12141485	--	TVA52
union select 	12141486	--	TVA53
union select 	12141487	--	TVA54
union select 	12141488	--	TVA55
union select 	12141489	--	TVA56
union select 	12141490	--	TVA57
union select 	12141491	--	TVA58
union select 	12141492	--	TVA59
union select 	12141493	--	TVA60
union select 	12141494	--	TVA61
union select 	12141495	--	TVA62
union select 	12141496	--	TVA63
union select 	12141497	--	TVA64
union select 	12141498	--	TVA65
union select 	12141499	--	TVA66
union select 	12141500	--	TVA67
union select 	12141501	--	TVA68
union select 	12141502	--	TVA69
union select 	12141503	--	TVA70
union select 	12141504	--	TVA71
union select 	12141505	--	TVA72
union select 	12141506	--	TVA73
union select 	12141507	--	TVA74
union select 	12141508	--	TVA75
union select 	12141509	--	TVA76
union select 	12141510	--	TVA77
union select 	12141511	--	TVA78
union select 	12141512	--	TVA79
union select 	12141513	--	TVA80
union select 	12141514	--	TVA81
union select 	12141515	--	TVA82
union select 	12141516	--	TVA83
union select 	12141517	--	TVA84
union select 	12141518	--	TVA85
union select 	12141519	--	TVA86
union select 	12141520	--	TVA87
union select 	12141521	--	TVA88
union select 	12141522	--	TVA89
union select 	12141523	--	TVA90
union select 	12141524	--	TVA91
union select 	12141525	--	TVA92
union select 	12141526	--	TVA93
union select 	12141527	--	TVA94
union select 	12141528	--	TVA95
union select 	12141529	--	TVA96
union select 	12141530	--	TVA97
union select 	12141531	--	TVA98
union select 	12141532	--	TVA99
union select 	12141584	--	TV21
union select 	12141585	--	TV22
union select 	12141586	--	TV23
union select 	12141587	--	TV24
union select 	12141588	--	TV25
union select 	12141589	--	TV26
union select 	12141590	--	TV27
union select 	12141591	--	TV28
union select 	12141592	--	TV29
union select 	12141595	--	TV32
union select 	12141596	--	TV33
union select 	12141597	--	TV34
union select 	12141598	--	TV35
union select 	12141599	--	TV36
union select 	12141600	--	TV37
union select 	12141601	--	TV38
union select 	12141602	--	TV39
union select 	12141603	--	TV40
union select 	12141604	--	TV41
union select 	12141605	--	TV42
union select 	12141606	--	TV43
union select 	12141607	--	TV44
union select 	12141608	--	TV45
union select 	12141612	--	TV47
union select 	12141613	--	TV48
union select 	12141614	--	TV49
union select 	12141615	--	TV50
union select 	12141616	--	TV51
union select 	12141617	--	TV52
union select 	12141618	--	TV53
union select 	12141619	--	TV54
union select 	12141620	--	TV55
union select 	12141621	--	TV56
union select 	12141622	--	TV57
union select 	12141623	--	TV58
union select 	12141624	--	TV59
union select 	12141625	--	TV60
union select 	12141626	--	TV61
union select 	12141627	--	TV62
union select 	12141628	--	TV63
union select 	12141629	--	TV64
union select 	12141630	--	TV65
union select 	12141631	--	TV66
union select 	12141632	--	TV67
union select 	12141633	--	TV68
union select 	12141634	--	TV69
union select 	12141635	--	TV70
union select 	12141636	--	TV71
union select 	12141637	--	TV72
union select 	12141638	--	TV73
union select 	12141639	--	TV74
union select 	12141640	--	TV75
union select 	12141641	--	TV76
union select 	12141642	--	TV77
union select 	12141643	--	TV78
union select 	12141644	--	TV79
union select 	12141647	--	TV82
union select 	12141648	--	TV83
union select 	12141649	--	TV84
union select 	12141650	--	TV85
union select 	12141651	--	TV86
union select 	12141652	--	TV87
union select 	12141653	--	TV88
union select 	12141654	--	TV89
union select 	12141655	--	TV90
union select 	12141659	--	TV93
union select 	12141660	--	TV94
union select 	12141661	--	TV95
union select 	12141662	--	TV96
union select 	12141663	--	TV97
union select 	12141664	--	TV98
union select 	12284153	--	TV0
union select 	13835089	--	TV2A
union select 	13850654	--	TV2B
union select 	13850790	--	TV2C
union select 	13850798	--	TV1A
union select 	13850805	--	TV1C
union select 	13850803	--	TV1B
union select 	13850815	--	TV4A
union select 	13850819	--	TV4C
union select 	13850822	--	TV4B
union select 	13850824	--	TV3A
union select 	13850836	--	TV3C
union select 	13850831	--	TV3B
union select 	13850844	--	TV7B
union select 	13850840	--	TV7A
union select 	13850849	--	TV7C
union select 	13859253	--	TV7D
union select 	13859243	--	TV2E
union select 	13859249	--	TV2F
union select 	13859190	--	TV2D

--for special members
INSERT INTO #tmpCust(custid)
	 select 	11746260	--	THAUS
union select 	11771775	--	THA1US
union select 	12055986	--	D-THAUS

--upline of these members
INSERT INTO #tmpCust(custid)
		  select 	3	--	SA-US$
union select 	4176	--	mus
union select 	1268	--	wsus
GO


--enable custgametype for these customers
UPDATE CustGameType WITH(UPDLOCK,ROWLOCK)
SET isDisabled = 0
WHERE custid IN (SELECT custid FROM #tmpCust)
	AND gametypeid NOT IN (2,6)
GO

