/*
	Created: Johnson
	Date: 2014-04-04
	Task: Disable keno's games for vip supers
	DB: DBTXN/CustDB
*/ 

-- STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting_03]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','CustGameType') AND type = 'U' ) <> 2
		RETURN
		
	UPDATE cg
	SET cg.IsDisabled = 1
	FROM CustGameType cg WITH(UPDLOCK,ROWLOCK)
		INNER JOIN CustInfo ci WITH(NOLOCK) ON cg.custid = ci.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND cg.gametypeid NOT IN (2,6)
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------	


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
CREATE TABLE #Supers(Custid INT , isfinished bit default(0))

INSERT INTO #supers (custid)
	 select 	5718827	--	EA6
union select 	5718831	--	EA7
union select 	5718836	--	EA8
union select 	1539339	--	EC
union select 	2426467	--	EL
union select 	2877058	--	EP
union select 	3043749	--	ES
union select 	8594806	--	ET9
union select 	11474444	--	KX10
union select 	11474382	--	KX2
union select 	11474407	--	KX4
union select 	11474415	--	KX5
union select 	11474424	--	KX6
union select 	11474429	--	KX7
union select 	11474434	--	KX8
union select 	11586973	--	KY1
union select 	11587359	--	KY10
union select 	11635979	--	KY11
union select 	11636059	--	KY12
union select 	11636284	--	KY14
union select 	11636345	--	KY16
union select 	11636409	--	KY17
union select 	11636461	--	KY19
union select 	11636471	--	KY20
union select 	11636481	--	KY21
union select 	11636551	--	KY25
union select 	11850282	--	KY26
union select 	11850467	--	KY27
union select 	11850655	--	KY28
union select 	11850975	--	KY30
union select 	11851377	--	KY32
union select 	14210944	--	KY36
union select 	11587079	--	KY4
union select 	11587125	--	KY5
union select 	11587193	--	KY6
union select 	11587333	--	KY9
union select 	12054098	--	NW15
union select 	12054225	--	NW16
union select 	12054463	--	NW18
union select 	12054490	--	NW19
union select 	12052706	--	NW2
union select 	12054506	--	NW20
union select 	13715703	--	NW21
union select 	13715739	--	NW22
union select 	13715785	--	NW24
union select 	13715803	--	NW27
union select 	13715841	--	NW28
union select 	13715921	--	NW29
union select 	12052773	--	NW3
union select 	13716070	--	NW30
union select 	12053067	--	NW5
union select 	12053091	--	NW6
union select 	12053229	--	NW7
union select 	12053285	--	NW8
union select 	12053334	--	NW9
union select 	12618565	--	Q10
union select 	12989122	--	Q11
union select 	12989150	--	Q12
union select 	12989209	--	Q14
union select 	12989224	--	Q15
union select 	12989251	--	Q16
union select 	12989266	--	Q17
union select 	12989286	--	Q19
union select 	12618562	--	Q2
union select 	12989306	--	Q20
union select 	12618667	--	Q3
union select 	12618703	--	Q4
union select 	12618726	--	Q5
union select 	12618408	--	Q6
union select 	12618432	--	Q7
union select 	12618527	--	Q8
union select 	12618555	--	Q9
union select 	4533984	--	QE
union select 	3428663	--	XD
union select 	3581460	--	XM
union select 	3707684	--	XQ
union select 	595565	--	XX
union select 	4281392	--	XXO
union select 	4281456	--	XXQ
union select 	1935638	--	XZ
union select 	5362729	--	EA4
union select 	5718840	--	EA9
union select 	5718851	--	EAA
union select 	5824460	--	EAC
union select 	5824473	--	EAE
union select 	5824484	--	EAF
union select 	5940542	--	EAG
union select 	5940557	--	EAI
union select 	6909004	--	EBA
union select 	6909014	--	EBC
union select 	6909021	--	EBD
union select 	6909027	--	EBE
union select 	6909067	--	EBF
union select 	6909106	--	EBG
union select 	6909137	--	EBH
union select 	6909152	--	EBI
union select 	6909165	--	EBJ
union select 	8104518	--	EBK
union select 	8104526	--	EBL
union select 	8104553	--	EBM
union select 	6456973	--	EEA
union select 	1731862	--	EF
union select 	1889065	--	EG
union select 	2063723	--	EJ
union select 	8594829	--	ET10
union select 	8594690	--	ET6
union select 	8594740	--	ET7
union select 	8594787	--	ET8
union select 	3318714	--	EU
union select 	3318716	--	EV
union select 	3379272	--	EY
union select 	11474369	--	KX1
union select 	11474397	--	KX3
union select 	11474436	--	KX9
union select 	11636318	--	KY15
union select 	11587004	--	KY2
union select 	11636516	--	KY23
union select 	11636534	--	KY24
union select 	11587237	--	KY7
union select 	11587251	--	KY8
union select 	12053431	--	NW10
union select 	12053599	--	NW11
union select 	12053747	--	NW12
union select 	12053970	--	NW14
union select 	12054361	--	NW17
union select 	13715773	--	NW23
union select 	13715798	--	NW25
union select 	13715763	--	NW26
union select 	12053037	--	NW4
union select 	12618409	--	Q1
union select 	12989192	--	Q13
union select 	4533993	--	QG
union select 	3919562	--	SSA
union select 	3397267	--	XB
union select 	3397270	--	XC
union select 	3466791	--	XG
union select 	3667252	--	XO
union select 	3672278	--	XP
union select 	4195794	--	XXG
union select 	4232989	--	XXJ
union select 	4232994	--	XXK
union select 	4281394	--	XXP
union select 	1935623	--	XY
union select 	5362731	--	EA5
union select 	5940565	--	EAJ
union select 	4079058	--	EJA
union select 	11851664	--	KY34
union select 	11851798	--	KY35
union select 	12052602	--	NW1
union select 	12053841	--	NW13
union select 	12989273	--	Q18
union select 	3919574	--	SSB
union select 	4629022	--	xxt
union select 	5362712	--	EA1
union select 	5362720	--	EA2
union select 	5362724	--	EA3
union select 	5824459	--	EAB
union select 	5824466	--	EAD
union select 	5940553	--	EAH
union select 	5940574	--	EAK
union select 	6909008	--	EBB
union select 	2063714	--	EI
union select 	3002015	--	ER
union select 	11636131	--	KY13
union select 	11636436	--	KY18
union select 	11636490	--	KY22
union select 	11850827	--	KY29
union select 	11587048	--	KY3
union select 	11851102	--	KY31
union select 	11851573	--	KY33
union select 	4533981	--	QD
union select 	4533988	--	QF
union select 	4689879	--	QJ
union select 	4058361	--	SSC
union select 	4058379	--	SSE
union select 	3397263	--	XA
union select 	3588788	--	XN
union select 	3707692	--	XR
union select 	4157382	--	XXD
union select 	4157389	--	XXE
union select 	4195796	--	XXH
union select 	4281463	--	XXR
union select 	4281469	--	XXS


DECLARE @max_custid INT, @srecommend INT

SET @max_custid = xxx 


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting_03] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
------------------------------------------------------


---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
CREATE TABLE #Supers(Custid INT , isfinished bit default(0))

INSERT INTO #supers (custid)
	 select 	5718827	--	EA6
union select 	5718831	--	EA7
union select 	5718836	--	EA8
union select 	1539339	--	EC
union select 	2426467	--	EL
union select 	2877058	--	EP
union select 	3043749	--	ES
union select 	8594806	--	ET9
union select 	11474444	--	KX10
union select 	11474382	--	KX2
union select 	11474407	--	KX4
union select 	11474415	--	KX5
union select 	11474424	--	KX6
union select 	11474429	--	KX7
union select 	11474434	--	KX8
union select 	11586973	--	KY1
union select 	11587359	--	KY10
union select 	11635979	--	KY11
union select 	11636059	--	KY12
union select 	11636284	--	KY14
union select 	11636345	--	KY16
union select 	11636409	--	KY17
union select 	11636461	--	KY19
union select 	11636471	--	KY20
union select 	11636481	--	KY21
union select 	11636551	--	KY25
union select 	11850282	--	KY26
union select 	11850467	--	KY27
union select 	11850655	--	KY28
union select 	11850975	--	KY30
union select 	11851377	--	KY32
union select 	14210944	--	KY36
union select 	11587079	--	KY4
union select 	11587125	--	KY5
union select 	11587193	--	KY6
union select 	11587333	--	KY9
union select 	12054098	--	NW15
union select 	12054225	--	NW16
union select 	12054463	--	NW18
union select 	12054490	--	NW19
union select 	12052706	--	NW2
union select 	12054506	--	NW20
union select 	13715703	--	NW21
union select 	13715739	--	NW22
union select 	13715785	--	NW24
union select 	13715803	--	NW27
union select 	13715841	--	NW28
union select 	13715921	--	NW29
union select 	12052773	--	NW3
union select 	13716070	--	NW30
union select 	12053067	--	NW5
union select 	12053091	--	NW6
union select 	12053229	--	NW7
union select 	12053285	--	NW8
union select 	12053334	--	NW9
union select 	12618565	--	Q10
union select 	12989122	--	Q11
union select 	12989150	--	Q12
union select 	12989209	--	Q14
union select 	12989224	--	Q15
union select 	12989251	--	Q16
union select 	12989266	--	Q17
union select 	12989286	--	Q19
union select 	12618562	--	Q2
union select 	12989306	--	Q20
union select 	12618667	--	Q3
union select 	12618703	--	Q4
union select 	12618726	--	Q5
union select 	12618408	--	Q6
union select 	12618432	--	Q7
union select 	12618527	--	Q8
union select 	12618555	--	Q9
union select 	4533984	--	QE
union select 	3428663	--	XD
union select 	3581460	--	XM
union select 	3707684	--	XQ
union select 	595565	--	XX
union select 	4281392	--	XXO
union select 	4281456	--	XXQ
union select 	1935638	--	XZ
union select 	5362729	--	EA4
union select 	5718840	--	EA9
union select 	5718851	--	EAA
union select 	5824460	--	EAC
union select 	5824473	--	EAE
union select 	5824484	--	EAF
union select 	5940542	--	EAG
union select 	5940557	--	EAI
union select 	6909004	--	EBA
union select 	6909014	--	EBC
union select 	6909021	--	EBD
union select 	6909027	--	EBE
union select 	6909067	--	EBF
union select 	6909106	--	EBG
union select 	6909137	--	EBH
union select 	6909152	--	EBI
union select 	6909165	--	EBJ
union select 	8104518	--	EBK
union select 	8104526	--	EBL
union select 	8104553	--	EBM
union select 	6456973	--	EEA
union select 	1731862	--	EF
union select 	1889065	--	EG
union select 	2063723	--	EJ
union select 	8594829	--	ET10
union select 	8594690	--	ET6
union select 	8594740	--	ET7
union select 	8594787	--	ET8
union select 	3318714	--	EU
union select 	3318716	--	EV
union select 	3379272	--	EY
union select 	11474369	--	KX1
union select 	11474397	--	KX3
union select 	11474436	--	KX9
union select 	11636318	--	KY15
union select 	11587004	--	KY2
union select 	11636516	--	KY23
union select 	11636534	--	KY24
union select 	11587237	--	KY7
union select 	11587251	--	KY8
union select 	12053431	--	NW10
union select 	12053599	--	NW11
union select 	12053747	--	NW12
union select 	12053970	--	NW14
union select 	12054361	--	NW17
union select 	13715773	--	NW23
union select 	13715798	--	NW25
union select 	13715763	--	NW26
union select 	12053037	--	NW4
union select 	12618409	--	Q1
union select 	12989192	--	Q13
union select 	4533993	--	QG
union select 	3919562	--	SSA
union select 	3397267	--	XB
union select 	3397270	--	XC
union select 	3466791	--	XG
union select 	3667252	--	XO
union select 	3672278	--	XP
union select 	4195794	--	XXG
union select 	4232989	--	XXJ
union select 	4232994	--	XXK
union select 	4281394	--	XXP
union select 	1935623	--	XY
union select 	5362731	--	EA5
union select 	5940565	--	EAJ
union select 	4079058	--	EJA
union select 	11851664	--	KY34
union select 	11851798	--	KY35
union select 	12052602	--	NW1
union select 	12053841	--	NW13
union select 	12989273	--	Q18
union select 	3919574	--	SSB
union select 	4629022	--	xxt
union select 	5362712	--	EA1
union select 	5362720	--	EA2
union select 	5362724	--	EA3
union select 	5824459	--	EAB
union select 	5824466	--	EAD
union select 	5940553	--	EAH
union select 	5940574	--	EAK
union select 	6909008	--	EBB
union select 	2063714	--	EI
union select 	3002015	--	ER
union select 	11636131	--	KY13
union select 	11636436	--	KY18
union select 	11636490	--	KY22
union select 	11850827	--	KY29
union select 	11587048	--	KY3
union select 	11851102	--	KY31
union select 	11851573	--	KY33
union select 	4533981	--	QD
union select 	4533988	--	QF
union select 	4689879	--	QJ
union select 	4058361	--	SSC
union select 	4058379	--	SSE
union select 	3397263	--	XA
union select 	3588788	--	XN
union select 	3707692	--	XR
union select 	4157382	--	XXD
union select 	4157389	--	XXE
union select 	4195796	--	XXH
union select 	4281463	--	XXR
union select 	4281469	--	XXS


DECLARE @max_custid INT, @srecommend INT

SET @max_custid = xxx 


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting_03] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBTRANS'
END			
GO		

-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------