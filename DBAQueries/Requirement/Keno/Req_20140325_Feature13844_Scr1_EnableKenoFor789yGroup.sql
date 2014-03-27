/*
	Created: Johnson
	Date: 2014-03-25
	Task: Enable keno's games on CustGameType for 789Y group customers 
	DB: DBTXN/CustDB
*/ 

ALTER PROCEDURE [dbo].[Acc_CustSetting_03]
	@custid INT
	,@roleid INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','CustGameType') AND type = 'U' ) <> 2
		RETURN
	
	DECLARE @srecommend INT, @mrecommend INT, @recommend INT
		
	IF @roleid = 4
	BEGIN
		--enable keno's games super & all downlines
		UPDATE cg
		SET cg.IsDisabled = 0
		FROM CustGameType cg WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON cg.custid = ci.custid
		WHERE ci.srecommend = @custid
			AND ci.custid <= @maxcustid
			AND cg.gametypeid NOT IN (2,6)
	END
	ELSE IF @roleid = 3
	BEGIN
		SELECT @srecommend = srecommend FROM CustInfo WITH(NOLOCK) WHERE custid = @custid
		
		--update upline & all downlines of master
		UPDATE cg
		SET cg.IsDisabled = 0
		FROM CustGameType cg WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON cg.custid = ci.custid
		WHERE ( ci.mrecommend = @custid OR ci.custid = @srecommend)
			AND ci.custid <= @maxcustid
			AND cg.gametypeid NOT IN (2,6)					
	END
	ELSE IF @roleid = 2
	BEGIN
		SELECT @srecommend = srecommend, @mrecommend = mrecommend FROM CustInfo WITH(NOLOCK) WHERE custid = @custid
		
		--update uplines & all downlines of agent
		UPDATE cg
		SET cg.IsDisabled = 0
		FROM CustGameType cg WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON cg.custid = ci.custid
		WHERE ( ci.recommend = @custid OR ci.custid IN (@srecommend,@mrecommend))
			AND ci.custid <= @maxcustid
			AND cg.gametypeid NOT IN (2,6)
	END
	ELSE IF @roleid = 1
	BEGIN
		SELECT @srecommend = srecommend, @mrecommend = mrecommend, @recommend = recommend FROM CustInfo WITH(NOLOCK) WHERE custid = @custid
		
		UPDATE cg
		SET cg.IsDisabled = 0
		FROM CustGameType cg WITH(UPDLOCK,ROWLOCK)
		WHERE cg.custid IN (@srecommend, @mrecommend, @recommend, @custid)
			AND gametypeid NOT IN (2,6)
	END		
END	
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
CREATE TABLE #tmpCust(custid INT PRIMARY KEY, roleid INT, isfinished bit default(0))

DECLARE @max_custid INT, @custid INT, @roleid INT

SET @max_custid = xxx 

--572 SMA affected & 3 million downlines will be updated
INSERT INTO #tmpCust(custid, roleid)
	select 	4051	,	1	--	831HK
union select 	12754	,	3	--	A8
union select 	3341773	,	4	--	HEU
union select 	6649511	,	4	--	HEA
union select 	4578528	,	4	--	CT
union select 	10507286	,	4	--	JWL
union select 	12909736	,	4	--	JWU
union select 	1388381	,	4	--	ABS
union select 	4521633	,	4	--	ABB
union select 	8004516	,	4	--	ABW
union select 	11574203	,	4	--	BBA
union select 	13715655	,	4	--	BBD
union select 	262627	,	4	--	SCC
union select 	262637	,	4	--	SCK
union select 	391471	,	4	--	VIP
union select 	731165	,	4	--	SKKS
union select 	923727	,	4	--	SKS
union select 	1335772	,	4	--	SKT
union select 	1435478	,	4	--	VID
union select 	1727939	,	4	--	SKD
union select 	1727945	,	4	--	SKV
union select 	1783435	,	1	--	KKKUSD
union select 	1898175	,	4	--	SKW
union select 	1940367	,	4	--	SKX
union select 	1977102	,	4	--	SKE
union select 	1977147	,	4	--	SKF
union select 	1977150	,	4	--	SKG
union select 	1978806	,	4	--	SKH
union select 	1999503	,	4	--	SKY
union select 	2075785	,	4	--	SKZ
union select 	2113740	,	4	--	SKI
union select 	2126540	,	4	--	SKJ
union select 	2198456	,	4	--	SKA
union select 	2198458	,	4	--	SKB
union select 	2198461	,	4	--	SKL
union select 	2198868	,	4	--	SKQ
union select 	2462931	,	4	--	SKK
union select 	2470330	,	4	--	VIU
union select 	2503678	,	4	--	SKO
union select 	2793182	,	4	--	skn
union select 	2793190	,	4	--	skp
union select 	2793195	,	4	--	SKAA
union select 	2798869	,	4	--	SKAB
union select 	2798950	,	4	--	SKAC
union select 	2850839	,	4	--	SKAD
union select 	2853316	,	4	--	SKAE
union select 	2877199	,	4	--	SKAF
union select 	2975866	,	4	--	SKAG
union select 	3024023	,	4	--	SKAH
union select 	3024027	,	4	--	SKAI
union select 	3024035	,	4	--	SKAJ
union select 	3122695	,	4	--	SKKA
union select 	3390616	,	4	--	QHN
union select 	3390621	,	4	--	QVN
union select 	3390623	,	4	--	SKAN
union select 	3412762	,	4	--	SHB
union select 	3472707	,	4	--	SKAO
union select 	3472732	,	4	--	SKAP
union select 	3508886	,	4	--	SHD
union select 	3535165	,	4	--	SKAR
union select 	3675856	,	4	--	SKAS
union select 	3675859	,	4	--	SKAT
union select 	4166219	,	4	--	skau
union select 	4166221	,	4	--	skav
union select 	4664102	,	4	--	skaw
union select 	4664106	,	4	--	skax
union select 	4664111	,	4	--	skay
union select 	5208493	,	4	--	skaz
union select 	5208504	,	4	--	skba
union select 	5208528	,	4	--	skbb
union select 	5881765	,	4	--	SKBC
union select 	5881771	,	4	--	SKBD
union select 	5933382	,	4	--	SKBE
union select 	5933395	,	4	--	SKBF
union select 	6000983	,	4	--	skbg
union select 	6001004	,	4	--	skbh
union select 	6660090	,	4	--	SKBI
union select 	6660095	,	4	--	SKBJ
union select 	7164448	,	4	--	SKBK
union select 	7164462	,	4	--	SKBL
union select 	7164469	,	4	--	SKBM
union select 	8296284	,	4	--	skbn
union select 	11578859	,	4	--	SKBO
union select 	11579157	,	4	--	skbp
union select 	11579230	,	4	--	SKBR
union select 	11579291	,	4	--	SKBT
union select 	11579683	,	4	--	SKBU
union select 	11582090	,	4	--	SKTB
union select 	11582156	,	4	--	SKTA
union select 	11791191	,	4	--	sktc
union select 	11889755	,	4	--	SKBQ
union select 	12001176	,	4	--	SKBV
union select 	12001367	,	4	--	SKBW
union select 	12001625	,	4	--	SKBX
union select 	12006434	,	4	--	skby
union select 	12006566	,	4	--	skbz
union select 	12006659	,	4	--	SKCA
union select 	12006725	,	4	--	skcb
union select 	12006808	,	4	--	SKCC
union select 	12006831	,	4	--	SKCD
union select 	262641	,	4	--	SDD
union select 	342710	,	4	--	SY1B
union select 	838269	,	4	--	SDDTB
union select 	927679	,	4	--	SDDT
union select 	1077097	,	4	--	SDT
union select 	1174759	,	4	--	SDE
union select 	3115624	,	4	--	SDU
union select 	3115630	,	4	--	SDM
union select 	5213502	,	4	--	SDY
union select 	5226628	,	4	--	SDV
union select 	5226641	,	4	--	SDW
union select 	5226650	,	4	--	SDX
union select 	5226659	,	4	--	SDZ
union select 	5340153	,	4	--	FYU
union select 	5362504	,	4	--	SDK
union select 	5362508	,	4	--	SDL
union select 	5375392	,	4	--	SDJ
union select 	5394907	,	4	--	SDO
union select 	5419321	,	4	--	SDP
union select 	5800564	,	4	--	SDB
union select 	5800577	,	4	--	SDC
union select 	5824370	,	4	--	SDF
union select 	5824374	,	4	--	SDG
union select 	5871571	,	4	--	SDI
union select 	5871590	,	4	--	SDN
union select 	5915537	,	4	--	SDY1
union select 	6087439	,	4	--	SYA
union select 	6087443	,	4	--	SYB
union select 	6714757	,	4	--	SYC
union select 	7124243	,	4	--	SYD
union select 	7209880	,	4	--	SYE
union select 	7263508	,	4	--	SYF
union select 	7545783	,	4	--	SYG
union select 	7596465	,	4	--	SYH
union select 	7596486	,	4	--	SYJ
union select 	7596503	,	4	--	SYK
union select 	7596522	,	4	--	SYL
union select 	7596533	,	4	--	SYN
union select 	7596541	,	4	--	SYO
union select 	7596578	,	4	--	SYP
union select 	7596597	,	4	--	SYQ
union select 	7596613	,	4	--	SYS
union select 	7596636	,	4	--	SYU
union select 	7651563	,	4	--	SYV
union select 	7651639	,	4	--	SYW
union select 	7703331	,	4	--	SYY
union select 	7902402	,	4	--	SDA
union select 	8211131	,	4	--	SYZ
union select 	8265079	,	4	--	SDY2
union select 	8394258	,	4	--	SQY
union select 	8594867	,	4	--	SYZ1
union select 	8812070	,	4	--	SDY3
union select 	9020799	,	4	--	SDY5
union select 	9285643	,	4	--	SDQ
union select 	9285744	,	4	--	SDS
union select 	9432645	,	4	--	SDY6
union select 	9579809	,	4	--	SYC2
union select 	9659841	,	4	--	SDY7
union select 	10181770	,	4	--	SDN1
union select 	10181790	,	4	--	SDN2
union select 	10223418	,	4	--	SDY8
union select 	10279904	,	4	--	UZA
union select 	10318451	,	4	--	SYC3
union select 	10558395	,	4	--	SDN3
union select 	10675880	,	4	--	SDY9
union select 	12151758	,	4	--	SQA
union select 	12183294	,	4	--	YDH
union select 	13850733	,	4	--	SDY11
union select 	13850738	,	4	--	SDY12
union select 	1283	,	1	--	etus
union select 	3472	,	1	--	ETCASINO
union select 	5106	,	2	--	VT1US
union select 	7714	,	1	--	etrmb
union select 	300958	,	4	--	SQ
union select 	525344	,	1	--	ET1RMB
union select 	595561	,	4	--	SC
union select 	595565	,	4	--	XX
union select 	636678	,	4	--	SQQR
union select 	1113450	,	4	--	SM
union select 	1317452	,	4	--	SG
union select 	1505137	,	4	--	EA
union select 	1505140	,	4	--	EB
union select 	1539339	,	4	--	EC
union select 	1667537	,	4	--	EE
union select 	1698753	,	4	--	SH
union select 	1731862	,	4	--	EF
union select 	1889065	,	4	--	EG
union select 	1935623	,	4	--	XY
union select 	1935638	,	4	--	XZ
union select 	1935648	,	4	--	EH
union select 	2063714	,	4	--	EI
union select 	2063723	,	4	--	EJ
union select 	2426461	,	4	--	EK
union select 	2426467	,	4	--	EL
union select 	2426472	,	4	--	EM
union select 	2440619	,	1	--	ETEX
union select 	2571383	,	4	--	EN
union select 	2822583	,	4	--	EO
union select 	2877058	,	4	--	EP
union select 	3002011	,	4	--	EQ
union select 	3002015	,	4	--	ER
union select 	3043749	,	4	--	ES
union select 	3043753	,	4	--	ET
union select 	3318714	,	4	--	EU
union select 	3318716	,	4	--	EV
union select 	3370732	,	4	--	EW
union select 	3379262	,	4	--	EX
union select 	3379272	,	4	--	EY
union select 	3397263	,	4	--	XA
union select 	3397267	,	4	--	XB
union select 	3397270	,	4	--	XC
union select 	3428663	,	4	--	XD
union select 	3448871	,	4	--	XE
union select 	3448873	,	4	--	XF
union select 	3466791	,	4	--	XG
union select 	3518530	,	4	--	XJ
union select 	3518536	,	4	--	XK
union select 	3518540	,	4	--	XL
union select 	3581460	,	4	--	XM
union select 	3588788	,	4	--	XN
union select 	3667252	,	4	--	XO
union select 	3672278	,	4	--	XP
union select 	3706024	,	4	--	XH
union select 	3707684	,	4	--	XQ
union select 	3707692	,	4	--	XR
union select 	3759851	,	4	--	XS
union select 	3764956	,	4	--	XT
union select 	3919562	,	4	--	SSA
union select 	3919574	,	4	--	SSB
union select 	3967000	,	4	--	XXA
union select 	4058361	,	4	--	SSC
union select 	4058379	,	4	--	SSE
union select 	4079058	,	4	--	EJA
union select 	4113805	,	4	--	XXB
union select 	4113806	,	4	--	XXC
union select 	4157382	,	4	--	XXD
union select 	4157389	,	4	--	XXE
union select 	4190683	,	4	--	XXF
union select 	4195794	,	4	--	XXG
union select 	4195796	,	4	--	XXH
union select 	4232989	,	4	--	XXJ
union select 	4232994	,	4	--	XXK
union select 	4281392	,	4	--	XXO
union select 	4281394	,	4	--	XXP
union select 	4281456	,	4	--	XXQ
union select 	4281463	,	4	--	XXR
union select 	4281469	,	4	--	XXS
union select 	4356069	,	4	--	SQH
union select 	4406327	,	4	--	QA
union select 	4406329	,	4	--	QB
union select 	4533981	,	4	--	QD
union select 	4533984	,	4	--	QE
union select 	4533988	,	4	--	QF
union select 	4533993	,	4	--	QG
union select 	4613190	,	4	--	QH
union select 	4613199	,	4	--	QI
union select 	4629022	,	4	--	xxt
union select 	4689879	,	4	--	QJ
union select 	4689920	,	4	--	QK
union select 	4689932	,	4	--	QL
union select 	4689945	,	4	--	QM
union select 	4697415	,	4	--	QN
union select 	4697426	,	4	--	QO
union select 	4697442	,	4	--	QP
union select 	4759908	,	4	--	qs
union select 	4798284	,	4	--	QR
union select 	4815149	,	4	--	QT
union select 	4833640	,	4	--	QU
union select 	4841141	,	4	--	QC
union select 	4870143	,	4	--	BK
union select 	4870194	,	4	--	HC
union select 	4873460	,	4	--	BC
union select 	4900076	,	4	--	QV
union select 	4908230	,	4	--	BD
union select 	4947571	,	4	--	BE
union select 	4996099	,	4	--	BG
union select 	5015348	,	4	--	BH
union select 	5015371	,	4	--	BL
union select 	5060788	,	4	--	BM
union select 	5060793	,	4	--	BN
union select 	5108723	,	4	--	BO
union select 	5108730	,	4	--	BP
union select 	5108737	,	4	--	BR
union select 	5160159	,	4	--	BX
union select 	5160163	,	4	--	BY
union select 	5160175	,	4	--	BZ
union select 	5241927	,	4	--	BC1
union select 	5241945	,	4	--	BC2
union select 	5241964	,	4	--	BC3
union select 	5311953	,	4	--	BC5
union select 	5311961	,	4	--	BC6
union select 	5311965	,	4	--	BC7
union select 	5362682	,	4	--	BC8
union select 	5362687	,	4	--	BC9
union select 	5362694	,	4	--	BCA
union select 	5362712	,	4	--	EA1
union select 	5362720	,	4	--	EA2
union select 	5362724	,	4	--	EA3
union select 	5362729	,	4	--	EA4
union select 	5362731	,	4	--	EA5
union select 	5480712	,	4	--	AZ1
union select 	5480716	,	4	--	AZ2
union select 	5480721	,	4	--	AZ3
union select 	5480731	,	4	--	AZ4
union select 	5480735	,	4	--	AZ5
union select 	5718827	,	4	--	EA6
union select 	5718831	,	4	--	EA7
union select 	5718836	,	4	--	EA8
union select 	5718840	,	4	--	EA9
union select 	5718851	,	4	--	EAA
union select 	5812159	,	4	--	EG1
union select 	5812172	,	4	--	EG2
union select 	5812196	,	4	--	EG3
union select 	5812218	,	4	--	EG5
union select 	5812228	,	4	--	EG6
union select 	5824459	,	4	--	EAB
union select 	5824460	,	4	--	EAC
union select 	5824466	,	4	--	EAD
union select 	5824473	,	4	--	EAE
union select 	5824484	,	4	--	EAF
union select 	5940542	,	4	--	EAG
union select 	5940553	,	4	--	EAH
union select 	5940557	,	4	--	EAI
union select 	5940565	,	4	--	EAJ
union select 	5940574	,	4	--	EAK
union select 	6197528	,	4	--	EAL
union select 	6406944	,	4	--	AZ6
union select 	6406961	,	4	--	AZ7
union select 	6406976	,	4	--	AZ8
union select 	6406986	,	4	--	AZ9
union select 	6406993	,	4	--	AZ10
union select 	6456973	,	4	--	EEA
union select 	6909004	,	4	--	EBA
union select 	6909008	,	4	--	EBB
union select 	6909014	,	4	--	EBC
union select 	6909021	,	4	--	EBD
union select 	6909027	,	4	--	EBE
union select 	6909067	,	4	--	EBF
union select 	6909106	,	4	--	EBG
union select 	6909137	,	4	--	EBH
union select 	6909152	,	4	--	EBI
union select 	6909165	,	4	--	EBJ
union select 	6910609	,	4	--	EB1
union select 	6910614	,	4	--	EB2
union select 	6910618	,	4	--	EB3
union select 	6910631	,	4	--	EB5
union select 	6910642	,	4	--	EB6
union select 	7604821	,	4	--	AZ11
union select 	7604832	,	4	--	AZ12
union select 	7604844	,	4	--	AZ13
union select 	7604852	,	4	--	AZ14
union select 	7604869	,	4	--	AZ15
union select 	7702438	,	4	--	ET1
union select 	7702445	,	4	--	ET2
union select 	7702455	,	4	--	ET3
union select 	7702469	,	4	--	ET4
union select 	7702473	,	4	--	ET5
union select 	8104518	,	4	--	EBK
union select 	8104526	,	4	--	EBL
union select 	8104553	,	4	--	EBM
union select 	8594690	,	4	--	ET6
union select 	8594740	,	4	--	ET7
union select 	8594787	,	4	--	ET8
union select 	8594806	,	4	--	ET9
union select 	8594829	,	4	--	ET10
union select 	10836879	,	4	--	EH1
union select 	10836909	,	4	--	EH2
union select 	10836921	,	4	--	EH3
union select 	10836940	,	4	--	EH5
union select 	10836949	,	4	--	EH6
union select 	11211824	,	4	--	EH7
union select 	11211847	,	4	--	EH8
union select 	11211878	,	4	--	EH9
union select 	11211891	,	4	--	EJ1
union select 	11211901	,	4	--	EJ2
union select 	11474369	,	4	--	KX1
union select 	11474382	,	4	--	KX2
union select 	11474397	,	4	--	KX3
union select 	11474407	,	4	--	KX4
union select 	11474415	,	4	--	KX5
union select 	11474424	,	4	--	KX6
union select 	11474429	,	4	--	KX7
union select 	11474434	,	4	--	KX8
union select 	11474436	,	4	--	KX9
union select 	11474444	,	4	--	KX10
union select 	11586973	,	4	--	KY1
union select 	11587004	,	4	--	KY2
union select 	11587048	,	4	--	KY3
union select 	11587079	,	4	--	KY4
union select 	11587125	,	4	--	KY5
union select 	11587193	,	4	--	KY6
union select 	11587237	,	4	--	KY7
union select 	11587251	,	4	--	KY8
union select 	11587333	,	4	--	KY9
union select 	11587359	,	4	--	KY10
union select 	11635979	,	4	--	KY11
union select 	11636059	,	4	--	KY12
union select 	11636131	,	4	--	KY13
union select 	11636284	,	4	--	KY14
union select 	11636318	,	4	--	KY15
union select 	11636345	,	4	--	KY16
union select 	11636409	,	4	--	KY17
union select 	11636436	,	4	--	KY18
union select 	11636461	,	4	--	KY19
union select 	11636471	,	4	--	KY20
union select 	11636481	,	4	--	KY21
union select 	11636490	,	4	--	KY22
union select 	11636516	,	4	--	KY23
union select 	11636534	,	4	--	KY24
union select 	11636551	,	4	--	KY25
union select 	11850282	,	4	--	KY26
union select 	11850467	,	4	--	KY27
union select 	11850655	,	4	--	KY28
union select 	11850827	,	4	--	KY29
union select 	11850975	,	4	--	KY30
union select 	11851102	,	4	--	KY31
union select 	11851377	,	4	--	KY32
union select 	11851573	,	4	--	KY33
union select 	11851664	,	4	--	KY34
union select 	11851798	,	4	--	KY35
union select 	12052602	,	4	--	NW1
union select 	12052706	,	4	--	NW2
union select 	12052773	,	4	--	NW3
union select 	12053037	,	4	--	NW4
union select 	12053067	,	4	--	NW5
union select 	12053091	,	4	--	NW6
union select 	12053229	,	4	--	NW7
union select 	12053285	,	4	--	NW8
union select 	12053334	,	4	--	NW9
union select 	12053431	,	4	--	NW10
union select 	12053599	,	4	--	NW11
union select 	12053747	,	4	--	NW12
union select 	12053841	,	4	--	NW13
union select 	12053970	,	4	--	NW14
union select 	12054098	,	4	--	NW15
union select 	12054225	,	4	--	NW16
union select 	12054361	,	4	--	NW17
union select 	12054463	,	4	--	NW18
union select 	12054490	,	4	--	NW19
union select 	12054506	,	4	--	NW20
union select 	12064912	,	4	--	CG1
union select 	12064966	,	4	--	CG2
union select 	12065024	,	4	--	CG3
union select 	12065046	,	4	--	CG4
union select 	12065076	,	4	--	CG5
union select 	12259386	,	4	--	KP1
union select 	12261917	,	4	--	KP2
union select 	12262001	,	4	--	KP3
union select 	12262043	,	4	--	KP4
union select 	12262066	,	4	--	KP5
union select 	12262090	,	4	--	KP6
union select 	12262124	,	4	--	KP7
union select 	12262139	,	4	--	KP8
union select 	12262161	,	4	--	KP9
union select 	12262186	,	4	--	KP10
union select 	12262203	,	4	--	KP41
union select 	12262244	,	4	--	KP12
union select 	12262274	,	4	--	KP13
union select 	12262302	,	4	--	KP14
union select 	12262326	,	4	--	KP15
union select 	12262357	,	4	--	KP16
union select 	12262379	,	4	--	KP17
union select 	12262401	,	4	--	KP18
union select 	12262435	,	4	--	KP19
union select 	12262471	,	4	--	KP20
union select 	12289536	,	4	--	CG6
union select 	12289579	,	4	--	CG7
union select 	12289604	,	4	--	CG8
union select 	12289632	,	4	--	CG9
union select 	12289649	,	4	--	CG13
union select 	12382533	,	4	--	SK8
union select 	12382994	,	4	--	CG15
union select 	12383032	,	4	--	CG16
union select 	12383066	,	4	--	CG17
union select 	12383094	,	4	--	CG18
union select 	12383140	,	4	--	CG19
union select 	12383193	,	4	--	CG20
union select 	12618408	,	4	--	Q6
union select 	12618409	,	4	--	Q1
union select 	12618432	,	4	--	Q7
union select 	12618527	,	4	--	Q8
union select 	12618555	,	4	--	Q9
union select 	12618562	,	4	--	Q2
union select 	12618565	,	4	--	Q10
union select 	12618667	,	4	--	Q3
union select 	12618703	,	4	--	Q4
union select 	12618726	,	4	--	Q5
union select 	12886929	,	4	--	XK4
union select 	12887530	,	4	--	XK5
union select 	12887995	,	4	--	XK3
union select 	12888369	,	4	--	XK2
union select 	12888597	,	4	--	XK1
union select 	12989122	,	4	--	Q11
union select 	12989150	,	4	--	Q12
union select 	12989192	,	4	--	Q13
union select 	12989209	,	4	--	Q14
union select 	12989224	,	4	--	Q15
union select 	12989251	,	4	--	Q16
union select 	12989266	,	4	--	Q17
union select 	12989273	,	4	--	Q18
union select 	12989286	,	4	--	Q19
union select 	12989306	,	4	--	Q20
union select 	13213942	,	4	--	EQH
union select 	13715703	,	4	--	NW21
union select 	13715739	,	4	--	NW22
union select 	13715763	,	4	--	NW26
union select 	13715773	,	4	--	NW23
union select 	13715785	,	4	--	NW24
union select 	13715798	,	4	--	NW25
union select 	13715803	,	4	--	NW27
union select 	13715841	,	4	--	NW28
union select 	13715921	,	4	--	NW29
union select 	13716070	,	4	--	NW30
union select 	13727949	,	4	--	ZW1
union select 	13728003	,	4	--	ZW2
union select 	13728029	,	4	--	ZW3
union select 	13728036	,	4	--	ZW4
union select 	13728040	,	4	--	ZW5
union select 	13728049	,	4	--	ZW6
union select 	13728052	,	4	--	ZW7
union select 	13728054	,	4	--	ZW8
union select 	13728056	,	4	--	ZW9
union select 	13728068	,	4	--	ZW10
union select 	13728074	,	4	--	ZW11
union select 	13728079	,	4	--	ZW12
union select 	13728082	,	4	--	ZW13
union select 	13728086	,	4	--	ZW14
union select 	13728090	,	4	--	ZW15
union select 	13728091	,	4	--	ZW16
union select 	13728094	,	4	--	ZW17
union select 	13728096	,	4	--	ZW18
union select 	13728101	,	4	--	ZW19
union select 	13728104	,	4	--	ZW20
union select 	13728105	,	4	--	ZW21
union select 	13728109	,	4	--	ZW22
union select 	13728111	,	4	--	ZW23
union select 	13728115	,	4	--	ZW24
union select 	13728116	,	4	--	ZW25
union select 	13728117	,	4	--	ZW26
union select 	13728119	,	4	--	ZW27
union select 	13728121	,	4	--	ZW28
union select 	13728122	,	4	--	ZW29
union select 	13728125	,	4	--	ZW30
union select 	13869563	,	4	--	KP21
union select 	13869606	,	4	--	KP22
union select 	13869616	,	4	--	KP23
union select 	13869619	,	4	--	KP24
union select 	13869621	,	4	--	KP25
union select 	13869622	,	4	--	KP26
union select 	13869624	,	4	--	KP27
union select 	13869627	,	4	--	KP28
union select 	13869629	,	4	--	KP29
union select 	13869630	,	4	--	KP30
union select 	13869634	,	4	--	KP31
union select 	13869640	,	4	--	KP32
union select 	13869643	,	4	--	KP33
union select 	13869648	,	4	--	KP34
union select 	13869651	,	4	--	KP35
union select 	13869652	,	4	--	KP36
union select 	13869654	,	4	--	KP37
union select 	13869658	,	4	--	KP38
union select 	13869661	,	4	--	KP39
union select 	13869663	,	4	--	KP40
union select 	14075093	,	4	--	XTA
union select 	14075113	,	4	--	XTB
union select 	14075118	,	4	--	XTC
union select 	14075122	,	4	--	XTD
union select 	14090947	,	4	--	CG21
union select 	14090980	,	4	--	CG22
union select 	14090991	,	4	--	CG23
union select 	14090994	,	4	--	CG24
union select 	14091001	,	4	--	CG25


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #tmpCust
	SET isfinished = 1
		,@custid = custid	
		,@roleid = roleid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.[Acc_CustSetting_03] @custid = @custid
		,@roleid = @roleid
		,@maxcustid = @max_custid
		,@target = 'REPLICATED'
		
	WAITFOR DELAY '00:00:00.280'
END
GO
-- END STEP 2: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
CREATE TABLE #tmpCust(custid INT PRIMARY KEY, roleid INT, isfinished bit default(0))

DECLARE @max_custid INT, @custid INT, @roleid INT

SET @max_custid = xxx 

--524 rows affected
INSERT INTO #tmpCust(custid, roleid)
	select 	4051	,	1	--	831HK
union select 	12754	,	3	--	A8
union select 	3341773	,	4	--	HEU
union select 	6649511	,	4	--	HEA
union select 	4578528	,	4	--	CT
union select 	10507286	,	4	--	JWL
union select 	12909736	,	4	--	JWU
union select 	1388381	,	4	--	ABS
union select 	4521633	,	4	--	ABB
union select 	8004516	,	4	--	ABW
union select 	11574203	,	4	--	BBA
union select 	13715655	,	4	--	BBD
union select 	262627	,	4	--	SCC
union select 	262637	,	4	--	SCK
union select 	391471	,	4	--	VIP
union select 	731165	,	4	--	SKKS
union select 	923727	,	4	--	SKS
union select 	1335772	,	4	--	SKT
union select 	1435478	,	4	--	VID
union select 	1727939	,	4	--	SKD
union select 	1727945	,	4	--	SKV
union select 	1783435	,	1	--	KKKUSD
union select 	1898175	,	4	--	SKW
union select 	1940367	,	4	--	SKX
union select 	1977102	,	4	--	SKE
union select 	1977147	,	4	--	SKF
union select 	1977150	,	4	--	SKG
union select 	1978806	,	4	--	SKH
union select 	1999503	,	4	--	SKY
union select 	2075785	,	4	--	SKZ
union select 	2113740	,	4	--	SKI
union select 	2126540	,	4	--	SKJ
union select 	2198456	,	4	--	SKA
union select 	2198458	,	4	--	SKB
union select 	2198461	,	4	--	SKL
union select 	2198868	,	4	--	SKQ
union select 	2462931	,	4	--	SKK
union select 	2470330	,	4	--	VIU
union select 	2503678	,	4	--	SKO
union select 	2793182	,	4	--	skn
union select 	2793190	,	4	--	skp
union select 	2793195	,	4	--	SKAA
union select 	2798869	,	4	--	SKAB
union select 	2798950	,	4	--	SKAC
union select 	2850839	,	4	--	SKAD
union select 	2853316	,	4	--	SKAE
union select 	2877199	,	4	--	SKAF
union select 	2975866	,	4	--	SKAG
union select 	3024023	,	4	--	SKAH
union select 	3024027	,	4	--	SKAI
union select 	3024035	,	4	--	SKAJ
union select 	3122695	,	4	--	SKKA
union select 	3390616	,	4	--	QHN
union select 	3390621	,	4	--	QVN
union select 	3390623	,	4	--	SKAN
union select 	3412762	,	4	--	SHB
union select 	3472707	,	4	--	SKAO
union select 	3472732	,	4	--	SKAP
union select 	3508886	,	4	--	SHD
union select 	3535165	,	4	--	SKAR
union select 	3675856	,	4	--	SKAS
union select 	3675859	,	4	--	SKAT
union select 	4166219	,	4	--	skau
union select 	4166221	,	4	--	skav
union select 	4664102	,	4	--	skaw
union select 	4664106	,	4	--	skax
union select 	4664111	,	4	--	skay
union select 	5208493	,	4	--	skaz
union select 	5208504	,	4	--	skba
union select 	5208528	,	4	--	skbb
union select 	5881765	,	4	--	SKBC
union select 	5881771	,	4	--	SKBD
union select 	5933382	,	4	--	SKBE
union select 	5933395	,	4	--	SKBF
union select 	6000983	,	4	--	skbg
union select 	6001004	,	4	--	skbh
union select 	6660090	,	4	--	SKBI
union select 	6660095	,	4	--	SKBJ
union select 	7164448	,	4	--	SKBK
union select 	7164462	,	4	--	SKBL
union select 	7164469	,	4	--	SKBM
union select 	8296284	,	4	--	skbn
union select 	11578859	,	4	--	SKBO
union select 	11579157	,	4	--	skbp
union select 	11579230	,	4	--	SKBR
union select 	11579291	,	4	--	SKBT
union select 	11579683	,	4	--	SKBU
union select 	11582090	,	4	--	SKTB
union select 	11582156	,	4	--	SKTA
union select 	11791191	,	4	--	sktc
union select 	11889755	,	4	--	SKBQ
union select 	12001176	,	4	--	SKBV
union select 	12001367	,	4	--	SKBW
union select 	12001625	,	4	--	SKBX
union select 	12006434	,	4	--	skby
union select 	12006566	,	4	--	skbz
union select 	12006659	,	4	--	SKCA
union select 	12006725	,	4	--	skcb
union select 	12006808	,	4	--	SKCC
union select 	12006831	,	4	--	SKCD
union select 	262641	,	4	--	SDD
union select 	342710	,	4	--	SY1B
union select 	838269	,	4	--	SDDTB
union select 	927679	,	4	--	SDDT
union select 	1077097	,	4	--	SDT
union select 	1174759	,	4	--	SDE
union select 	3115624	,	4	--	SDU
union select 	3115630	,	4	--	SDM
union select 	5213502	,	4	--	SDY
union select 	5226628	,	4	--	SDV
union select 	5226641	,	4	--	SDW
union select 	5226650	,	4	--	SDX
union select 	5226659	,	4	--	SDZ
union select 	5340153	,	4	--	FYU
union select 	5362504	,	4	--	SDK
union select 	5362508	,	4	--	SDL
union select 	5375392	,	4	--	SDJ
union select 	5394907	,	4	--	SDO
union select 	5419321	,	4	--	SDP
union select 	5800564	,	4	--	SDB
union select 	5800577	,	4	--	SDC
union select 	5824370	,	4	--	SDF
union select 	5824374	,	4	--	SDG
union select 	5871571	,	4	--	SDI
union select 	5871590	,	4	--	SDN
union select 	5915537	,	4	--	SDY1
union select 	6087439	,	4	--	SYA
union select 	6087443	,	4	--	SYB
union select 	6714757	,	4	--	SYC
union select 	7124243	,	4	--	SYD
union select 	7209880	,	4	--	SYE
union select 	7263508	,	4	--	SYF
union select 	7545783	,	4	--	SYG
union select 	7596465	,	4	--	SYH
union select 	7596486	,	4	--	SYJ
union select 	7596503	,	4	--	SYK
union select 	7596522	,	4	--	SYL
union select 	7596533	,	4	--	SYN
union select 	7596541	,	4	--	SYO
union select 	7596578	,	4	--	SYP
union select 	7596597	,	4	--	SYQ
union select 	7596613	,	4	--	SYS
union select 	7596636	,	4	--	SYU
union select 	7651563	,	4	--	SYV
union select 	7651639	,	4	--	SYW
union select 	7703331	,	4	--	SYY
union select 	7902402	,	4	--	SDA
union select 	8211131	,	4	--	SYZ
union select 	8265079	,	4	--	SDY2
union select 	8394258	,	4	--	SQY
union select 	8594867	,	4	--	SYZ1
union select 	8812070	,	4	--	SDY3
union select 	9020799	,	4	--	SDY5
union select 	9285643	,	4	--	SDQ
union select 	9285744	,	4	--	SDS
union select 	9432645	,	4	--	SDY6
union select 	9579809	,	4	--	SYC2
union select 	9659841	,	4	--	SDY7
union select 	10181770	,	4	--	SDN1
union select 	10181790	,	4	--	SDN2
union select 	10223418	,	4	--	SDY8
union select 	10279904	,	4	--	UZA
union select 	10318451	,	4	--	SYC3
union select 	10558395	,	4	--	SDN3
union select 	10675880	,	4	--	SDY9
union select 	12151758	,	4	--	SQA
union select 	12183294	,	4	--	YDH
union select 	13850733	,	4	--	SDY11
union select 	13850738	,	4	--	SDY12
union select 	1283	,	1	--	etus
union select 	3472	,	1	--	ETCASINO
union select 	5106	,	2	--	VT1US
union select 	7714	,	1	--	etrmb
union select 	300958	,	4	--	SQ
union select 	525344	,	1	--	ET1RMB
union select 	595561	,	4	--	SC
union select 	595565	,	4	--	XX
union select 	636678	,	4	--	SQQR
union select 	1113450	,	4	--	SM
union select 	1317452	,	4	--	SG
union select 	1505137	,	4	--	EA
union select 	1505140	,	4	--	EB
union select 	1539339	,	4	--	EC
union select 	1667537	,	4	--	EE
union select 	1698753	,	4	--	SH
union select 	1731862	,	4	--	EF
union select 	1889065	,	4	--	EG
union select 	1935623	,	4	--	XY
union select 	1935638	,	4	--	XZ
union select 	1935648	,	4	--	EH
union select 	2063714	,	4	--	EI
union select 	2063723	,	4	--	EJ
union select 	2426461	,	4	--	EK
union select 	2426467	,	4	--	EL
union select 	2426472	,	4	--	EM
union select 	2440619	,	1	--	ETEX
union select 	2571383	,	4	--	EN
union select 	2822583	,	4	--	EO
union select 	2877058	,	4	--	EP
union select 	3002011	,	4	--	EQ
union select 	3002015	,	4	--	ER
union select 	3043749	,	4	--	ES
union select 	3043753	,	4	--	ET
union select 	3318714	,	4	--	EU
union select 	3318716	,	4	--	EV
union select 	3370732	,	4	--	EW
union select 	3379262	,	4	--	EX
union select 	3379272	,	4	--	EY
union select 	3397263	,	4	--	XA
union select 	3397267	,	4	--	XB
union select 	3397270	,	4	--	XC
union select 	3428663	,	4	--	XD
union select 	3448871	,	4	--	XE
union select 	3448873	,	4	--	XF
union select 	3466791	,	4	--	XG
union select 	3518530	,	4	--	XJ
union select 	3518536	,	4	--	XK
union select 	3518540	,	4	--	XL
union select 	3581460	,	4	--	XM
union select 	3588788	,	4	--	XN
union select 	3667252	,	4	--	XO
union select 	3672278	,	4	--	XP
union select 	3706024	,	4	--	XH
union select 	3707684	,	4	--	XQ
union select 	3707692	,	4	--	XR
union select 	3759851	,	4	--	XS
union select 	3764956	,	4	--	XT
union select 	3919562	,	4	--	SSA
union select 	3919574	,	4	--	SSB
union select 	3967000	,	4	--	XXA
union select 	4058361	,	4	--	SSC
union select 	4058379	,	4	--	SSE
union select 	4079058	,	4	--	EJA
union select 	4113805	,	4	--	XXB
union select 	4113806	,	4	--	XXC
union select 	4157382	,	4	--	XXD
union select 	4157389	,	4	--	XXE
union select 	4190683	,	4	--	XXF
union select 	4195794	,	4	--	XXG
union select 	4195796	,	4	--	XXH
union select 	4232989	,	4	--	XXJ
union select 	4232994	,	4	--	XXK
union select 	4281392	,	4	--	XXO
union select 	4281394	,	4	--	XXP
union select 	4281456	,	4	--	XXQ
union select 	4281463	,	4	--	XXR
union select 	4281469	,	4	--	XXS
union select 	4356069	,	4	--	SQH
union select 	4406327	,	4	--	QA
union select 	4406329	,	4	--	QB
union select 	4533981	,	4	--	QD
union select 	4533984	,	4	--	QE
union select 	4533988	,	4	--	QF
union select 	4533993	,	4	--	QG
union select 	4613190	,	4	--	QH
union select 	4613199	,	4	--	QI
union select 	4629022	,	4	--	xxt
union select 	4689879	,	4	--	QJ
union select 	4689920	,	4	--	QK
union select 	4689932	,	4	--	QL
union select 	4689945	,	4	--	QM
union select 	4697415	,	4	--	QN
union select 	4697426	,	4	--	QO
union select 	4697442	,	4	--	QP
union select 	4759908	,	4	--	qs
union select 	4798284	,	4	--	QR
union select 	4815149	,	4	--	QT
union select 	4833640	,	4	--	QU
union select 	4841141	,	4	--	QC
union select 	4870143	,	4	--	BK
union select 	4870194	,	4	--	HC
union select 	4873460	,	4	--	BC
union select 	4900076	,	4	--	QV
union select 	4908230	,	4	--	BD
union select 	4947571	,	4	--	BE
union select 	4996099	,	4	--	BG
union select 	5015348	,	4	--	BH
union select 	5015371	,	4	--	BL
union select 	5060788	,	4	--	BM
union select 	5060793	,	4	--	BN
union select 	5108723	,	4	--	BO
union select 	5108730	,	4	--	BP
union select 	5108737	,	4	--	BR
union select 	5160159	,	4	--	BX
union select 	5160163	,	4	--	BY
union select 	5160175	,	4	--	BZ
union select 	5241927	,	4	--	BC1
union select 	5241945	,	4	--	BC2
union select 	5241964	,	4	--	BC3
union select 	5311953	,	4	--	BC5
union select 	5311961	,	4	--	BC6
union select 	5311965	,	4	--	BC7
union select 	5362682	,	4	--	BC8
union select 	5362687	,	4	--	BC9
union select 	5362694	,	4	--	BCA
union select 	5362712	,	4	--	EA1
union select 	5362720	,	4	--	EA2
union select 	5362724	,	4	--	EA3
union select 	5362729	,	4	--	EA4
union select 	5362731	,	4	--	EA5
union select 	5480712	,	4	--	AZ1
union select 	5480716	,	4	--	AZ2
union select 	5480721	,	4	--	AZ3
union select 	5480731	,	4	--	AZ4
union select 	5480735	,	4	--	AZ5
union select 	5718827	,	4	--	EA6
union select 	5718831	,	4	--	EA7
union select 	5718836	,	4	--	EA8
union select 	5718840	,	4	--	EA9
union select 	5718851	,	4	--	EAA
union select 	5812159	,	4	--	EG1
union select 	5812172	,	4	--	EG2
union select 	5812196	,	4	--	EG3
union select 	5812218	,	4	--	EG5
union select 	5812228	,	4	--	EG6
union select 	5824459	,	4	--	EAB
union select 	5824460	,	4	--	EAC
union select 	5824466	,	4	--	EAD
union select 	5824473	,	4	--	EAE
union select 	5824484	,	4	--	EAF
union select 	5940542	,	4	--	EAG
union select 	5940553	,	4	--	EAH
union select 	5940557	,	4	--	EAI
union select 	5940565	,	4	--	EAJ
union select 	5940574	,	4	--	EAK
union select 	6197528	,	4	--	EAL
union select 	6406944	,	4	--	AZ6
union select 	6406961	,	4	--	AZ7
union select 	6406976	,	4	--	AZ8
union select 	6406986	,	4	--	AZ9
union select 	6406993	,	4	--	AZ10
union select 	6456973	,	4	--	EEA
union select 	6909004	,	4	--	EBA
union select 	6909008	,	4	--	EBB
union select 	6909014	,	4	--	EBC
union select 	6909021	,	4	--	EBD
union select 	6909027	,	4	--	EBE
union select 	6909067	,	4	--	EBF
union select 	6909106	,	4	--	EBG
union select 	6909137	,	4	--	EBH
union select 	6909152	,	4	--	EBI
union select 	6909165	,	4	--	EBJ
union select 	6910609	,	4	--	EB1
union select 	6910614	,	4	--	EB2
union select 	6910618	,	4	--	EB3
union select 	6910631	,	4	--	EB5
union select 	6910642	,	4	--	EB6
union select 	7604821	,	4	--	AZ11
union select 	7604832	,	4	--	AZ12
union select 	7604844	,	4	--	AZ13
union select 	7604852	,	4	--	AZ14
union select 	7604869	,	4	--	AZ15
union select 	7702438	,	4	--	ET1
union select 	7702445	,	4	--	ET2
union select 	7702455	,	4	--	ET3
union select 	7702469	,	4	--	ET4
union select 	7702473	,	4	--	ET5
union select 	8104518	,	4	--	EBK
union select 	8104526	,	4	--	EBL
union select 	8104553	,	4	--	EBM
union select 	8594690	,	4	--	ET6
union select 	8594740	,	4	--	ET7
union select 	8594787	,	4	--	ET8
union select 	8594806	,	4	--	ET9
union select 	8594829	,	4	--	ET10
union select 	10836879	,	4	--	EH1
union select 	10836909	,	4	--	EH2
union select 	10836921	,	4	--	EH3
union select 	10836940	,	4	--	EH5
union select 	10836949	,	4	--	EH6
union select 	11211824	,	4	--	EH7
union select 	11211847	,	4	--	EH8
union select 	11211878	,	4	--	EH9
union select 	11211891	,	4	--	EJ1
union select 	11211901	,	4	--	EJ2
union select 	11474369	,	4	--	KX1
union select 	11474382	,	4	--	KX2
union select 	11474397	,	4	--	KX3
union select 	11474407	,	4	--	KX4
union select 	11474415	,	4	--	KX5
union select 	11474424	,	4	--	KX6
union select 	11474429	,	4	--	KX7
union select 	11474434	,	4	--	KX8
union select 	11474436	,	4	--	KX9
union select 	11474444	,	4	--	KX10
union select 	11586973	,	4	--	KY1
union select 	11587004	,	4	--	KY2
union select 	11587048	,	4	--	KY3
union select 	11587079	,	4	--	KY4
union select 	11587125	,	4	--	KY5
union select 	11587193	,	4	--	KY6
union select 	11587237	,	4	--	KY7
union select 	11587251	,	4	--	KY8
union select 	11587333	,	4	--	KY9
union select 	11587359	,	4	--	KY10
union select 	11635979	,	4	--	KY11
union select 	11636059	,	4	--	KY12
union select 	11636131	,	4	--	KY13
union select 	11636284	,	4	--	KY14
union select 	11636318	,	4	--	KY15
union select 	11636345	,	4	--	KY16
union select 	11636409	,	4	--	KY17
union select 	11636436	,	4	--	KY18
union select 	11636461	,	4	--	KY19
union select 	11636471	,	4	--	KY20
union select 	11636481	,	4	--	KY21
union select 	11636490	,	4	--	KY22
union select 	11636516	,	4	--	KY23
union select 	11636534	,	4	--	KY24
union select 	11636551	,	4	--	KY25
union select 	11850282	,	4	--	KY26
union select 	11850467	,	4	--	KY27
union select 	11850655	,	4	--	KY28
union select 	11850827	,	4	--	KY29
union select 	11850975	,	4	--	KY30
union select 	11851102	,	4	--	KY31
union select 	11851377	,	4	--	KY32
union select 	11851573	,	4	--	KY33
union select 	11851664	,	4	--	KY34
union select 	11851798	,	4	--	KY35
union select 	12052602	,	4	--	NW1
union select 	12052706	,	4	--	NW2
union select 	12052773	,	4	--	NW3
union select 	12053037	,	4	--	NW4
union select 	12053067	,	4	--	NW5
union select 	12053091	,	4	--	NW6
union select 	12053229	,	4	--	NW7
union select 	12053285	,	4	--	NW8
union select 	12053334	,	4	--	NW9
union select 	12053431	,	4	--	NW10
union select 	12053599	,	4	--	NW11
union select 	12053747	,	4	--	NW12
union select 	12053841	,	4	--	NW13
union select 	12053970	,	4	--	NW14
union select 	12054098	,	4	--	NW15
union select 	12054225	,	4	--	NW16
union select 	12054361	,	4	--	NW17
union select 	12054463	,	4	--	NW18
union select 	12054490	,	4	--	NW19
union select 	12054506	,	4	--	NW20
union select 	12064912	,	4	--	CG1
union select 	12064966	,	4	--	CG2
union select 	12065024	,	4	--	CG3
union select 	12065046	,	4	--	CG4
union select 	12065076	,	4	--	CG5
union select 	12259386	,	4	--	KP1
union select 	12261917	,	4	--	KP2
union select 	12262001	,	4	--	KP3
union select 	12262043	,	4	--	KP4
union select 	12262066	,	4	--	KP5
union select 	12262090	,	4	--	KP6
union select 	12262124	,	4	--	KP7
union select 	12262139	,	4	--	KP8
union select 	12262161	,	4	--	KP9
union select 	12262186	,	4	--	KP10
union select 	12262203	,	4	--	KP41
union select 	12262244	,	4	--	KP12
union select 	12262274	,	4	--	KP13
union select 	12262302	,	4	--	KP14
union select 	12262326	,	4	--	KP15
union select 	12262357	,	4	--	KP16
union select 	12262379	,	4	--	KP17
union select 	12262401	,	4	--	KP18
union select 	12262435	,	4	--	KP19
union select 	12262471	,	4	--	KP20
union select 	12289536	,	4	--	CG6
union select 	12289579	,	4	--	CG7
union select 	12289604	,	4	--	CG8
union select 	12289632	,	4	--	CG9
union select 	12289649	,	4	--	CG13
union select 	12382533	,	4	--	SK8
union select 	12382994	,	4	--	CG15
union select 	12383032	,	4	--	CG16
union select 	12383066	,	4	--	CG17
union select 	12383094	,	4	--	CG18
union select 	12383140	,	4	--	CG19
union select 	12383193	,	4	--	CG20
union select 	12618408	,	4	--	Q6
union select 	12618409	,	4	--	Q1
union select 	12618432	,	4	--	Q7
union select 	12618527	,	4	--	Q8
union select 	12618555	,	4	--	Q9
union select 	12618562	,	4	--	Q2
union select 	12618565	,	4	--	Q10
union select 	12618667	,	4	--	Q3
union select 	12618703	,	4	--	Q4
union select 	12618726	,	4	--	Q5
union select 	12886929	,	4	--	XK4
union select 	12887530	,	4	--	XK5
union select 	12887995	,	4	--	XK3
union select 	12888369	,	4	--	XK2
union select 	12888597	,	4	--	XK1
union select 	12989122	,	4	--	Q11
union select 	12989150	,	4	--	Q12
union select 	12989192	,	4	--	Q13
union select 	12989209	,	4	--	Q14
union select 	12989224	,	4	--	Q15
union select 	12989251	,	4	--	Q16
union select 	12989266	,	4	--	Q17
union select 	12989273	,	4	--	Q18
union select 	12989286	,	4	--	Q19
union select 	12989306	,	4	--	Q20
union select 	13213942	,	4	--	EQH
union select 	13715703	,	4	--	NW21
union select 	13715739	,	4	--	NW22
union select 	13715763	,	4	--	NW26
union select 	13715773	,	4	--	NW23
union select 	13715785	,	4	--	NW24
union select 	13715798	,	4	--	NW25
union select 	13715803	,	4	--	NW27
union select 	13715841	,	4	--	NW28
union select 	13715921	,	4	--	NW29
union select 	13716070	,	4	--	NW30
union select 	13727949	,	4	--	ZW1
union select 	13728003	,	4	--	ZW2
union select 	13728029	,	4	--	ZW3
union select 	13728036	,	4	--	ZW4
union select 	13728040	,	4	--	ZW5
union select 	13728049	,	4	--	ZW6
union select 	13728052	,	4	--	ZW7
union select 	13728054	,	4	--	ZW8
union select 	13728056	,	4	--	ZW9
union select 	13728068	,	4	--	ZW10
union select 	13728074	,	4	--	ZW11
union select 	13728079	,	4	--	ZW12
union select 	13728082	,	4	--	ZW13
union select 	13728086	,	4	--	ZW14
union select 	13728090	,	4	--	ZW15
union select 	13728091	,	4	--	ZW16
union select 	13728094	,	4	--	ZW17
union select 	13728096	,	4	--	ZW18
union select 	13728101	,	4	--	ZW19
union select 	13728104	,	4	--	ZW20
union select 	13728105	,	4	--	ZW21
union select 	13728109	,	4	--	ZW22
union select 	13728111	,	4	--	ZW23
union select 	13728115	,	4	--	ZW24
union select 	13728116	,	4	--	ZW25
union select 	13728117	,	4	--	ZW26
union select 	13728119	,	4	--	ZW27
union select 	13728121	,	4	--	ZW28
union select 	13728122	,	4	--	ZW29
union select 	13728125	,	4	--	ZW30
union select 	13869563	,	4	--	KP21
union select 	13869606	,	4	--	KP22
union select 	13869616	,	4	--	KP23
union select 	13869619	,	4	--	KP24
union select 	13869621	,	4	--	KP25
union select 	13869622	,	4	--	KP26
union select 	13869624	,	4	--	KP27
union select 	13869627	,	4	--	KP28
union select 	13869629	,	4	--	KP29
union select 	13869630	,	4	--	KP30
union select 	13869634	,	4	--	KP31
union select 	13869640	,	4	--	KP32
union select 	13869643	,	4	--	KP33
union select 	13869648	,	4	--	KP34
union select 	13869651	,	4	--	KP35
union select 	13869652	,	4	--	KP36
union select 	13869654	,	4	--	KP37
union select 	13869658	,	4	--	KP38
union select 	13869661	,	4	--	KP39
union select 	13869663	,	4	--	KP40
union select 	14075093	,	4	--	XTA
union select 	14075113	,	4	--	XTB
union select 	14075118	,	4	--	XTC
union select 	14075122	,	4	--	XTD
union select 	14090947	,	4	--	CG21
union select 	14090980	,	4	--	CG22
union select 	14090991	,	4	--	CG23
union select 	14090994	,	4	--	CG24
union select 	14091001	,	4	--	CG25



WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #tmpCust
	SET isfinished = 1
		,@custid = custid	
		,@roleid = roleid
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.[Acc_CustSetting_03] @custid = @custid
		,@roleid = @roleid
		,@maxcustid = @max_custid
		,@target = 'DBTRANS'
		
	WAITFOR DELAY '00:00:00.280'
END
GO
