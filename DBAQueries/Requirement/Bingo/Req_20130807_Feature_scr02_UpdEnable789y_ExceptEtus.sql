 ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	
	@ids varchar(max)
AS
SET NOCOUNT ON

/*
	Task: update sync & enable Bingo for all customer of 789 except Etus Headline
	
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
					3390616	, --QHN
					3390621	, --QVN
					262627	, --SCC
					262637	, --SCK
					3412762	, --SHB
					3508886	, --SHD
					2198456	, --SKA
					2793195	, --SKAA
					2798869	, --SKAB
					2798950	, --SKAC
					2850839	, --SKAD
					2853316	, --SKAE
					2877199	, --SKAF
					2975866	, --SKAG
					3024023	, --SKAH
					3024027	, --SKAI
					3024035	, --SKAJ
					3390623	, --SKAN
					3472707	, --SKAO
					3472732	, --SKAP
					3535165	, --SKAR
					3675856	, --SKAS
					3675859	, --SKAT
					4166219	, --skau
					4166221	, --skav
					4664102	, --skaw
					4664106	, --skax
					4664111	, --skay
					5208493	, --skaz
					2198458	, --SKB
					5208504	, --skba
					5208528	, --skbb
					5881765	, --SKBC
					5881771	, --SKBD
					5933382	, --SKBE
					5933395	, --SKBF
					6000983	, --skbg
					6001004	, --skbh
					6660090	, --SKBI
					6660095	, --SKBJ
					7164448	, --SKBK
					7164462	, --SKBL
					7164469	, --SKBM
					8296284	, --skbn
					11578859	, --SKBO
					11579157	, --skbp
					11889755	, --SKBQ
					11579291	, --SKBT
					11579683	, --SKBU
					1727939	, --SKD
					1977102	, --SKE
					1977147	, --SKF
					1977150	, --SKG
					1978806	, --SKH
					2113740	, --SKI
					2126540	, --SKJ
					2462931	, --SKK
					3122695	, --SKKA
					731165	, --SKKS
					2198461	, --SKL
					2793182	, --skn
					2503678	, --SKO
					2793190	, --skp
					2198868	, --SKQ
					923727	, --SKS
					1335772	, --SKT
					11582156	, --SKTA
					11582090	, --SKTB
					11791191	, --sktc
					1727945	, --SKV
					1898175	, --SKW
					1940367	, --SKX
					1999503	, --SKY
					2075785	, --SKZ
					3286734	, --U2
					1435478	, --VID
					391471	, --VIP
					2470330	, --VIU
					7932892	, --AAB
					5340153	, --FYU
					7902402	, --SDA
					5800564	, --SDB
					5800577	, --SDC
					262641	, --SDD
					927679	, --SDDT
					838269	, --SDDTB
					1174759	, --SDE
					5824370	, --SDF
					5824374	, --SDG
					5871571	, --SDI
					5375392	, --SDJ
					5362504	, --SDK
					5362508	, --SDL
					3115630	, --SDM
					5871590	, --SDN
					10181770	, --SDN1
					10181790	, --SDN2
					10558395	, --SDN3
					5394907	, --SDO
					5419321	, --SDP
					9285643	, --SDQ
					9285744	, --SDS
					1077097	, --SDT
					3115624	, --SDU
					5226628	, --SDV
					5226641	, --SDW
					5226650	, --SDX
					5213502	, --SDY
					5915537	, --SDY1
					8265079	, --SDY2
					8812070	, --SDY3
					9020799	, --SDY5
					9432645	, --SDY6
					9659841	, --SDY7
					10223418	, --SDY8
					10675880	, --SDY9
					5226659	, --SDZ
					8394258	, --SQY
					342710	, --SY1B
					6087439	, --SYA
					6087443	, --SYB
					6714757	, --SYC
					9579809	, --SYC2
					10318451	, --SYC3
					7124243	, --SYD
					7209880	, --SYE
					7263508	, --SYF
					7545783	, --SYG
					7596465	, --SYH
					7596486	, --SYJ
					7596503	, --SYK
					7596522	, --SYL
					7596533	, --SYN
					7596541	, --SYO
					7596578	, --SYP
					7596597	, --SYQ
					7596613	, --SYS
					7596636	, --SYU
					7651563	, --SYV
					7651639	, --SYW
					7703331	, --SYY
					8211131	, --SYZ
					8594867	, --SYZ1
					10279904	, --UZA
					11742953	, --TV1
					11743311	, --TV10
					11743322	, --TV11
					11743380	, --TV12
					11743398	, --TV13
					11743411	, --TV14
					11743425	, --TV15
					11746534	, --TV16
					11746581	, --TV17
					11746613	, --TV18
					11746658	, --TV19
					11743087	, --TV2
					11746685	, --TV20
					11743112	, --TV3
					11743132	, --TV4
					11743161	, --TV5
					11743182	, --TV6
					11743211	, --TV7
					11743225	, --TV8
					11743279	, --TV9
					11574203	, --BBA
					1358405	, --BBBU
					3341773	, --HEU
					2491562	, --JU
					10507286	, --JWL
					11576016	, --KKP
					11641121	, --KKQ
					11550395	, --KKU
					11572886	, --KKU1
					11574872	, --KKV
					11733939	, --KKX
					10507224	, --QQUS
					9332492	, --S56US
					10507315	, --S922B
					2770628	, --S922U
					4901252	, --S922US
					324619	 --SPUS
)
	AND (SyncBingo = 0 OR DisableBingo = 1)







--upline of direct members
INSERT INTO #tmpCust(custid)
SELECT 3
UNION ALL SELECT 4176
UNION ALL SELECT 1268


--direct members
INSERT INTO #tmpCust(custid)
		  SELECT 	11746260	 --THAUS
UNION ALL SELECT 	11771775	 --THA1US

 
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
