  /*
	Created: Johnson
	Date: 2014-04-11
	Task: Update racing bet setting for deposit customers
	DB: DBTXN/CustDB
 */
 
 
-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
 
 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]	
	@srecommend INT,
	@sporttype INT,
	@minbet MONEY,
	@maxbet MONEY,
	@maxpermatch MONEY,
	@maxcustid INT,
	@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('custinfo') AND type = 'U'
	) <> 1 RETURN
	
	IF @sporttype = 151 and @maxpermatch IS NOT NULL-- horse racing
	BEGIN
		UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
		SET maxpermatch151 = @maxpermatch,
			MaxPerMatch151_OT = @maxpermatch, 
			MaxPerMatch151_AU = @maxpermatch			
		WHERE srecommend = @srecommend
			AND custid <= @maxcustid
	END
	ELSE IF @sporttype = 152 AND @maxpermatch IS NOT NULL-- greyhounds
	BEGIN
		UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
		SET MaxPerMatch152_UK = @maxpermatch,
			MaxPerMatch152_AU = @maxpermatch
		WHERE srecommend = @srecommend
			AND custid <= @maxcustid
	END
	ELSE IF @sporttype = 153 AND @maxpermatch IS NOT NULL-- harness
	BEGIN
		UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
		SET MaxPerMatch153_AU = @maxpermatch
		WHERE srecommend = @srecommend
			AND custid <= @maxcustid
	END
	
	IF (SELECT COUNT(1)
	FROM sys.objects
	WHERE NAME IN ('Dep_custsetting3rd') AND type = 'U'
	) <> 1 RETURN
	
	IF @sporttype = 151 AND (@minbet IS NOT NULL OR @maxbet IS NOT NULL)-- horse racing
	BEGIN
		UPDATE cs
		SET minbet = ISNULL(@minbet,minbet),
			maxbet = ISNULL(@maxbet,maxbet)
		FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		WHERE ci.srecommend = @srecommend
			AND cs.sporttype = 151	
			AND cs.bettype IN (31,32,41,42,51,52)		
			AND ci.custid <= @maxcustid
	END	
	ELSE IF @sporttype = 152 AND (@minbet IS NOT NULL OR @maxbet IS NOT NULL)--greyhounds
	BEGIN
		UPDATE cs
		SET minbet = ISNULL(@minbet,minbet),
			maxbet = ISNULL(@maxbet,maxbet)
		FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		WHERE ci.srecommend = @srecommend
			AND cs.sporttype = 152
			AND cs.bettype IN (41,42,51,52)
			AND ci.custid <= @maxcustid
	END
	ELSE IF @sporttype = 153 AND (@minbet IS NOT NULL OR @maxbet IS NOT NULL)--harness
	BEGIN
		UPDATE cs
		SET minbet = ISNULL(@minbet,minbet),
			maxbet = ISNULL(@maxbet,maxbet)
		FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		WHERE ci.srecommend = @srecommend
			AND cs.sporttype = 153
			AND cs.bettype IN (51,52)
			AND ci.custid <= @maxcustid
	END
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
CREATE TABLE #DepSettings(Custid INT , sporttype INT, minbet MONEY, maxbet MONEY, maxpermatch MONEY, isfinished bit default(0))

INSERT INTO #depSettings(custid, sporttype, minbet, maxbet, maxpermatch)
		 select	1752415	,	151	,	NULL	,	NULL	,	28000	--	12Bet	,	12BETSuperSD$
union select	1752415	,	152	,	NULL	,	7000	,	28000	--	12Bet	,	12BETSuperSD$
union select	1752415	,	153	,	NULL	,	7000	,	28000	--	12Bet	,	12BETSuperSD$
union select	836218	,	152	,	NULL	,	20000	,	NULL	--	12Bet	,	12BETSuperRM
union select	836218	,	153	,	NULL	,	20000	,	NULL	--	12Bet	,	12BETSuperRM
union select	791080	,	151	,	NULL	,	NULL	,	24000	--	12Bet	,	12BETSuperUS$
union select	791080	,	152	,	NULL	,	6000	,	24000	--	12Bet	,	12BETSuperUS$
union select	791080	,	153	,	NULL	,	6000	,	24000	--	12Bet	,	12BETSuperUS$
union select	836203	,	151	,	NULL	,	NULL	,	720000	--	12Bet	,	12BETSuperTB
union select	836203	,	152	,	NULL	,	180000	,	720000	--	12Bet	,	12BETSuperTB
union select	836203	,	153	,	NULL	,	180000	,	720000	--	12Bet	,	12BETSuperTB
union select	791081	,	151	,	NULL	,	NULL	,	16000	--	12Bet	,	12BETSuperEURO
union select	791081	,	152	,	NULL	,	4000	,	16000	--	12Bet	,	12BETSuperEURO
union select	791081	,	153	,	NULL	,	4000	,	16000	--	12Bet	,	12BETSuperEURO
union select	1015419	,	151	,	NULL	,	NULL	,	24000	--	12Bet	,	12BETSuperAUD
union select	1015419	,	152	,	NULL	,	6000	,	24000	--	12Bet	,	12BETSuperAUD
union select	1015419	,	153	,	NULL	,	6000	,	24000	--	12Bet	,	12BETSuperAUD
union select	836212	,	151	,	NULL	,	NULL	,	12000	--	12Bet	,	12BETSuperGBP
union select	836212	,	152	,	NULL	,	3000	,	12000	--	12Bet	,	12BETSuperGBP
union select	836212	,	153	,	NULL	,	3000	,	12000	--	12Bet	,	12BETSuperGBP
union select	836226	,	151	,	NULL	,	NULL	,	128000	--	12Bet	,	12BETSuperRMB
union select	836226	,	152	,	NULL	,	32000	,	128000	--	12Bet	,	12BETSuperRMB
union select	836226	,	153	,	NULL	,	32000	,	128000	--	12Bet	,	12BETSuperRMB
union select	1813575	,	152	,	NULL	,	65000	,	NULL	--	12Bet	,	12BETSuperIN
union select	1813575	,	153	,	NULL	,	65000	,	NULL	--	12Bet	,	12BETSuperIN
union select	6006478	,	151	,	NULL	,	NULL	,	2000000	--	12Bet	,	12BETSuperJPY
union select	6006478	,	152	,	NULL	,	500000	,	2000000	--	12Bet	,	12BETSuperJPY
union select	6006478	,	153	,	NULL	,	500000	,	2000000	--	12Bet	,	12BETSuperJPY
union select	1015427	,	152	,	NULL	,	5000	,	NULL	--	12Bet	,	12BETSuperCHF
union select	1015427	,	153	,	NULL	,	5000	,	NULL	--	12Bet	,	12BETSuperCHF
union select	6006276	,	151	,	NULL	,	NULL	,	24000000	--	12Bet	,	12BETSuperWON
union select	6006276	,	152	,	NULL	,	6000000	,	24000000	--	12Bet	,	12BETSuperWON
union select	6006276	,	153	,	NULL	,	6000000	,	24000000	--	12Bet	,	12BETSuperWON
union select	6006409	,	152	,	NULL	,	350000	,	NULL	--	12Bet	,	12BETSuperINR
union select	6006409	,	153	,	NULL	,	350000	,	NULL	--	12Bet	,	12BETSuperINR
union select	2747862	,	151	,	NULL	,	NULL	,	28000	--	alog	,	ALogSuperSD$
union select	2747862	,	152	,	NULL	,	7000	,	28000	--	alog	,	ALogSuperSD$
union select	2747862	,	153	,	NULL	,	7000	,	28000	--	alog	,	ALogSuperSD$
union select	2747736	,	152	,	NULL	,	20000	,	80000	--	alog	,	ALogSuperRM
union select	2747736	,	153	,	NULL	,	20000	,	80000	--	alog	,	ALogSuperRM
union select	2308796	,	151	,	NULL	,	NULL	,	24000	--	alog	,	ALogSuperUS$
union select	2308796	,	152	,	NULL	,	6000	,	24000	--	alog	,	ALogSuperUS$
union select	2308796	,	153	,	NULL	,	6000	,	24000	--	alog	,	ALogSuperUS$
union select	2747989	,	151	,	NULL	,	NULL	,	720000	--	alog	,	ALogSuperTB
union select	2747989	,	152	,	NULL	,	180000	,	720000	--	alog	,	ALogSuperTB
union select	2747989	,	153	,	NULL	,	180000	,	720000	--	alog	,	ALogSuperTB
union select	3114255	,	151	,	NULL	,	NULL	,	16000	--	alog	,	AlogSuperEURO
union select	3114255	,	152	,	NULL	,	4000	,	16000	--	alog	,	AlogSuperEURO
union select	3114255	,	153	,	NULL	,	4000	,	16000	--	alog	,	AlogSuperEURO
union select	2308771	,	151	,	NULL	,	NULL	,	12000	--	alog	,	ALogSuperGBP
union select	2308771	,	152	,	NULL	,	3000	,	12000	--	alog	,	ALogSuperGBP
union select	2308771	,	153	,	NULL	,	3000	,	12000	--	alog	,	ALogSuperGBP
union select	2308841	,	151	,	NULL	,	NULL	,	128000	--	alog	,	ALogSuperRMB
union select	2308841	,	152	,	NULL	,	32000	,	128000	--	alog	,	ALogSuperRMB
union select	2308841	,	153	,	NULL	,	32000	,	128000	--	alog	,	ALogSuperRMB
union select	3782799	,	151	,	100	,	NULL	,	NULL	--	alog	,	AlogSuperIN
union select	3782799	,	152	,	50	,	NULL	,	NULL	--	alog	,	AlogSuperIN
union select	3782799	,	153	,	50	,	NULL	,	NULL	--	alog	,	AlogSuperIN
union select	3417070	,	152	,	NULL	,	120000	,	480000	--	alog	,	AlogSuperINH
union select	3417070	,	153	,	NULL	,	120000	,	480000	--	alog	,	AlogSuperINH
union select	6618394	,	151	,	NULL	,	NULL	,	64000	--	alog	,	AlogSuperPLN
union select	6618394	,	152	,	NULL	,	16000	,	64000	--	alog	,	AlogSuperPLN
union select	6618394	,	153	,	NULL	,	16000	,	64000	--	alog	,	AlogSuperPLN
union select	6092487	,	151	,	NULL	,	NULL	,	1400000	--	alog	,	AlogSuperINR
union select	6092487	,	152	,	NULL	,	350000	,	1400000	--	alog	,	AlogSuperINR
union select	6092487	,	153	,	NULL	,	350000	,	1400000	--	alog	,	AlogSuperINR
union select	1004374	,	151	,	NULL	,	NULL	,	28000	--	asiabet88	,	AB88SuperSD$
union select	1004374	,	152	,	NULL	,	7000	,	28000	--	asiabet88	,	AB88SuperSD$
union select	1004374	,	153	,	NULL	,	7000	,	28000	--	asiabet88	,	AB88SuperSD$
union select	932209	,	152	,	NULL	,	20000	,	NULL	--	asiabet88	,	AB88SuperRM
union select	932209	,	153	,	NULL	,	20000	,	NULL	--	asiabet88	,	AB88SuperRM
union select	932063	,	151	,	NULL	,	NULL	,	24000	--	asiabet88	,	AB88SuperUS$
union select	932063	,	152	,	NULL	,	6000	,	24000	--	asiabet88	,	AB88SuperUS$
union select	932063	,	153	,	NULL	,	6000	,	24000	--	asiabet88	,	AB88SuperUS$
union select	932181	,	151	,	300	,	NULL	,	720000	--	asiabet88	,	AB88SuperTB
union select	932181	,	152	,	NULL	,	180000	,	720000	--	asiabet88	,	AB88SuperTB
union select	932181	,	153	,	NULL	,	180000	,	720000	--	asiabet88	,	AB88SuperTB
union select	932167	,	151	,	NULL	,	NULL	,	16000	--	asiabet88	,	AB88SuperEURO
union select	932167	,	152	,	NULL	,	4000	,	16000	--	asiabet88	,	AB88SuperEURO
union select	932167	,	153	,	NULL	,	4000	,	16000	--	asiabet88	,	AB88SuperEURO
union select	932188	,	151	,	NULL	,	NULL	,	12000	--	asiabet88	,	AB88SuperGBP
union select	932188	,	152	,	NULL	,	3000	,	12000	--	asiabet88	,	AB88SuperGBP
union select	932188	,	153	,	NULL	,	3000	,	12000	--	asiabet88	,	AB88SuperGBP
union select	932253	,	151	,	NULL	,	NULL	,	128000	--	asiabet88	,	AB88SuperRMB
union select	932253	,	152	,	NULL	,	32000	,	128000	--	asiabet88	,	AB88SuperRMB
union select	932253	,	153	,	NULL	,	32000	,	128000	--	asiabet88	,	AB88SuperRMB
union select	2564717	,	152	,	NULL	,	65000	,	NULL	--	asiabet88	,	AB88SuperIN
union select	2564717	,	153	,	NULL	,	65000	,	NULL	--	asiabet88	,	AB88SuperIN
union select	14131319	,	151	,	7000	,	NULL	,	NULL	--	asiabet88	,	asiabet88SuperWon
union select	14131319	,	152	,	7000	,	NULL	,	NULL	--	asiabet88	,	asiabet88SuperWon
union select	14131319	,	153	,	7000	,	NULL	,	NULL	--	asiabet88	,	asiabet88SuperWon
union select	4833492	,	151	,	150	,	NULL	,	NULL	--	asiabet88	,	AB88SuperINH
union select	4833492	,	152	,	70	,	NULL	,	NULL	--	asiabet88	,	AB88SuperINH
union select	4833492	,	153	,	70	,	NULL	,	NULL	--	asiabet88	,	AB88SuperINH
union select	4689517	,	152	,	NULL	,	7000	,	NULL	--	Bodog	,	BODOGSuperSD$
union select	4689517	,	153	,	NULL	,	7000	,	NULL	--	Bodog	,	BODOGSuperSD$
union select	4714272	,	152	,	NULL	,	20000	,	NULL	--	Bodog	,	BODOGSuperRM
union select	4714272	,	153	,	NULL	,	20000	,	NULL	--	Bodog	,	BODOGSuperRM
union select	4686903	,	152	,	NULL	,	6000	,	NULL	--	Bodog	,	BODOGSuperUS$
union select	4686903	,	153	,	NULL	,	6000	,	NULL	--	Bodog	,	BODOGSuperUS$
union select	4689166	,	152	,	NULL	,	180000	,	NULL	--	Bodog	,	BODOGSuperTB
union select	4689166	,	153	,	NULL	,	180000	,	NULL	--	Bodog	,	BODOGSuperTB
union select	4715142	,	152	,	NULL	,	4000	,	NULL	--	Bodog	,	BODOGSuperEURO
union select	4715142	,	153	,	NULL	,	4000	,	NULL	--	Bodog	,	BODOGSuperEURO
union select	7651889	,	152	,	NULL	,	6000	,	NULL	--	Bodog	,	BODOGSuperAUD
union select	7651889	,	153	,	NULL	,	6000	,	NULL	--	Bodog	,	BODOGSuperAUD
union select	4715061	,	152	,	NULL	,	3000	,	NULL	--	Bodog	,	BODOGSuperGBP
union select	4715061	,	153	,	NULL	,	3000	,	NULL	--	Bodog	,	BODOGSuperGBP
union select	4688739	,	152	,	NULL	,	32000	,	NULL	--	Bodog	,	BODOGSuperRMB
union select	4688739	,	153	,	NULL	,	32000	,	NULL	--	Bodog	,	BODOGSuperRMB
union select	4715507	,	152	,	NULL	,	6000000	,	NULL	--	Bodog	,	BODOGSuperWON
union select	4715507	,	153	,	NULL	,	6000000	,	NULL	--	Bodog	,	BODOGSuperWON
union select	8198572	,	151	,	NULL	,	NULL	,	480000	--	Bodog	,	BODOGSuperINH
union select	8198572	,	152	,	NULL	,	120000	,	480000	--	Bodog	,	BODOGSuperINH
union select	8198572	,	153	,	NULL	,	120000	,	480000	--	Bodog	,	BODOGSuperINH
union select	12910607	,	151	,	50	,	NULL	,	128000	--	Boma365	,	Boma365SuperRMB
union select	12910607	,	152	,	30	,	32000	,	128000	--	Boma365	,	Boma365SuperRMB
union select	12910607	,	153	,	30	,	32000	,	128000	--	Boma365	,	Boma365SuperRMB
union select	13853422	,	151	,	50	,	NULL	,	NULL	--	Happy1668	,	Happy1668SuperRMB
union select	13853422	,	152	,	30	,	NULL	,	NULL	--	Happy1668	,	Happy1668SuperRMB
union select	13853422	,	153	,	30	,	NULL	,	NULL	--	Happy1668	,	Happy1668SuperRMB
union select	13626157	,	151	,	NULL	,	NULL	,	128000	--	Hengcai88	,	Hengcai88SuperRMB
union select	13626157	,	152	,	NULL	,	32000	,	128000	--	Hengcai88	,	Hengcai88SuperRMB
union select	13626157	,	153	,	NULL	,	32000	,	128000	--	Hengcai88	,	Hengcai88SuperRMB
union select	1574036	,	152	,	NULL	,	7000	,	28000	--	mansion88	,	MS88SuperSD$
union select	1574036	,	153	,	NULL	,	7000	,	28000	--	mansion88	,	MS88SuperSD$
union select	1574028	,	152	,	NULL	,	20000	,	NULL	--	mansion88	,	MS88SuperRM
union select	1574028	,	153	,	NULL	,	20000	,	NULL	--	mansion88	,	MS88SuperRM
union select	1573954	,	152	,	NULL	,	6000	,	24000	--	mansion88	,	MS88SuperUS$
union select	1573954	,	153	,	NULL	,	6000	,	24000	--	mansion88	,	MS88SuperUS$
union select	1573967	,	152	,	NULL	,	180000	,	720000	--	mansion88	,	MS88SuperTB
union select	1573967	,	153	,	NULL	,	180000	,	720000	--	mansion88	,	MS88SuperTB
union select	1574024	,	151	,	50	,	NULL	,	NULL	--	mansion88	,	MS88SuperHK$
union select	1574024	,	152	,	NULL	,	40000	,	NULL	--	mansion88	,	MS88SuperHK$
union select	1574024	,	153	,	NULL	,	40000	,	NULL	--	mansion88	,	MS88SuperHK$
union select	1573960	,	152	,	NULL	,	4000	,	16000	--	mansion88	,	MS88SuperEURO
union select	1573960	,	153	,	NULL	,	4000	,	16000	--	mansion88	,	MS88SuperEURO
union select	1574016	,	151	,	NULL	,	NULL	,	24000	--	mansion88	,	MS88SuperAUD
union select	1574016	,	152	,	NULL	,	6000	,	24000	--	mansion88	,	MS88SuperAUD
union select	1574016	,	153	,	NULL	,	6000	,	24000	--	mansion88	,	MS88SuperAUD
union select	1573975	,	151	,	NULL	,	NULL	,	12000	--	mansion88	,	MS88SuperGBP
union select	1573975	,	152	,	NULL	,	3000	,	12000	--	mansion88	,	MS88SuperGBP
union select	1573975	,	153	,	NULL	,	3000	,	12000	--	mansion88	,	MS88SuperGBP
union select	1574008	,	152	,	NULL	,	32000	,	128000	--	mansion88	,	MS88SuperRMB
union select	1574008	,	153	,	NULL	,	32000	,	128000	--	mansion88	,	MS88SuperRMB
union select	1574102	,	152	,	NULL	,	65000	,	NULL	--	mansion88	,	MS88SuperIN
union select	1574102	,	153	,	NULL	,	65000	,	NULL	--	mansion88	,	MS88SuperIN
union select	2397872	,	152	,	NULL	,	500000	,	NULL	--	mansion88	,	MS88SuperJPY
union select	2397872	,	153	,	NULL	,	500000	,	NULL	--	mansion88	,	MS88SuperJPY
union select	2397885	,	151	,	NULL	,	NULL	,	24000000	--	mansion88	,	MS88SuperWON
union select	2397885	,	152	,	NULL	,	6000000	,	24000000	--	mansion88	,	MS88SuperWON
union select	2397885	,	153	,	NULL	,	6000000	,	24000000	--	mansion88	,	MS88SuperWON
union select	1574083	,	151	,	NULL	,	NULL	,	28000	--	mansion88	,	MS88SuperBND
union select	1574083	,	152	,	NULL	,	7000	,	28000	--	mansion88	,	MS88SuperBND
union select	1574083	,	153	,	NULL	,	7000	,	28000	--	mansion88	,	MS88SuperBND
union select	13105568	,	151	,	NULL	,	NULL	,	128000	--	Salon365	,	Salon365SuperRMB
union select	13105568	,	152	,	NULL	,	32000	,	128000	--	Salon365	,	Salon365SuperRMB
union select	13105568	,	153	,	NULL	,	32000	,	128000	--	Salon365	,	Salon365SuperRMB
union select	13105479	,	151	,	NULL	,	NULL	,	128000	--	Saloncs	,	SaloncsSuperRMB
union select	13105479	,	152	,	NULL	,	32000	,	128000	--	Saloncs	,	SaloncsSuperRMB
union select	13105479	,	153	,	NULL	,	32000	,	128000	--	Saloncs	,	SaloncsSuperRMB
union select	7140934	,	151	,	NULL	,	NULL	,	28000	--	VCasia	,	VCasiaSuperSD$
union select	7140934	,	152	,	NULL	,	7000	,	28000	--	VCasia	,	VCasiaSuperSD$
union select	7140934	,	153	,	NULL	,	7000	,	28000	--	VCasia	,	VCasiaSuperSD$
union select	7140747	,	151	,	NULL	,	NULL	,	24000	--	VCasia	,	VcasiaSuperUS$
union select	7140747	,	152	,	NULL	,	6000	,	24000	--	VCasia	,	VcasiaSuperUS$
union select	7140747	,	153	,	NULL	,	6000	,	24000	--	VCasia	,	VcasiaSuperUS$
union select	7140648	,	151	,	NULL	,	NULL	,	16000	--	VCasia	,	VCasiaSuperEuro
union select	7140648	,	152	,	NULL	,	4000	,	16000	--	VCasia	,	VCasiaSuperEuro
union select	7140648	,	153	,	NULL	,	4000	,	16000	--	VCasia	,	VCasiaSuperEuro
union select	7140807	,	151	,	NULL	,	NULL	,	24000	--	VCasia	,	VCasiaSuperAUD
union select	7140807	,	152	,	NULL	,	6000	,	24000	--	VCasia	,	VCasiaSuperAUD
union select	7140807	,	153	,	NULL	,	6000	,	24000	--	VCasia	,	VCasiaSuperAUD
union select	7140071	,	151	,	NULL	,	NULL	,	12000	--	VCasia	,	VCasiaSuperGBP
union select	7140071	,	152	,	NULL	,	3000	,	12000	--	VCasia	,	VCasiaSuperGBP
union select	7140071	,	153	,	NULL	,	3000	,	12000	--	VCasia	,	VCasiaSuperGBP
union select	7141027	,	151	,	NULL	,	NULL	,	128000	--	VCasia	,	VCasiaSuperRMB
union select	7141027	,	152	,	NULL	,	32000	,	128000	--	VCasia	,	VCasiaSuperRMB
union select	7141027	,	153	,	NULL	,	32000	,	128000	--	VCasia	,	VCasiaSuperRMB
union select	3752050	,	151	,	NULL	,	NULL	,	128000	--	mayfair	,	MFSuperRMB
union select	3752050	,	152	,	NULL	,	NULL	,	128000	--	mayfair	,	MFSuperRMB
union select	3752050	,	153	,	NULL	,	NULL	,	128000	--	mayfair	,	MFSuperRMB
union select	11387211	,	152	,	NULL	,	20000	,	NULL	--	VWin	,	VWinSuperRM
union select	11387211	,	153	,	NULL	,	20000	,	NULL	--	VWin	,	VWinSuperRM
union select	7596783	,	151	,	NULL	,	NULL	,	24000	--	VWin	,	VwinSuperUS$
union select	7596783	,	152	,	NULL	,	NULL	,	24000	--	VWin	,	VwinSuperUS$
union select	7596783	,	153	,	NULL	,	NULL	,	24000	--	VWin	,	VwinSuperUS$
union select	11387220	,	152	,	NULL	,	180000	,	NULL	--	VWin	,	VWinSuperTB
union select	11387220	,	153	,	NULL	,	180000	,	NULL	--	VWin	,	VWinSuperTB
union select	10380749	,	151	,	NULL	,	NULL	,	128000	--	VWin	,	VWINSuperRMB
union select	10380749	,	152	,	NULL	,	NULL	,	128000	--	VWin	,	VWINSuperRMB
union select	10380749	,	153	,	NULL	,	NULL	,	128000	--	VWin	,	VWINSuperRMB
union select	11387229	,	152	,	NULL	,	NULL	,	260000	--	VWin	,	VWinSuperIN
union select	11387229	,	153	,	NULL	,	NULL	,	260000	--	VWin	,	VWinSuperIN
union select	13461694	,	151	,	NULL	,	NULL	,	2000000	--	VWin	,	VwinSuperJPY
union select	13461694	,	152	,	NULL	,	500000	,	2000000	--	VWin	,	VwinSuperJPY
union select	13461694	,	153	,	NULL	,	500000	,	2000000	--	VWin	,	VwinSuperJPY
union select	13461733	,	151	,	NULL	,	NULL	,	24000000	--	VWin	,	VwinSuperWon
union select	13461733	,	152	,	NULL	,	6000000	,	24000000	--	VWin	,	VwinSuperWon
union select	13461733	,	153	,	NULL	,	6000000	,	24000000	--	VWin	,	VwinSuperWon
union select	11387238	,	151	,	150	,	NULL	,	NULL	--	VWin	,	VWinSuperINH
union select	10580795	,	152	,	NULL	,	20000	,	NULL	--	W88	,	W88SuperRM
union select	10580795	,	153	,	NULL	,	20000	,	NULL	--	W88	,	W88SuperRM
union select	10580805	,	151	,	NULL	,	NULL	,	24000	--	W88	,	W88SuperUS$
union select	10580805	,	152	,	NULL	,	6000	,	24000	--	W88	,	W88SuperUS$
union select	10580805	,	153	,	NULL	,	6000	,	24000	--	W88	,	W88SuperUS$
union select	10580767	,	151	,	NULL	,	NULL	,	720000	--	W88	,	W88SuperTB
union select	10580767	,	152	,	NULL	,	180000	,	720000	--	W88	,	W88SuperTB
union select	10580767	,	153	,	NULL	,	180000	,	720000	--	W88	,	W88SuperTB
union select	10580824	,	151	,	NULL	,	NULL	,	16000	--	W88	,	W88SuperEURO
union select	10580824	,	152	,	NULL	,	4000	,	16000	--	W88	,	W88SuperEURO
union select	10580824	,	153	,	NULL	,	4000	,	16000	--	W88	,	W88SuperEURO
union select	10580814	,	151	,	NULL	,	NULL	,	24000	--	W88	,	W88SuperAUD
union select	10580814	,	152	,	NULL	,	6000	,	24000	--	W88	,	W88SuperAUD
union select	10580814	,	153	,	NULL	,	6000	,	24000	--	W88	,	W88SuperAUD
union select	10580835	,	151	,	NULL	,	NULL	,	12000	--	W88	,	W88SuperGBP
union select	10580835	,	152	,	NULL	,	3000	,	12000	--	W88	,	W88SuperGBP
union select	10580835	,	153	,	NULL	,	3000	,	12000	--	W88	,	W88SuperGBP
union select	10580722	,	151	,	NULL	,	NULL	,	128000	--	W88	,	W88SuperRMB
union select	10580722	,	152	,	NULL	,	32000	,	128000	--	W88	,	W88SuperRMB
union select	10580722	,	153	,	NULL	,	32000	,	128000	--	W88	,	W88SuperRMB
union select	10580776	,	152	,	NULL	,	65000	,	NULL	--	W88	,	W88SuperIN
union select	10580776	,	153	,	NULL	,	65000	,	NULL	--	W88	,	W88SuperIN
union select	10580846	,	151	,	NULL	,	NULL	,	2000000	--	W88	,	W88SuperJPY
union select	10580846	,	152	,	NULL	,	500000	,	2000000	--	W88	,	W88SuperJPY
union select	10580846	,	153	,	NULL	,	500000	,	2000000	--	W88	,	W88SuperJPY
union select	12613176	,	151	,	7000	,	NULL	,	24000000	--	W88	,	W88SuperWON
union select	12613176	,	152	,	7000	,	6000000	,	24000000	--	W88	,	W88SuperWON
union select	12613176	,	153	,	7000	,	6000000	,	24000000	--	W88	,	W88SuperWON
union select	10580858	,	152	,	NULL	,	350000	,	NULL	--	W88	,	W88SuperINR
union select	10580858	,	153	,	NULL	,	350000	,	NULL	--	W88	,	W88SuperINR


DECLARE @srecommend INT, @max_custid INT, @sporttype INT, @minbet MONEY, @maxbet MONEY, @maxpermatch MONEY

SET @max_custid = xxx
	
WHILE(1=1)
BEGIN
	UPDATE TOP(1) #DepSettings
	SET @srecommend = custid,
		@sporttype = sporttype,
		@minbet = minbet,
		@maxbet = maxbet,
		@maxpermatch = maxpermatch,
		isfinished = 1
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
		,@sporttype = @sporttype
		,@minbet = @minbet
		,@maxbet = @maxbet
		,@maxpermatch = @maxpermatch		
		,@maxcustid = @max_custid
		,@target = 'REPLICATED'
END		

GO
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
---

---
---
-- BEGIN STEP 3:  RUN THIS SCRIPT AT DBTRANS -----
--------------------------------------------------------------------------------------
CREATE TABLE #DepSettings(Custid INT , sporttype INT, minbet MONEY, maxbet MONEY, maxpermatch MONEY, isfinished bit default(0))

INSERT INTO #depSettings(custid, sporttype, minbet, maxbet, maxpermatch)
		 select	1752415	,	151	,	NULL	,	NULL	,	28000	--	12Bet	,	12BETSuperSD$
union select	1752415	,	152	,	NULL	,	7000	,	28000	--	12Bet	,	12BETSuperSD$
union select	1752415	,	153	,	NULL	,	7000	,	28000	--	12Bet	,	12BETSuperSD$
union select	836218	,	152	,	NULL	,	20000	,	NULL	--	12Bet	,	12BETSuperRM
union select	836218	,	153	,	NULL	,	20000	,	NULL	--	12Bet	,	12BETSuperRM
union select	791080	,	151	,	NULL	,	NULL	,	24000	--	12Bet	,	12BETSuperUS$
union select	791080	,	152	,	NULL	,	6000	,	24000	--	12Bet	,	12BETSuperUS$
union select	791080	,	153	,	NULL	,	6000	,	24000	--	12Bet	,	12BETSuperUS$
union select	836203	,	151	,	NULL	,	NULL	,	720000	--	12Bet	,	12BETSuperTB
union select	836203	,	152	,	NULL	,	180000	,	720000	--	12Bet	,	12BETSuperTB
union select	836203	,	153	,	NULL	,	180000	,	720000	--	12Bet	,	12BETSuperTB
union select	791081	,	151	,	NULL	,	NULL	,	16000	--	12Bet	,	12BETSuperEURO
union select	791081	,	152	,	NULL	,	4000	,	16000	--	12Bet	,	12BETSuperEURO
union select	791081	,	153	,	NULL	,	4000	,	16000	--	12Bet	,	12BETSuperEURO
union select	1015419	,	151	,	NULL	,	NULL	,	24000	--	12Bet	,	12BETSuperAUD
union select	1015419	,	152	,	NULL	,	6000	,	24000	--	12Bet	,	12BETSuperAUD
union select	1015419	,	153	,	NULL	,	6000	,	24000	--	12Bet	,	12BETSuperAUD
union select	836212	,	151	,	NULL	,	NULL	,	12000	--	12Bet	,	12BETSuperGBP
union select	836212	,	152	,	NULL	,	3000	,	12000	--	12Bet	,	12BETSuperGBP
union select	836212	,	153	,	NULL	,	3000	,	12000	--	12Bet	,	12BETSuperGBP
union select	836226	,	151	,	NULL	,	NULL	,	128000	--	12Bet	,	12BETSuperRMB
union select	836226	,	152	,	NULL	,	32000	,	128000	--	12Bet	,	12BETSuperRMB
union select	836226	,	153	,	NULL	,	32000	,	128000	--	12Bet	,	12BETSuperRMB
union select	1813575	,	152	,	NULL	,	65000	,	NULL	--	12Bet	,	12BETSuperIN
union select	1813575	,	153	,	NULL	,	65000	,	NULL	--	12Bet	,	12BETSuperIN
union select	6006478	,	151	,	NULL	,	NULL	,	2000000	--	12Bet	,	12BETSuperJPY
union select	6006478	,	152	,	NULL	,	500000	,	2000000	--	12Bet	,	12BETSuperJPY
union select	6006478	,	153	,	NULL	,	500000	,	2000000	--	12Bet	,	12BETSuperJPY
union select	1015427	,	152	,	NULL	,	5000	,	NULL	--	12Bet	,	12BETSuperCHF
union select	1015427	,	153	,	NULL	,	5000	,	NULL	--	12Bet	,	12BETSuperCHF
union select	6006276	,	151	,	NULL	,	NULL	,	24000000	--	12Bet	,	12BETSuperWON
union select	6006276	,	152	,	NULL	,	6000000	,	24000000	--	12Bet	,	12BETSuperWON
union select	6006276	,	153	,	NULL	,	6000000	,	24000000	--	12Bet	,	12BETSuperWON
union select	6006409	,	152	,	NULL	,	350000	,	NULL	--	12Bet	,	12BETSuperINR
union select	6006409	,	153	,	NULL	,	350000	,	NULL	--	12Bet	,	12BETSuperINR
union select	2747862	,	151	,	NULL	,	NULL	,	28000	--	alog	,	ALogSuperSD$
union select	2747862	,	152	,	NULL	,	7000	,	28000	--	alog	,	ALogSuperSD$
union select	2747862	,	153	,	NULL	,	7000	,	28000	--	alog	,	ALogSuperSD$
union select	2747736	,	152	,	NULL	,	20000	,	80000	--	alog	,	ALogSuperRM
union select	2747736	,	153	,	NULL	,	20000	,	80000	--	alog	,	ALogSuperRM
union select	2308796	,	151	,	NULL	,	NULL	,	24000	--	alog	,	ALogSuperUS$
union select	2308796	,	152	,	NULL	,	6000	,	24000	--	alog	,	ALogSuperUS$
union select	2308796	,	153	,	NULL	,	6000	,	24000	--	alog	,	ALogSuperUS$
union select	2747989	,	151	,	NULL	,	NULL	,	720000	--	alog	,	ALogSuperTB
union select	2747989	,	152	,	NULL	,	180000	,	720000	--	alog	,	ALogSuperTB
union select	2747989	,	153	,	NULL	,	180000	,	720000	--	alog	,	ALogSuperTB
union select	3114255	,	151	,	NULL	,	NULL	,	16000	--	alog	,	AlogSuperEURO
union select	3114255	,	152	,	NULL	,	4000	,	16000	--	alog	,	AlogSuperEURO
union select	3114255	,	153	,	NULL	,	4000	,	16000	--	alog	,	AlogSuperEURO
union select	2308771	,	151	,	NULL	,	NULL	,	12000	--	alog	,	ALogSuperGBP
union select	2308771	,	152	,	NULL	,	3000	,	12000	--	alog	,	ALogSuperGBP
union select	2308771	,	153	,	NULL	,	3000	,	12000	--	alog	,	ALogSuperGBP
union select	2308841	,	151	,	NULL	,	NULL	,	128000	--	alog	,	ALogSuperRMB
union select	2308841	,	152	,	NULL	,	32000	,	128000	--	alog	,	ALogSuperRMB
union select	2308841	,	153	,	NULL	,	32000	,	128000	--	alog	,	ALogSuperRMB
union select	3782799	,	151	,	100	,	NULL	,	NULL	--	alog	,	AlogSuperIN
union select	3782799	,	152	,	50	,	NULL	,	NULL	--	alog	,	AlogSuperIN
union select	3782799	,	153	,	50	,	NULL	,	NULL	--	alog	,	AlogSuperIN
union select	3417070	,	152	,	NULL	,	120000	,	480000	--	alog	,	AlogSuperINH
union select	3417070	,	153	,	NULL	,	120000	,	480000	--	alog	,	AlogSuperINH
union select	6618394	,	151	,	NULL	,	NULL	,	64000	--	alog	,	AlogSuperPLN
union select	6618394	,	152	,	NULL	,	16000	,	64000	--	alog	,	AlogSuperPLN
union select	6618394	,	153	,	NULL	,	16000	,	64000	--	alog	,	AlogSuperPLN
union select	6092487	,	151	,	NULL	,	NULL	,	1400000	--	alog	,	AlogSuperINR
union select	6092487	,	152	,	NULL	,	350000	,	1400000	--	alog	,	AlogSuperINR
union select	6092487	,	153	,	NULL	,	350000	,	1400000	--	alog	,	AlogSuperINR
union select	1004374	,	151	,	NULL	,	NULL	,	28000	--	asiabet88	,	AB88SuperSD$
union select	1004374	,	152	,	NULL	,	7000	,	28000	--	asiabet88	,	AB88SuperSD$
union select	1004374	,	153	,	NULL	,	7000	,	28000	--	asiabet88	,	AB88SuperSD$
union select	932209	,	152	,	NULL	,	20000	,	NULL	--	asiabet88	,	AB88SuperRM
union select	932209	,	153	,	NULL	,	20000	,	NULL	--	asiabet88	,	AB88SuperRM
union select	932063	,	151	,	NULL	,	NULL	,	24000	--	asiabet88	,	AB88SuperUS$
union select	932063	,	152	,	NULL	,	6000	,	24000	--	asiabet88	,	AB88SuperUS$
union select	932063	,	153	,	NULL	,	6000	,	24000	--	asiabet88	,	AB88SuperUS$
union select	932181	,	151	,	300	,	NULL	,	720000	--	asiabet88	,	AB88SuperTB
union select	932181	,	152	,	NULL	,	180000	,	720000	--	asiabet88	,	AB88SuperTB
union select	932181	,	153	,	NULL	,	180000	,	720000	--	asiabet88	,	AB88SuperTB
union select	932167	,	151	,	NULL	,	NULL	,	16000	--	asiabet88	,	AB88SuperEURO
union select	932167	,	152	,	NULL	,	4000	,	16000	--	asiabet88	,	AB88SuperEURO
union select	932167	,	153	,	NULL	,	4000	,	16000	--	asiabet88	,	AB88SuperEURO
union select	932188	,	151	,	NULL	,	NULL	,	12000	--	asiabet88	,	AB88SuperGBP
union select	932188	,	152	,	NULL	,	3000	,	12000	--	asiabet88	,	AB88SuperGBP
union select	932188	,	153	,	NULL	,	3000	,	12000	--	asiabet88	,	AB88SuperGBP
union select	932253	,	151	,	NULL	,	NULL	,	128000	--	asiabet88	,	AB88SuperRMB
union select	932253	,	152	,	NULL	,	32000	,	128000	--	asiabet88	,	AB88SuperRMB
union select	932253	,	153	,	NULL	,	32000	,	128000	--	asiabet88	,	AB88SuperRMB
union select	2564717	,	152	,	NULL	,	65000	,	NULL	--	asiabet88	,	AB88SuperIN
union select	2564717	,	153	,	NULL	,	65000	,	NULL	--	asiabet88	,	AB88SuperIN
union select	14131319	,	151	,	7000	,	NULL	,	NULL	--	asiabet88	,	asiabet88SuperWon
union select	14131319	,	152	,	7000	,	NULL	,	NULL	--	asiabet88	,	asiabet88SuperWon
union select	14131319	,	153	,	7000	,	NULL	,	NULL	--	asiabet88	,	asiabet88SuperWon
union select	4833492	,	151	,	150	,	NULL	,	NULL	--	asiabet88	,	AB88SuperINH
union select	4833492	,	152	,	70	,	NULL	,	NULL	--	asiabet88	,	AB88SuperINH
union select	4833492	,	153	,	70	,	NULL	,	NULL	--	asiabet88	,	AB88SuperINH
union select	4689517	,	152	,	NULL	,	7000	,	NULL	--	Bodog	,	BODOGSuperSD$
union select	4689517	,	153	,	NULL	,	7000	,	NULL	--	Bodog	,	BODOGSuperSD$
union select	4714272	,	152	,	NULL	,	20000	,	NULL	--	Bodog	,	BODOGSuperRM
union select	4714272	,	153	,	NULL	,	20000	,	NULL	--	Bodog	,	BODOGSuperRM
union select	4686903	,	152	,	NULL	,	6000	,	NULL	--	Bodog	,	BODOGSuperUS$
union select	4686903	,	153	,	NULL	,	6000	,	NULL	--	Bodog	,	BODOGSuperUS$
union select	4689166	,	152	,	NULL	,	180000	,	NULL	--	Bodog	,	BODOGSuperTB
union select	4689166	,	153	,	NULL	,	180000	,	NULL	--	Bodog	,	BODOGSuperTB
union select	4715142	,	152	,	NULL	,	4000	,	NULL	--	Bodog	,	BODOGSuperEURO
union select	4715142	,	153	,	NULL	,	4000	,	NULL	--	Bodog	,	BODOGSuperEURO
union select	7651889	,	152	,	NULL	,	6000	,	NULL	--	Bodog	,	BODOGSuperAUD
union select	7651889	,	153	,	NULL	,	6000	,	NULL	--	Bodog	,	BODOGSuperAUD
union select	4715061	,	152	,	NULL	,	3000	,	NULL	--	Bodog	,	BODOGSuperGBP
union select	4715061	,	153	,	NULL	,	3000	,	NULL	--	Bodog	,	BODOGSuperGBP
union select	4688739	,	152	,	NULL	,	32000	,	NULL	--	Bodog	,	BODOGSuperRMB
union select	4688739	,	153	,	NULL	,	32000	,	NULL	--	Bodog	,	BODOGSuperRMB
union select	4715507	,	152	,	NULL	,	6000000	,	NULL	--	Bodog	,	BODOGSuperWON
union select	4715507	,	153	,	NULL	,	6000000	,	NULL	--	Bodog	,	BODOGSuperWON
union select	8198572	,	151	,	NULL	,	NULL	,	480000	--	Bodog	,	BODOGSuperINH
union select	8198572	,	152	,	NULL	,	120000	,	480000	--	Bodog	,	BODOGSuperINH
union select	8198572	,	153	,	NULL	,	120000	,	480000	--	Bodog	,	BODOGSuperINH
union select	12910607	,	151	,	50	,	NULL	,	128000	--	Boma365	,	Boma365SuperRMB
union select	12910607	,	152	,	30	,	32000	,	128000	--	Boma365	,	Boma365SuperRMB
union select	12910607	,	153	,	30	,	32000	,	128000	--	Boma365	,	Boma365SuperRMB
union select	13853422	,	151	,	50	,	NULL	,	NULL	--	Happy1668	,	Happy1668SuperRMB
union select	13853422	,	152	,	30	,	NULL	,	NULL	--	Happy1668	,	Happy1668SuperRMB
union select	13853422	,	153	,	30	,	NULL	,	NULL	--	Happy1668	,	Happy1668SuperRMB
union select	13626157	,	151	,	NULL	,	NULL	,	128000	--	Hengcai88	,	Hengcai88SuperRMB
union select	13626157	,	152	,	NULL	,	32000	,	128000	--	Hengcai88	,	Hengcai88SuperRMB
union select	13626157	,	153	,	NULL	,	32000	,	128000	--	Hengcai88	,	Hengcai88SuperRMB
union select	1574036	,	152	,	NULL	,	7000	,	28000	--	mansion88	,	MS88SuperSD$
union select	1574036	,	153	,	NULL	,	7000	,	28000	--	mansion88	,	MS88SuperSD$
union select	1574028	,	152	,	NULL	,	20000	,	NULL	--	mansion88	,	MS88SuperRM
union select	1574028	,	153	,	NULL	,	20000	,	NULL	--	mansion88	,	MS88SuperRM
union select	1573954	,	152	,	NULL	,	6000	,	24000	--	mansion88	,	MS88SuperUS$
union select	1573954	,	153	,	NULL	,	6000	,	24000	--	mansion88	,	MS88SuperUS$
union select	1573967	,	152	,	NULL	,	180000	,	720000	--	mansion88	,	MS88SuperTB
union select	1573967	,	153	,	NULL	,	180000	,	720000	--	mansion88	,	MS88SuperTB
union select	1574024	,	151	,	50	,	NULL	,	NULL	--	mansion88	,	MS88SuperHK$
union select	1574024	,	152	,	NULL	,	40000	,	NULL	--	mansion88	,	MS88SuperHK$
union select	1574024	,	153	,	NULL	,	40000	,	NULL	--	mansion88	,	MS88SuperHK$
union select	1573960	,	152	,	NULL	,	4000	,	16000	--	mansion88	,	MS88SuperEURO
union select	1573960	,	153	,	NULL	,	4000	,	16000	--	mansion88	,	MS88SuperEURO
union select	1574016	,	151	,	NULL	,	NULL	,	24000	--	mansion88	,	MS88SuperAUD
union select	1574016	,	152	,	NULL	,	6000	,	24000	--	mansion88	,	MS88SuperAUD
union select	1574016	,	153	,	NULL	,	6000	,	24000	--	mansion88	,	MS88SuperAUD
union select	1573975	,	151	,	NULL	,	NULL	,	12000	--	mansion88	,	MS88SuperGBP
union select	1573975	,	152	,	NULL	,	3000	,	12000	--	mansion88	,	MS88SuperGBP
union select	1573975	,	153	,	NULL	,	3000	,	12000	--	mansion88	,	MS88SuperGBP
union select	1574008	,	152	,	NULL	,	32000	,	128000	--	mansion88	,	MS88SuperRMB
union select	1574008	,	153	,	NULL	,	32000	,	128000	--	mansion88	,	MS88SuperRMB
union select	1574102	,	152	,	NULL	,	65000	,	NULL	--	mansion88	,	MS88SuperIN
union select	1574102	,	153	,	NULL	,	65000	,	NULL	--	mansion88	,	MS88SuperIN
union select	2397872	,	152	,	NULL	,	500000	,	NULL	--	mansion88	,	MS88SuperJPY
union select	2397872	,	153	,	NULL	,	500000	,	NULL	--	mansion88	,	MS88SuperJPY
union select	2397885	,	151	,	NULL	,	NULL	,	24000000	--	mansion88	,	MS88SuperWON
union select	2397885	,	152	,	NULL	,	6000000	,	24000000	--	mansion88	,	MS88SuperWON
union select	2397885	,	153	,	NULL	,	6000000	,	24000000	--	mansion88	,	MS88SuperWON
union select	1574083	,	151	,	NULL	,	NULL	,	28000	--	mansion88	,	MS88SuperBND
union select	1574083	,	152	,	NULL	,	7000	,	28000	--	mansion88	,	MS88SuperBND
union select	1574083	,	153	,	NULL	,	7000	,	28000	--	mansion88	,	MS88SuperBND
union select	13105568	,	151	,	NULL	,	NULL	,	128000	--	Salon365	,	Salon365SuperRMB
union select	13105568	,	152	,	NULL	,	32000	,	128000	--	Salon365	,	Salon365SuperRMB
union select	13105568	,	153	,	NULL	,	32000	,	128000	--	Salon365	,	Salon365SuperRMB
union select	13105479	,	151	,	NULL	,	NULL	,	128000	--	Saloncs	,	SaloncsSuperRMB
union select	13105479	,	152	,	NULL	,	32000	,	128000	--	Saloncs	,	SaloncsSuperRMB
union select	13105479	,	153	,	NULL	,	32000	,	128000	--	Saloncs	,	SaloncsSuperRMB
union select	7140934	,	151	,	NULL	,	NULL	,	28000	--	VCasia	,	VCasiaSuperSD$
union select	7140934	,	152	,	NULL	,	7000	,	28000	--	VCasia	,	VCasiaSuperSD$
union select	7140934	,	153	,	NULL	,	7000	,	28000	--	VCasia	,	VCasiaSuperSD$
union select	7140747	,	151	,	NULL	,	NULL	,	24000	--	VCasia	,	VcasiaSuperUS$
union select	7140747	,	152	,	NULL	,	6000	,	24000	--	VCasia	,	VcasiaSuperUS$
union select	7140747	,	153	,	NULL	,	6000	,	24000	--	VCasia	,	VcasiaSuperUS$
union select	7140648	,	151	,	NULL	,	NULL	,	16000	--	VCasia	,	VCasiaSuperEuro
union select	7140648	,	152	,	NULL	,	4000	,	16000	--	VCasia	,	VCasiaSuperEuro
union select	7140648	,	153	,	NULL	,	4000	,	16000	--	VCasia	,	VCasiaSuperEuro
union select	7140807	,	151	,	NULL	,	NULL	,	24000	--	VCasia	,	VCasiaSuperAUD
union select	7140807	,	152	,	NULL	,	6000	,	24000	--	VCasia	,	VCasiaSuperAUD
union select	7140807	,	153	,	NULL	,	6000	,	24000	--	VCasia	,	VCasiaSuperAUD
union select	7140071	,	151	,	NULL	,	NULL	,	12000	--	VCasia	,	VCasiaSuperGBP
union select	7140071	,	152	,	NULL	,	3000	,	12000	--	VCasia	,	VCasiaSuperGBP
union select	7140071	,	153	,	NULL	,	3000	,	12000	--	VCasia	,	VCasiaSuperGBP
union select	7141027	,	151	,	NULL	,	NULL	,	128000	--	VCasia	,	VCasiaSuperRMB
union select	7141027	,	152	,	NULL	,	32000	,	128000	--	VCasia	,	VCasiaSuperRMB
union select	7141027	,	153	,	NULL	,	32000	,	128000	--	VCasia	,	VCasiaSuperRMB
union select	3752050	,	151	,	NULL	,	NULL	,	128000	--	mayfair	,	MFSuperRMB
union select	3752050	,	152	,	NULL	,	NULL	,	128000	--	mayfair	,	MFSuperRMB
union select	3752050	,	153	,	NULL	,	NULL	,	128000	--	mayfair	,	MFSuperRMB
union select	11387211	,	152	,	NULL	,	20000	,	NULL	--	VWin	,	VWinSuperRM
union select	11387211	,	153	,	NULL	,	20000	,	NULL	--	VWin	,	VWinSuperRM
union select	7596783	,	151	,	NULL	,	NULL	,	24000	--	VWin	,	VwinSuperUS$
union select	7596783	,	152	,	NULL	,	NULL	,	24000	--	VWin	,	VwinSuperUS$
union select	7596783	,	153	,	NULL	,	NULL	,	24000	--	VWin	,	VwinSuperUS$
union select	11387220	,	152	,	NULL	,	180000	,	NULL	--	VWin	,	VWinSuperTB
union select	11387220	,	153	,	NULL	,	180000	,	NULL	--	VWin	,	VWinSuperTB
union select	10380749	,	151	,	NULL	,	NULL	,	128000	--	VWin	,	VWINSuperRMB
union select	10380749	,	152	,	NULL	,	NULL	,	128000	--	VWin	,	VWINSuperRMB
union select	10380749	,	153	,	NULL	,	NULL	,	128000	--	VWin	,	VWINSuperRMB
union select	11387229	,	152	,	NULL	,	NULL	,	260000	--	VWin	,	VWinSuperIN
union select	11387229	,	153	,	NULL	,	NULL	,	260000	--	VWin	,	VWinSuperIN
union select	13461694	,	151	,	NULL	,	NULL	,	2000000	--	VWin	,	VwinSuperJPY
union select	13461694	,	152	,	NULL	,	500000	,	2000000	--	VWin	,	VwinSuperJPY
union select	13461694	,	153	,	NULL	,	500000	,	2000000	--	VWin	,	VwinSuperJPY
union select	13461733	,	151	,	NULL	,	NULL	,	24000000	--	VWin	,	VwinSuperWon
union select	13461733	,	152	,	NULL	,	6000000	,	24000000	--	VWin	,	VwinSuperWon
union select	13461733	,	153	,	NULL	,	6000000	,	24000000	--	VWin	,	VwinSuperWon
union select	11387238	,	151	,	150	,	NULL	,	NULL	--	VWin	,	VWinSuperINH
union select	10580795	,	152	,	NULL	,	20000	,	NULL	--	W88	,	W88SuperRM
union select	10580795	,	153	,	NULL	,	20000	,	NULL	--	W88	,	W88SuperRM
union select	10580805	,	151	,	NULL	,	NULL	,	24000	--	W88	,	W88SuperUS$
union select	10580805	,	152	,	NULL	,	6000	,	24000	--	W88	,	W88SuperUS$
union select	10580805	,	153	,	NULL	,	6000	,	24000	--	W88	,	W88SuperUS$
union select	10580767	,	151	,	NULL	,	NULL	,	720000	--	W88	,	W88SuperTB
union select	10580767	,	152	,	NULL	,	180000	,	720000	--	W88	,	W88SuperTB
union select	10580767	,	153	,	NULL	,	180000	,	720000	--	W88	,	W88SuperTB
union select	10580824	,	151	,	NULL	,	NULL	,	16000	--	W88	,	W88SuperEURO
union select	10580824	,	152	,	NULL	,	4000	,	16000	--	W88	,	W88SuperEURO
union select	10580824	,	153	,	NULL	,	4000	,	16000	--	W88	,	W88SuperEURO
union select	10580814	,	151	,	NULL	,	NULL	,	24000	--	W88	,	W88SuperAUD
union select	10580814	,	152	,	NULL	,	6000	,	24000	--	W88	,	W88SuperAUD
union select	10580814	,	153	,	NULL	,	6000	,	24000	--	W88	,	W88SuperAUD
union select	10580835	,	151	,	NULL	,	NULL	,	12000	--	W88	,	W88SuperGBP
union select	10580835	,	152	,	NULL	,	3000	,	12000	--	W88	,	W88SuperGBP
union select	10580835	,	153	,	NULL	,	3000	,	12000	--	W88	,	W88SuperGBP
union select	10580722	,	151	,	NULL	,	NULL	,	128000	--	W88	,	W88SuperRMB
union select	10580722	,	152	,	NULL	,	32000	,	128000	--	W88	,	W88SuperRMB
union select	10580722	,	153	,	NULL	,	32000	,	128000	--	W88	,	W88SuperRMB
union select	10580776	,	152	,	NULL	,	65000	,	NULL	--	W88	,	W88SuperIN
union select	10580776	,	153	,	NULL	,	65000	,	NULL	--	W88	,	W88SuperIN
union select	10580846	,	151	,	NULL	,	NULL	,	2000000	--	W88	,	W88SuperJPY
union select	10580846	,	152	,	NULL	,	500000	,	2000000	--	W88	,	W88SuperJPY
union select	10580846	,	153	,	NULL	,	500000	,	2000000	--	W88	,	W88SuperJPY
union select	12613176	,	151	,	7000	,	NULL	,	24000000	--	W88	,	W88SuperWON
union select	12613176	,	152	,	7000	,	6000000	,	24000000	--	W88	,	W88SuperWON
union select	12613176	,	153	,	7000	,	6000000	,	24000000	--	W88	,	W88SuperWON
union select	10580858	,	152	,	NULL	,	350000	,	NULL	--	W88	,	W88SuperINR
union select	10580858	,	153	,	NULL	,	350000	,	NULL	--	W88	,	W88SuperINR


DECLARE @srecommend INT, @max_custid INT, @sporttype INT, @minbet MONEY, @maxbet MONEY, @maxpermatch MONEY

SET @max_custid = xxx
	
WHILE(1=1)
BEGIN
	UPDATE TOP(1) #DepSettings
	SET @srecommend = custid,
		@sporttype = sporttype,
		@minbet = minbet,
		@maxbet = maxbet,
		@maxpermatch = maxpermatch,
		isfinished = 1
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
		,@sporttype = @sporttype
		,@minbet = @minbet
		,@maxbet = @maxbet
		,@maxpermatch = @maxpermatch		
		,@maxcustid = @max_custid
		,@target = 'DBTRANS'
END		
GO
-- END STEP 3: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
