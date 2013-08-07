 ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids varchar(max)
AS
SET NOCOUNT ON

/*
	Task: update sync & enable Bingo for Etus Headline customer
	
*/
	
BEGIN
	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('custinfo') AND type = 'U') <> 1
		RETURN

	DECLARE @res AS TABLE (custid INT)
	DECLARE @splitter CHAR(1), @string VARCHAR(MAX)

	SELECT @splitter = ',', @string = @ids

	IF SUBSTRING (@string, LEN (@string), 1) <> @splitter
		  SET @string= @string+@splitter

	DECLARE @START INT, @word NVARCHAR(4000), @CHARINDEX INT, @i INT
	SET @i=1
	SET @START=1
	SET @CHARINDEX= CHARINDEX( @splitter, @string, @START)
	WHILE (@CHARINDEX <> 0)BEGIN
		SET @word= SUBSTRING( @string, @START, @CHARINDEX - @START)
		SET @START= @CHARINDEX +1
		SET @CHARINDEX= CHARINDEX( @splitter, @string, @START)
		INSERT INTO @res  VALUES(CAST(@word AS INT))
		SET @i=@i+1
	END
	
		
	UPDATE custinfo WITH(ROWLOCK,UPDLOCK)
	SET SyncBingo = 1
		,DisableBingo = 0
	WHERE custid IN (SELECT * FROM @res)
		
END

GO

DECLARE @max_custid INT
CREATE TABLE #tmpCust (custid INT primary key, isfinished bit default(0))

SET @max_custid = xxx

--downline of supers
INSERT INTO #tmpCust (custid)
SELECT custid 
FROM custinfo WITH(NOLOCK)
WHERE custid <= @max_custid
AND	srecommend IN (
					5480712	, --AZ1
					6406993	, --AZ10
					7604821	, --AZ11
					7604832	, --AZ12
					7604844	, --AZ13
					7604852	, --AZ14
					7604869	, --AZ15
					5480716	, --AZ2
					5480721	, --AZ3
					5480731	, --AZ4
					5480735	, --AZ5
					6406944	, --AZ6
					6406961	, --AZ7
					6406976	, --AZ8
					6406986	, --AZ9
					4873460	, --BC
					5241927	, --BC1
					5241945	, --BC2
					5241964	, --BC3
					5311953	, --BC5
					5311961	, --BC6
					5311965	, --BC7
					5362682	, --BC8
					5362687	, --BC9
					5362694	, --BCA
					4908230	, --BD
					4947571	, --BE
					4996099	, --BG
					5015348	, --BH
					4870143	, --BK
					5015371	, --BL
					5060788	, --BM
					5060793	, --BN
					5108723	, --BO
					5108730	, --BP
					5108737	, --BR
					5160159	, --BX
					5160163	, --BY
					5160175	, --BZ
					1505137	, --EA
					5362712	, --EA1
					5362720	, --EA2
					5362724	, --EA3
					5362729	, --EA4
					5362731	, --EA5
					5718827	, --EA6
					5718831	, --EA7
					5718836	, --EA8
					5718840	, --EA9
					5718851	, --EAA
					5824459	, --EAB
					5824460	, --EAC
					5824466	, --EAD
					5824473	, --EAE
					5824484	, --EAF
					5940542	, --EAG
					5940553	, --EAH
					5940557	, --EAI
					5940565	, --EAJ
					5940574	, --EAK
					6197528	, --EAL
					1505140	, --EB
					6910609	, --EB1
					6910614	, --EB2
					6910618	, --EB3
					6910631	, --EB5
					6910642	, --EB6
					6909004	, --EBA
					6909008	, --EBB
					6909014	, --EBC
					6909021	, --EBD
					6909027	, --EBE
					6909067	, --EBF
					6909106	, --EBG
					6909137	, --EBH
					6909152	, --EBI
					6909165	, --EBJ
					8104518	, --EBK
					8104526	, --EBL
					1539339	, --EC
					1667537	, --EE
					6456973	, --EEA
					1731862	, --EF
					1889065	, --EG
					5812159	, --EG1
					5812172	, --EG2
					5812196	, --EG3
					5812218	, --EG5
					5812228	, --EG6
					1935648	, --EH
					10836879	, --EH1
					10836909	, --EH2
					10836921	, --EH3
					10836940	, --EH5
					10836949	, --EH6
					11211824	, --EH7
					11211847	, --EH8
					11211878	, --EH9
					2063714	, --EI
					2063723	, --EJ
					11211891	, --EJ1
					11211901	, --EJ2
					4079058	, --EJA
					2426461	, --EK
					2426467	, --EL
					2426472	, --EM
					2571383	, --EN
					2822583	, --EO
					2877058	, --EP
					3002011	, --EQ
					3002015	, --ER
					3043749	, --ES
					3043753	, --ET
					7702438	, --ET1
					8594829	, --ET10
					7702445	, --ET2
					7702455	, --ET3
					7702469	, --ET4
					7702473	, --ET5
					8594690	, --ET6
					8594740	, --ET7
					8594787	, --ET8
					8594806	, --ET9
					3318714	, --EU
					3318716	, --EV
					3370732	, --EW
					3379262	, --EX
					3379272	, --EY
					4870194	, --HC
					11474369	, --KX1
					11474444	, --KX10
					11474382	, --KX2
					11474397	, --KX3
					11474407	, --KX4
					11474415	, --KX5
					11474424	, --KX6
					11474429	, --KX7
					11474434	, --KX8
					11474436	, --KX9
					11586973	, --KY1
					11587359	, --KY10
					11635979	, --KY11
					11636059	, --KY12
					11636131	, --KY13
					11636284	, --KY14
					11636318	, --KY15
					11636345	, --KY16
					11636409	, --KY17
					11636436	, --KY18
					11636461	, --KY19
					11587004	, --KY2
					11636471	, --KY20
					11636481	, --KY21
					11636490	, --KY22
					11636516	, --KY23
					11636534	, --KY24
					11636551	, --KY25
					11850282	, --KY26
					11850467	, --KY27
					11850655	, --KY28
					11850827	, --KY29
					11587048	, --KY3
					11850975	, --KY30
					11851102	, --KY31
					11851377	, --KY32
					11851573	, --KY33
					11851664	, --KY34
					11851798	, --KY35
					11587079	, --KY4
					11587125	, --KY5
					11587193	, --KY6
					11587237	, --KY7
					11587251	, --KY8
					11587333	, --KY9
					4406327	, --QA
					4406329	, --QB
					4841141	, --QC
					4533981	, --QD
					4533984	, --QE
					4533988	, --QF
					4533993	, --QG
					4613190	, --QH
					4613199	, --QI
					4689879	, --QJ
					4689920	, --QK
					4689932	, --QL
					4689945	, --QM
					4697415	, --QN
					4697426	, --QO
					4697442	, --QP
					4798284	, --QR
					4759908	, --qs
					4815149	, --QT
					4833640	, --QU
					4900076	, --QV
					595561	, --SC
					1317452	, --SG
					1698753	, --SH
					1113450	, --SM
					300958	, --SQ
					3919562	, --SSA
					3919574	, --SSB
					4058361	, --SSC
					4058379	, --SSE
					3397263	, --XA
					3397267	, --XB
					3397270	, --XC
					3428663	, --XD
					3448871	, --XE
					3448873	, --XF
					3466791	, --XG
					3706024	, --XH
					3518530	, --XJ
					3518536	, --XK
					3518540	, --XL
					3581460	, --XM
					3588788	, --XN
					3667252	, --XO
					3672278	, --XP
					3707684	, --XQ
					3707692	, --XR
					3759851	, --XS
					3764956	, --XT
					595565	, --XX
					3967000	, --XXA
					4113805	, --XXB
					4113806	, --XXC
					4157382	, --XXD
					4157389	, --XXE
					4190683	, --XXF
					4195794	, --XXG
					4195796	, --XXH
					4232989	, --XXJ
					4232994	, --XXK
					4281392	, --XXO
					4281394	, --XXP
					4281456	, --XXQ
					4281463	, --XXR
					4281469	, --XXS
					4629022	, --xxt
					1935623	, --XY
					1935638	 --XZ
)
	AND (SyncBingo = 0 OR DisableBingo = 1)



 
GO
GO

declare @ids varchar(max), @rowcnt int

while (1=1)
begin
	select @ids = ''
	
	update TOP (10000) #tmpCust
	set @ids = @ids + case @ids when '' then '' else ',' end + cast(custid as varchar(12))
		,isfinished = 1
	from #tmpCust
	where isfinished = 0
	
	select @rowcnt = @@rowcount	

	EXEC [Acc_ExecRep_09] @ids = @ids
	
	if @rowcnt < 10000 RETURN

	WAITFOR DELAY '00:00:01'
end
