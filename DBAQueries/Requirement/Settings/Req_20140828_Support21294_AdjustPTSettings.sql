/*
	Created: Johnson
	Date: 2014-08-28
	Task: Adjust PT settings for Supers and downlines
	DB: DBTXn/CustDB
*/ 

--SWW: update SB PT follow 0.85/0.8/0.75
UPDATE CustSetting WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = 0.85
	,mpositiontaking = 0.8
	,apositiontaking = 0.75
	,slivepositiontaking = CASE WHEN sporttype = 1 AND bettype IN (1,3,7,8) THEN 0.85 ELSE slivepositiontaking END 
	,mlivepositiontaking = CASE WHEN sporttype = 1 AND bettype IN (1,3,7,8) THEN 0.8 ELSE mlivepositiontaking END 
	,alivepositiontaking = CASE WHEN sporttype = 1 AND bettype IN (1,3,7,8) THEN 0.75 ELSE alivepositiontaking END 
WHERE custid = 2522889
AND NOT (sporttype = 5 AND bettype = 9999)

UPDATE custoverride WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = 0.85
	,maxlivepositiontaking = CASE WHEN bettype IN (1,3,7,8) THEN 0.85 ELSE maxlivepositiontaking END
WHERE custid = 2522889
AND NOT (sporttype = 5 AND bettype = 9999)

--correct pt settings for SWW downlines
--master level
--(i3 = 0 and s3 + m3 <=0.85 and m3<= 0.8) 
--script check 
/*
;with  b as (
select custid from custInfo with(nolock) where srecommend = 2522889 and roleid = 3
and Enabled = 1
)

select * from CustSetting with(nolock)
where custid in (select custid from b)
and isautopositiontaking = 0
and (apositiontaking > 0.75 or mpositiontaking + apositiontaking > 0.8 or spositiontaking + mpositiontaking + apositiontaking > 0.85
or 1= case when sporttype = 1 and bettype in (1,3,7,8) and (alivepositiontaking > 0.75 or mlivepositiontaking + alivepositiontaking > 0.8 or slivepositiontaking + mlivepositiontaking + alivepositiontaking > 0.85) then 1 else 0 end
)
order by custid
*/
--custid = 11981345: SWWBB 
UPDATE CustSetting WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN spositiontaking > 0.85 THEN 0.85 ELSE spositiontaking END
	,slivepositiontaking = CASE WHEN sporttype = 1 AND bettype IN (1,3,7,8) AND slivepositiontaking > 0.85 THEN 0.85 ELSE slivepositiontaking END
WHERE custid = 11981345
AND NOT (sporttype = 5 AND bettype = 9999)

--(i3 = 1 and us3 <= 0.85 and m3<=0.8)
/*
;with  b as (
select custid from custInfo with(nolock) where srecommend = 2522889 and roleid = 3
and Enabled = 1
)

select distinct custid from CustSetting with(nolock)
where custid in (select custid from b)
and isautopositiontaking = 1
and (apositiontaking > 0.75 or mpositiontaking + apositiontaking > 0.8 or autopositiontaking > 0.85
or 1= case when sporttype = 1 and bettype in (1,3,7,8) and (alivepositiontaking > 0.75 or mlivepositiontaking + alivepositiontaking > 0.8 or autolivepositiontaking > 0.85) then 1 else 0 end
)
*/
--custid=11640137: SWWMM
--custid=12246786: SWWM0
UPDATE custSetting WITH(UPDLOCK,ROWLOCK)
SET mpositiontaking = CASE WHEN isautopositiontaking = 1 AND mpositiontaking > 0.8 THEN 0.8 ELSE mpositiontaking END
	,autopositiontaking = CASE WHEN isautopositiontaking = 1 AND autopositiontaking > 0.85 THEN 0.85 ELSE autopositiontaking END
	,mlivepositiontaking = CASE WHEN sporttype = 1 AND bettype IN (1,3,7,8) AND isautolivepositiontaking = 1 AND mlivepositiontaking > 0.8 THEN 0.8 ELSE mpositiontaking END
	,autolivepositiontaking = CASE WHEN sporttype = 1 AND bettype IN (1,3,7,8) AND isautolivepositiontaking = 1 AND autolivepositiontaking > 0.85 THEN 0.85 ELSE autolivepositiontaking END
WHERE custid IN (11640137,12246786)	
	AND (isautopositiontaking = 1 OR isautolivepositiontaking = 1)
	AND (mpositiontaking > 0.8 or autopositiontaking > 0.85
			OR 1= CASE WHEN sporttype = 1 AND bettype IN (1,3,7,8) AND (mlivepositiontaking > 0.8 OR autolivepositiontaking > 0.85) THEN 1 ELSE 0 END
		)
	AND NOT (sporttype = 5 AND bettype = 9999)
GO

--correct member level
EXEC Acc_CustSetting_07 @srecommend = 2522889, @roleid = 4
GO

--SWW: update NG PT follow 0.85/0.8/0.75
UPDATE CustSetting3rd WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.85 ELSE spositiontaking END
	,mpositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.8 ELSE mpositiontaking END
	,apositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.75 ELSE apositiontaking END
	,slivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.85 ELSE slivepositiontaking END 
	,mlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.8 ELSE mlivepositiontaking END 
	,alivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.75 ELSE alivepositiontaking END 
WHERE custid = 2522889
	AND sporttype = 161 


UPDATE custoverride3rd WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.85 ELSE maxpositiontaking END
	,maxlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) THEN 0.85 ELSE maxlivepositiontaking END
WHERE custid = 2522889
AND sporttype = 161


--correct pt settings for SWW downlines
--master level
--(i3 = 0 and s3 + m3 <=0.85 and m3<= 0.8)
--custid = 11981345: SWWBB 

UPDATE CustSetting3rd WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN  bettype IN (81,83,86,88) AND spositiontaking > 0.85 THEN 0.85 ELSE spositiontaking END
	,slivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND slivepositiontaking > 0.85 THEN 0.85 ELSE slivepositiontaking END
WHERE custid = 11981345
AND sporttype = 161

--(i3 = 1 and us3 <= 0.85 and m3<=0.8)
--custid=11640137: SWWMM
--custid=12246786: SWWM0
UPDATE custSetting3rd WITH(UPDLOCK,ROWLOCK)
SET mpositiontaking = CASE WHEN  bettype IN (81,83,86,88) AND isautopositiontaking = 1 AND mpositiontaking > 0.8 THEN 0.8 ELSE mpositiontaking END
	,autopositiontaking = CASE WHEN bettype IN (81,83,86,88) AND isautopositiontaking = 1 AND autopositiontaking > 0.85 THEN 0.85 ELSE autopositiontaking END
	,mlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND isautolivepositiontaking = 1 AND mlivepositiontaking > 0.8 THEN 0.8 ELSE mpositiontaking END
	,autolivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND isautolivepositiontaking = 1 AND autolivepositiontaking > 0.85 THEN 0.85 ELSE autolivepositiontaking END
WHERE custid IN (11640137,12246786)	
	AND sporttype = 161
	AND (isautopositiontaking = 1 OR isautolivepositiontaking = 1)
	AND (mpositiontaking > 0.8 or autopositiontaking > 0.85
			OR 1= CASE WHEN bettype IN (85,86,87,89,90) AND (mlivepositiontaking > 0.8 OR autolivepositiontaking > 0.85) THEN 1 ELSE 0 END
		)
GO

--correct pt on member level
EXEC dbo.Acc_CustSetting3rd_07 @srecommend = 2522889, @roleid = 3, @mode = 'number'	
GO

-------------------------------------------------------------------------
--Super STEF: update NG PT follow 0.85/0.8/0.75

UPDATE CustSetting3rd WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.85 ELSE spositiontaking END
	,mpositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.8 ELSE mpositiontaking END
	,apositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.75 ELSE apositiontaking END
	,slivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.85 ELSE slivepositiontaking END 
	,mlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.8 ELSE mlivepositiontaking END 
	,alivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.75 ELSE alivepositiontaking END 
WHERE custid = 3592707
	AND sporttype = 161 

UPDATE custoverride3rd WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = 0.85
	,maxlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) THEN 0.85 ELSE maxlivepositiontaking END
WHERE custid = 3592707
AND sporttype = 161





-------------------------------------------------------
--SUPER JSC NG 0.7/0.7/0.7

UPDATE CustSetting3rd WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.7 ELSE spositiontaking END
	,mpositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.7 ELSE mpositiontaking END
	,apositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN  0.7 ELSE apositiontaking END
	,slivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.7 ELSE slivepositiontaking END 
	,mlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.7 ELSE mlivepositiontaking END 
	,alivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.7 ELSE alivepositiontaking END 
WHERE custid = 3992866
	AND sporttype = 161 

UPDATE custoverride3rd WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.7 ELSE maxpositiontaking END
	,maxlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) THEN 0.7 ELSE maxlivepositiontaking END
WHERE custid = 3992866
AND sporttype = 161

--correct pt settings for STEF downlines
--master level
--(i3 = 0 and s3 + m3 <=0.85 and m3<= 0.8) 

DECLARE @mpos SMALLMONEY,@mlpos SMALLMONEY

UPDATE cs
SET @mpos = CASE WHEN bettype IN (81,83,86,88) AND mpositiontaking > 0.7 THEN 0.7 ELSE mpositiontaking END
	,mposisiontaking = @mpos
	,spositiontaking = CASE WHEN bettype IN (81,83,86,88) AND @mpos + spositiontaking > 0.7 THEN 0.7 - @mpos ELSE spositiontaking END
	,@mlpos = CASE WHEN bettype in (85,86,87,89,90) AND mlivepositiontaking > 0.7 THEN 0.7 ELSE mlivepositiontaking END 
	,mlivepositiontaking = @mlpos
	,slivepositiontaking = CASE WHEN bettype in (85,86,87,89,90) AND @mlpos + slivepositiontaking > 0.7 THEN 0.7 - @mpos ELSE slivepositiontaking END
FROM CustSetting3rd cs with(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid and srecommend = 3992866 and roleid = 3
WHERE (isautopositiontaking = 0 or isautolivepositiontaking = 0)
	AND sporttype = 161
	AND (apositiontaking > 0.7 or mpositiontaking + apositiontaking > 0.7 or spositiontaking + mpositiontaking + apositiontaking > 0.7
	or 1= case when bettype in (85,86,87,89,90) and (alivepositiontaking > 0.7 or mlivepositiontaking + alivepositiontaking > 0.7 or slivepositiontaking + mlivepositiontaking + alivepositiontaking > 0.7) then 1 else 0 end
	)


--(i3 = 1 and us3 <= 0.85 and m3<=0.8)

UPDATE cs
SET mpositiontaking = CASE WHEN  bettype IN (81,83,86,88) AND isautopositiontaking = 1 AND mpositiontaking > 0.7 THEN 0.7 ELSE mpositiontaking END
	,autopositiontaking = CASE WHEN bettype IN (81,83,86,88) AND isautopositiontaking = 1 AND autopositiontaking > 0.7 THEN 0.7 ELSE autopositiontaking END
	,mlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND isautolivepositiontaking = 1 AND mlivepositiontaking > 0.7 THEN 0.7 ELSE mpositiontaking END
	,autolivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND isautolivepositiontaking = 1 AND autolivepositiontaking > 0.7 THEN 0.7 ELSE autolivepositiontaking END
FROM custSetting3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid AND srecommend = 3992866 AND roleid = 3
WHERE  sporttype = 161
	AND (isautopositiontaking = 1 OR isautolivepositiontaking = 1)
	AND (mpositiontaking > 0.7 or autopositiontaking > 0.7
			OR 1= CASE WHEN bettype IN (85,86,87,89,90) AND (mlivepositiontaking > 0.7 OR autolivepositiontaking > 0.7) THEN 1 ELSE 0 END
		)

--agent JSC7211
UPDATE custsetting3rd WITH(UPDLOCK,ROWLOCK)
SET autompositiontaking = 0.
WHERE custid = 7370042
	AND sporttype = 161
	AND bettype IN (81,83,86)
	AND isautompositiontaking = 1

-------------------------------------------------------
--SPSD	3623378

UPDATE CustSetting3rd WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.85 ELSE spositiontaking END
	,mpositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.8 ELSE mpositiontaking END
	,apositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.75 ELSE apositiontaking END
	,slivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.85 ELSE slivepositiontaking END 
	,mlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.8 ELSE mlivepositiontaking END 
	,alivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.75 ELSE alivepositiontaking END 
WHERE custid = 3623378
	AND sporttype = 161 
	

UPDATE custoverride3rd WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.85 ELSE maxpositiontaking END
	,maxlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) THEN 0.85 ELSE maxlivepositiontaking END
WHERE custid = 3623378
AND sporttype = 161


--correct pt settings for SPSD downlines
--master level
--(i3 = 0 and s3 + m3 <=0.85 and m3<= 0.8)
DECLARE @mpos smallmoney, @mlpos smallmoney

UPDATE cs
SET @mpos = CASE WHEN bettype IN (81,83,86,88) AND mpositiontaking > 0.8 THEN 0.8 ELSE mpositiontaking END
	,mpositiontaking = @mpos
	,spositiontaking = CASE WHEN bettype IN (81,83,86,88) AND @mpos + spositiontaking > 0.85 THEN 0.85 - @mpos ELSE spositiontaking END
	,@mlpos = CASE WHEN bettype in (85,86,87,89,90) AND mlivepositiontaking > 0.8 THEN 0.8 ELSE mlivepositiontaking END 
	,mlivepositiontaking = @mlpos
	,slivepositiontaking = CASE WHEN bettype in (85,86,87,89,90) AND @mlpos + slivepositiontaking > 0.85 THEN 0.85 - @mlpos ELSE slivepositiontaking END
FROM CustSetting3rd cs with(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid = ci.custid and srecommend = 3623378 and roleid = 3
WHERE (isautopositiontaking = 0 or isautolivepositiontaking = 0)
	AND sporttype = 161
	AND (apositiontaking > 0.75 or mpositiontaking + apositiontaking > 0.8 or spositiontaking + mpositiontaking + apositiontaking > 0.85
	or 1= case when bettype in (85,86,87,89,90) and (alivepositiontaking > 0.75 or mlivepositiontaking + alivepositiontaking > 0.8 or slivepositiontaking + mlivepositiontaking + alivepositiontaking > 0.85) then 1 else 0 end
	)
GO


--correct pt on member for SPSD downlines
--member level
DECLARE @apos smallmoney, @mpos smallmoney, @alpos smallmoney, @mlpos smallmoney

UPDATE cs
SET @apos =  CASE WHEN bettype IN (81,83,86,88) AND apositiontaking > 0.75 THEN 0.75 ELSE apositiontaking END
	,apositiontaking = @apos
	,@mpos = CASE WHEN bettype IN (81,83,86,88) AND mpositiontaking + @apos > 0.8 THEN 0.8- @apos ELSE mpositiontaking END
	,mpositiontaking = @mpos
	,spositiontaking = CASE WHEN bettype IN (81,83,86,88) AND spositiontaking + @mpos + @apos > 0.85 THEN 0.85 - @mpos - @apos ELSE spositiontaking END

	,@alpos =  CASE WHEN bettype IN (85,86,87,89,90) AND alivepositiontaking > 0.75 THEN 0.75 ELSE alivepositiontaking END
	,alivepositiontaking = @alpos
	,@mlpos = CASE WHEN bettype IN (85,86,87,89,90) AND mlivepositiontaking + @alpos > 0.8 THEN 0.8- @alpos ELSE mlivepositiontaking END
	,mlivepositiontaking = @mlpos
	,slivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND slivepositiontaking + @mlpos + @alpos > 0.85 THEN 0.85 - @mlpos - @alpos ELSE slivepositiontaking END	
from CustSetting3rd cs with(UPDLOCK,ROWLOCK)
	inner join custInfo ci with(nolock) on cs.custid = ci.custid and srecommend = 3623378 and roleid = 1
where  sporttype = 161
 and (apositiontaking > 0.75 or mpositiontaking + apositiontaking > 0.8 or spositiontaking + mpositiontaking + apositiontaking > 0.85
or 1= case when bettype in (85,86,87,89,90) and (alivepositiontaking > 0.75 or mlivepositiontaking + alivepositiontaking > 0.8 or slivepositiontaking + mlivepositiontaking + alivepositiontaking > 0.85) then 1 else 0 end
)
GO

---------------------------------------------------
--LHH3

UPDATE CustSetting3rd WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.7 ELSE spositiontaking END
	,mpositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.7 ELSE mpositiontaking END
	,apositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.7 ELSE apositiontaking END
	,slivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.7 ELSE slivepositiontaking END 
	,mlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.7 ELSE mlivepositiontaking END 
	,alivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90)  THEN 0.7 ELSE alivepositiontaking END 
WHERE custid = 7754182
	AND sporttype = 161 
	

UPDATE custoverride3rd WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = CASE WHEN bettype IN (81,83,86,88) THEN 0.7 ELSE maxpositiontaking END
	,maxlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) THEN 0.7 ELSE maxlivepositiontaking END
WHERE custid = 7754182
AND sporttype = 161

--correct pt settings for SPSD downlines
--master level
--(i3 = 0 and s3 + m3 <=0.7 and m3<= 0.7)
DECLARE @mpos smallmoney, @mlpos smallmoney

UPDATE cs
SET @mpos = CASE WHEN bettype IN (81,83,86,88) AND mpositiontaking > 0.7 THEN 0.7 ELSE mpositiontaking END
	,mpositiontaking = @mpos
	,spositiontaking = CASE WHEN bettype IN (81,83,86,88) AND @mpos + spositiontaking > 0.7 THEN 0.7 - @mpos ELSE spositiontaking END
	,@mlpos = CASE WHEN bettype in (85,86,87,89,90) AND mlivepositiontaking > 0.7 THEN 0.7 ELSE mlivepositiontaking END 
	,mlivepositiontaking = @mlpos
	,slivepositiontaking = CASE WHEN bettype in (85,86,87,89,90) AND @mlpos + slivepositiontaking > 0.7 THEN 0.7 - @mlpos ELSE slivepositiontaking END
 from CustSetting3rd cs with(UPDLOCK,ROWLOCK)
	inner join custInfo ci with(nolock) on cs.custid = ci.custid and srecommend = 7754182 and roleid = 3
where (isautopositiontaking = 0 or isautolivepositiontaking = 0)
and sporttype = 161
and (apositiontaking > 0.7 or mpositiontaking + apositiontaking > 0.7 or spositiontaking + mpositiontaking + apositiontaking > 0.7
or 1= case when bettype in (85,86,87,89,90) and (alivepositiontaking > 0.7 or mlivepositiontaking + alivepositiontaking > 0.7 or slivepositiontaking + mlivepositiontaking + alivepositiontaking > 0.7) then 1 else 0 end
)
GO
--n3<= 0.7
UPDATE cs
SET minpositiontaking = CASE WHEN bettype IN (81,83,86,88) AND minpositiontaking > 0.7 THEN 0.7 ELSE minpositiontaking END
	,minlivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND minlivepositiontaking > 0.7 THEN 0.7 ELSE minlivepositiontaking END
FROM custoverride3rd cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid AND srecommend = 7754182 AND roleid IN (2,3)
WHERE sporttype = 161 
AND (minpositiontaking > 0.7 OR minlivepositiontaking > 0.7)

--correct pt on member for SPSD downlines
--member level
DECLARE @apos smallmoney, @mpos smallmoney, @alpos smallmoney, @mlpos smallmoney

UPDATE cs
SET @apos =  CASE WHEN bettype IN (81,83,86,88) AND apositiontaking > 0.7 THEN 0.7 ELSE apositiontaking END
	,apositiontaking = @apos
	,@mpos = CASE WHEN bettype IN (81,83,86,88) AND mpositiontaking + @apos > 0.7 THEN 0.7- @apos ELSE mpositiontaking END
	,mpositiontaking = @mpos
	,spositiontaking = CASE WHEN bettype IN (81,83,86,88) AND spositiontaking + @mpos + @apos > 0.7 THEN 0.7 - @mpos - @apos ELSE spositiontaking END

	,@alpos =  CASE WHEN bettype IN (85,86,87,89,90) AND alivepositiontaking > 0.7 THEN 0.7 ELSE alivepositiontaking END
	,alivepositiontaking = @alpos
	,@mlpos = CASE WHEN bettype IN (85,86,87,89,90) AND mlivepositiontaking + @alpos > 0.7 THEN 0.7- @alpos ELSE mlivepositiontaking END
	,mlivepositiontaking = @mlpos
	,slivepositiontaking = CASE WHEN bettype IN (85,86,87,89,90) AND slivepositiontaking + @mlpos + @alpos > 0.7 THEN 0.7 - @mlpos - @alpos ELSE slivepositiontaking END	
from CustSetting3rd cs with(UPDLOCK,ROWLOCK)
	inner join custInfo ci with(nolock) on cs.custid = ci.custid and srecommend = 7754182 and roleid = 1
where  sporttype = 161
 and (apositiontaking > 0.7 or mpositiontaking + apositiontaking > 0.7 or spositiontaking + mpositiontaking + apositiontaking > 0.7
or 1= case when bettype in (85,86,87,89,90) and (alivepositiontaking > 0.7 or mlivepositiontaking + alivepositiontaking > 0.7 or slivepositiontaking + mlivepositiontaking + alivepositiontaking > 0.7) then 1 else 0 end
)
GO

------------------------------------------------------------
--JSC Virtual sports : 0.7/0.7/0.7

UPDATE custsetting3rd WITH(UPDLOCK,ROWLOCK)
SET apositiontaking = 0.7
	,mpositiontaking = 0.7
	,spositiontaking = 0.7
WHERE custid = 3992866	
	AND sporttype BETWEEN 180 AND 186

UPDATE custoverride3rd WITH(UPDLOCK,ROWLOCK)
SET maxpositiontaking = 0.7
WHERE custid = 3992866	
	AND sporttype BETWEEN 180 AND 186


--correct pt settings for SPSD downlines
--master level
--(i3 = 0 and s3 + m3 <=0.7 and m3<= 0.7)
DECLARE @mpos smallmoney

UPDATE cs
SET @mpos = CASE WHEN mpositiontaking > 0.7 THEN 0.7 ELSE mpositiontaking END
	,mpositiontaking = @mpos
	,spositiontaking = CASE WHEN @mpos + spositiontaking > 0.7 THEN 0.7 - @mpos ELSE spositiontaking END	
from CustSetting3rd cs with(UPDLOCK,ROWLOCK) 
	inner join custInfo ci with(nolock) on cs.custid = ci.custid and srecommend = 3992866 and roleid = 3
where cs.sporttype between 180 and 186
	and cs.isautopositiontaking = 0
	and (mpositiontaking > 0.7 or spositiontaking + mpositiontaking > 0.7
	)	

--(i3 = 1 and us3 <= 0.7 and m3<=0.7)

UPDATE cs
SET mpositiontaking = CASE WHEN mpositiontaking > 0.7 THEN 0.7 ELSE mpositiontaking END	
	,autopositiontaking = CASE WHEN autopositiontaking > 0.7 THEN 0.7 ELSE autopositiontaking END	
from CustSetting3rd cs with(UPDLOCK,ROWLOCK) 
	inner join custInfo ci with(nolock) on cs.custid = ci.custid and srecommend = 3992866 and roleid = 3
where cs.sporttype between 180 and 186
	and cs.isautopositiontaking = 1
	and (mpositiontaking > 0.7 or autopositiontaking > 0.7
	)	
GO	

--correct pt on member for JSC downlines
--member level

DECLARE @apos smallmoney, @mpos smallmoney

UPDATE cs
SET @apos =  CASE WHEN apositiontaking > 0.7 THEN 0.7 ELSE apositiontaking END
	,apositiontaking = @apos
	,@mpos = CASE WHEN mpositiontaking + @apos > 0.7 THEN 0.7- @apos ELSE mpositiontaking END
	,mpositiontaking = @mpos
	,spositiontaking = CASE WHEN spositiontaking + @mpos + @apos > 0.7 THEN 0.7 - @mpos - @apos ELSE spositiontaking END
from CustSetting3rd cs with(UPDLOCK,ROWLOCK)
	inner join custInfo ci with(nolock) on cs.custid = ci.custid and srecommend = 3992866 and roleid = 1
where  sporttype BETWEEN 180 AND 186
 and (apositiontaking > 0.7 or mpositiontaking + apositiontaking > 0.7 or spositiontaking + mpositiontaking + apositiontaking > 0.7
)
GO