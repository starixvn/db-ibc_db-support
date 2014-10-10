 /*
	Created: Johnson
	Date: 2014-10-09
	Task: Adjust PT settings for sportbook & VS
	DB: DBTXN/CUSTDB
 */
 
---Sportbook
--HIR	1091262
--PT = 0.7/0.7/0.7
UPDATE CustSetting WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN spositiontaking >0.7 THEN 0.7 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.7 THEN 0.7 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.7 THEN 0.7 ELSE apositiontaking END,
	slivepositiontaking = CASE WHEN slivepositiontaking >0.7 THEN 0.7 ELSE slivepositiontaking END,
	mlivepositiontaking = CASE WHEN mlivepositiontaking >0.7 THEN 0.7 ELSE mlivepositiontaking END,
	alivepositiontaking = CASE WHEN alivepositiontaking >0.7 THEN 0.7 ELSE alivepositiontaking END
WHERE custid = 1091262

--update l4 =0.7
UPDATE CustOverride WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = CASE WHEN maxpositiontaking >0.7 THEN 0.7 ELSE maxpositiontaking END,
	maxlivepositiontaking = CASE WHEN maxlivepositiontaking >0.7 THEN 0.7 ELSE maxlivepositiontaking END
WHERE custid = 1091262
GO


-------------------------------------------------------------------------------
--MTEST (1688074),master MTEST01 (1688137)
--PT = 0.85/0.8/0.75
UPDATE CustSetting WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN spositiontaking >0.85 THEN 0.85 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.8 THEN 0.8 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.75 THEN 0.75 ELSE apositiontaking END,
	slivepositiontaking = CASE WHEN slivepositiontaking >0.85 THEN 0.85 ELSE slivepositiontaking END,
	mlivepositiontaking = CASE WHEN mlivepositiontaking >0.8 THEN 0.8 ELSE mlivepositiontaking END,
	alivepositiontaking = CASE WHEN alivepositiontaking >0.75 THEN 0.75 ELSE alivepositiontaking END
WHERE custid IN (1688074,1688137)

UPDATE CustOverride WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = CASE WHEN maxpositiontaking >0.85 THEN 0.85 ELSE maxpositiontaking END,
	maxlivepositiontaking = CASE WHEN maxlivepositiontaking >0.85 THEN 0.85 ELSE maxlivepositiontaking END
WHERE custid = 1688074
GO


-------------------------------------------------------------------------------
--STE7	3801008
--PT =0.7/0.7/0.7
UPDATE CustSetting WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN spositiontaking >0.7 THEN 0.7 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.7 THEN 0.7 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.7 THEN 0.7 ELSE apositiontaking END,
	slivepositiontaking = CASE WHEN slivepositiontaking >0.7 THEN 0.7 ELSE slivepositiontaking END,
	mlivepositiontaking = CASE WHEN mlivepositiontaking >0.7 THEN 0.7 ELSE mlivepositiontaking END,
	alivepositiontaking = CASE WHEN alivepositiontaking >0.7 THEN 0.7 ELSE alivepositiontaking END
WHERE custid = 3801008

--set l4=0.7
UPDATE CustOverride WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = CASE WHEN maxpositiontaking >0.7 THEN 0.7 ELSE maxpositiontaking END,
	maxlivepositiontaking = CASE WHEN maxlivepositiontaking >0.7 THEN 0.7 ELSE maxlivepositiontaking END
WHERE custid = 3801008

--correct downlines master, agent
UPDATE cs
SET spositiontaking = CASE WHEN spositiontaking >0.7 THEN 0.7 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.7 THEN 0.7 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.7 THEN 0.7 ELSE apositiontaking END,
	slivepositiontaking = CASE WHEN slivepositiontaking >0.7 THEN 0.7 ELSE slivepositiontaking END,
	mlivepositiontaking = CASE WHEN mlivepositiontaking >0.7 THEN 0.7 ELSE mlivepositiontaking END,
	alivepositiontaking = CASE WHEN alivepositiontaking >0.7 THEN 0.7 ELSE alivepositiontaking END,
	autopositiontaking = CASE WHEN autopositiontaking >0.7 THEN 0.7 ELSE autopositiontaking END,
	autompositiontaking = CASE WHEN autompositiontaking >0.7 THEN 0.7 ELSE autompositiontaking END
FROM CustSetting cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend = 3801008 AND roleid IN (2,3)
GO

-------------------------------------------------------------------------------
--MTESTEU (1807421), mtesteu01 (1807715)
--PT = 0.7/0.7/0.7
UPDATE CustSetting WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN spositiontaking >0.7 THEN 0.7 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.7 THEN 0.7 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.7 THEN 0.7 ELSE apositiontaking END,
	slivepositiontaking = CASE WHEN slivepositiontaking >0.7 THEN 0.7 ELSE slivepositiontaking END,
	mlivepositiontaking = CASE WHEN mlivepositiontaking >0.7 THEN 0.7 ELSE mlivepositiontaking END,
	alivepositiontaking = CASE WHEN alivepositiontaking >0.7 THEN 0.7 ELSE alivepositiontaking END
WHERE custid IN(1807421, 1807715)

UPDATE CustOverride WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = CASE WHEN maxpositiontaking >0.7 THEN 0.7 ELSE maxpositiontaking END,
	maxlivepositiontaking = CASE WHEN maxlivepositiontaking >0.7 THEN 0.7 ELSE maxlivepositiontaking END
WHERE custid = 1807421
GO

---------------------------------------------------------------------------------
--LK (4100631)
--PT = 0.8/0.77/0.73
UPDATE CustSetting WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN spositiontaking >0.8 THEN 0.8 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.77 THEN 0.77 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.73 THEN 0.73 ELSE apositiontaking END,
	slivepositiontaking = CASE WHEN slivepositiontaking >0.8 THEN 0.8 ELSE slivepositiontaking END,
	mlivepositiontaking = CASE WHEN mlivepositiontaking >0.77 THEN 0.77 ELSE mlivepositiontaking END,
	alivepositiontaking = CASE WHEN alivepositiontaking >0.73 THEN 0.73 ELSE alivepositiontaking END
WHERE custid = 4100631

UPDATE CustOverride WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = CASE WHEN maxpositiontaking >0.8 THEN 0.8 ELSE maxpositiontaking END,
	maxlivepositiontaking = CASE WHEN maxlivepositiontaking >0.8 THEN 0.8 ELSE maxlivepositiontaking END
WHERE custid = 4100631

--correct downlines master, agent
UPDATE cs
SET spositiontaking = CASE WHEN spositiontaking >0.8 THEN 0.8 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.77 THEN 0.77 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.73 THEN 0.73 ELSE apositiontaking END,
	slivepositiontaking = CASE WHEN slivepositiontaking >0.8 THEN 0.8 ELSE slivepositiontaking END,
	mlivepositiontaking = CASE WHEN mlivepositiontaking >0.77 THEN 0.77 ELSE mlivepositiontaking END,
	alivepositiontaking = CASE WHEN alivepositiontaking >0.73 THEN 0.73 ELSE alivepositiontaking END,
	autopositiontaking = CASE WHEN autopositiontaking >0.8 THEN 0.8 ELSE autopositiontaking END,
	autompositiontaking = CASE WHEN autompositiontaking >0.77 THEN 0.77 ELSE autompositiontaking END
FROM CustSetting cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend = 4100631 AND roleid IN (2,3)
GO

--correct downlines for members
--use execrep Acc_CustSetting3rd_19
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
   @srecommend INT,
   @target     VARCHAR(20)
AS
BEGIN
  SET NOCOUNT ON
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF (SELECT COUNT(1) 
			FROM dbo.sysobjects 
			WHERE name IN ('Custinfo','custsetting')
				AND TYPE = 'U' ) <> 2
	   RETURN
  
  DECLARE @mpos SMALLMONEY
      , @apos SMALLMONEY
      , @spos SMALLMONEY
      , @mlpos SMALLMONEY
      , @alpos SMALLMONEY
      , @slpos SMALLMONEY
      
 --UPDATE s1,m1,a1 in case s1+m1+a1>s4
 --13K rows affected
UPDATE cs
SET @apos = CASE WHEN apositiontaking > 0.73 THEN 0.73 ELSE apositiontaking END,
	apositiontaking = @apos,
	@mpos = CASE WHEN mpositiontaking + @apos > 0.77 THEN 0.77 - @apos ELSE mpositiontaking END,
	mpositiontaking = @mpos,
	@spos = CASE WHEN spositiontaking + @mpos + @apos > 0.8 THEN 0.8 - @mpos - @apos ELSE spositiontaking END,
	spositiontaking = @spos,
	
	@alpos = CASE WHEN alivepositiontaking > 0.73 THEN 0.73 ELSE alivepositiontaking END,
	alivepositiontaking = @alpos,
	@mlpos = CASE WHEN mlivepositiontaking + @alpos > 0.77 THEN 0.77 - @alpos ELSE mlivepositiontaking END,
	mlivepositiontaking = @mlpos,
	@slpos = CASE WHEN slivepositiontaking + @mlpos + @alpos > 0.8 THEN 0.8 - @mlpos - @alpos ELSE slivepositiontaking END,
	slivepositiontaking = @slpos      
FROM CustSetting cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend = @srecommend AND roleid = 1
	AND (spositiontaking + mpositiontaking + apositiontaking > 0.8 OR mpositiontaking + apositiontaking > 0.77 OR apositiontaking > 0.73
	OR slivepositiontaking + mlivepositiontaking + alivepositiontaking > 0.8 OR mlivepositiontaking + alivepositiontaking > 0.77 OR alivepositiontaking > 0.73
	)
END
GO

--execute sp to correct downlines
---RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
EXEC Acc_CustSetting3rd_19 @srecommend = 4100631,@target = 'REPLICATED'
GO

--
--  RUN THIS SCRIPT AT @DBTRANS.CUSTDB -----
EXEC Acc_CustSetting3rd_19 @srecommend = 4100631,@target = 'DBTRANS'
GO



------------------------------------------------------------------------------------
--JA	4152553
--PT = 0.8/0.77/0.73
UPDATE CustSetting WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN spositiontaking >0.8 THEN 0.8 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.77 THEN 0.77 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.73 THEN 0.73 ELSE apositiontaking END,
	slivepositiontaking = CASE WHEN slivepositiontaking >0.8 THEN 0.8 ELSE slivepositiontaking END,
	mlivepositiontaking = CASE WHEN mlivepositiontaking >0.77 THEN 0.77 ELSE mlivepositiontaking END,
	alivepositiontaking = CASE WHEN alivepositiontaking >0.73 THEN 0.73 ELSE alivepositiontaking END
WHERE custid = 4152553

UPDATE CustOverride WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = CASE WHEN maxpositiontaking >0.8 THEN 0.8 ELSE maxpositiontaking END,
	maxlivepositiontaking = CASE WHEN maxlivepositiontaking >0.8 THEN 0.8 ELSE maxlivepositiontaking END
WHERE custid = 4152553

--correct downlines master, agent
UPDATE cs
SET spositiontaking = CASE WHEN spositiontaking >0.8 THEN 0.8 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.77 THEN 0.77 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.73 THEN 0.73 ELSE apositiontaking END,
	slivepositiontaking = CASE WHEN slivepositiontaking >0.8 THEN 0.8 ELSE slivepositiontaking END,
	mlivepositiontaking = CASE WHEN mlivepositiontaking >0.77 THEN 0.77 ELSE mlivepositiontaking END,
	alivepositiontaking = CASE WHEN alivepositiontaking >0.73 THEN 0.73 ELSE alivepositiontaking END,
	autopositiontaking = CASE WHEN autopositiontaking >0.8 THEN 0.8 ELSE autopositiontaking END,
	autompositiontaking = CASE WHEN autompositiontaking >0.77 THEN 0.77 ELSE autompositiontaking END
FROM CustSetting cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend = 4152553 AND roleid IN (2,3)
GO


--correct downlines for members
--use execrep Acc_CustSetting3rd_19
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
   @srecommend INT,
   @target     VARCHAR(20)
AS
BEGIN
  SET NOCOUNT ON
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF (SELECT COUNT(1) 
			FROM dbo.sysobjects 
			WHERE name IN ('Custinfo','custsetting')
				AND TYPE = 'U' ) <> 2
	   RETURN
  
  DECLARE @mpos SMALLMONEY
      , @apos SMALLMONEY
      , @spos SMALLMONEY
      , @mlpos SMALLMONEY
      , @alpos SMALLMONEY
      , @slpos SMALLMONEY
      
 --UPDATE s1,m1,a1 in case s1+m1+a1>s4
 --13K rows affected
UPDATE cs
SET @apos = CASE WHEN apositiontaking > 0.73 THEN 0.73 ELSE apositiontaking END,
	apositiontaking = @apos,
	@mpos = CASE WHEN mpositiontaking + @apos > 0.77 THEN 0.77 - @apos ELSE mpositiontaking END,
	mpositiontaking = @mpos,
	@spos = CASE WHEN spositiontaking + @mpos + @apos > 0.8 THEN 0.8 - @mpos - @apos ELSE spositiontaking END,
	spositiontaking = @spos,
	
	@alpos = CASE WHEN alivepositiontaking > 0.73 THEN 0.73 ELSE alivepositiontaking END,
	alivepositiontaking = @alpos,
	@mlpos = CASE WHEN mlivepositiontaking + @alpos > 0.77 THEN 0.77 - @alpos ELSE mlivepositiontaking END,
	mlivepositiontaking = @mlpos,
	@slpos = CASE WHEN slivepositiontaking + @mlpos + @alpos > 0.8 THEN 0.8 - @mlpos - @alpos ELSE slivepositiontaking END,
	slivepositiontaking = @slpos      
FROM CustSetting cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend = @srecommend AND roleid = 1
	AND (spositiontaking + mpositiontaking + apositiontaking > 0.8 OR mpositiontaking + apositiontaking > 0.77 OR apositiontaking > 0.73
	OR slivepositiontaking + mlivepositiontaking + alivepositiontaking > 0.8 OR mlivepositiontaking + alivepositiontaking > 0.77 OR alivepositiontaking > 0.73
	)
END
GO

--execute sp to correct downlines
---RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
EXEC Acc_CustSetting3rd_19 @srecommend = 4152553,@target = 'REPLICATED'
GO

--
--  RUN THIS SCRIPT AT @DBTRANS.CUSTDB -----
EXEC Acc_CustSetting3rd_19 @srecommend = 4152553,@target = 'DBTRANS'
GO

----------------------------------------------------------------------------
--HO	6210213
--PT = 0.8/0.77/0.73
UPDATE CustSetting WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN spositiontaking >0.8 THEN 0.8 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.77 THEN 0.77 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.73 THEN 0.73 ELSE apositiontaking END,
	slivepositiontaking = CASE WHEN slivepositiontaking >0.8 THEN 0.8 ELSE slivepositiontaking END,
	mlivepositiontaking = CASE WHEN mlivepositiontaking >0.77 THEN 0.77 ELSE mlivepositiontaking END,
	alivepositiontaking = CASE WHEN alivepositiontaking >0.73 THEN 0.73 ELSE alivepositiontaking END
WHERE custid = 6210213

UPDATE CustOverride WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = CASE WHEN maxpositiontaking >0.8 THEN 0.8 ELSE maxpositiontaking END,
	maxlivepositiontaking = CASE WHEN maxlivepositiontaking >0.8 THEN 0.8 ELSE maxlivepositiontaking END
WHERE custid = 6210213

--correct downlines master, agent
UPDATE cs
SET spositiontaking = CASE WHEN spositiontaking >0.8 THEN 0.8 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.77 THEN 0.77 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.73 THEN 0.73 ELSE apositiontaking END,
	slivepositiontaking = CASE WHEN slivepositiontaking >0.8 THEN 0.8 ELSE slivepositiontaking END,
	mlivepositiontaking = CASE WHEN mlivepositiontaking >0.77 THEN 0.77 ELSE mlivepositiontaking END,
	alivepositiontaking = CASE WHEN alivepositiontaking >0.73 THEN 0.73 ELSE alivepositiontaking END,
	autopositiontaking = CASE WHEN autopositiontaking >0.8 THEN 0.8 ELSE autopositiontaking END,
	autompositiontaking = CASE WHEN autompositiontaking >0.77 THEN 0.77 ELSE autompositiontaking END
FROM CustSetting cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend = 6210213 AND roleid IN (2,3)
GO


--correct downlines for members
--use execrep Acc_CustSetting3rd_19
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
   @srecommend INT,
   @target     VARCHAR(20)
AS
BEGIN
  SET NOCOUNT ON
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF (SELECT COUNT(1) 
			FROM dbo.sysobjects 
			WHERE name IN ('Custinfo','custsetting')
				AND TYPE = 'U' ) <> 2
	   RETURN
  
  DECLARE @mpos SMALLMONEY
      , @apos SMALLMONEY
      , @spos SMALLMONEY
      , @mlpos SMALLMONEY
      , @alpos SMALLMONEY
      , @slpos SMALLMONEY
      
 --UPDATE s1,m1,a1 in case s1+m1+a1>s4
 --13K rows affected
UPDATE cs
SET @apos = CASE WHEN apositiontaking > 0.73 THEN 0.73 ELSE apositiontaking END,
	apositiontaking = @apos,
	@mpos = CASE WHEN mpositiontaking + @apos > 0.77 THEN 0.77 - @apos ELSE mpositiontaking END,
	mpositiontaking = @mpos,
	@spos = CASE WHEN spositiontaking + @mpos + @apos > 0.8 THEN 0.8 - @mpos - @apos ELSE spositiontaking END,
	spositiontaking = @spos,
	
	@alpos = CASE WHEN alivepositiontaking > 0.73 THEN 0.73 ELSE alivepositiontaking END,
	alivepositiontaking = @alpos,
	@mlpos = CASE WHEN mlivepositiontaking + @alpos > 0.77 THEN 0.77 - @alpos ELSE mlivepositiontaking END,
	mlivepositiontaking = @mlpos,
	@slpos = CASE WHEN slivepositiontaking + @mlpos + @alpos > 0.8 THEN 0.8 - @mlpos - @alpos ELSE slivepositiontaking END,
	slivepositiontaking = @slpos      
FROM CustSetting cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend = @srecommend AND roleid = 1
	AND (spositiontaking + mpositiontaking + apositiontaking > 0.8 OR mpositiontaking + apositiontaking > 0.77 OR apositiontaking > 0.73
	OR slivepositiontaking + mlivepositiontaking + alivepositiontaking > 0.8 OR mlivepositiontaking + alivepositiontaking > 0.77 OR alivepositiontaking > 0.73
	)
END
GO

--execute sp to correct downlines
---RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
EXEC Acc_CustSetting3rd_19 @srecommend = 6210213,@target = 'REPLICATED'
GO

--
--  RUN THIS SCRIPT AT @DBTRANS.CUSTDB -----
EXEC Acc_CustSetting3rd_19 @srecommend = 6210213,@target = 'DBTRANS'
GO



--------------------------------------------------------------------------------------------------------------------------------
--Virtual Sports
--POE (9513012), PYH (9525991), YDH(12183294), QQKY(12573245), S98K(12653798), S6P(12665939)
--EQH(13213942), PYT(13338762), 2CT(13344620),  JAR(13469220), HAK(14537929), KHR(15092757),
--WMB(8864806), S2C(10357130), MTEST(1688074), S11M4(9387993),sg9m(9507450)
--C3(10775412), VKS(12545925), MOU(12932432), BBD(13715655)

--SET PT = 0.85/0.8/0.75
UPDATE CustSetting3rd WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN spositiontaking >0.85 THEN 0.85 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.8 THEN 0.8 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.75 THEN 0.75 ELSE apositiontaking END
WHERE custid IN ( 9513012,9525991,12183294,12573245,12653798,12665939
	,13213942,13338762,13344620,13469220,14537929,15092757,8864806,10357130
	,1688074,9387993,9507450,10775412,12545925,12932432,13715655)
	AND sporttype BETWEEN 180 AND 186

UPDATE CustOverride3rd WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = CASE WHEN maxpositiontaking >0.85 THEN 0.85 ELSE maxpositiontaking END	
WHERE custid IN (9513012,9525991,12183294,12573245,12653798,12665939
	,13213942,13338762,13344620,13469220,14537929,15092757,8864806,10357130
	,1688074,9387993,9507450,10775412,12545925,12932432,13715655
	)
	AND sporttype BETWEEN 180 AND 186
GO

--JARWRONG(13469206),MLH (8550141), SWX(8864778), SBHD(8907700), FYK(9428916),HHHK2(10794837)
--TEG(12696856), POD(9649538), QAG(10406668), SG33H(10719518), WTA(13216226),SMCH(13294314)
--SQHH(14210898), SX5(14822871), SVJ(8489914), gtwrong(8551070), SAE(10321289), S999S(10440396)
--PT = 0.7/0.7/0.7
UPDATE CustSetting3rd WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN spositiontaking >0.7 THEN 0.7 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.7 THEN 0.7 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.7 THEN 0.7 ELSE apositiontaking END
WHERE custid IN (13469206,8550141,8864778,8907700,9428916,10794837,12696856,9649538
		,10406668,10719518,13216226,13294314,14210898,14822871,8551070,10321289
		,10440396
	)
	AND sporttype BETWEEN 180 AND 186

UPDATE CustOverride3rd WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = CASE WHEN maxpositiontaking >0.7 THEN 0.7 ELSE maxpositiontaking END	
WHERE custid IN (13469206,8550141,8864778,8907700,9428916,10794837,12696856,9649538
		,10406668,10719518,13216226,13294314,14210898,14822871,8551070,10321289
		,10440396
	)
	AND sporttype BETWEEN 180 AND 186
GO	

--------------------------------------------------------------------------
--TV16(11746534),KY36(14210944),JIP(9573322),MO(11674017),MP(11674030)
--PT = 0.8/0.8/0.8
UPDATE CustSetting3rd WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN spositiontaking >0.8 THEN 0.8 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.8 THEN 0.8 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.8 THEN 0.8 ELSE apositiontaking END
WHERE custid IN (11746534,14210944,9573322,11674017,11674030
	)
	AND sporttype BETWEEN 180 AND 186


UPDATE CustOverride3rd WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = CASE WHEN maxpositiontaking >0.8 THEN 0.8 ELSE maxpositiontaking END	
WHERE custid IN (11746534,14210944,9573322,11674017,11674030
	)
	AND sporttype BETWEEN 180 AND 186
GO
		
----------------------------------------------------
--correct downlines for master,agent
---MTEST 1688074, master MTEST01 1688137
--C3	10775412
--PT = 0.85/0.8/0.75

UPDATE cs
SET spositiontaking = CASE WHEN spositiontaking >0.85 THEN 0.85 ELSE spositiontaking END,
	mpositiontaking = CASE WHEN mpositiontaking >0.8 THEN 0.8 ELSE mpositiontaking END,
	apositiontaking = CASE WHEN apositiontaking >0.75 THEN 0.75 ELSE apositiontaking END,
	autopositiontaking = CASE WHEN autopositiontaking >0.85 THEN 0.85 ELSE autopositiontaking END,
	autompositiontaking = CASE WHEN autompositiontaking >0.8 THEN 0.8 ELSE autompositiontaking END
FROM CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend IN (1688074,10775412) AND roleid IN (2,3)
	AND sporttype BETWEEN 180 and 186
GO	
--correct downlines for members
--C3(10775412)
--PT = 0.85/0.8/0.75
  DECLARE @mpos SMALLMONEY
      , @apos SMALLMONEY
      , @spos SMALLMONEY
     
      
 --UPDATE s1,m1,a1 in case s1+m1+a1>s4
 --344 rows affected
UPDATE cs
SET @apos = CASE WHEN apositiontaking > 0.75 THEN 0.75 ELSE apositiontaking END,
	apositiontaking = @apos,
	@mpos = CASE WHEN mpositiontaking + @apos > 0.8 THEN 0.8 - @apos ELSE mpositiontaking END,
	mpositiontaking = @mpos,
	@spos = CASE WHEN spositiontaking + @mpos + @apos > 0.85 THEN 0.85 - @mpos - @apos ELSE spositiontaking END,
	spositiontaking = @spos	
FROM CustSetting3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend = 10775412 AND roleid = 1
	AND (spositiontaking + mpositiontaking + apositiontaking > 0.85 OR mpositiontaking + apositiontaking > 0.8 OR apositiontaking > 0.75	
	)
	AND sporttype BETWEEN 180 and 186

