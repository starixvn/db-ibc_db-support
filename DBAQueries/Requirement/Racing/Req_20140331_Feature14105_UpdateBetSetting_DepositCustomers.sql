  /*
	Created: Johnson
	Date: 2014-03-31
	Task: Update racing bet setting for deposit customers
	DB: DBTXN/CustDB
 */
 
 
-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
 
 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]	
	@srecommend INT,
	@sporttype INT,
	@bettype INT,
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
	
	IF @sporttype = 151 -- horse racing
	BEGIN
		IF @bettype = 31--SA
		BEGIN
			UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
			SET maxpermatch151 = @maxpermatch			
			WHERE srecommend = @srecommend
				AND custid <= @maxcustid
		END
		ELSE IF @bettype = 41--UK
		BEGIN
			UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
			SET maxpermatch151_OT = @maxpermatch			
			WHERE srecommend = @srecommend
				AND custid <= @maxcustid
		END
		ELSE IF @bettype = 51--AUST
		BEGIN
			UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
			SET maxpermatch151_AU = @maxpermatch			
			WHERE srecommend = @srecommend
				AND custid <= @maxcustid
		END
	END
	ELSE IF @sporttype = 152 -- Greyhounds
	BEGIN
		IF @bettype = 41
		BEGIN
			UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
			SET	MaxPerMatch152_UK = @maxpermatch
			WHERE srecommend = @srecommend
				AND custid <= @maxcustid
		END
		ELSE IF @bettype = 51
		BEGIN
			UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
			SET	MaxPerMatch152_AU = @maxpermatch
			WHERE srecommend = @srecommend
				AND custid <= @maxcustid
		END
	END
	ELSE IF @sporttype = 153-- Harness
	BEGIN
		UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
		SET	MaxPerMatch153_AU = @maxpermatch
		WHERE srecommend = @srecommend
			AND custid <= @maxcustid
	END
	
	IF (SELECT COUNT(1)
	FROM sys.objects
	WHERE NAME IN ('Dep_custsetting3rd') AND type = 'U'
	) <> 1 RETURN
	
	IF @sporttype = 151-- Horse racing
	BEGIN
		IF @bettype = 31--SA
		BEGIN
			UPDATE cs
			SET minbet = @minbet,
				maxbet = @maxbet
			FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
				INNER JOIN CustInfo ci WITH(NOLOCK) ON ci.custid = cs.custid
			WHERE ci.srecommend = @srecommend
				AND cs.sporttype = 151
				AND cs.bettype IN (31,32)
				AND ci.custid <= @maxcustid
		END
		ELSE IF @bettype = 41--UK
		BEGIN
			UPDATE cs
			SET minbet = @minbet,
				maxbet = @maxbet
			FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
				INNER JOIN CustInfo ci WITH(NOLOCK) ON ci.custid = cs.custid
			WHERE ci.srecommend = @srecommend
				AND cs.sporttype = 151
				AND cs.bettype IN (41,42)
				AND ci.custid <= @maxcustid
		END
		ELSE IF @bettype = 51--AUST
		BEGIN
			UPDATE cs
			SET minbet = @minbet,
				maxbet = @maxbet
			FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
				INNER JOIN CustInfo ci WITH(NOLOCK) ON ci.custid = cs.custid
			WHERE ci.srecommend = @srecommend
				AND cs.sporttype = 151
				AND cs.bettype IN (51,52)
				AND ci.custid <= @maxcustid
		END
	END	
	ELSE IF @sporttype = 152--Greyhounds
	BEGIN
		IF @bettype = 41--UK
		BEGIN
			UPDATE cs
			SET minbet = @minbet,
				maxbet = @maxbet
			FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
				INNER JOIN CustInfo ci WITH(NOLOCK) ON ci.custid = cs.custid
			WHERE ci.srecommend = @srecommend
				AND cs.sporttype = 152
				AND cs.bettype IN (41,42)
				AND ci.custid <= @maxcustid
		END
		ELSE IF @bettype = 51--AUST
		BEGIN
			UPDATE cs
			SET minbet = @minbet,
				maxbet = @maxbet
			FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
				INNER JOIN CustInfo ci WITH(NOLOCK) ON ci.custid = cs.custid
			WHERE ci.srecommend = @srecommend
				AND cs.sporttype = 152
				AND cs.bettype IN (51,52)
				AND ci.custid <= @maxcustid
		END
	END
	ELSE IF @sporttype = 153--Harness
	BEGIN
		UPDATE cs
		SET minbet = @minbet,
			maxbet = @maxbet
		FROM Dep_CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
			INNER JOIN CustInfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		WHERE ci.srecommend = @srecommend
			AND cs.sporttype = 153
			AND cs.bettype IN (51,52)
			AND ci.custid <= @maxcustid
	END
END
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
CREATE TABLE #DepSettings(Custid INT, sporttype INT, bettype INT, minbet MONEY, maxbet MONEY, maxpermatch MONEY, isfinished bit default(0))

INSERT INTO #DepSettings(custid, sporttype, bettype, minbet, maxbet, maxpermatch)
			select	1752415	,	151	,	31	,	10	,	1500	,	30000	--	12BETSuperSD$
union all select	1752415	,	151	,	41	,	10	,	1500	,	40000	--	12BETSuperSD$
union all select	1752415	,	151	,	51	,	10	,	1500	,	40000	--	12BETSuperSD$
union all select	1752415	,	152	,	41	,	10	,	20000	,	40000	--	12BETSuperSD$
union all select	1752415	,	152	,	51	,	10	,	20000	,	40000	--	12BETSuperSD$
union all select	1752415	,	153	,	51	,	10	,	20000	,	40000	--	12BETSuperSD$
union all select	836218	,	151	,	31	,	30	,	4000	,	80000	--	12BETSuperRM
union all select	836218	,	151	,	41	,	30	,	4000	,	80000	--	12BETSuperRM
union all select	836218	,	151	,	51	,	30	,	4000	,	80000	--	12BETSuperRM
union all select	836218	,	152	,	41	,	30	,	40000	,	80000	--	12BETSuperRM
union all select	836218	,	152	,	51	,	30	,	40000	,	80000	--	12BETSuperRM
union all select	836218	,	153	,	51	,	30	,	40000	,	80000	--	12BETSuperRM
union all select	791080	,	151	,	31	,	10	,	1200	,	30000	--	12BETSuperUS$
union all select	791080	,	151	,	41	,	10	,	1200	,	30000	--	12BETSuperUS$
union all select	791080	,	151	,	51	,	10	,	1200	,	30000	--	12BETSuperUS$
union all select	791080	,	152	,	41	,	10	,	15000	,	30000	--	12BETSuperUS$
union all select	791080	,	152	,	51	,	10	,	15000	,	30000	--	12BETSuperUS$
union all select	791080	,	153	,	51	,	10	,	15000	,	30000	--	12BETSuperUS$
union all select	836203	,	151	,	31	,	300	,	40000	,	800000	--	12BETSuperTB
union all select	836203	,	151	,	41	,	300	,	40000	,	800000	--	12BETSuperTB
union all select	836203	,	151	,	51	,	300	,	40000	,	800000	--	12BETSuperTB
union all select	836203	,	152	,	41	,	300	,	400000	,	800000	--	12BETSuperTB
union all select	836203	,	152	,	51	,	300	,	400000	,	800000	--	12BETSuperTB
union all select	836203	,	153	,	51	,	300	,	400000	,	800000	--	12BETSuperTB
union all select	7526048	,	151	,	31	,	0	,	10000	,	0	--	12BETSuperHK$
union all select	7526048	,	151	,	41	,	10	,	10000	,	30000	--	12BETSuperHK$
union all select	7526048	,	151	,	51	,	0	,	10000	,	0	--	12BETSuperHK$
union all select	7526048	,	152	,	41	,	10	,	15000	,	30000	--	12BETSuperHK$
union all select	7526048	,	152	,	51	,	0	,	0	,	0	--	12BETSuperHK$
union all select	7526048	,	153	,	51	,	0	,	0	,	0	--	12BETSuperHK$
union all select	791081	,	151	,	31	,	10	,	1000	,	20000	--	12BETSuperEURO
union all select	791081	,	151	,	41	,	10	,	1000	,	20000	--	12BETSuperEURO
union all select	791081	,	151	,	51	,	10	,	1000	,	20000	--	12BETSuperEURO
union all select	791081	,	152	,	41	,	10	,	10000	,	20000	--	12BETSuperEURO
union all select	791081	,	152	,	51	,	10	,	10000	,	20000	--	12BETSuperEURO
union all select	791081	,	153	,	51	,	10	,	10000	,	20000	--	12BETSuperEURO
union all select	1015419	,	151	,	31	,	5	,	1400	,	30000	--	12BETSuperAUD
union all select	1015419	,	151	,	41	,	10	,	1400	,	30000	--	12BETSuperAUD
union all select	1015419	,	151	,	51	,	5	,	1400	,	30000	--	12BETSuperAUD
union all select	1015419	,	152	,	41	,	10	,	15000	,	30000	--	12BETSuperAUD
union all select	1015419	,	152	,	51	,	5	,	15000	,	30000	--	12BETSuperAUD
union all select	1015419	,	153	,	51	,	5	,	15000	,	30000	--	12BETSuperAUD
union all select	836212	,	151	,	31	,	10	,	800	,	20000	--	12BETSuperGBP
union all select	836212	,	151	,	41	,	10	,	800	,	20000	--	12BETSuperGBP
union all select	836212	,	151	,	51	,	10	,	800	,	20000	--	12BETSuperGBP
union all select	836212	,	152	,	41	,	10	,	10000	,	20000	--	12BETSuperGBP
union all select	836212	,	152	,	51	,	10	,	10000	,	20000	--	12BETSuperGBP
union all select	836212	,	153	,	51	,	10	,	10000	,	20000	--	12BETSuperGBP
union all select	836226	,	151	,	31	,	50	,	7000	,	160000	--	12BETSuperRMB
union all select	836226	,	151	,	41	,	50	,	7000	,	160000	--	12BETSuperRMB
union all select	836226	,	151	,	51	,	50	,	7000	,	160000	--	12BETSuperRMB
union all select	836226	,	152	,	41	,	50	,	80000	,	160000	--	12BETSuperRMB
union all select	836226	,	152	,	51	,	50	,	80000	,	160000	--	12BETSuperRMB
union all select	836226	,	153	,	51	,	50	,	80000	,	160000	--	12BETSuperRMB
union all select	1813575	,	151	,	31	,	50	,	12000	,	240000	--	12BETSuperIN
union all select	1813575	,	151	,	41	,	100	,	12000	,	240000	--	12BETSuperIN
union all select	1813575	,	151	,	51	,	50	,	12000	,	240000	--	12BETSuperIN
union all select	1813575	,	152	,	41	,	100	,	120000	,	240000	--	12BETSuperIN
union all select	1813575	,	152	,	51	,	50	,	120000	,	240000	--	12BETSuperIN
union all select	1813575	,	153	,	51	,	50	,	120000	,	240000	--	12BETSuperIN
union all select	916498	,	151	,	31	,	10	,	500	,	1500	--	12BETSuperUUS
union all select	916498	,	151	,	41	,	10	,	499	,	1500	--	12BETSuperUUS
union all select	916498	,	151	,	51	,	5	,	15000	,	30000	--	12BETSuperUUS
union all select	916498	,	152	,	41	,	10	,	499	,	1500	--	12BETSuperUUS
union all select	916498	,	152	,	51	,	5	,	15000	,	30000	--	12BETSuperUUS
union all select	916498	,	153	,	51	,	5	,	15000	,	30000	--	12BETSuperUUS
union all select	6006478	,	151	,	31	,	700	,	110000	,	2200000	--	12BETSuperJPY
union all select	6006478	,	151	,	41	,	700	,	110000	,	2200000	--	12BETSuperJPY
union all select	6006478	,	151	,	51	,	700	,	110000	,	2200000	--	12BETSuperJPY
union all select	6006478	,	152	,	41	,	700	,	1100000	,	2200000	--	12BETSuperJPY
union all select	6006478	,	152	,	51	,	700	,	1100000	,	2200000	--	12BETSuperJPY
union all select	6006478	,	153	,	51	,	700	,	1100000	,	2200000	--	12BETSuperJPY
union all select	1015427	,	151	,	31	,	5	,	1000	,	30000	--	12BETSuperCHF
union all select	1015427	,	151	,	41	,	10	,	1000	,	20000	--	12BETSuperCHF
union all select	1015427	,	151	,	51	,	10	,	1000	,	20000	--	12BETSuperCHF
union all select	1015427	,	152	,	41	,	10	,	10000	,	20000	--	12BETSuperCHF
union all select	1015427	,	152	,	51	,	10	,	10000	,	20000	--	12BETSuperCHF
union all select	1015427	,	153	,	51	,	10	,	10000	,	20000	--	12BETSuperCHF
union all select	6006276	,	151	,	31	,	10000	,	1200000	,	30000000	--	12BETSuperWON
union all select	6006276	,	151	,	41	,	10000	,	1200000	,	30000000	--	12BETSuperWON
union all select	6006276	,	151	,	51	,	10000	,	1200000	,	30000000	--	12BETSuperWON
union all select	6006276	,	152	,	41	,	10000	,	15000000	,	30000000	--	12BETSuperWON
union all select	6006276	,	152	,	51	,	10000	,	15000000	,	30000000	--	12BETSuperWON
union all select	6006276	,	153	,	51	,	10000	,	15000000	,	30000000	--	12BETSuperWON
union all select	3167631	,	151	,	31	,	150	,	12000	,	20000	--	12BETSuperINH
union all select	3167631	,	151	,	41	,	150	,	12000	,	99999	--	12BETSuperINH
union all select	3167631	,	151	,	51	,	150	,	12000	,	80000	--	12BETSuperINH
union all select	3167631	,	152	,	41	,	150	,	9999	,	99999	--	12BETSuperINH
union all select	3167631	,	152	,	51	,	150	,	40000	,	80000	--	12BETSuperINH
union all select	3167631	,	153	,	51	,	150	,	40000	,	80000	--	12BETSuperINH
union all select	6006409	,	151	,	31	,	500	,	70000	,	1400000	--	12BETSuperINR
union all select	6006409	,	151	,	41	,	500	,	70000	,	1400000	--	12BETSuperINR
union all select	6006409	,	151	,	51	,	500	,	70000	,	1400000	--	12BETSuperINR
union all select	6006409	,	152	,	41	,	500	,	700000	,	1400000	--	12BETSuperINR
union all select	6006409	,	152	,	51	,	500	,	700000	,	1400000	--	12BETSuperINR
union all select	6006409	,	153	,	51	,	500	,	700000	,	1400000	--	12BETSuperINR
union all select	2747862	,	151	,	31	,	10	,	1500	,	30000	--	ALogSuperSD$
union all select	2747862	,	151	,	41	,	10	,	1500	,	125000	--	ALogSuperSD$
union all select	2747862	,	151	,	51	,	10	,	1500	,	125000	--	ALogSuperSD$
union all select	2747862	,	152	,	41	,	10	,	10000	,	125000	--	ALogSuperSD$
union all select	2747862	,	152	,	51	,	10	,	10000	,	125000	--	ALogSuperSD$
union all select	2747862	,	153	,	51	,	10	,	10000	,	125000	--	ALogSuperSD$
union all select	2747736	,	151	,	31	,	30	,	4000	,	80000	--	ALogSuperRM
union all select	2747736	,	151	,	41	,	30	,	4000	,	300000	--	ALogSuperRM
union all select	2747736	,	151	,	51	,	30	,	4000	,	300000	--	ALogSuperRM
union all select	2747736	,	152	,	41	,	30	,	30000	,	300000	--	ALogSuperRM
union all select	2747736	,	152	,	51	,	30	,	30000	,	300000	--	ALogSuperRM
union all select	2747736	,	153	,	51	,	30	,	30000	,	300000	--	ALogSuperRM
union all select	2308796	,	151	,	31	,	10	,	1200	,	30000	--	ALogSuperUS$
union all select	2308796	,	151	,	41	,	10	,	1200	,	100000	--	ALogSuperUS$
union all select	2308796	,	151	,	51	,	10	,	1200	,	100000	--	ALogSuperUS$
union all select	2308796	,	152	,	41	,	10	,	10000	,	100000	--	ALogSuperUS$
union all select	2308796	,	152	,	51	,	10	,	10000	,	100000	--	ALogSuperUS$
union all select	2308796	,	153	,	51	,	10	,	10000	,	100000	--	ALogSuperUS$
union all select	2747989	,	151	,	31	,	300	,	40000	,	800000	--	ALogSuperTB
union all select	2747989	,	151	,	41	,	300	,	40000	,	1000000	--	ALogSuperTB
union all select	2747989	,	151	,	51	,	300	,	40000	,	1000000	--	ALogSuperTB
union all select	2747989	,	152	,	41	,	300	,	300000	,	1000000	--	ALogSuperTB
union all select	2747989	,	152	,	51	,	300	,	300000	,	1000000	--	ALogSuperTB
union all select	2747989	,	153	,	51	,	300	,	300000	,	1000000	--	ALogSuperTB
union all select	3114255	,	151	,	31	,	10	,	1000	,	20000	--	AlogSuperEURO
union all select	3114255	,	151	,	41	,	10	,	1000	,	50000	--	AlogSuperEURO
union all select	3114255	,	151	,	51	,	10	,	1000	,	50000	--	AlogSuperEURO
union all select	3114255	,	152	,	41	,	10	,	5000	,	50000	--	AlogSuperEURO
union all select	3114255	,	152	,	51	,	10	,	5000	,	50000	--	AlogSuperEURO
union all select	3114255	,	153	,	51	,	10	,	5000	,	50000	--	AlogSuperEURO
union all select	2308771	,	151	,	31	,	10	,	800	,	20000	--	ALogSuperGBP
union all select	2308771	,	151	,	41	,	10	,	800	,	50000	--	ALogSuperGBP
union all select	2308771	,	151	,	51	,	10	,	800	,	50000	--	ALogSuperGBP
union all select	2308771	,	152	,	41	,	10	,	5000	,	50000	--	ALogSuperGBP
union all select	2308771	,	152	,	51	,	10	,	5000	,	50000	--	ALogSuperGBP
union all select	2308771	,	153	,	51	,	10	,	5000	,	50000	--	ALogSuperGBP
union all select	2308841	,	151	,	31	,	50	,	7000	,	160000	--	ALogSuperRMB
union all select	2308841	,	151	,	41	,	50	,	7000	,	800000	--	ALogSuperRMB
union all select	2308841	,	151	,	51	,	50	,	7000	,	800000	--	ALogSuperRMB
union all select	2308841	,	152	,	41	,	50	,	50000	,	800000	--	ALogSuperRMB
union all select	2308841	,	152	,	51	,	50	,	50000	,	800000	--	ALogSuperRMB
union all select	2308841	,	153	,	51	,	50	,	50000	,	800000	--	ALogSuperRMB
union all select	3782799	,	151	,	31	,	40	,	12000	,	240000	--	AlogSuperIN
union all select	3782799	,	151	,	41	,	40	,	12000	,	240000	--	AlogSuperIN
union all select	3782799	,	151	,	51	,	40	,	12000	,	20000	--	AlogSuperIN
union all select	3782799	,	152	,	41	,	40	,	120000	,	240000	--	AlogSuperIN
union all select	3782799	,	152	,	51	,	40	,	10000	,	20000	--	AlogSuperIN
union all select	3782799	,	153	,	51	,	40	,	10000	,	20000	--	AlogSuperIN
union all select	2308733	,	151	,	31	,	10	,	500	,	1500	--	ALogSuperUUS
union all select	2308733	,	151	,	41	,	10	,	500	,	1500	--	ALogSuperUUS
union all select	2308733	,	151	,	51	,	5	,	15000	,	30000	--	ALogSuperUUS
union all select	2308733	,	152	,	41	,	10	,	500	,	1500	--	ALogSuperUUS
union all select	2308733	,	152	,	51	,	5	,	15000	,	30000	--	ALogSuperUUS
union all select	2308733	,	153	,	51	,	5	,	15000	,	30000	--	ALogSuperUUS
union all select	3289719	,	151	,	31	,	700	,	110000	,	2000000	--	AlogSuperJPY
union all select	3289719	,	151	,	41	,	700	,	110000	,	1000000	--	AlogSuperJPY
union all select	3289719	,	151	,	51	,	700	,	110000	,	1000000	--	AlogSuperJPY
union all select	3289719	,	152	,	41	,	700	,	500000	,	1000000	--	AlogSuperJPY
union all select	3289719	,	152	,	51	,	700	,	500000	,	1000000	--	AlogSuperJPY
union all select	3289719	,	153	,	51	,	700	,	500000	,	1000000	--	AlogSuperJPY
union all select	3289746	,	151	,	31	,	7000	,	1200000	,	10000000	--	AlogSuperWON
union all select	3289746	,	151	,	41	,	7000	,	1200000	,	10000000	--	AlogSuperWON
union all select	3289746	,	151	,	51	,	7000	,	1200000	,	10000000	--	AlogSuperWON
union all select	3289746	,	152	,	41	,	7000	,	5000000	,	10000000	--	AlogSuperWON
union all select	3289746	,	152	,	51	,	7000	,	5000000	,	10000000	--	AlogSuperWON
union all select	3289746	,	153	,	51	,	7000	,	5000000	,	10000000	--	AlogSuperWON
union all select	3417070	,	151	,	31	,	150	,	12000	,	20000	--	AlogSuperINH
union all select	3417070	,	151	,	41	,	150	,	12000	,	500000	--	AlogSuperINH
union all select	3417070	,	151	,	51	,	150	,	12000	,	500000	--	AlogSuperINH
union all select	3417070	,	152	,	41	,	150	,	200000	,	500000	--	AlogSuperINH
union all select	3417070	,	152	,	51	,	150	,	200000	,	500000	--	AlogSuperINH
union all select	3417070	,	153	,	51	,	150	,	200000	,	500000	--	AlogSuperINH
union all select	3928584	,	151	,	31	,	300	,	40000	,	800000	--	AlogSuperRUB
union all select	3928584	,	151	,	41	,	300	,	40000	,	800000	--	AlogSuperRUB
union all select	3928584	,	151	,	51	,	300	,	40000	,	800000	--	AlogSuperRUB
union all select	3928584	,	152	,	41	,	300	,	200000	,	800000	--	AlogSuperRUB
union all select	3928584	,	152	,	51	,	300	,	200000	,	800000	--	AlogSuperRUB
union all select	3928584	,	153	,	51	,	300	,	200000	,	800000	--	AlogSuperRUB
union all select	6618394	,	151	,	31	,	300	,	4000	,	90000	--	AlogSuperPLN
union all select	6618394	,	151	,	41	,	300	,	4000	,	90000	--	AlogSuperPLN
union all select	6618394	,	151	,	51	,	300	,	4000	,	90000	--	AlogSuperPLN
union all select	6618394	,	152	,	41	,	300	,	30000	,	90000	--	AlogSuperPLN
union all select	6618394	,	152	,	51	,	300	,	30000	,	90000	--	AlogSuperPLN
union all select	6618394	,	153	,	51	,	300	,	30000	,	90000	--	AlogSuperPLN
union all select	6092487	,	151	,	31	,	500	,	70000	,	1500000	--	AlogSuperINR
union all select	6092487	,	151	,	41	,	500	,	70000	,	1500000	--	AlogSuperINR
union all select	6092487	,	151	,	51	,	500	,	70000	,	1500000	--	AlogSuperINR
union all select	6092487	,	152	,	41	,	500	,	500000	,	1500000	--	AlogSuperINR
union all select	6092487	,	152	,	51	,	500	,	500000	,	1500000	--	AlogSuperINR
union all select	6092487	,	153	,	51	,	500	,	500000	,	1500000	--	AlogSuperINR
union all select	1004374	,	151	,	31	,	5	,	1500	,	30000	--	AB88SuperSD$
union all select	1004374	,	151	,	41	,	10	,	1500	,	40000	--	AB88SuperSD$
union all select	1004374	,	151	,	51	,	5	,	1500	,	40000	--	AB88SuperSD$
union all select	1004374	,	152	,	41	,	10	,	20000	,	40000	--	AB88SuperSD$
union all select	1004374	,	152	,	51	,	5	,	20000	,	40000	--	AB88SuperSD$
union all select	1004374	,	153	,	51	,	5	,	20000	,	40000	--	AB88SuperSD$
union all select	932209	,	151	,	31	,	10	,	4000	,	80000	--	AB88SuperRM
union all select	932209	,	151	,	41	,	30	,	4000	,	80000	--	AB88SuperRM
union all select	932209	,	151	,	51	,	10	,	4000	,	80000	--	AB88SuperRM
union all select	932209	,	152	,	41	,	30	,	40000	,	80000	--	AB88SuperRM
union all select	932209	,	152	,	51	,	10	,	40000	,	80000	--	AB88SuperRM
union all select	932209	,	153	,	51	,	10	,	40000	,	80000	--	AB88SuperRM
union all select	932063	,	151	,	31	,	5	,	1200	,	30000	--	AB88SuperUS$
union all select	932063	,	151	,	41	,	10	,	1200	,	30000	--	AB88SuperUS$
union all select	932063	,	151	,	51	,	5	,	1200	,	30000	--	AB88SuperUS$
union all select	932063	,	152	,	41	,	10	,	15000	,	30000	--	AB88SuperUS$
union all select	932063	,	152	,	51	,	5	,	15000	,	30000	--	AB88SuperUS$
union all select	932063	,	153	,	51	,	5	,	15000	,	30000	--	AB88SuperUS$
union all select	932181	,	151	,	31	,	100	,	40000	,	800000	--	AB88SuperTB
union all select	932181	,	151	,	41	,	300	,	40000	,	800000	--	AB88SuperTB
union all select	932181	,	151	,	51	,	300	,	40000	,	800000	--	AB88SuperTB
union all select	932181	,	152	,	41	,	300	,	400000	,	800000	--	AB88SuperTB
union all select	932181	,	152	,	51	,	300	,	400000	,	800000	--	AB88SuperTB
union all select	932181	,	153	,	51	,	300	,	400000	,	800000	--	AB88SuperTB
union all select	932167	,	151	,	31	,	5	,	1000	,	20000	--	AB88SuperEURO
union all select	932167	,	151	,	41	,	10	,	1000	,	20000	--	AB88SuperEURO
union all select	932167	,	151	,	51	,	5	,	1000	,	20000	--	AB88SuperEURO
union all select	932167	,	152	,	41	,	10	,	10000	,	20000	--	AB88SuperEURO
union all select	932167	,	152	,	51	,	5	,	10000	,	20000	--	AB88SuperEURO
union all select	932167	,	153	,	51	,	5	,	10000	,	20000	--	AB88SuperEURO
union all select	932188	,	151	,	31	,	5	,	800	,	20000	--	AB88SuperGBP
union all select	932188	,	151	,	41	,	10	,	800	,	20000	--	AB88SuperGBP
union all select	932188	,	151	,	51	,	5	,	800	,	20000	--	AB88SuperGBP
union all select	932188	,	152	,	41	,	10	,	10000	,	20000	--	AB88SuperGBP
union all select	932188	,	152	,	51	,	5	,	10000	,	20000	--	AB88SuperGBP
union all select	932188	,	153	,	51	,	5	,	10000	,	20000	--	AB88SuperGBP
union all select	932253	,	151	,	31	,	20	,	7000	,	160000	--	AB88SuperRMB
union all select	932253	,	151	,	41	,	50	,	7000	,	160000	--	AB88SuperRMB
union all select	932253	,	151	,	51	,	30	,	7000	,	160000	--	AB88SuperRMB
union all select	932253	,	152	,	41	,	50	,	80000	,	160000	--	AB88SuperRMB
union all select	932253	,	152	,	51	,	30	,	80000	,	160000	--	AB88SuperRMB
union all select	932253	,	153	,	51	,	30	,	80000	,	160000	--	AB88SuperRMB
union all select	2564717	,	151	,	31	,	50	,	12000	,	240000	--	AB88SuperIN
union all select	2564717	,	151	,	41	,	100	,	12000	,	240000	--	AB88SuperIN
union all select	2564717	,	151	,	51	,	50	,	12000	,	240000	--	AB88SuperIN
union all select	2564717	,	152	,	41	,	100	,	120000	,	240000	--	AB88SuperIN
union all select	2564717	,	152	,	51	,	50	,	120000	,	240000	--	AB88SuperIN
union all select	2564717	,	153	,	51	,	50	,	120000	,	240000	--	AB88SuperIN
union all select	925144	,	151	,	31	,	10	,	500	,	1500	--	AB88SuperUUS
union all select	925144	,	151	,	41	,	10	,	499	,	1500	--	AB88SuperUUS
union all select	925144	,	151	,	51	,	5	,	15000	,	30000	--	AB88SuperUUS
union all select	925144	,	152	,	41	,	10	,	499	,	1500	--	AB88SuperUUS
union all select	925144	,	152	,	51	,	5	,	15000	,	30000	--	AB88SuperUUS
union all select	925144	,	153	,	51	,	5	,	15000	,	30000	--	AB88SuperUUS
union all select	14131319	,	151	,	31	,	1000	,	3000000	,	6000000	--	AB88SuperWon
union all select	14131319	,	151	,	41	,	1000	,	3000000	,	6000000	--	AB88SuperWon
union all select	14131319	,	151	,	51	,	1000	,	3000000	,	6000000	--	AB88SuperWon
union all select	14131319	,	152	,	41	,	1000	,	3000000	,	6000000	--	AB88SuperWon
union all select	14131319	,	152	,	51	,	1000	,	3000000	,	6000000	--	AB88SuperWon
union all select	14131319	,	153	,	51	,	1000	,	3000000	,	6000000	--	AB88SuperWon
union all select	4833492	,	151	,	31	,	40	,	12000	,	30000	--	AB88SuperINH
union all select	4833492	,	151	,	41	,	40	,	12000	,	30000	--	AB88SuperINH
union all select	4833492	,	151	,	51	,	40	,	12000	,	30000	--	AB88SuperINH
union all select	4833492	,	152	,	41	,	40	,	15000	,	30000	--	AB88SuperINH
union all select	4833492	,	152	,	51	,	40	,	15000	,	30000	--	AB88SuperINH
union all select	4833492	,	153	,	51	,	40	,	15000	,	30000	--	AB88SuperINH
union all select	4689517	,	151	,	31	,	10	,	1500	,	12476	--	BODOGSuperSD$
union all select	4689517	,	151	,	41	,	10	,	1500	,	12476	--	BODOGSuperSD$
union all select	4689517	,	151	,	51	,	10	,	1500	,	12476	--	BODOGSuperSD$
union all select	4689517	,	152	,	41	,	10	,	12476	,	12476	--	BODOGSuperSD$
union all select	4689517	,	152	,	51	,	10	,	12476	,	12476	--	BODOGSuperSD$
union all select	4689517	,	153	,	51	,	10	,	12476	,	12476	--	BODOGSuperSD$
union all select	4714272	,	151	,	31	,	30	,	4000	,	30704	--	BODOGSuperRM
union all select	4714272	,	151	,	41	,	30	,	4000	,	30704	--	BODOGSuperRM
union all select	4714272	,	151	,	51	,	30	,	4000	,	30704	--	BODOGSuperRM
union all select	4714272	,	152	,	41	,	30	,	30704	,	30704	--	BODOGSuperRM
union all select	4714272	,	152	,	51	,	30	,	30704	,	30704	--	BODOGSuperRM
union all select	4714272	,	153	,	51	,	30	,	30704	,	30704	--	BODOGSuperRM
union all select	4686903	,	151	,	31	,	10	,	1200	,	10000	--	BODOGSuperUS$
union all select	4686903	,	151	,	41	,	10	,	1200	,	10000	--	BODOGSuperUS$
union all select	4686903	,	151	,	51	,	10	,	1200	,	10000	--	BODOGSuperUS$
union all select	4686903	,	152	,	41	,	10	,	10000	,	10000	--	BODOGSuperUS$
union all select	4686903	,	152	,	51	,	10	,	10000	,	10000	--	BODOGSuperUS$
union all select	4686903	,	153	,	51	,	10	,	10000	,	10000	--	BODOGSuperUS$
union all select	4689166	,	151	,	31	,	300	,	40000	,	294812	--	BODOGSuperTB
union all select	4689166	,	151	,	41	,	300	,	40000	,	294812	--	BODOGSuperTB
union all select	4689166	,	151	,	51	,	300	,	40000	,	294812	--	BODOGSuperTB
union all select	4689166	,	152	,	41	,	300	,	294812	,	294812	--	BODOGSuperTB
union all select	4689166	,	152	,	51	,	300	,	294812	,	294812	--	BODOGSuperTB
union all select	4689166	,	153	,	51	,	300	,	294812	,	294812	--	BODOGSuperTB
union all select	4715142	,	151	,	31	,	10	,	1000	,	7689	--	BODOGSuperEURO
union all select	4715142	,	151	,	41	,	10	,	1000	,	7689	--	BODOGSuperEURO
union all select	4715142	,	151	,	51	,	10	,	1000	,	7689	--	BODOGSuperEURO
union all select	4715142	,	152	,	41	,	10	,	7689	,	7689	--	BODOGSuperEURO
union all select	4715142	,	152	,	51	,	10	,	7689	,	7689	--	BODOGSuperEURO
union all select	4715142	,	153	,	51	,	10	,	7689	,	7689	--	BODOGSuperEURO
union all select	7651889	,	151	,	31	,	10	,	1400	,	9766	--	BODOGSuperAUD
union all select	7651889	,	151	,	41	,	10	,	1400	,	9766	--	BODOGSuperAUD
union all select	7651889	,	151	,	51	,	10	,	1400	,	9766	--	BODOGSuperAUD
union all select	7651889	,	152	,	41	,	10	,	9766	,	9766	--	BODOGSuperAUD
union all select	7651889	,	152	,	51	,	10	,	9766	,	9766	--	BODOGSuperAUD
union all select	7651889	,	153	,	51	,	10	,	9766	,	9766	--	BODOGSuperAUD
union all select	4715061	,	151	,	31	,	10	,	800	,	6698	--	BODOGSuperGBP
union all select	4715061	,	151	,	41	,	10	,	800	,	6698	--	BODOGSuperGBP
union all select	4715061	,	151	,	51	,	10	,	800	,	6698	--	BODOGSuperGBP
union all select	4715061	,	152	,	41	,	10	,	6698	,	6698	--	BODOGSuperGBP
union all select	4715061	,	152	,	51	,	10	,	6698	,	6698	--	BODOGSuperGBP
union all select	4715061	,	153	,	51	,	10	,	6698	,	6698	--	BODOGSuperGBP
union all select	4688739	,	151	,	31	,	50	,	7000	,	62696	--	BODOGSuperRMB
union all select	4688739	,	151	,	41	,	50	,	7000	,	62696	--	BODOGSuperRMB
union all select	4688739	,	151	,	51	,	50	,	7000	,	62696	--	BODOGSuperRMB
union all select	4688739	,	152	,	41	,	50	,	62696	,	62696	--	BODOGSuperRMB
union all select	4688739	,	152	,	51	,	50	,	62696	,	62696	--	BODOGSuperRMB
union all select	4688739	,	153	,	51	,	50	,	62696	,	62696	--	BODOGSuperRMB
union all select	4603197	,	151	,	31	,	2	,	10000	,	10000	--	BODOGSuperUUS
union all select	4603197	,	151	,	41	,	2	,	10000	,	10000	--	BODOGSuperUUS
union all select	4603197	,	151	,	51	,	2	,	10000	,	10000	--	BODOGSuperUUS
union all select	4603197	,	152	,	41	,	2	,	10000	,	10000	--	BODOGSuperUUS
union all select	4603197	,	152	,	51	,	2	,	10000	,	10000	--	BODOGSuperUUS
union all select	4603197	,	153	,	51	,	2	,	10000	,	10000	--	BODOGSuperUUS
union all select	4715507	,	151	,	31	,	7000	,	1200000	,	10760788	--	BODOGSuperWON
union all select	4715507	,	151	,	41	,	7000	,	1200000	,	10760788	--	BODOGSuperWON
union all select	4715507	,	151	,	51	,	7000	,	1200000	,	10760788	--	BODOGSuperWON
union all select	4715507	,	152	,	41	,	7000	,	10760788	,	10760788	--	BODOGSuperWON
union all select	4715507	,	152	,	51	,	7000	,	10760788	,	10760788	--	BODOGSuperWON
union all select	4715507	,	153	,	51	,	7000	,	10760788	,	10760788	--	BODOGSuperWON
union all select	8198572	,	151	,	31	,	150	,	12000	,	200000000	--	BODOGSuperINH
union all select	8198572	,	151	,	41	,	150	,	12000	,	200000000	--	BODOGSuperINH
union all select	8198572	,	151	,	51	,	150	,	12000	,	200000000	--	BODOGSuperINH
union all select	8198572	,	152	,	41	,	150	,	50000000	,	200000000	--	BODOGSuperINH
union all select	8198572	,	152	,	51	,	150	,	50000000	,	200000000	--	BODOGSuperINH
union all select	8198572	,	153	,	51	,	150	,	50000000	,	200000000	--	BODOGSuperINH
union all select	12910607	,	151	,	31	,	10	,	7000	,	160000	--	Boma365SuperRMB
union all select	12910607	,	151	,	41	,	10	,	7000	,	160000	--	Boma365SuperRMB
union all select	12910607	,	151	,	51	,	10	,	7000	,	160000	--	Boma365SuperRMB
union all select	12910607	,	152	,	41	,	10	,	80000	,	160000	--	Boma365SuperRMB
union all select	12910607	,	152	,	51	,	10	,	80000	,	160000	--	Boma365SuperRMB
union all select	12910607	,	153	,	51	,	10	,	80000	,	160000	--	Boma365SuperRMB
union all select	12910877	,	151	,	31	,	10	,	7000	,	160000	--	Boma365SuperUUS
union all select	12910877	,	151	,	41	,	10	,	7000	,	160000	--	Boma365SuperUUS
union all select	12910877	,	151	,	51	,	10	,	7000	,	160000	--	Boma365SuperUUS
union all select	12910877	,	152	,	41	,	10	,	80000	,	160000	--	Boma365SuperUUS
union all select	12910877	,	152	,	51	,	10	,	80000	,	160000	--	Boma365SuperUUS
union all select	12910877	,	153	,	51	,	10	,	80000	,	160000	--	Boma365SuperUUS
union all select	13853422	,	151	,	31	,	5	,	5000	,	20000	--	Happy1668SuperRMB
union all select	13853422	,	151	,	41	,	5	,	5000	,	20000	--	Happy1668SuperRMB
union all select	13853422	,	151	,	51	,	5	,	5000	,	20000	--	Happy1668SuperRMB
union all select	13853422	,	152	,	41	,	5	,	5000	,	20000	--	Happy1668SuperRMB
union all select	13853422	,	152	,	51	,	5	,	5000	,	20000	--	Happy1668SuperRMB
union all select	13853422	,	153	,	51	,	5	,	5000	,	20000	--	Happy1668SuperRMB
union all select	13853453	,	151	,	31	,	5	,	5000	,	20000	--	Happy1668SuperUUS
union all select	13853453	,	151	,	41	,	5	,	5000	,	20000	--	Happy1668SuperUUS
union all select	13853453	,	151	,	51	,	5	,	5000	,	20000	--	Happy1668SuperUUS
union all select	13853453	,	152	,	41	,	5	,	5000	,	20000	--	Happy1668SuperUUS
union all select	13853453	,	152	,	51	,	5	,	5000	,	20000	--	Happy1668SuperUUS
union all select	13853453	,	153	,	51	,	5	,	5000	,	20000	--	Happy1668SuperUUS
union all select	13626157	,	151	,	31	,	50	,	7000	,	160000	--	Hengcai88SuperRMB
union all select	13626157	,	151	,	41	,	50	,	7000	,	160000	--	Hengcai88SuperRMB
union all select	13626157	,	151	,	51	,	50	,	7000	,	160000	--	Hengcai88SuperRMB
union all select	13626157	,	152	,	41	,	50	,	80000	,	160000	--	Hengcai88SuperRMB
union all select	13626157	,	152	,	51	,	50	,	80000	,	160000	--	Hengcai88SuperRMB
union all select	13626157	,	153	,	51	,	50	,	80000	,	160000	--	Hengcai88SuperRMB
union all select	13626184	,	151	,	31	,	50	,	7000	,	160000	--	Hengcai88SuperUUS
union all select	13626184	,	151	,	41	,	50	,	7000	,	160000	--	Hengcai88SuperUUS
union all select	13626184	,	151	,	51	,	50	,	7000	,	160000	--	Hengcai88SuperUUS
union all select	13626184	,	152	,	41	,	50	,	80000	,	160000	--	Hengcai88SuperUUS
union all select	13626184	,	152	,	51	,	50	,	80000	,	160000	--	Hengcai88SuperUUS
union all select	13626184	,	153	,	51	,	50	,	80000	,	160000	--	Hengcai88SuperUUS
union all select	1574036	,	151	,	31	,	10	,	1500	,	30000	--	MS88SuperSD$
union all select	1574036	,	151	,	41	,	10	,	1500	,	5000	--	MS88SuperSD$
union all select	1574036	,	151	,	51	,	10	,	1500	,	40000	--	MS88SuperSD$
union all select	1574036	,	152	,	41	,	10	,	1999	,	5000	--	MS88SuperSD$
union all select	1574036	,	152	,	51	,	10	,	20000	,	40000	--	MS88SuperSD$
union all select	1574036	,	153	,	51	,	10	,	20000	,	40000	--	MS88SuperSD$
union all select	1574028	,	151	,	31	,	30	,	4000	,	80000	--	MS88SuperRM
union all select	1574028	,	151	,	41	,	30	,	4000	,	5000	--	MS88SuperRM
union all select	1574028	,	151	,	51	,	30	,	4000	,	80000	--	MS88SuperRM
union all select	1574028	,	152	,	41	,	30	,	2999	,	5000	--	MS88SuperRM
union all select	1574028	,	152	,	51	,	30	,	40000	,	80000	--	MS88SuperRM
union all select	1574028	,	153	,	51	,	30	,	40000	,	80000	--	MS88SuperRM
union all select	1573954	,	151	,	31	,	10	,	1200	,	30000	--	MS88SuperUS$
union all select	1573954	,	151	,	41	,	10	,	1200	,	2000	--	MS88SuperUS$
union all select	1573954	,	151	,	51	,	10	,	1200	,	30000	--	MS88SuperUS$
union all select	1573954	,	152	,	41	,	10	,	499	,	2000	--	MS88SuperUS$
union all select	1573954	,	152	,	51	,	10	,	15000	,	30000	--	MS88SuperUS$
union all select	1573954	,	153	,	51	,	10	,	15000	,	30000	--	MS88SuperUS$
union all select	1573967	,	151	,	31	,	300	,	40000	,	800000	--	MS88SuperTB
union all select	1573967	,	151	,	41	,	300	,	40000	,	50000	--	MS88SuperTB
union all select	1573967	,	151	,	51	,	300	,	40000	,	800000	--	MS88SuperTB
union all select	1573967	,	152	,	41	,	300	,	29999	,	50000	--	MS88SuperTB
union all select	1573967	,	152	,	51	,	300	,	400000	,	800000	--	MS88SuperTB
union all select	1573967	,	153	,	51	,	300	,	400000	,	800000	--	MS88SuperTB
union all select	1574024	,	151	,	31	,	20	,	10000	,	160000	--	MS88SuperHK$
union all select	1574024	,	151	,	41	,	10	,	10000	,	10000	--	MS88SuperHK$
union all select	1574024	,	151	,	51	,	30	,	10000	,	160000	--	MS88SuperHK$
union all select	1574024	,	152	,	41	,	10	,	3999	,	10000	--	MS88SuperHK$
union all select	1574024	,	152	,	51	,	30	,	80000	,	160000	--	MS88SuperHK$
union all select	1574024	,	153	,	51	,	30	,	80000	,	160000	--	MS88SuperHK$
union all select	1573960	,	151	,	31	,	10	,	1000	,	20000	--	MS88SuperEURO
union all select	1573960	,	151	,	41	,	10	,	1000	,	2000	--	MS88SuperEURO
union all select	1573960	,	151	,	51	,	10	,	1000	,	20000	--	MS88SuperEURO
union all select	1573960	,	152	,	41	,	10	,	499	,	2000	--	MS88SuperEURO
union all select	1573960	,	152	,	51	,	10	,	10000	,	20000	--	MS88SuperEURO
union all select	1573960	,	153	,	51	,	10	,	10000	,	20000	--	MS88SuperEURO
union all select	1574016	,	151	,	31	,	5	,	1400	,	30000	--	MS88SuperAUD
union all select	1574016	,	151	,	41	,	10	,	1400	,	30000	--	MS88SuperAUD
union all select	1574016	,	151	,	51	,	5	,	1400	,	30000	--	MS88SuperAUD
union all select	1574016	,	152	,	41	,	10	,	15000	,	30000	--	MS88SuperAUD
union all select	1574016	,	152	,	51	,	5	,	15000	,	30000	--	MS88SuperAUD
union all select	1574016	,	153	,	51	,	5	,	15000	,	30000	--	MS88SuperAUD
union all select	1573975	,	151	,	31	,	10	,	800	,	20000	--	MS88SuperGBP
union all select	1573975	,	151	,	41	,	10	,	800	,	20000	--	MS88SuperGBP
union all select	1573975	,	151	,	51	,	10	,	800	,	20000	--	MS88SuperGBP
union all select	1573975	,	152	,	41	,	10	,	10000	,	20000	--	MS88SuperGBP
union all select	1573975	,	152	,	51	,	10	,	10000	,	20000	--	MS88SuperGBP
union all select	1573975	,	153	,	51	,	10	,	10000	,	20000	--	MS88SuperGBP
union all select	1574008	,	151	,	31	,	50	,	7000	,	160000	--	MS88SuperRMB
union all select	1574008	,	151	,	41	,	50	,	7000	,	10000	--	MS88SuperRMB
union all select	1574008	,	151	,	51	,	50	,	7000	,	160000	--	MS88SuperRMB
union all select	1574008	,	152	,	41	,	50	,	3999	,	10000	--	MS88SuperRMB
union all select	1574008	,	152	,	51	,	50	,	80000	,	160000	--	MS88SuperRMB
union all select	1574008	,	153	,	51	,	50	,	80000	,	160000	--	MS88SuperRMB
union all select	1574102	,	151	,	31	,	50	,	12000	,	240000	--	MS88SuperIN
union all select	1574102	,	151	,	41	,	100	,	12000	,	240000	--	MS88SuperIN
union all select	1574102	,	151	,	51	,	50	,	12000	,	240000	--	MS88SuperIN
union all select	1574102	,	152	,	41	,	100	,	120000	,	240000	--	MS88SuperIN
union all select	1574102	,	152	,	51	,	50	,	120000	,	240000	--	MS88SuperIN
union all select	1574102	,	153	,	51	,	50	,	120000	,	240000	--	MS88SuperIN
union all select	1574095	,	151	,	31	,	10	,	500	,	1500	--	MS88SuperUUS
union all select	1574095	,	151	,	41	,	10	,	500	,	1500	--	MS88SuperUUS
union all select	1574095	,	151	,	51	,	5	,	15000	,	30000	--	MS88SuperUUS
union all select	1574095	,	152	,	41	,	10	,	500	,	1500	--	MS88SuperUUS
union all select	1574095	,	152	,	51	,	5	,	15000	,	30000	--	MS88SuperUUS
union all select	1574095	,	153	,	51	,	5	,	15000	,	30000	--	MS88SuperUUS
union all select	2397872	,	151	,	31	,	700	,	110000	,	2000000	--	MS88SuperJPY
union all select	2397872	,	151	,	41	,	700	,	110000	,	2000000	--	MS88SuperJPY
union all select	2397872	,	151	,	51	,	700	,	110000	,	2000000	--	MS88SuperJPY
union all select	2397872	,	152	,	41	,	700	,	1000000	,	2000000	--	MS88SuperJPY
union all select	2397872	,	152	,	51	,	700	,	1000000	,	2000000	--	MS88SuperJPY
union all select	2397872	,	153	,	51	,	700	,	1000000	,	2000000	--	MS88SuperJPY
union all select	2397885	,	151	,	31	,	7000	,	1200000	,	32000000	--	MS88SuperWON
union all select	2397885	,	151	,	41	,	7000	,	1200000	,	32000000	--	MS88SuperWON
union all select	2397885	,	151	,	51	,	7000	,	1200000	,	32000000	--	MS88SuperWON
union all select	2397885	,	152	,	41	,	7000	,	16000000	,	32000000	--	MS88SuperWON
union all select	2397885	,	152	,	51	,	7000	,	16000000	,	32000000	--	MS88SuperWON
union all select	2397885	,	153	,	51	,	7000	,	16000000	,	32000000	--	MS88SuperWON
union all select	1574083	,	151	,	31	,	5	,	1500	,	30000	--	MS88SuperBND
union all select	1574083	,	151	,	41	,	10	,	1500	,	30000	--	MS88SuperBND
union all select	1574083	,	151	,	51	,	5	,	1500	,	30000	--	MS88SuperBND
union all select	1574083	,	152	,	41	,	10	,	15000	,	30000	--	MS88SuperBND
union all select	1574083	,	152	,	51	,	5	,	15000	,	30000	--	MS88SuperBND
union all select	1574083	,	153	,	51	,	5	,	15000	,	30000	--	MS88SuperBND
union all select	3287311	,	151	,	31	,	150	,	12000	,	20000	--	MS88SuperINH
union all select	3287311	,	151	,	41	,	150	,	12000	,	99999	--	MS88SuperINH
union all select	3287311	,	151	,	51	,	150	,	12000	,	80000	--	MS88SuperINH
union all select	3287311	,	152	,	41	,	150	,	9999	,	99999	--	MS88SuperINH
union all select	3287311	,	152	,	51	,	150	,	40000	,	80000	--	MS88SuperINH
union all select	3287311	,	153	,	51	,	150	,	40000	,	80000	--	MS88SuperINH
union all select	5068911	,	151	,	31	,	500	,	70000	,	100000	--	MS88SuperINR
union all select	5068911	,	151	,	41	,	500	,	70000	,	100000	--	MS88SuperINR
union all select	5068911	,	151	,	51	,	500	,	70000	,	100000	--	MS88SuperINR
union all select	5068911	,	152	,	41	,	500	,	30000	,	100000	--	MS88SuperINR
union all select	5068911	,	152	,	51	,	500	,	30000	,	100000	--	MS88SuperINR
union all select	5068911	,	153	,	51	,	500	,	30000	,	100000	--	MS88SuperINR
union all select	3544240	,	151	,	31	,	30	,	4000	,	80000	--	MFSuperRM
union all select	3544240	,	151	,	41	,	30	,	4000	,	0	--	MFSuperRM
union all select	3544240	,	151	,	51	,	30	,	4000	,	80000	--	MFSuperRM
union all select	3544240	,	152	,	41	,	30	,	0	,	0	--	MFSuperRM
union all select	3544240	,	152	,	51	,	30	,	40000	,	80000	--	MFSuperRM
union all select	3544240	,	153	,	51	,	30	,	40000	,	80000	--	MFSuperRM
union all select	3752544	,	151	,	31	,	10	,	1200	,	160000	--	MFSuperUS$
union all select	3752544	,	151	,	41	,	10	,	1200	,	160000	--	MFSuperUS$
union all select	3752544	,	151	,	51	,	10	,	1200	,	160000	--	MFSuperUS$
union all select	3752544	,	152	,	41	,	10	,	30000	,	160000	--	MFSuperUS$
union all select	3752544	,	152	,	51	,	10	,	30000	,	160000	--	MFSuperUS$
union all select	3752544	,	153	,	51	,	10	,	30000	,	160000	--	MFSuperUS$
union all select	3544312	,	151	,	31	,	300	,	40000	,	800000	--	MFSuperTB
union all select	3544312	,	151	,	41	,	300	,	40000	,	0	--	MFSuperTB
union all select	3544312	,	151	,	51	,	300	,	40000	,	800000	--	MFSuperTB
union all select	3544312	,	152	,	41	,	300	,	0	,	0	--	MFSuperTB
union all select	3544312	,	152	,	51	,	300	,	400000	,	800000	--	MFSuperTB
union all select	3544312	,	153	,	51	,	300	,	400000	,	800000	--	MFSuperTB
union all select	7604551	,	151	,	31	,	0	,	1000	,	0	--	MFSuperEURO
union all select	7604551	,	151	,	41	,	0	,	1000	,	0	--	MFSuperEURO
union all select	7604551	,	151	,	51	,	0	,	1000	,	0	--	MFSuperEURO
union all select	7604551	,	152	,	41	,	0	,	0	,	0	--	MFSuperEURO
union all select	7604551	,	152	,	51	,	0	,	0	,	0	--	MFSuperEURO
union all select	7604551	,	153	,	51	,	0	,	0	,	0	--	MFSuperEURO
union all select	3752050	,	151	,	31	,	20	,	80000	,	160000	--	MFSuperRMB
union all select	3752050	,	151	,	41	,	50	,	7000	,	160000	--	MFSuperRMB
union all select	3752050	,	151	,	51	,	30	,	32000	,	160000	--	MFSuperRMB
union all select	3752050	,	152	,	41	,	50	,	7000	,	160000	--	MFSuperRMB
union all select	3752050	,	152	,	51	,	30	,	32000	,	160000	--	MFSuperRMB
union all select	3752050	,	153	,	51	,	30	,	32000	,	160000	--	MFSuperRMB
union all select	3544377	,	151	,	31	,	50	,	12000	,	240000	--	MFSuperIN
union all select	3544377	,	151	,	41	,	100	,	12000	,	240000	--	MFSuperIN
union all select	3544377	,	151	,	51	,	50	,	12000	,	240000	--	MFSuperIN
union all select	3544377	,	152	,	41	,	100	,	120000	,	240000	--	MFSuperIN
union all select	3544377	,	152	,	51	,	50	,	120000	,	240000	--	MFSuperIN
union all select	3544377	,	153	,	51	,	50	,	120000	,	240000	--	MFSuperIN
union all select	3543918	,	151	,	31	,	0	,	0	,	0	--	MFSuperUUS
union all select	3543918	,	151	,	41	,	0	,	0	,	0	--	MFSuperUUS
union all select	3543918	,	151	,	51	,	5	,	15000	,	30000	--	MFSuperUUS
union all select	3543918	,	152	,	41	,	0	,	0	,	0	--	MFSuperUUS
union all select	3543918	,	152	,	51	,	5	,	15000	,	30000	--	MFSuperUUS
union all select	3543918	,	153	,	51	,	5	,	15000	,	30000	--	MFSuperUUS
union all select	3763288	,	151	,	31	,	700	,	110000	,	2000000	--	MFSuperJPY
union all select	3763288	,	151	,	41	,	700	,	110000	,	4000000	--	MFSuperJPY
union all select	3763288	,	151	,	51	,	700	,	110000	,	2000000	--	MFSuperJPY
union all select	3763288	,	152	,	41	,	700	,	1200000	,	4000000	--	MFSuperJPY
union all select	3763288	,	152	,	51	,	700	,	1000000	,	2000000	--	MFSuperJPY
union all select	3763288	,	153	,	51	,	700	,	1000000	,	2000000	--	MFSuperJPY
union all select	13105568	,	151	,	31	,	50	,	7000	,	160000	--	Salon365SuperRMB
union all select	13105568	,	151	,	41	,	50	,	7000	,	160000	--	Salon365SuperRMB
union all select	13105568	,	151	,	51	,	50	,	7000	,	160000	--	Salon365SuperRMB
union all select	13105568	,	152	,	41	,	50	,	80000	,	160000	--	Salon365SuperRMB
union all select	13105568	,	152	,	51	,	50	,	80000	,	160000	--	Salon365SuperRMB
union all select	13105568	,	153	,	51	,	50	,	80000	,	160000	--	Salon365SuperRMB
union all select	13106576	,	151	,	31	,	50	,	7000	,	160000	--	Salon365SuperUUS
union all select	13106576	,	151	,	41	,	50	,	7000	,	160000	--	Salon365SuperUUS
union all select	13106576	,	151	,	51	,	50	,	7000	,	160000	--	Salon365SuperUUS
union all select	13106576	,	152	,	41	,	50	,	80000	,	160000	--	Salon365SuperUUS
union all select	13106576	,	152	,	51	,	50	,	80000	,	160000	--	Salon365SuperUUS
union all select	13106576	,	153	,	51	,	50	,	80000	,	160000	--	Salon365SuperUUS
union all select	13105479	,	151	,	31	,	50	,	7000	,	160000	--	SaloncsSuperRMB
union all select	13105479	,	151	,	41	,	50	,	7000	,	160000	--	SaloncsSuperRMB
union all select	13105479	,	151	,	51	,	50	,	7000	,	160000	--	SaloncsSuperRMB
union all select	13105479	,	152	,	41	,	50	,	80000	,	160000	--	SaloncsSuperRMB
union all select	13105479	,	152	,	51	,	50	,	80000	,	160000	--	SaloncsSuperRMB
union all select	13105479	,	153	,	51	,	50	,	80000	,	160000	--	SaloncsSuperRMB
union all select	13107046	,	151	,	31	,	50	,	7000	,	160000	--	SaloncsSuperUUS
union all select	13107046	,	151	,	41	,	50	,	7000	,	160000	--	SaloncsSuperUUS
union all select	13107046	,	151	,	51	,	50	,	7000	,	160000	--	SaloncsSuperUUS
union all select	13107046	,	152	,	41	,	50	,	80000	,	160000	--	SaloncsSuperUUS
union all select	13107046	,	152	,	51	,	50	,	80000	,	160000	--	SaloncsSuperUUS
union all select	13107046	,	153	,	51	,	50	,	80000	,	160000	--	SaloncsSuperUUS
union all select	7140934	,	151	,	31	,	10	,	1500	,	30000	--	VCasiaSuperSD$
union all select	7140934	,	151	,	41	,	10	,	1500	,	40000	--	VCasiaSuperSD$
union all select	7140934	,	151	,	51	,	10	,	1500	,	40000	--	VCasiaSuperSD$
union all select	7140934	,	152	,	41	,	10	,	20000	,	40000	--	VCasiaSuperSD$
union all select	7140934	,	152	,	51	,	10	,	20000	,	40000	--	VCasiaSuperSD$
union all select	7140934	,	153	,	51	,	10	,	20000	,	40000	--	VCasiaSuperSD$
union all select	7140747	,	151	,	31	,	10	,	1200	,	30000	--	VcasiaSuperUS$
union all select	7140747	,	151	,	41	,	10	,	1200	,	30000	--	VcasiaSuperUS$
union all select	7140747	,	151	,	51	,	10	,	1200	,	30000	--	VcasiaSuperUS$
union all select	7140747	,	152	,	41	,	10	,	15000	,	30000	--	VcasiaSuperUS$
union all select	7140747	,	152	,	51	,	10	,	15000	,	30000	--	VcasiaSuperUS$
union all select	7140747	,	153	,	51	,	10	,	15000	,	30000	--	VcasiaSuperUS$
union all select	7140648	,	151	,	31	,	10	,	1000	,	20000	--	VCasiaSuperEuro
union all select	7140648	,	151	,	41	,	10	,	1000	,	20000	--	VCasiaSuperEuro
union all select	7140648	,	151	,	51	,	10	,	1000	,	20000	--	VCasiaSuperEuro
union all select	7140648	,	152	,	41	,	10	,	10000	,	20000	--	VCasiaSuperEuro
union all select	7140648	,	152	,	51	,	10	,	10000	,	20000	--	VCasiaSuperEuro
union all select	7140648	,	153	,	51	,	10	,	10000	,	20000	--	VCasiaSuperEuro
union all select	7140807	,	151	,	31	,	5	,	1400	,	30000	--	VCasiaSuperAUD
union all select	7140807	,	151	,	41	,	10	,	1400	,	30000	--	VCasiaSuperAUD
union all select	7140807	,	151	,	51	,	5	,	1400	,	30000	--	VCasiaSuperAUD
union all select	7140807	,	152	,	41	,	10	,	15000	,	30000	--	VCasiaSuperAUD
union all select	7140807	,	152	,	51	,	5	,	15000	,	30000	--	VCasiaSuperAUD
union all select	7140807	,	153	,	51	,	5	,	15000	,	30000	--	VCasiaSuperAUD
union all select	7140071	,	151	,	31	,	10	,	800	,	20000	--	VCasiaSuperGBP
union all select	7140071	,	151	,	41	,	10	,	800	,	20000	--	VCasiaSuperGBP
union all select	7140071	,	151	,	51	,	10	,	800	,	20000	--	VCasiaSuperGBP
union all select	7140071	,	152	,	41	,	10	,	10000	,	20000	--	VCasiaSuperGBP
union all select	7140071	,	152	,	51	,	10	,	10000	,	20000	--	VCasiaSuperGBP
union all select	7140071	,	153	,	51	,	10	,	10000	,	20000	--	VCasiaSuperGBP
union all select	7141027	,	151	,	31	,	50	,	7000	,	160000	--	VCasiaSuperRMB
union all select	7141027	,	151	,	41	,	50	,	7000	,	160000	--	VCasiaSuperRMB
union all select	7141027	,	151	,	51	,	50	,	7000	,	160000	--	VCasiaSuperRMB
union all select	7141027	,	152	,	41	,	50	,	80000	,	160000	--	VCasiaSuperRMB
union all select	7141027	,	152	,	51	,	50	,	80000	,	160000	--	VCasiaSuperRMB
union all select	7141027	,	153	,	51	,	50	,	80000	,	160000	--	VCasiaSuperRMB
union all select	4845960	,	151	,	31	,	10	,	15000	,	300000	--	VCasiaSuperUUS
union all select	4845960	,	151	,	41	,	10	,	15000	,	300000	--	VCasiaSuperUUS
union all select	4845960	,	151	,	51	,	10	,	15000	,	300000	--	VCasiaSuperUUS
union all select	4845960	,	152	,	41	,	10	,	15000	,	300000	--	VCasiaSuperUUS
union all select	4845960	,	152	,	51	,	10	,	15000	,	300000	--	VCasiaSuperUUS
union all select	4845960	,	153	,	51	,	10	,	15000	,	300000	--	VCasiaSuperUUS
union all select	11387211	,	151	,	31	,	30	,	4000	,	80000	--	VWinSuperRM
union all select	11387211	,	151	,	41	,	30	,	4000	,	80000	--	VWinSuperRM
union all select	11387211	,	151	,	51	,	30	,	4000	,	80000	--	VWinSuperRM
union all select	11387211	,	152	,	41	,	30	,	40000	,	80000	--	VWinSuperRM
union all select	11387211	,	152	,	51	,	30	,	40000	,	80000	--	VWinSuperRM
union all select	11387211	,	153	,	51	,	30	,	40000	,	80000	--	VWinSuperRM
union all select	7596783	,	151	,	31	,	5	,	15000	,	30000	--	VwinSuperUS$
union all select	7596783	,	151	,	41	,	10	,	1200	,	30000	--	VwinSuperUS$
union all select	7596783	,	151	,	51	,	5	,	3000	,	30000	--	VwinSuperUS$
union all select	7596783	,	152	,	41	,	10	,	1200	,	30000	--	VwinSuperUS$
union all select	7596783	,	152	,	51	,	5	,	3000	,	30000	--	VwinSuperUS$
union all select	7596783	,	153	,	51	,	5	,	3000	,	30000	--	VwinSuperUS$
union all select	11387220	,	151	,	31	,	100	,	400000	,	800000	--	VWinSuperTB
union all select	11387220	,	151	,	41	,	300	,	40000	,	800000	--	VWinSuperTB
union all select	11387220	,	151	,	51	,	300	,	200000	,	200000	--	VWinSuperTB
union all select	11387220	,	152	,	41	,	300	,	40000	,	800000	--	VWinSuperTB
union all select	11387220	,	152	,	51	,	300	,	200000	,	200000	--	VWinSuperTB
union all select	11387220	,	153	,	51	,	300	,	200000	,	200000	--	VWinSuperTB
union all select	7596324	,	151	,	31	,	0	,	1000	,	0	--	VwinSuperEURO
union all select	7596324	,	151	,	41	,	0	,	1000	,	0	--	VwinSuperEURO
union all select	7596324	,	151	,	51	,	0	,	1000	,	0	--	VwinSuperEURO
union all select	7596324	,	152	,	41	,	0	,	0	,	0	--	VwinSuperEURO
union all select	7596324	,	152	,	51	,	0	,	0	,	0	--	VwinSuperEURO
union all select	7596324	,	153	,	51	,	0	,	0	,	0	--	VwinSuperEURO
union all select	10380749	,	151	,	31	,	20	,	80000	,	160000	--	VWINSuperRMB
union all select	10380749	,	151	,	41	,	50	,	7000	,	160000	--	VWINSuperRMB
union all select	10380749	,	151	,	51	,	30	,	32000	,	160000	--	VWINSuperRMB
union all select	10380749	,	152	,	41	,	50	,	7000	,	160000	--	VWINSuperRMB
union all select	10380749	,	152	,	51	,	30	,	32000	,	160000	--	VWINSuperRMB
union all select	10380749	,	153	,	51	,	30	,	32000	,	160000	--	VWINSuperRMB
union all select	11387229	,	151	,	31	,	50	,	120000	,	240000	--	VWinSuperIN
union all select	11387229	,	151	,	41	,	100	,	12000	,	240000	--	VWinSuperIN
union all select	11387229	,	151	,	51	,	50	,	48000	,	300000	--	VWinSuperIN
union all select	11387229	,	152	,	41	,	100	,	12000	,	240000	--	VWinSuperIN
union all select	11387229	,	152	,	51	,	50	,	48000	,	300000	--	VWinSuperIN
union all select	11387229	,	153	,	51	,	50	,	48000	,	300000	--	VWinSuperIN
union all select	4854900	,	151	,	31	,	50	,	7000	,	160000	--	VwinSuperUUS
union all select	4854900	,	151	,	41	,	50	,	7000	,	160000	--	VwinSuperUUS
union all select	4854900	,	151	,	51	,	50	,	7000	,	160000	--	VwinSuperUUS
union all select	4854900	,	152	,	41	,	50	,	80000	,	160000	--	VwinSuperUUS
union all select	4854900	,	152	,	51	,	50	,	80000	,	160000	--	VwinSuperUUS
union all select	4854900	,	153	,	51	,	50	,	80000	,	160000	--	VwinSuperUUS
union all select	13461694	,	151	,	31	,	700	,	110000	,	2200000	--	VwinSuperJPY
union all select	13461694	,	151	,	41	,	700	,	110000	,	2200000	--	VwinSuperJPY
union all select	13461694	,	151	,	51	,	700	,	110000	,	2200000	--	VwinSuperJPY
union all select	13461694	,	152	,	41	,	700	,	1100000	,	2200000	--	VwinSuperJPY
union all select	13461694	,	152	,	51	,	700	,	1100000	,	2200000	--	VwinSuperJPY
union all select	13461694	,	153	,	51	,	700	,	1100000	,	2200000	--	VwinSuperJPY
union all select	13461733	,	151	,	31	,	7000	,	1200000	,	29500000	--	VwinSuperWon
union all select	13461733	,	151	,	41	,	7000	,	1200000	,	29500000	--	VwinSuperWon
union all select	13461733	,	151	,	51	,	7000	,	1200000	,	29500000	--	VwinSuperWon
union all select	13461733	,	152	,	41	,	7000	,	14800000	,	29500000	--	VwinSuperWon
union all select	13461733	,	152	,	51	,	7000	,	14800000	,	29500000	--	VwinSuperWon
union all select	13461733	,	153	,	51	,	7000	,	14800000	,	29500000	--	VwinSuperWon
union all select	11387238	,	151	,	31	,	70	,	120000	,	240000	--	VWinSuperINH
union all select	11387238	,	151	,	41	,	150	,	12000	,	240000	--	VWinSuperINH
union all select	11387238	,	151	,	51	,	70	,	100000	,	300000	--	VWinSuperINH
union all select	11387238	,	152	,	41	,	150	,	12000	,	240000	--	VWinSuperINH
union all select	11387238	,	152	,	51	,	70	,	100000	,	300000	--	VWinSuperINH
union all select	11387238	,	153	,	51	,	70	,	100000	,	300000	--	VWinSuperINH
union all select	10580795	,	151	,	31	,	30	,	4000	,	80000	--	W88SuperRM
union all select	10580795	,	151	,	41	,	30	,	4000	,	80000	--	W88SuperRM
union all select	10580795	,	151	,	51	,	30	,	4000	,	80000	--	W88SuperRM
union all select	10580795	,	152	,	41	,	30	,	40000	,	80000	--	W88SuperRM
union all select	10580795	,	152	,	51	,	30	,	40000	,	80000	--	W88SuperRM
union all select	10580795	,	153	,	51	,	30	,	40000	,	80000	--	W88SuperRM
union all select	10580805	,	151	,	31	,	10	,	1200	,	30000	--	W88SuperUS$
union all select	10580805	,	151	,	41	,	10	,	1200	,	30000	--	W88SuperUS$
union all select	10580805	,	151	,	51	,	10	,	1200	,	30000	--	W88SuperUS$
union all select	10580805	,	152	,	41	,	10	,	15000	,	30000	--	W88SuperUS$
union all select	10580805	,	152	,	51	,	10	,	15000	,	30000	--	W88SuperUS$
union all select	10580805	,	153	,	51	,	10	,	15000	,	30000	--	W88SuperUS$
union all select	10580767	,	151	,	31	,	300	,	40000	,	800000	--	W88SuperTB
union all select	10580767	,	151	,	41	,	300	,	40000	,	800000	--	W88SuperTB
union all select	10580767	,	151	,	51	,	300	,	40000	,	800000	--	W88SuperTB
union all select	10580767	,	152	,	41	,	300	,	400000	,	800000	--	W88SuperTB
union all select	10580767	,	152	,	51	,	300	,	400000	,	800000	--	W88SuperTB
union all select	10580767	,	153	,	51	,	300	,	400000	,	800000	--	W88SuperTB
union all select	10580824	,	151	,	31	,	10	,	1000	,	20000	--	W88SuperEURO
union all select	10580824	,	151	,	41	,	10	,	1000	,	20000	--	W88SuperEURO
union all select	10580824	,	151	,	51	,	10	,	1000	,	20000	--	W88SuperEURO
union all select	10580824	,	152	,	41	,	10	,	10000	,	20000	--	W88SuperEURO
union all select	10580824	,	152	,	51	,	10	,	10000	,	20000	--	W88SuperEURO
union all select	10580824	,	153	,	51	,	10	,	10000	,	20000	--	W88SuperEURO
union all select	10580814	,	151	,	31	,	5	,	1400	,	30000	--	W88SuperAUD
union all select	10580814	,	151	,	41	,	10	,	1400	,	30000	--	W88SuperAUD
union all select	10580814	,	151	,	51	,	5	,	1400	,	30000	--	W88SuperAUD
union all select	10580814	,	152	,	41	,	10	,	15000	,	30000	--	W88SuperAUD
union all select	10580814	,	152	,	51	,	5	,	15000	,	30000	--	W88SuperAUD
union all select	10580814	,	153	,	51	,	5	,	15000	,	30000	--	W88SuperAUD
union all select	10580835	,	151	,	31	,	10	,	800	,	20000	--	W88SuperGBP
union all select	10580835	,	151	,	41	,	10	,	800	,	20000	--	W88SuperGBP
union all select	10580835	,	151	,	51	,	10	,	800	,	20000	--	W88SuperGBP
union all select	10580835	,	152	,	41	,	10	,	10000	,	20000	--	W88SuperGBP
union all select	10580835	,	152	,	51	,	10	,	10000	,	20000	--	W88SuperGBP
union all select	10580835	,	153	,	51	,	10	,	10000	,	20000	--	W88SuperGBP
union all select	10580722	,	151	,	31	,	50	,	7000	,	160000	--	W88SuperRMB
union all select	10580722	,	151	,	41	,	50	,	7000	,	160000	--	W88SuperRMB
union all select	10580722	,	151	,	51	,	50	,	7000	,	160000	--	W88SuperRMB
union all select	10580722	,	152	,	41	,	50	,	80000	,	160000	--	W88SuperRMB
union all select	10580722	,	152	,	51	,	50	,	80000	,	160000	--	W88SuperRMB
union all select	10580722	,	153	,	51	,	50	,	80000	,	160000	--	W88SuperRMB
union all select	10580776	,	151	,	31	,	50	,	12000	,	240000	--	W88SuperIN
union all select	10580776	,	151	,	41	,	100	,	12000	,	240000	--	W88SuperIN
union all select	10580776	,	151	,	51	,	50	,	12000	,	240000	--	W88SuperIN
union all select	10580776	,	152	,	41	,	100	,	120000	,	240000	--	W88SuperIN
union all select	10580776	,	152	,	51	,	50	,	120000	,	240000	--	W88SuperIN
union all select	10580776	,	153	,	51	,	50	,	120000	,	240000	--	W88SuperIN
union all select	10541896	,	151	,	31	,	10	,	500	,	1500	--	W88SuperUUS
union all select	10541896	,	151	,	41	,	10	,	499	,	1500	--	W88SuperUUS
union all select	10541896	,	151	,	51	,	5	,	15000	,	30000	--	W88SuperUUS
union all select	10541896	,	152	,	41	,	10	,	499	,	1500	--	W88SuperUUS
union all select	10541896	,	152	,	51	,	5	,	15000	,	30000	--	W88SuperUUS
union all select	10541896	,	153	,	51	,	5	,	15000	,	30000	--	W88SuperUUS
union all select	10580846	,	151	,	31	,	700	,	110000	,	2200000	--	W88SuperJPY
union all select	10580846	,	151	,	41	,	700	,	110000	,	2200000	--	W88SuperJPY
union all select	10580846	,	151	,	51	,	700	,	110000	,	2200000	--	W88SuperJPY
union all select	10580846	,	152	,	41	,	700	,	1100000	,	2200000	--	W88SuperJPY
union all select	10580846	,	152	,	51	,	700	,	1100000	,	2200000	--	W88SuperJPY
union all select	10580846	,	153	,	51	,	700	,	1100000	,	2200000	--	W88SuperJPY
union all select	12613176	,	151	,	31	,	500	,	1200000	,	29500000	--	W88SuperWON
union all select	12613176	,	151	,	41	,	500	,	1200000	,	29500000	--	W88SuperWON
union all select	12613176	,	151	,	51	,	500	,	1200000	,	29500000	--	W88SuperWON
union all select	12613176	,	152	,	41	,	500	,	14800000	,	29500000	--	W88SuperWON
union all select	12613176	,	152	,	51	,	500	,	14800000	,	29500000	--	W88SuperWON
union all select	12613176	,	153	,	51	,	500	,	14800000	,	29500000	--	W88SuperWON
union all select	10580785	,	151	,	31	,	150	,	12000	,	20000	--	W88SuperINH
union all select	10580785	,	151	,	41	,	150	,	12000	,	99999	--	W88SuperINH
union all select	10580785	,	151	,	51	,	150	,	12000	,	80000	--	W88SuperINH
union all select	10580785	,	152	,	41	,	150	,	9999	,	99999	--	W88SuperINH
union all select	10580785	,	152	,	51	,	150	,	40000	,	80000	--	W88SuperINH
union all select	10580785	,	153	,	51	,	150	,	40000	,	80000	--	W88SuperINH
union all select	10580858	,	151	,	31	,	500	,	70000	,	1400000	--	W88SuperINR
union all select	10580858	,	151	,	41	,	500	,	70000	,	1400000	--	W88SuperINR
union all select	10580858	,	151	,	51	,	500	,	70000	,	1400000	--	W88SuperINR
union all select	10580858	,	152	,	41	,	500	,	700000	,	1400000	--	W88SuperINR
union all select	10580858	,	152	,	51	,	500	,	700000	,	1400000	--	W88SuperINR
union all select	10580858	,	153	,	51	,	500	,	700000	,	1400000	--	W88SuperINR

DECLARE @srecommend INT, @max_custid INT, @sporttype INT, @bettype INT, @minbet MONEY, @maxbet MONEY, @maxpermatch MONEY

SET @max_custid = xxx

WHILE (1=1)
BEGIN

	UPDATE TOP(1) #DepSettings
	SET @srecommend = custid,
		@sporttype = sporttype,
		@bettype = bettype,
		@minbet = minbet,
		@maxbet = maxbet,
		@maxpermatch = maxpermatch,
		isfinished = 1
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
		,@sporttype = @sporttype
		,@bettype = @bettype
		,@minbet = @minbet
		,@maxbet = @maxbet
		,@maxpermatch = @maxpermatch		
		,@maxcustid = @max_custid
		,@target = 'REPLICATED'
		
	WAITFOR DELAY '00:00:00.280'
END
GO
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------
---

---
---
-- BEGIN STEP 3:  RUN THIS SCRIPT AT DBTRANS -----
--------------------------------------------------------------------------------------
CREATE TABLE #DepSettings(Custid INT, sporttype INT, bettype INT, minbet MONEY, maxbet MONEY, maxpermatch MONEY, isfinished bit default(0))

INSERT INTO #DepSettings(custid, sporttype, bettype, minbet, maxbet, maxpermatch)
			select	1752415	,	151	,	31	,	10	,	1500	,	30000	--	12BETSuperSD$
union all select	1752415	,	151	,	41	,	10	,	1500	,	40000	--	12BETSuperSD$
union all select	1752415	,	151	,	51	,	10	,	1500	,	40000	--	12BETSuperSD$
union all select	1752415	,	152	,	41	,	10	,	20000	,	40000	--	12BETSuperSD$
union all select	1752415	,	152	,	51	,	10	,	20000	,	40000	--	12BETSuperSD$
union all select	1752415	,	153	,	51	,	10	,	20000	,	40000	--	12BETSuperSD$
union all select	836218	,	151	,	31	,	30	,	4000	,	80000	--	12BETSuperRM
union all select	836218	,	151	,	41	,	30	,	4000	,	80000	--	12BETSuperRM
union all select	836218	,	151	,	51	,	30	,	4000	,	80000	--	12BETSuperRM
union all select	836218	,	152	,	41	,	30	,	40000	,	80000	--	12BETSuperRM
union all select	836218	,	152	,	51	,	30	,	40000	,	80000	--	12BETSuperRM
union all select	836218	,	153	,	51	,	30	,	40000	,	80000	--	12BETSuperRM
union all select	791080	,	151	,	31	,	10	,	1200	,	30000	--	12BETSuperUS$
union all select	791080	,	151	,	41	,	10	,	1200	,	30000	--	12BETSuperUS$
union all select	791080	,	151	,	51	,	10	,	1200	,	30000	--	12BETSuperUS$
union all select	791080	,	152	,	41	,	10	,	15000	,	30000	--	12BETSuperUS$
union all select	791080	,	152	,	51	,	10	,	15000	,	30000	--	12BETSuperUS$
union all select	791080	,	153	,	51	,	10	,	15000	,	30000	--	12BETSuperUS$
union all select	836203	,	151	,	31	,	300	,	40000	,	800000	--	12BETSuperTB
union all select	836203	,	151	,	41	,	300	,	40000	,	800000	--	12BETSuperTB
union all select	836203	,	151	,	51	,	300	,	40000	,	800000	--	12BETSuperTB
union all select	836203	,	152	,	41	,	300	,	400000	,	800000	--	12BETSuperTB
union all select	836203	,	152	,	51	,	300	,	400000	,	800000	--	12BETSuperTB
union all select	836203	,	153	,	51	,	300	,	400000	,	800000	--	12BETSuperTB
union all select	7526048	,	151	,	31	,	0	,	10000	,	0	--	12BETSuperHK$
union all select	7526048	,	151	,	41	,	10	,	10000	,	30000	--	12BETSuperHK$
union all select	7526048	,	151	,	51	,	0	,	10000	,	0	--	12BETSuperHK$
union all select	7526048	,	152	,	41	,	10	,	15000	,	30000	--	12BETSuperHK$
union all select	7526048	,	152	,	51	,	0	,	0	,	0	--	12BETSuperHK$
union all select	7526048	,	153	,	51	,	0	,	0	,	0	--	12BETSuperHK$
union all select	791081	,	151	,	31	,	10	,	1000	,	20000	--	12BETSuperEURO
union all select	791081	,	151	,	41	,	10	,	1000	,	20000	--	12BETSuperEURO
union all select	791081	,	151	,	51	,	10	,	1000	,	20000	--	12BETSuperEURO
union all select	791081	,	152	,	41	,	10	,	10000	,	20000	--	12BETSuperEURO
union all select	791081	,	152	,	51	,	10	,	10000	,	20000	--	12BETSuperEURO
union all select	791081	,	153	,	51	,	10	,	10000	,	20000	--	12BETSuperEURO
union all select	1015419	,	151	,	31	,	5	,	1400	,	30000	--	12BETSuperAUD
union all select	1015419	,	151	,	41	,	10	,	1400	,	30000	--	12BETSuperAUD
union all select	1015419	,	151	,	51	,	5	,	1400	,	30000	--	12BETSuperAUD
union all select	1015419	,	152	,	41	,	10	,	15000	,	30000	--	12BETSuperAUD
union all select	1015419	,	152	,	51	,	5	,	15000	,	30000	--	12BETSuperAUD
union all select	1015419	,	153	,	51	,	5	,	15000	,	30000	--	12BETSuperAUD
union all select	836212	,	151	,	31	,	10	,	800	,	20000	--	12BETSuperGBP
union all select	836212	,	151	,	41	,	10	,	800	,	20000	--	12BETSuperGBP
union all select	836212	,	151	,	51	,	10	,	800	,	20000	--	12BETSuperGBP
union all select	836212	,	152	,	41	,	10	,	10000	,	20000	--	12BETSuperGBP
union all select	836212	,	152	,	51	,	10	,	10000	,	20000	--	12BETSuperGBP
union all select	836212	,	153	,	51	,	10	,	10000	,	20000	--	12BETSuperGBP
union all select	836226	,	151	,	31	,	50	,	7000	,	160000	--	12BETSuperRMB
union all select	836226	,	151	,	41	,	50	,	7000	,	160000	--	12BETSuperRMB
union all select	836226	,	151	,	51	,	50	,	7000	,	160000	--	12BETSuperRMB
union all select	836226	,	152	,	41	,	50	,	80000	,	160000	--	12BETSuperRMB
union all select	836226	,	152	,	51	,	50	,	80000	,	160000	--	12BETSuperRMB
union all select	836226	,	153	,	51	,	50	,	80000	,	160000	--	12BETSuperRMB
union all select	1813575	,	151	,	31	,	50	,	12000	,	240000	--	12BETSuperIN
union all select	1813575	,	151	,	41	,	100	,	12000	,	240000	--	12BETSuperIN
union all select	1813575	,	151	,	51	,	50	,	12000	,	240000	--	12BETSuperIN
union all select	1813575	,	152	,	41	,	100	,	120000	,	240000	--	12BETSuperIN
union all select	1813575	,	152	,	51	,	50	,	120000	,	240000	--	12BETSuperIN
union all select	1813575	,	153	,	51	,	50	,	120000	,	240000	--	12BETSuperIN
union all select	916498	,	151	,	31	,	10	,	500	,	1500	--	12BETSuperUUS
union all select	916498	,	151	,	41	,	10	,	499	,	1500	--	12BETSuperUUS
union all select	916498	,	151	,	51	,	5	,	15000	,	30000	--	12BETSuperUUS
union all select	916498	,	152	,	41	,	10	,	499	,	1500	--	12BETSuperUUS
union all select	916498	,	152	,	51	,	5	,	15000	,	30000	--	12BETSuperUUS
union all select	916498	,	153	,	51	,	5	,	15000	,	30000	--	12BETSuperUUS
union all select	6006478	,	151	,	31	,	700	,	110000	,	2200000	--	12BETSuperJPY
union all select	6006478	,	151	,	41	,	700	,	110000	,	2200000	--	12BETSuperJPY
union all select	6006478	,	151	,	51	,	700	,	110000	,	2200000	--	12BETSuperJPY
union all select	6006478	,	152	,	41	,	700	,	1100000	,	2200000	--	12BETSuperJPY
union all select	6006478	,	152	,	51	,	700	,	1100000	,	2200000	--	12BETSuperJPY
union all select	6006478	,	153	,	51	,	700	,	1100000	,	2200000	--	12BETSuperJPY
union all select	1015427	,	151	,	31	,	5	,	1000	,	30000	--	12BETSuperCHF
union all select	1015427	,	151	,	41	,	10	,	1000	,	20000	--	12BETSuperCHF
union all select	1015427	,	151	,	51	,	10	,	1000	,	20000	--	12BETSuperCHF
union all select	1015427	,	152	,	41	,	10	,	10000	,	20000	--	12BETSuperCHF
union all select	1015427	,	152	,	51	,	10	,	10000	,	20000	--	12BETSuperCHF
union all select	1015427	,	153	,	51	,	10	,	10000	,	20000	--	12BETSuperCHF
union all select	6006276	,	151	,	31	,	10000	,	1200000	,	30000000	--	12BETSuperWON
union all select	6006276	,	151	,	41	,	10000	,	1200000	,	30000000	--	12BETSuperWON
union all select	6006276	,	151	,	51	,	10000	,	1200000	,	30000000	--	12BETSuperWON
union all select	6006276	,	152	,	41	,	10000	,	15000000	,	30000000	--	12BETSuperWON
union all select	6006276	,	152	,	51	,	10000	,	15000000	,	30000000	--	12BETSuperWON
union all select	6006276	,	153	,	51	,	10000	,	15000000	,	30000000	--	12BETSuperWON
union all select	3167631	,	151	,	31	,	150	,	12000	,	20000	--	12BETSuperINH
union all select	3167631	,	151	,	41	,	150	,	12000	,	99999	--	12BETSuperINH
union all select	3167631	,	151	,	51	,	150	,	12000	,	80000	--	12BETSuperINH
union all select	3167631	,	152	,	41	,	150	,	9999	,	99999	--	12BETSuperINH
union all select	3167631	,	152	,	51	,	150	,	40000	,	80000	--	12BETSuperINH
union all select	3167631	,	153	,	51	,	150	,	40000	,	80000	--	12BETSuperINH
union all select	6006409	,	151	,	31	,	500	,	70000	,	1400000	--	12BETSuperINR
union all select	6006409	,	151	,	41	,	500	,	70000	,	1400000	--	12BETSuperINR
union all select	6006409	,	151	,	51	,	500	,	70000	,	1400000	--	12BETSuperINR
union all select	6006409	,	152	,	41	,	500	,	700000	,	1400000	--	12BETSuperINR
union all select	6006409	,	152	,	51	,	500	,	700000	,	1400000	--	12BETSuperINR
union all select	6006409	,	153	,	51	,	500	,	700000	,	1400000	--	12BETSuperINR
union all select	2747862	,	151	,	31	,	10	,	1500	,	30000	--	ALogSuperSD$
union all select	2747862	,	151	,	41	,	10	,	1500	,	125000	--	ALogSuperSD$
union all select	2747862	,	151	,	51	,	10	,	1500	,	125000	--	ALogSuperSD$
union all select	2747862	,	152	,	41	,	10	,	10000	,	125000	--	ALogSuperSD$
union all select	2747862	,	152	,	51	,	10	,	10000	,	125000	--	ALogSuperSD$
union all select	2747862	,	153	,	51	,	10	,	10000	,	125000	--	ALogSuperSD$
union all select	2747736	,	151	,	31	,	30	,	4000	,	80000	--	ALogSuperRM
union all select	2747736	,	151	,	41	,	30	,	4000	,	300000	--	ALogSuperRM
union all select	2747736	,	151	,	51	,	30	,	4000	,	300000	--	ALogSuperRM
union all select	2747736	,	152	,	41	,	30	,	30000	,	300000	--	ALogSuperRM
union all select	2747736	,	152	,	51	,	30	,	30000	,	300000	--	ALogSuperRM
union all select	2747736	,	153	,	51	,	30	,	30000	,	300000	--	ALogSuperRM
union all select	2308796	,	151	,	31	,	10	,	1200	,	30000	--	ALogSuperUS$
union all select	2308796	,	151	,	41	,	10	,	1200	,	100000	--	ALogSuperUS$
union all select	2308796	,	151	,	51	,	10	,	1200	,	100000	--	ALogSuperUS$
union all select	2308796	,	152	,	41	,	10	,	10000	,	100000	--	ALogSuperUS$
union all select	2308796	,	152	,	51	,	10	,	10000	,	100000	--	ALogSuperUS$
union all select	2308796	,	153	,	51	,	10	,	10000	,	100000	--	ALogSuperUS$
union all select	2747989	,	151	,	31	,	300	,	40000	,	800000	--	ALogSuperTB
union all select	2747989	,	151	,	41	,	300	,	40000	,	1000000	--	ALogSuperTB
union all select	2747989	,	151	,	51	,	300	,	40000	,	1000000	--	ALogSuperTB
union all select	2747989	,	152	,	41	,	300	,	300000	,	1000000	--	ALogSuperTB
union all select	2747989	,	152	,	51	,	300	,	300000	,	1000000	--	ALogSuperTB
union all select	2747989	,	153	,	51	,	300	,	300000	,	1000000	--	ALogSuperTB
union all select	3114255	,	151	,	31	,	10	,	1000	,	20000	--	AlogSuperEURO
union all select	3114255	,	151	,	41	,	10	,	1000	,	50000	--	AlogSuperEURO
union all select	3114255	,	151	,	51	,	10	,	1000	,	50000	--	AlogSuperEURO
union all select	3114255	,	152	,	41	,	10	,	5000	,	50000	--	AlogSuperEURO
union all select	3114255	,	152	,	51	,	10	,	5000	,	50000	--	AlogSuperEURO
union all select	3114255	,	153	,	51	,	10	,	5000	,	50000	--	AlogSuperEURO
union all select	2308771	,	151	,	31	,	10	,	800	,	20000	--	ALogSuperGBP
union all select	2308771	,	151	,	41	,	10	,	800	,	50000	--	ALogSuperGBP
union all select	2308771	,	151	,	51	,	10	,	800	,	50000	--	ALogSuperGBP
union all select	2308771	,	152	,	41	,	10	,	5000	,	50000	--	ALogSuperGBP
union all select	2308771	,	152	,	51	,	10	,	5000	,	50000	--	ALogSuperGBP
union all select	2308771	,	153	,	51	,	10	,	5000	,	50000	--	ALogSuperGBP
union all select	2308841	,	151	,	31	,	50	,	7000	,	160000	--	ALogSuperRMB
union all select	2308841	,	151	,	41	,	50	,	7000	,	800000	--	ALogSuperRMB
union all select	2308841	,	151	,	51	,	50	,	7000	,	800000	--	ALogSuperRMB
union all select	2308841	,	152	,	41	,	50	,	50000	,	800000	--	ALogSuperRMB
union all select	2308841	,	152	,	51	,	50	,	50000	,	800000	--	ALogSuperRMB
union all select	2308841	,	153	,	51	,	50	,	50000	,	800000	--	ALogSuperRMB
union all select	3782799	,	151	,	31	,	40	,	12000	,	240000	--	AlogSuperIN
union all select	3782799	,	151	,	41	,	40	,	12000	,	240000	--	AlogSuperIN
union all select	3782799	,	151	,	51	,	40	,	12000	,	20000	--	AlogSuperIN
union all select	3782799	,	152	,	41	,	40	,	120000	,	240000	--	AlogSuperIN
union all select	3782799	,	152	,	51	,	40	,	10000	,	20000	--	AlogSuperIN
union all select	3782799	,	153	,	51	,	40	,	10000	,	20000	--	AlogSuperIN
union all select	2308733	,	151	,	31	,	10	,	500	,	1500	--	ALogSuperUUS
union all select	2308733	,	151	,	41	,	10	,	500	,	1500	--	ALogSuperUUS
union all select	2308733	,	151	,	51	,	5	,	15000	,	30000	--	ALogSuperUUS
union all select	2308733	,	152	,	41	,	10	,	500	,	1500	--	ALogSuperUUS
union all select	2308733	,	152	,	51	,	5	,	15000	,	30000	--	ALogSuperUUS
union all select	2308733	,	153	,	51	,	5	,	15000	,	30000	--	ALogSuperUUS
union all select	3289719	,	151	,	31	,	700	,	110000	,	2000000	--	AlogSuperJPY
union all select	3289719	,	151	,	41	,	700	,	110000	,	1000000	--	AlogSuperJPY
union all select	3289719	,	151	,	51	,	700	,	110000	,	1000000	--	AlogSuperJPY
union all select	3289719	,	152	,	41	,	700	,	500000	,	1000000	--	AlogSuperJPY
union all select	3289719	,	152	,	51	,	700	,	500000	,	1000000	--	AlogSuperJPY
union all select	3289719	,	153	,	51	,	700	,	500000	,	1000000	--	AlogSuperJPY
union all select	3289746	,	151	,	31	,	7000	,	1200000	,	10000000	--	AlogSuperWON
union all select	3289746	,	151	,	41	,	7000	,	1200000	,	10000000	--	AlogSuperWON
union all select	3289746	,	151	,	51	,	7000	,	1200000	,	10000000	--	AlogSuperWON
union all select	3289746	,	152	,	41	,	7000	,	5000000	,	10000000	--	AlogSuperWON
union all select	3289746	,	152	,	51	,	7000	,	5000000	,	10000000	--	AlogSuperWON
union all select	3289746	,	153	,	51	,	7000	,	5000000	,	10000000	--	AlogSuperWON
union all select	3417070	,	151	,	31	,	150	,	12000	,	20000	--	AlogSuperINH
union all select	3417070	,	151	,	41	,	150	,	12000	,	500000	--	AlogSuperINH
union all select	3417070	,	151	,	51	,	150	,	12000	,	500000	--	AlogSuperINH
union all select	3417070	,	152	,	41	,	150	,	200000	,	500000	--	AlogSuperINH
union all select	3417070	,	152	,	51	,	150	,	200000	,	500000	--	AlogSuperINH
union all select	3417070	,	153	,	51	,	150	,	200000	,	500000	--	AlogSuperINH
union all select	3928584	,	151	,	31	,	300	,	40000	,	800000	--	AlogSuperRUB
union all select	3928584	,	151	,	41	,	300	,	40000	,	800000	--	AlogSuperRUB
union all select	3928584	,	151	,	51	,	300	,	40000	,	800000	--	AlogSuperRUB
union all select	3928584	,	152	,	41	,	300	,	200000	,	800000	--	AlogSuperRUB
union all select	3928584	,	152	,	51	,	300	,	200000	,	800000	--	AlogSuperRUB
union all select	3928584	,	153	,	51	,	300	,	200000	,	800000	--	AlogSuperRUB
union all select	6618394	,	151	,	31	,	300	,	4000	,	90000	--	AlogSuperPLN
union all select	6618394	,	151	,	41	,	300	,	4000	,	90000	--	AlogSuperPLN
union all select	6618394	,	151	,	51	,	300	,	4000	,	90000	--	AlogSuperPLN
union all select	6618394	,	152	,	41	,	300	,	30000	,	90000	--	AlogSuperPLN
union all select	6618394	,	152	,	51	,	300	,	30000	,	90000	--	AlogSuperPLN
union all select	6618394	,	153	,	51	,	300	,	30000	,	90000	--	AlogSuperPLN
union all select	6092487	,	151	,	31	,	500	,	70000	,	1500000	--	AlogSuperINR
union all select	6092487	,	151	,	41	,	500	,	70000	,	1500000	--	AlogSuperINR
union all select	6092487	,	151	,	51	,	500	,	70000	,	1500000	--	AlogSuperINR
union all select	6092487	,	152	,	41	,	500	,	500000	,	1500000	--	AlogSuperINR
union all select	6092487	,	152	,	51	,	500	,	500000	,	1500000	--	AlogSuperINR
union all select	6092487	,	153	,	51	,	500	,	500000	,	1500000	--	AlogSuperINR
union all select	1004374	,	151	,	31	,	5	,	1500	,	30000	--	AB88SuperSD$
union all select	1004374	,	151	,	41	,	10	,	1500	,	40000	--	AB88SuperSD$
union all select	1004374	,	151	,	51	,	5	,	1500	,	40000	--	AB88SuperSD$
union all select	1004374	,	152	,	41	,	10	,	20000	,	40000	--	AB88SuperSD$
union all select	1004374	,	152	,	51	,	5	,	20000	,	40000	--	AB88SuperSD$
union all select	1004374	,	153	,	51	,	5	,	20000	,	40000	--	AB88SuperSD$
union all select	932209	,	151	,	31	,	10	,	4000	,	80000	--	AB88SuperRM
union all select	932209	,	151	,	41	,	30	,	4000	,	80000	--	AB88SuperRM
union all select	932209	,	151	,	51	,	10	,	4000	,	80000	--	AB88SuperRM
union all select	932209	,	152	,	41	,	30	,	40000	,	80000	--	AB88SuperRM
union all select	932209	,	152	,	51	,	10	,	40000	,	80000	--	AB88SuperRM
union all select	932209	,	153	,	51	,	10	,	40000	,	80000	--	AB88SuperRM
union all select	932063	,	151	,	31	,	5	,	1200	,	30000	--	AB88SuperUS$
union all select	932063	,	151	,	41	,	10	,	1200	,	30000	--	AB88SuperUS$
union all select	932063	,	151	,	51	,	5	,	1200	,	30000	--	AB88SuperUS$
union all select	932063	,	152	,	41	,	10	,	15000	,	30000	--	AB88SuperUS$
union all select	932063	,	152	,	51	,	5	,	15000	,	30000	--	AB88SuperUS$
union all select	932063	,	153	,	51	,	5	,	15000	,	30000	--	AB88SuperUS$
union all select	932181	,	151	,	31	,	100	,	40000	,	800000	--	AB88SuperTB
union all select	932181	,	151	,	41	,	300	,	40000	,	800000	--	AB88SuperTB
union all select	932181	,	151	,	51	,	300	,	40000	,	800000	--	AB88SuperTB
union all select	932181	,	152	,	41	,	300	,	400000	,	800000	--	AB88SuperTB
union all select	932181	,	152	,	51	,	300	,	400000	,	800000	--	AB88SuperTB
union all select	932181	,	153	,	51	,	300	,	400000	,	800000	--	AB88SuperTB
union all select	932167	,	151	,	31	,	5	,	1000	,	20000	--	AB88SuperEURO
union all select	932167	,	151	,	41	,	10	,	1000	,	20000	--	AB88SuperEURO
union all select	932167	,	151	,	51	,	5	,	1000	,	20000	--	AB88SuperEURO
union all select	932167	,	152	,	41	,	10	,	10000	,	20000	--	AB88SuperEURO
union all select	932167	,	152	,	51	,	5	,	10000	,	20000	--	AB88SuperEURO
union all select	932167	,	153	,	51	,	5	,	10000	,	20000	--	AB88SuperEURO
union all select	932188	,	151	,	31	,	5	,	800	,	20000	--	AB88SuperGBP
union all select	932188	,	151	,	41	,	10	,	800	,	20000	--	AB88SuperGBP
union all select	932188	,	151	,	51	,	5	,	800	,	20000	--	AB88SuperGBP
union all select	932188	,	152	,	41	,	10	,	10000	,	20000	--	AB88SuperGBP
union all select	932188	,	152	,	51	,	5	,	10000	,	20000	--	AB88SuperGBP
union all select	932188	,	153	,	51	,	5	,	10000	,	20000	--	AB88SuperGBP
union all select	932253	,	151	,	31	,	20	,	7000	,	160000	--	AB88SuperRMB
union all select	932253	,	151	,	41	,	50	,	7000	,	160000	--	AB88SuperRMB
union all select	932253	,	151	,	51	,	30	,	7000	,	160000	--	AB88SuperRMB
union all select	932253	,	152	,	41	,	50	,	80000	,	160000	--	AB88SuperRMB
union all select	932253	,	152	,	51	,	30	,	80000	,	160000	--	AB88SuperRMB
union all select	932253	,	153	,	51	,	30	,	80000	,	160000	--	AB88SuperRMB
union all select	2564717	,	151	,	31	,	50	,	12000	,	240000	--	AB88SuperIN
union all select	2564717	,	151	,	41	,	100	,	12000	,	240000	--	AB88SuperIN
union all select	2564717	,	151	,	51	,	50	,	12000	,	240000	--	AB88SuperIN
union all select	2564717	,	152	,	41	,	100	,	120000	,	240000	--	AB88SuperIN
union all select	2564717	,	152	,	51	,	50	,	120000	,	240000	--	AB88SuperIN
union all select	2564717	,	153	,	51	,	50	,	120000	,	240000	--	AB88SuperIN
union all select	925144	,	151	,	31	,	10	,	500	,	1500	--	AB88SuperUUS
union all select	925144	,	151	,	41	,	10	,	499	,	1500	--	AB88SuperUUS
union all select	925144	,	151	,	51	,	5	,	15000	,	30000	--	AB88SuperUUS
union all select	925144	,	152	,	41	,	10	,	499	,	1500	--	AB88SuperUUS
union all select	925144	,	152	,	51	,	5	,	15000	,	30000	--	AB88SuperUUS
union all select	925144	,	153	,	51	,	5	,	15000	,	30000	--	AB88SuperUUS
union all select	14131319	,	151	,	31	,	1000	,	3000000	,	6000000	--	AB88SuperWon
union all select	14131319	,	151	,	41	,	1000	,	3000000	,	6000000	--	AB88SuperWon
union all select	14131319	,	151	,	51	,	1000	,	3000000	,	6000000	--	AB88SuperWon
union all select	14131319	,	152	,	41	,	1000	,	3000000	,	6000000	--	AB88SuperWon
union all select	14131319	,	152	,	51	,	1000	,	3000000	,	6000000	--	AB88SuperWon
union all select	14131319	,	153	,	51	,	1000	,	3000000	,	6000000	--	AB88SuperWon
union all select	4833492	,	151	,	31	,	40	,	12000	,	30000	--	AB88SuperINH
union all select	4833492	,	151	,	41	,	40	,	12000	,	30000	--	AB88SuperINH
union all select	4833492	,	151	,	51	,	40	,	12000	,	30000	--	AB88SuperINH
union all select	4833492	,	152	,	41	,	40	,	15000	,	30000	--	AB88SuperINH
union all select	4833492	,	152	,	51	,	40	,	15000	,	30000	--	AB88SuperINH
union all select	4833492	,	153	,	51	,	40	,	15000	,	30000	--	AB88SuperINH
union all select	4689517	,	151	,	31	,	10	,	1500	,	12476	--	BODOGSuperSD$
union all select	4689517	,	151	,	41	,	10	,	1500	,	12476	--	BODOGSuperSD$
union all select	4689517	,	151	,	51	,	10	,	1500	,	12476	--	BODOGSuperSD$
union all select	4689517	,	152	,	41	,	10	,	12476	,	12476	--	BODOGSuperSD$
union all select	4689517	,	152	,	51	,	10	,	12476	,	12476	--	BODOGSuperSD$
union all select	4689517	,	153	,	51	,	10	,	12476	,	12476	--	BODOGSuperSD$
union all select	4714272	,	151	,	31	,	30	,	4000	,	30704	--	BODOGSuperRM
union all select	4714272	,	151	,	41	,	30	,	4000	,	30704	--	BODOGSuperRM
union all select	4714272	,	151	,	51	,	30	,	4000	,	30704	--	BODOGSuperRM
union all select	4714272	,	152	,	41	,	30	,	30704	,	30704	--	BODOGSuperRM
union all select	4714272	,	152	,	51	,	30	,	30704	,	30704	--	BODOGSuperRM
union all select	4714272	,	153	,	51	,	30	,	30704	,	30704	--	BODOGSuperRM
union all select	4686903	,	151	,	31	,	10	,	1200	,	10000	--	BODOGSuperUS$
union all select	4686903	,	151	,	41	,	10	,	1200	,	10000	--	BODOGSuperUS$
union all select	4686903	,	151	,	51	,	10	,	1200	,	10000	--	BODOGSuperUS$
union all select	4686903	,	152	,	41	,	10	,	10000	,	10000	--	BODOGSuperUS$
union all select	4686903	,	152	,	51	,	10	,	10000	,	10000	--	BODOGSuperUS$
union all select	4686903	,	153	,	51	,	10	,	10000	,	10000	--	BODOGSuperUS$
union all select	4689166	,	151	,	31	,	300	,	40000	,	294812	--	BODOGSuperTB
union all select	4689166	,	151	,	41	,	300	,	40000	,	294812	--	BODOGSuperTB
union all select	4689166	,	151	,	51	,	300	,	40000	,	294812	--	BODOGSuperTB
union all select	4689166	,	152	,	41	,	300	,	294812	,	294812	--	BODOGSuperTB
union all select	4689166	,	152	,	51	,	300	,	294812	,	294812	--	BODOGSuperTB
union all select	4689166	,	153	,	51	,	300	,	294812	,	294812	--	BODOGSuperTB
union all select	4715142	,	151	,	31	,	10	,	1000	,	7689	--	BODOGSuperEURO
union all select	4715142	,	151	,	41	,	10	,	1000	,	7689	--	BODOGSuperEURO
union all select	4715142	,	151	,	51	,	10	,	1000	,	7689	--	BODOGSuperEURO
union all select	4715142	,	152	,	41	,	10	,	7689	,	7689	--	BODOGSuperEURO
union all select	4715142	,	152	,	51	,	10	,	7689	,	7689	--	BODOGSuperEURO
union all select	4715142	,	153	,	51	,	10	,	7689	,	7689	--	BODOGSuperEURO
union all select	7651889	,	151	,	31	,	10	,	1400	,	9766	--	BODOGSuperAUD
union all select	7651889	,	151	,	41	,	10	,	1400	,	9766	--	BODOGSuperAUD
union all select	7651889	,	151	,	51	,	10	,	1400	,	9766	--	BODOGSuperAUD
union all select	7651889	,	152	,	41	,	10	,	9766	,	9766	--	BODOGSuperAUD
union all select	7651889	,	152	,	51	,	10	,	9766	,	9766	--	BODOGSuperAUD
union all select	7651889	,	153	,	51	,	10	,	9766	,	9766	--	BODOGSuperAUD
union all select	4715061	,	151	,	31	,	10	,	800	,	6698	--	BODOGSuperGBP
union all select	4715061	,	151	,	41	,	10	,	800	,	6698	--	BODOGSuperGBP
union all select	4715061	,	151	,	51	,	10	,	800	,	6698	--	BODOGSuperGBP
union all select	4715061	,	152	,	41	,	10	,	6698	,	6698	--	BODOGSuperGBP
union all select	4715061	,	152	,	51	,	10	,	6698	,	6698	--	BODOGSuperGBP
union all select	4715061	,	153	,	51	,	10	,	6698	,	6698	--	BODOGSuperGBP
union all select	4688739	,	151	,	31	,	50	,	7000	,	62696	--	BODOGSuperRMB
union all select	4688739	,	151	,	41	,	50	,	7000	,	62696	--	BODOGSuperRMB
union all select	4688739	,	151	,	51	,	50	,	7000	,	62696	--	BODOGSuperRMB
union all select	4688739	,	152	,	41	,	50	,	62696	,	62696	--	BODOGSuperRMB
union all select	4688739	,	152	,	51	,	50	,	62696	,	62696	--	BODOGSuperRMB
union all select	4688739	,	153	,	51	,	50	,	62696	,	62696	--	BODOGSuperRMB
union all select	4603197	,	151	,	31	,	2	,	10000	,	10000	--	BODOGSuperUUS
union all select	4603197	,	151	,	41	,	2	,	10000	,	10000	--	BODOGSuperUUS
union all select	4603197	,	151	,	51	,	2	,	10000	,	10000	--	BODOGSuperUUS
union all select	4603197	,	152	,	41	,	2	,	10000	,	10000	--	BODOGSuperUUS
union all select	4603197	,	152	,	51	,	2	,	10000	,	10000	--	BODOGSuperUUS
union all select	4603197	,	153	,	51	,	2	,	10000	,	10000	--	BODOGSuperUUS
union all select	4715507	,	151	,	31	,	7000	,	1200000	,	10760788	--	BODOGSuperWON
union all select	4715507	,	151	,	41	,	7000	,	1200000	,	10760788	--	BODOGSuperWON
union all select	4715507	,	151	,	51	,	7000	,	1200000	,	10760788	--	BODOGSuperWON
union all select	4715507	,	152	,	41	,	7000	,	10760788	,	10760788	--	BODOGSuperWON
union all select	4715507	,	152	,	51	,	7000	,	10760788	,	10760788	--	BODOGSuperWON
union all select	4715507	,	153	,	51	,	7000	,	10760788	,	10760788	--	BODOGSuperWON
union all select	8198572	,	151	,	31	,	150	,	12000	,	200000000	--	BODOGSuperINH
union all select	8198572	,	151	,	41	,	150	,	12000	,	200000000	--	BODOGSuperINH
union all select	8198572	,	151	,	51	,	150	,	12000	,	200000000	--	BODOGSuperINH
union all select	8198572	,	152	,	41	,	150	,	50000000	,	200000000	--	BODOGSuperINH
union all select	8198572	,	152	,	51	,	150	,	50000000	,	200000000	--	BODOGSuperINH
union all select	8198572	,	153	,	51	,	150	,	50000000	,	200000000	--	BODOGSuperINH
union all select	12910607	,	151	,	31	,	10	,	7000	,	160000	--	Boma365SuperRMB
union all select	12910607	,	151	,	41	,	10	,	7000	,	160000	--	Boma365SuperRMB
union all select	12910607	,	151	,	51	,	10	,	7000	,	160000	--	Boma365SuperRMB
union all select	12910607	,	152	,	41	,	10	,	80000	,	160000	--	Boma365SuperRMB
union all select	12910607	,	152	,	51	,	10	,	80000	,	160000	--	Boma365SuperRMB
union all select	12910607	,	153	,	51	,	10	,	80000	,	160000	--	Boma365SuperRMB
union all select	12910877	,	151	,	31	,	10	,	7000	,	160000	--	Boma365SuperUUS
union all select	12910877	,	151	,	41	,	10	,	7000	,	160000	--	Boma365SuperUUS
union all select	12910877	,	151	,	51	,	10	,	7000	,	160000	--	Boma365SuperUUS
union all select	12910877	,	152	,	41	,	10	,	80000	,	160000	--	Boma365SuperUUS
union all select	12910877	,	152	,	51	,	10	,	80000	,	160000	--	Boma365SuperUUS
union all select	12910877	,	153	,	51	,	10	,	80000	,	160000	--	Boma365SuperUUS
union all select	13853422	,	151	,	31	,	5	,	5000	,	20000	--	Happy1668SuperRMB
union all select	13853422	,	151	,	41	,	5	,	5000	,	20000	--	Happy1668SuperRMB
union all select	13853422	,	151	,	51	,	5	,	5000	,	20000	--	Happy1668SuperRMB
union all select	13853422	,	152	,	41	,	5	,	5000	,	20000	--	Happy1668SuperRMB
union all select	13853422	,	152	,	51	,	5	,	5000	,	20000	--	Happy1668SuperRMB
union all select	13853422	,	153	,	51	,	5	,	5000	,	20000	--	Happy1668SuperRMB
union all select	13853453	,	151	,	31	,	5	,	5000	,	20000	--	Happy1668SuperUUS
union all select	13853453	,	151	,	41	,	5	,	5000	,	20000	--	Happy1668SuperUUS
union all select	13853453	,	151	,	51	,	5	,	5000	,	20000	--	Happy1668SuperUUS
union all select	13853453	,	152	,	41	,	5	,	5000	,	20000	--	Happy1668SuperUUS
union all select	13853453	,	152	,	51	,	5	,	5000	,	20000	--	Happy1668SuperUUS
union all select	13853453	,	153	,	51	,	5	,	5000	,	20000	--	Happy1668SuperUUS
union all select	13626157	,	151	,	31	,	50	,	7000	,	160000	--	Hengcai88SuperRMB
union all select	13626157	,	151	,	41	,	50	,	7000	,	160000	--	Hengcai88SuperRMB
union all select	13626157	,	151	,	51	,	50	,	7000	,	160000	--	Hengcai88SuperRMB
union all select	13626157	,	152	,	41	,	50	,	80000	,	160000	--	Hengcai88SuperRMB
union all select	13626157	,	152	,	51	,	50	,	80000	,	160000	--	Hengcai88SuperRMB
union all select	13626157	,	153	,	51	,	50	,	80000	,	160000	--	Hengcai88SuperRMB
union all select	13626184	,	151	,	31	,	50	,	7000	,	160000	--	Hengcai88SuperUUS
union all select	13626184	,	151	,	41	,	50	,	7000	,	160000	--	Hengcai88SuperUUS
union all select	13626184	,	151	,	51	,	50	,	7000	,	160000	--	Hengcai88SuperUUS
union all select	13626184	,	152	,	41	,	50	,	80000	,	160000	--	Hengcai88SuperUUS
union all select	13626184	,	152	,	51	,	50	,	80000	,	160000	--	Hengcai88SuperUUS
union all select	13626184	,	153	,	51	,	50	,	80000	,	160000	--	Hengcai88SuperUUS
union all select	1574036	,	151	,	31	,	10	,	1500	,	30000	--	MS88SuperSD$
union all select	1574036	,	151	,	41	,	10	,	1500	,	5000	--	MS88SuperSD$
union all select	1574036	,	151	,	51	,	10	,	1500	,	40000	--	MS88SuperSD$
union all select	1574036	,	152	,	41	,	10	,	1999	,	5000	--	MS88SuperSD$
union all select	1574036	,	152	,	51	,	10	,	20000	,	40000	--	MS88SuperSD$
union all select	1574036	,	153	,	51	,	10	,	20000	,	40000	--	MS88SuperSD$
union all select	1574028	,	151	,	31	,	30	,	4000	,	80000	--	MS88SuperRM
union all select	1574028	,	151	,	41	,	30	,	4000	,	5000	--	MS88SuperRM
union all select	1574028	,	151	,	51	,	30	,	4000	,	80000	--	MS88SuperRM
union all select	1574028	,	152	,	41	,	30	,	2999	,	5000	--	MS88SuperRM
union all select	1574028	,	152	,	51	,	30	,	40000	,	80000	--	MS88SuperRM
union all select	1574028	,	153	,	51	,	30	,	40000	,	80000	--	MS88SuperRM
union all select	1573954	,	151	,	31	,	10	,	1200	,	30000	--	MS88SuperUS$
union all select	1573954	,	151	,	41	,	10	,	1200	,	2000	--	MS88SuperUS$
union all select	1573954	,	151	,	51	,	10	,	1200	,	30000	--	MS88SuperUS$
union all select	1573954	,	152	,	41	,	10	,	499	,	2000	--	MS88SuperUS$
union all select	1573954	,	152	,	51	,	10	,	15000	,	30000	--	MS88SuperUS$
union all select	1573954	,	153	,	51	,	10	,	15000	,	30000	--	MS88SuperUS$
union all select	1573967	,	151	,	31	,	300	,	40000	,	800000	--	MS88SuperTB
union all select	1573967	,	151	,	41	,	300	,	40000	,	50000	--	MS88SuperTB
union all select	1573967	,	151	,	51	,	300	,	40000	,	800000	--	MS88SuperTB
union all select	1573967	,	152	,	41	,	300	,	29999	,	50000	--	MS88SuperTB
union all select	1573967	,	152	,	51	,	300	,	400000	,	800000	--	MS88SuperTB
union all select	1573967	,	153	,	51	,	300	,	400000	,	800000	--	MS88SuperTB
union all select	1574024	,	151	,	31	,	20	,	10000	,	160000	--	MS88SuperHK$
union all select	1574024	,	151	,	41	,	10	,	10000	,	10000	--	MS88SuperHK$
union all select	1574024	,	151	,	51	,	30	,	10000	,	160000	--	MS88SuperHK$
union all select	1574024	,	152	,	41	,	10	,	3999	,	10000	--	MS88SuperHK$
union all select	1574024	,	152	,	51	,	30	,	80000	,	160000	--	MS88SuperHK$
union all select	1574024	,	153	,	51	,	30	,	80000	,	160000	--	MS88SuperHK$
union all select	1573960	,	151	,	31	,	10	,	1000	,	20000	--	MS88SuperEURO
union all select	1573960	,	151	,	41	,	10	,	1000	,	2000	--	MS88SuperEURO
union all select	1573960	,	151	,	51	,	10	,	1000	,	20000	--	MS88SuperEURO
union all select	1573960	,	152	,	41	,	10	,	499	,	2000	--	MS88SuperEURO
union all select	1573960	,	152	,	51	,	10	,	10000	,	20000	--	MS88SuperEURO
union all select	1573960	,	153	,	51	,	10	,	10000	,	20000	--	MS88SuperEURO
union all select	1574016	,	151	,	31	,	5	,	1400	,	30000	--	MS88SuperAUD
union all select	1574016	,	151	,	41	,	10	,	1400	,	30000	--	MS88SuperAUD
union all select	1574016	,	151	,	51	,	5	,	1400	,	30000	--	MS88SuperAUD
union all select	1574016	,	152	,	41	,	10	,	15000	,	30000	--	MS88SuperAUD
union all select	1574016	,	152	,	51	,	5	,	15000	,	30000	--	MS88SuperAUD
union all select	1574016	,	153	,	51	,	5	,	15000	,	30000	--	MS88SuperAUD
union all select	1573975	,	151	,	31	,	10	,	800	,	20000	--	MS88SuperGBP
union all select	1573975	,	151	,	41	,	10	,	800	,	20000	--	MS88SuperGBP
union all select	1573975	,	151	,	51	,	10	,	800	,	20000	--	MS88SuperGBP
union all select	1573975	,	152	,	41	,	10	,	10000	,	20000	--	MS88SuperGBP
union all select	1573975	,	152	,	51	,	10	,	10000	,	20000	--	MS88SuperGBP
union all select	1573975	,	153	,	51	,	10	,	10000	,	20000	--	MS88SuperGBP
union all select	1574008	,	151	,	31	,	50	,	7000	,	160000	--	MS88SuperRMB
union all select	1574008	,	151	,	41	,	50	,	7000	,	10000	--	MS88SuperRMB
union all select	1574008	,	151	,	51	,	50	,	7000	,	160000	--	MS88SuperRMB
union all select	1574008	,	152	,	41	,	50	,	3999	,	10000	--	MS88SuperRMB
union all select	1574008	,	152	,	51	,	50	,	80000	,	160000	--	MS88SuperRMB
union all select	1574008	,	153	,	51	,	50	,	80000	,	160000	--	MS88SuperRMB
union all select	1574102	,	151	,	31	,	50	,	12000	,	240000	--	MS88SuperIN
union all select	1574102	,	151	,	41	,	100	,	12000	,	240000	--	MS88SuperIN
union all select	1574102	,	151	,	51	,	50	,	12000	,	240000	--	MS88SuperIN
union all select	1574102	,	152	,	41	,	100	,	120000	,	240000	--	MS88SuperIN
union all select	1574102	,	152	,	51	,	50	,	120000	,	240000	--	MS88SuperIN
union all select	1574102	,	153	,	51	,	50	,	120000	,	240000	--	MS88SuperIN
union all select	1574095	,	151	,	31	,	10	,	500	,	1500	--	MS88SuperUUS
union all select	1574095	,	151	,	41	,	10	,	500	,	1500	--	MS88SuperUUS
union all select	1574095	,	151	,	51	,	5	,	15000	,	30000	--	MS88SuperUUS
union all select	1574095	,	152	,	41	,	10	,	500	,	1500	--	MS88SuperUUS
union all select	1574095	,	152	,	51	,	5	,	15000	,	30000	--	MS88SuperUUS
union all select	1574095	,	153	,	51	,	5	,	15000	,	30000	--	MS88SuperUUS
union all select	2397872	,	151	,	31	,	700	,	110000	,	2000000	--	MS88SuperJPY
union all select	2397872	,	151	,	41	,	700	,	110000	,	2000000	--	MS88SuperJPY
union all select	2397872	,	151	,	51	,	700	,	110000	,	2000000	--	MS88SuperJPY
union all select	2397872	,	152	,	41	,	700	,	1000000	,	2000000	--	MS88SuperJPY
union all select	2397872	,	152	,	51	,	700	,	1000000	,	2000000	--	MS88SuperJPY
union all select	2397872	,	153	,	51	,	700	,	1000000	,	2000000	--	MS88SuperJPY
union all select	2397885	,	151	,	31	,	7000	,	1200000	,	32000000	--	MS88SuperWON
union all select	2397885	,	151	,	41	,	7000	,	1200000	,	32000000	--	MS88SuperWON
union all select	2397885	,	151	,	51	,	7000	,	1200000	,	32000000	--	MS88SuperWON
union all select	2397885	,	152	,	41	,	7000	,	16000000	,	32000000	--	MS88SuperWON
union all select	2397885	,	152	,	51	,	7000	,	16000000	,	32000000	--	MS88SuperWON
union all select	2397885	,	153	,	51	,	7000	,	16000000	,	32000000	--	MS88SuperWON
union all select	1574083	,	151	,	31	,	5	,	1500	,	30000	--	MS88SuperBND
union all select	1574083	,	151	,	41	,	10	,	1500	,	30000	--	MS88SuperBND
union all select	1574083	,	151	,	51	,	5	,	1500	,	30000	--	MS88SuperBND
union all select	1574083	,	152	,	41	,	10	,	15000	,	30000	--	MS88SuperBND
union all select	1574083	,	152	,	51	,	5	,	15000	,	30000	--	MS88SuperBND
union all select	1574083	,	153	,	51	,	5	,	15000	,	30000	--	MS88SuperBND
union all select	3287311	,	151	,	31	,	150	,	12000	,	20000	--	MS88SuperINH
union all select	3287311	,	151	,	41	,	150	,	12000	,	99999	--	MS88SuperINH
union all select	3287311	,	151	,	51	,	150	,	12000	,	80000	--	MS88SuperINH
union all select	3287311	,	152	,	41	,	150	,	9999	,	99999	--	MS88SuperINH
union all select	3287311	,	152	,	51	,	150	,	40000	,	80000	--	MS88SuperINH
union all select	3287311	,	153	,	51	,	150	,	40000	,	80000	--	MS88SuperINH
union all select	5068911	,	151	,	31	,	500	,	70000	,	100000	--	MS88SuperINR
union all select	5068911	,	151	,	41	,	500	,	70000	,	100000	--	MS88SuperINR
union all select	5068911	,	151	,	51	,	500	,	70000	,	100000	--	MS88SuperINR
union all select	5068911	,	152	,	41	,	500	,	30000	,	100000	--	MS88SuperINR
union all select	5068911	,	152	,	51	,	500	,	30000	,	100000	--	MS88SuperINR
union all select	5068911	,	153	,	51	,	500	,	30000	,	100000	--	MS88SuperINR
union all select	3544240	,	151	,	31	,	30	,	4000	,	80000	--	MFSuperRM
union all select	3544240	,	151	,	41	,	30	,	4000	,	0	--	MFSuperRM
union all select	3544240	,	151	,	51	,	30	,	4000	,	80000	--	MFSuperRM
union all select	3544240	,	152	,	41	,	30	,	0	,	0	--	MFSuperRM
union all select	3544240	,	152	,	51	,	30	,	40000	,	80000	--	MFSuperRM
union all select	3544240	,	153	,	51	,	30	,	40000	,	80000	--	MFSuperRM
union all select	3752544	,	151	,	31	,	10	,	1200	,	160000	--	MFSuperUS$
union all select	3752544	,	151	,	41	,	10	,	1200	,	160000	--	MFSuperUS$
union all select	3752544	,	151	,	51	,	10	,	1200	,	160000	--	MFSuperUS$
union all select	3752544	,	152	,	41	,	10	,	30000	,	160000	--	MFSuperUS$
union all select	3752544	,	152	,	51	,	10	,	30000	,	160000	--	MFSuperUS$
union all select	3752544	,	153	,	51	,	10	,	30000	,	160000	--	MFSuperUS$
union all select	3544312	,	151	,	31	,	300	,	40000	,	800000	--	MFSuperTB
union all select	3544312	,	151	,	41	,	300	,	40000	,	0	--	MFSuperTB
union all select	3544312	,	151	,	51	,	300	,	40000	,	800000	--	MFSuperTB
union all select	3544312	,	152	,	41	,	300	,	0	,	0	--	MFSuperTB
union all select	3544312	,	152	,	51	,	300	,	400000	,	800000	--	MFSuperTB
union all select	3544312	,	153	,	51	,	300	,	400000	,	800000	--	MFSuperTB
union all select	7604551	,	151	,	31	,	0	,	1000	,	0	--	MFSuperEURO
union all select	7604551	,	151	,	41	,	0	,	1000	,	0	--	MFSuperEURO
union all select	7604551	,	151	,	51	,	0	,	1000	,	0	--	MFSuperEURO
union all select	7604551	,	152	,	41	,	0	,	0	,	0	--	MFSuperEURO
union all select	7604551	,	152	,	51	,	0	,	0	,	0	--	MFSuperEURO
union all select	7604551	,	153	,	51	,	0	,	0	,	0	--	MFSuperEURO
union all select	3752050	,	151	,	31	,	20	,	80000	,	160000	--	MFSuperRMB
union all select	3752050	,	151	,	41	,	50	,	7000	,	160000	--	MFSuperRMB
union all select	3752050	,	151	,	51	,	30	,	32000	,	160000	--	MFSuperRMB
union all select	3752050	,	152	,	41	,	50	,	7000	,	160000	--	MFSuperRMB
union all select	3752050	,	152	,	51	,	30	,	32000	,	160000	--	MFSuperRMB
union all select	3752050	,	153	,	51	,	30	,	32000	,	160000	--	MFSuperRMB
union all select	3544377	,	151	,	31	,	50	,	12000	,	240000	--	MFSuperIN
union all select	3544377	,	151	,	41	,	100	,	12000	,	240000	--	MFSuperIN
union all select	3544377	,	151	,	51	,	50	,	12000	,	240000	--	MFSuperIN
union all select	3544377	,	152	,	41	,	100	,	120000	,	240000	--	MFSuperIN
union all select	3544377	,	152	,	51	,	50	,	120000	,	240000	--	MFSuperIN
union all select	3544377	,	153	,	51	,	50	,	120000	,	240000	--	MFSuperIN
union all select	3543918	,	151	,	31	,	0	,	0	,	0	--	MFSuperUUS
union all select	3543918	,	151	,	41	,	0	,	0	,	0	--	MFSuperUUS
union all select	3543918	,	151	,	51	,	5	,	15000	,	30000	--	MFSuperUUS
union all select	3543918	,	152	,	41	,	0	,	0	,	0	--	MFSuperUUS
union all select	3543918	,	152	,	51	,	5	,	15000	,	30000	--	MFSuperUUS
union all select	3543918	,	153	,	51	,	5	,	15000	,	30000	--	MFSuperUUS
union all select	3763288	,	151	,	31	,	700	,	110000	,	2000000	--	MFSuperJPY
union all select	3763288	,	151	,	41	,	700	,	110000	,	4000000	--	MFSuperJPY
union all select	3763288	,	151	,	51	,	700	,	110000	,	2000000	--	MFSuperJPY
union all select	3763288	,	152	,	41	,	700	,	1200000	,	4000000	--	MFSuperJPY
union all select	3763288	,	152	,	51	,	700	,	1000000	,	2000000	--	MFSuperJPY
union all select	3763288	,	153	,	51	,	700	,	1000000	,	2000000	--	MFSuperJPY
union all select	13105568	,	151	,	31	,	50	,	7000	,	160000	--	Salon365SuperRMB
union all select	13105568	,	151	,	41	,	50	,	7000	,	160000	--	Salon365SuperRMB
union all select	13105568	,	151	,	51	,	50	,	7000	,	160000	--	Salon365SuperRMB
union all select	13105568	,	152	,	41	,	50	,	80000	,	160000	--	Salon365SuperRMB
union all select	13105568	,	152	,	51	,	50	,	80000	,	160000	--	Salon365SuperRMB
union all select	13105568	,	153	,	51	,	50	,	80000	,	160000	--	Salon365SuperRMB
union all select	13106576	,	151	,	31	,	50	,	7000	,	160000	--	Salon365SuperUUS
union all select	13106576	,	151	,	41	,	50	,	7000	,	160000	--	Salon365SuperUUS
union all select	13106576	,	151	,	51	,	50	,	7000	,	160000	--	Salon365SuperUUS
union all select	13106576	,	152	,	41	,	50	,	80000	,	160000	--	Salon365SuperUUS
union all select	13106576	,	152	,	51	,	50	,	80000	,	160000	--	Salon365SuperUUS
union all select	13106576	,	153	,	51	,	50	,	80000	,	160000	--	Salon365SuperUUS
union all select	13105479	,	151	,	31	,	50	,	7000	,	160000	--	SaloncsSuperRMB
union all select	13105479	,	151	,	41	,	50	,	7000	,	160000	--	SaloncsSuperRMB
union all select	13105479	,	151	,	51	,	50	,	7000	,	160000	--	SaloncsSuperRMB
union all select	13105479	,	152	,	41	,	50	,	80000	,	160000	--	SaloncsSuperRMB
union all select	13105479	,	152	,	51	,	50	,	80000	,	160000	--	SaloncsSuperRMB
union all select	13105479	,	153	,	51	,	50	,	80000	,	160000	--	SaloncsSuperRMB
union all select	13107046	,	151	,	31	,	50	,	7000	,	160000	--	SaloncsSuperUUS
union all select	13107046	,	151	,	41	,	50	,	7000	,	160000	--	SaloncsSuperUUS
union all select	13107046	,	151	,	51	,	50	,	7000	,	160000	--	SaloncsSuperUUS
union all select	13107046	,	152	,	41	,	50	,	80000	,	160000	--	SaloncsSuperUUS
union all select	13107046	,	152	,	51	,	50	,	80000	,	160000	--	SaloncsSuperUUS
union all select	13107046	,	153	,	51	,	50	,	80000	,	160000	--	SaloncsSuperUUS
union all select	7140934	,	151	,	31	,	10	,	1500	,	30000	--	VCasiaSuperSD$
union all select	7140934	,	151	,	41	,	10	,	1500	,	40000	--	VCasiaSuperSD$
union all select	7140934	,	151	,	51	,	10	,	1500	,	40000	--	VCasiaSuperSD$
union all select	7140934	,	152	,	41	,	10	,	20000	,	40000	--	VCasiaSuperSD$
union all select	7140934	,	152	,	51	,	10	,	20000	,	40000	--	VCasiaSuperSD$
union all select	7140934	,	153	,	51	,	10	,	20000	,	40000	--	VCasiaSuperSD$
union all select	7140747	,	151	,	31	,	10	,	1200	,	30000	--	VcasiaSuperUS$
union all select	7140747	,	151	,	41	,	10	,	1200	,	30000	--	VcasiaSuperUS$
union all select	7140747	,	151	,	51	,	10	,	1200	,	30000	--	VcasiaSuperUS$
union all select	7140747	,	152	,	41	,	10	,	15000	,	30000	--	VcasiaSuperUS$
union all select	7140747	,	152	,	51	,	10	,	15000	,	30000	--	VcasiaSuperUS$
union all select	7140747	,	153	,	51	,	10	,	15000	,	30000	--	VcasiaSuperUS$
union all select	7140648	,	151	,	31	,	10	,	1000	,	20000	--	VCasiaSuperEuro
union all select	7140648	,	151	,	41	,	10	,	1000	,	20000	--	VCasiaSuperEuro
union all select	7140648	,	151	,	51	,	10	,	1000	,	20000	--	VCasiaSuperEuro
union all select	7140648	,	152	,	41	,	10	,	10000	,	20000	--	VCasiaSuperEuro
union all select	7140648	,	152	,	51	,	10	,	10000	,	20000	--	VCasiaSuperEuro
union all select	7140648	,	153	,	51	,	10	,	10000	,	20000	--	VCasiaSuperEuro
union all select	7140807	,	151	,	31	,	5	,	1400	,	30000	--	VCasiaSuperAUD
union all select	7140807	,	151	,	41	,	10	,	1400	,	30000	--	VCasiaSuperAUD
union all select	7140807	,	151	,	51	,	5	,	1400	,	30000	--	VCasiaSuperAUD
union all select	7140807	,	152	,	41	,	10	,	15000	,	30000	--	VCasiaSuperAUD
union all select	7140807	,	152	,	51	,	5	,	15000	,	30000	--	VCasiaSuperAUD
union all select	7140807	,	153	,	51	,	5	,	15000	,	30000	--	VCasiaSuperAUD
union all select	7140071	,	151	,	31	,	10	,	800	,	20000	--	VCasiaSuperGBP
union all select	7140071	,	151	,	41	,	10	,	800	,	20000	--	VCasiaSuperGBP
union all select	7140071	,	151	,	51	,	10	,	800	,	20000	--	VCasiaSuperGBP
union all select	7140071	,	152	,	41	,	10	,	10000	,	20000	--	VCasiaSuperGBP
union all select	7140071	,	152	,	51	,	10	,	10000	,	20000	--	VCasiaSuperGBP
union all select	7140071	,	153	,	51	,	10	,	10000	,	20000	--	VCasiaSuperGBP
union all select	7141027	,	151	,	31	,	50	,	7000	,	160000	--	VCasiaSuperRMB
union all select	7141027	,	151	,	41	,	50	,	7000	,	160000	--	VCasiaSuperRMB
union all select	7141027	,	151	,	51	,	50	,	7000	,	160000	--	VCasiaSuperRMB
union all select	7141027	,	152	,	41	,	50	,	80000	,	160000	--	VCasiaSuperRMB
union all select	7141027	,	152	,	51	,	50	,	80000	,	160000	--	VCasiaSuperRMB
union all select	7141027	,	153	,	51	,	50	,	80000	,	160000	--	VCasiaSuperRMB
union all select	4845960	,	151	,	31	,	10	,	15000	,	300000	--	VCasiaSuperUUS
union all select	4845960	,	151	,	41	,	10	,	15000	,	300000	--	VCasiaSuperUUS
union all select	4845960	,	151	,	51	,	10	,	15000	,	300000	--	VCasiaSuperUUS
union all select	4845960	,	152	,	41	,	10	,	15000	,	300000	--	VCasiaSuperUUS
union all select	4845960	,	152	,	51	,	10	,	15000	,	300000	--	VCasiaSuperUUS
union all select	4845960	,	153	,	51	,	10	,	15000	,	300000	--	VCasiaSuperUUS
union all select	11387211	,	151	,	31	,	30	,	4000	,	80000	--	VWinSuperRM
union all select	11387211	,	151	,	41	,	30	,	4000	,	80000	--	VWinSuperRM
union all select	11387211	,	151	,	51	,	30	,	4000	,	80000	--	VWinSuperRM
union all select	11387211	,	152	,	41	,	30	,	40000	,	80000	--	VWinSuperRM
union all select	11387211	,	152	,	51	,	30	,	40000	,	80000	--	VWinSuperRM
union all select	11387211	,	153	,	51	,	30	,	40000	,	80000	--	VWinSuperRM
union all select	7596783	,	151	,	31	,	5	,	15000	,	30000	--	VwinSuperUS$
union all select	7596783	,	151	,	41	,	10	,	1200	,	30000	--	VwinSuperUS$
union all select	7596783	,	151	,	51	,	5	,	3000	,	30000	--	VwinSuperUS$
union all select	7596783	,	152	,	41	,	10	,	1200	,	30000	--	VwinSuperUS$
union all select	7596783	,	152	,	51	,	5	,	3000	,	30000	--	VwinSuperUS$
union all select	7596783	,	153	,	51	,	5	,	3000	,	30000	--	VwinSuperUS$
union all select	11387220	,	151	,	31	,	100	,	400000	,	800000	--	VWinSuperTB
union all select	11387220	,	151	,	41	,	300	,	40000	,	800000	--	VWinSuperTB
union all select	11387220	,	151	,	51	,	300	,	200000	,	200000	--	VWinSuperTB
union all select	11387220	,	152	,	41	,	300	,	40000	,	800000	--	VWinSuperTB
union all select	11387220	,	152	,	51	,	300	,	200000	,	200000	--	VWinSuperTB
union all select	11387220	,	153	,	51	,	300	,	200000	,	200000	--	VWinSuperTB
union all select	7596324	,	151	,	31	,	0	,	1000	,	0	--	VwinSuperEURO
union all select	7596324	,	151	,	41	,	0	,	1000	,	0	--	VwinSuperEURO
union all select	7596324	,	151	,	51	,	0	,	1000	,	0	--	VwinSuperEURO
union all select	7596324	,	152	,	41	,	0	,	0	,	0	--	VwinSuperEURO
union all select	7596324	,	152	,	51	,	0	,	0	,	0	--	VwinSuperEURO
union all select	7596324	,	153	,	51	,	0	,	0	,	0	--	VwinSuperEURO
union all select	10380749	,	151	,	31	,	20	,	80000	,	160000	--	VWINSuperRMB
union all select	10380749	,	151	,	41	,	50	,	7000	,	160000	--	VWINSuperRMB
union all select	10380749	,	151	,	51	,	30	,	32000	,	160000	--	VWINSuperRMB
union all select	10380749	,	152	,	41	,	50	,	7000	,	160000	--	VWINSuperRMB
union all select	10380749	,	152	,	51	,	30	,	32000	,	160000	--	VWINSuperRMB
union all select	10380749	,	153	,	51	,	30	,	32000	,	160000	--	VWINSuperRMB
union all select	11387229	,	151	,	31	,	50	,	120000	,	240000	--	VWinSuperIN
union all select	11387229	,	151	,	41	,	100	,	12000	,	240000	--	VWinSuperIN
union all select	11387229	,	151	,	51	,	50	,	48000	,	300000	--	VWinSuperIN
union all select	11387229	,	152	,	41	,	100	,	12000	,	240000	--	VWinSuperIN
union all select	11387229	,	152	,	51	,	50	,	48000	,	300000	--	VWinSuperIN
union all select	11387229	,	153	,	51	,	50	,	48000	,	300000	--	VWinSuperIN
union all select	4854900	,	151	,	31	,	50	,	7000	,	160000	--	VwinSuperUUS
union all select	4854900	,	151	,	41	,	50	,	7000	,	160000	--	VwinSuperUUS
union all select	4854900	,	151	,	51	,	50	,	7000	,	160000	--	VwinSuperUUS
union all select	4854900	,	152	,	41	,	50	,	80000	,	160000	--	VwinSuperUUS
union all select	4854900	,	152	,	51	,	50	,	80000	,	160000	--	VwinSuperUUS
union all select	4854900	,	153	,	51	,	50	,	80000	,	160000	--	VwinSuperUUS
union all select	13461694	,	151	,	31	,	700	,	110000	,	2200000	--	VwinSuperJPY
union all select	13461694	,	151	,	41	,	700	,	110000	,	2200000	--	VwinSuperJPY
union all select	13461694	,	151	,	51	,	700	,	110000	,	2200000	--	VwinSuperJPY
union all select	13461694	,	152	,	41	,	700	,	1100000	,	2200000	--	VwinSuperJPY
union all select	13461694	,	152	,	51	,	700	,	1100000	,	2200000	--	VwinSuperJPY
union all select	13461694	,	153	,	51	,	700	,	1100000	,	2200000	--	VwinSuperJPY
union all select	13461733	,	151	,	31	,	7000	,	1200000	,	29500000	--	VwinSuperWon
union all select	13461733	,	151	,	41	,	7000	,	1200000	,	29500000	--	VwinSuperWon
union all select	13461733	,	151	,	51	,	7000	,	1200000	,	29500000	--	VwinSuperWon
union all select	13461733	,	152	,	41	,	7000	,	14800000	,	29500000	--	VwinSuperWon
union all select	13461733	,	152	,	51	,	7000	,	14800000	,	29500000	--	VwinSuperWon
union all select	13461733	,	153	,	51	,	7000	,	14800000	,	29500000	--	VwinSuperWon
union all select	11387238	,	151	,	31	,	70	,	120000	,	240000	--	VWinSuperINH
union all select	11387238	,	151	,	41	,	150	,	12000	,	240000	--	VWinSuperINH
union all select	11387238	,	151	,	51	,	70	,	100000	,	300000	--	VWinSuperINH
union all select	11387238	,	152	,	41	,	150	,	12000	,	240000	--	VWinSuperINH
union all select	11387238	,	152	,	51	,	70	,	100000	,	300000	--	VWinSuperINH
union all select	11387238	,	153	,	51	,	70	,	100000	,	300000	--	VWinSuperINH
union all select	10580795	,	151	,	31	,	30	,	4000	,	80000	--	W88SuperRM
union all select	10580795	,	151	,	41	,	30	,	4000	,	80000	--	W88SuperRM
union all select	10580795	,	151	,	51	,	30	,	4000	,	80000	--	W88SuperRM
union all select	10580795	,	152	,	41	,	30	,	40000	,	80000	--	W88SuperRM
union all select	10580795	,	152	,	51	,	30	,	40000	,	80000	--	W88SuperRM
union all select	10580795	,	153	,	51	,	30	,	40000	,	80000	--	W88SuperRM
union all select	10580805	,	151	,	31	,	10	,	1200	,	30000	--	W88SuperUS$
union all select	10580805	,	151	,	41	,	10	,	1200	,	30000	--	W88SuperUS$
union all select	10580805	,	151	,	51	,	10	,	1200	,	30000	--	W88SuperUS$
union all select	10580805	,	152	,	41	,	10	,	15000	,	30000	--	W88SuperUS$
union all select	10580805	,	152	,	51	,	10	,	15000	,	30000	--	W88SuperUS$
union all select	10580805	,	153	,	51	,	10	,	15000	,	30000	--	W88SuperUS$
union all select	10580767	,	151	,	31	,	300	,	40000	,	800000	--	W88SuperTB
union all select	10580767	,	151	,	41	,	300	,	40000	,	800000	--	W88SuperTB
union all select	10580767	,	151	,	51	,	300	,	40000	,	800000	--	W88SuperTB
union all select	10580767	,	152	,	41	,	300	,	400000	,	800000	--	W88SuperTB
union all select	10580767	,	152	,	51	,	300	,	400000	,	800000	--	W88SuperTB
union all select	10580767	,	153	,	51	,	300	,	400000	,	800000	--	W88SuperTB
union all select	10580824	,	151	,	31	,	10	,	1000	,	20000	--	W88SuperEURO
union all select	10580824	,	151	,	41	,	10	,	1000	,	20000	--	W88SuperEURO
union all select	10580824	,	151	,	51	,	10	,	1000	,	20000	--	W88SuperEURO
union all select	10580824	,	152	,	41	,	10	,	10000	,	20000	--	W88SuperEURO
union all select	10580824	,	152	,	51	,	10	,	10000	,	20000	--	W88SuperEURO
union all select	10580824	,	153	,	51	,	10	,	10000	,	20000	--	W88SuperEURO
union all select	10580814	,	151	,	31	,	5	,	1400	,	30000	--	W88SuperAUD
union all select	10580814	,	151	,	41	,	10	,	1400	,	30000	--	W88SuperAUD
union all select	10580814	,	151	,	51	,	5	,	1400	,	30000	--	W88SuperAUD
union all select	10580814	,	152	,	41	,	10	,	15000	,	30000	--	W88SuperAUD
union all select	10580814	,	152	,	51	,	5	,	15000	,	30000	--	W88SuperAUD
union all select	10580814	,	153	,	51	,	5	,	15000	,	30000	--	W88SuperAUD
union all select	10580835	,	151	,	31	,	10	,	800	,	20000	--	W88SuperGBP
union all select	10580835	,	151	,	41	,	10	,	800	,	20000	--	W88SuperGBP
union all select	10580835	,	151	,	51	,	10	,	800	,	20000	--	W88SuperGBP
union all select	10580835	,	152	,	41	,	10	,	10000	,	20000	--	W88SuperGBP
union all select	10580835	,	152	,	51	,	10	,	10000	,	20000	--	W88SuperGBP
union all select	10580835	,	153	,	51	,	10	,	10000	,	20000	--	W88SuperGBP
union all select	10580722	,	151	,	31	,	50	,	7000	,	160000	--	W88SuperRMB
union all select	10580722	,	151	,	41	,	50	,	7000	,	160000	--	W88SuperRMB
union all select	10580722	,	151	,	51	,	50	,	7000	,	160000	--	W88SuperRMB
union all select	10580722	,	152	,	41	,	50	,	80000	,	160000	--	W88SuperRMB
union all select	10580722	,	152	,	51	,	50	,	80000	,	160000	--	W88SuperRMB
union all select	10580722	,	153	,	51	,	50	,	80000	,	160000	--	W88SuperRMB
union all select	10580776	,	151	,	31	,	50	,	12000	,	240000	--	W88SuperIN
union all select	10580776	,	151	,	41	,	100	,	12000	,	240000	--	W88SuperIN
union all select	10580776	,	151	,	51	,	50	,	12000	,	240000	--	W88SuperIN
union all select	10580776	,	152	,	41	,	100	,	120000	,	240000	--	W88SuperIN
union all select	10580776	,	152	,	51	,	50	,	120000	,	240000	--	W88SuperIN
union all select	10580776	,	153	,	51	,	50	,	120000	,	240000	--	W88SuperIN
union all select	10541896	,	151	,	31	,	10	,	500	,	1500	--	W88SuperUUS
union all select	10541896	,	151	,	41	,	10	,	499	,	1500	--	W88SuperUUS
union all select	10541896	,	151	,	51	,	5	,	15000	,	30000	--	W88SuperUUS
union all select	10541896	,	152	,	41	,	10	,	499	,	1500	--	W88SuperUUS
union all select	10541896	,	152	,	51	,	5	,	15000	,	30000	--	W88SuperUUS
union all select	10541896	,	153	,	51	,	5	,	15000	,	30000	--	W88SuperUUS
union all select	10580846	,	151	,	31	,	700	,	110000	,	2200000	--	W88SuperJPY
union all select	10580846	,	151	,	41	,	700	,	110000	,	2200000	--	W88SuperJPY
union all select	10580846	,	151	,	51	,	700	,	110000	,	2200000	--	W88SuperJPY
union all select	10580846	,	152	,	41	,	700	,	1100000	,	2200000	--	W88SuperJPY
union all select	10580846	,	152	,	51	,	700	,	1100000	,	2200000	--	W88SuperJPY
union all select	10580846	,	153	,	51	,	700	,	1100000	,	2200000	--	W88SuperJPY
union all select	12613176	,	151	,	31	,	500	,	1200000	,	29500000	--	W88SuperWON
union all select	12613176	,	151	,	41	,	500	,	1200000	,	29500000	--	W88SuperWON
union all select	12613176	,	151	,	51	,	500	,	1200000	,	29500000	--	W88SuperWON
union all select	12613176	,	152	,	41	,	500	,	14800000	,	29500000	--	W88SuperWON
union all select	12613176	,	152	,	51	,	500	,	14800000	,	29500000	--	W88SuperWON
union all select	12613176	,	153	,	51	,	500	,	14800000	,	29500000	--	W88SuperWON
union all select	10580785	,	151	,	31	,	150	,	12000	,	20000	--	W88SuperINH
union all select	10580785	,	151	,	41	,	150	,	12000	,	99999	--	W88SuperINH
union all select	10580785	,	151	,	51	,	150	,	12000	,	80000	--	W88SuperINH
union all select	10580785	,	152	,	41	,	150	,	9999	,	99999	--	W88SuperINH
union all select	10580785	,	152	,	51	,	150	,	40000	,	80000	--	W88SuperINH
union all select	10580785	,	153	,	51	,	150	,	40000	,	80000	--	W88SuperINH
union all select	10580858	,	151	,	31	,	500	,	70000	,	1400000	--	W88SuperINR
union all select	10580858	,	151	,	41	,	500	,	70000	,	1400000	--	W88SuperINR
union all select	10580858	,	151	,	51	,	500	,	70000	,	1400000	--	W88SuperINR
union all select	10580858	,	152	,	41	,	500	,	700000	,	1400000	--	W88SuperINR
union all select	10580858	,	152	,	51	,	500	,	700000	,	1400000	--	W88SuperINR
union all select	10580858	,	153	,	51	,	500	,	700000	,	1400000	--	W88SuperINR

DECLARE @srecommend INT, @max_custid INT, @sporttype INT, @bettype INT, @minbet MONEY, @maxbet MONEY, @maxpermatch MONEY

SET @max_custid = xxx

WHILE (1=1)
BEGIN

	UPDATE TOP(1) #DepSettings
	SET @srecommend = custid,
		@sporttype = sporttype,
		@bettype = bettype,
		@minbet = minbet,
		@maxbet = maxbet,
		@maxpermatch = maxpermatch,
		isfinished = 1
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
		,@sporttype = @sporttype
		,@bettype = @bettype
		,@minbet = @minbet
		,@maxbet = @maxbet
		,@maxpermatch = @maxpermatch		
		,@maxcustid = @max_custid
		,@target = 'DBTRANS'
		
	WAITFOR DELAY '00:00:00.280'
END
GO
-- END STEP 3: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------
