
--select custid into #customer 
--from custInfo witH(nolock)
--where custid in (11213414,
--356947,
--985934,
--1247148,
--324563,
--12452613,
--407731,
--837877,
--1416231,
--2192160)
--and roleid = 4

-- S4 < S1 + M1 + A1
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custsetting  scs WITH (NOLOCK) ON scs.custid=ci.srecommend and scs.sporttype=cs.sporttype and scs.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=1 -- and cs.bettype = 1201 and cs.sporttype= 180
    and scs.spositiontaking < cs.spositiontaking + cs.mpositiontaking + cs.apositiontaking

--N4 > S1 + M1 + A1   
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custoverride  sco WITH (NOLOCK) ON sco.custid=ci.srecommend and sco.sporttype=cs.sporttype and sco.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=1 -- and cs.bettype = 1201 and cs.sporttype= 180
and sco.minpositiontaking > cs.spositiontaking + cs.mpositiontaking + cs.apositiontaking

--M3 < M1 + A1
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custsetting  mcs WITH (NOLOCK) ON mcs.custid=ci.mrecommend and mcs.sporttype=cs.sporttype and mcs.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=1 -- and cs.bettype = 1201 and cs.sporttype= 180
    and mcs.mpositiontaking < cs.mpositiontaking + cs.apositiontaking

-- N3 > M1 + A1
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custoverride  mco WITH (NOLOCK) ON mco.custid=ci.mrecommend and mco.sporttype=cs.sporttype and mco.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=1 -- and cs.bettype = 1201 and cs.sporttype= 180
    and mco.minpositiontaking > cs.mpositiontaking + cs.apositiontaking
   
--N2 > A1
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custoverride  aco WITH (NOLOCK) ON aco.custid=ci.recommend and aco.sporttype=cs.sporttype and aco.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=1 -- and cs.bettype = 1201 and cs.sporttype= 180
    and aco.minpositiontaking > cs.apositiontaking
   
--A4 < A1
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custsetting  sco WITH (NOLOCK) ON sco.custid=ci.srecommend and sco.sporttype=cs.sporttype and sco.bettype=cs.bettype
WHERE srecommend IN (select * from #customer)  and roleid=1 -- and cs.bettype = 1201 and cs.sporttype= 180
    and sco.apositiontaking < cs.apositiontaking
   
--S1 < 0 || M1 < 0 || A1 < 0
--S1 + M1 + A1 > 0.9   

SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
WHERE srecommend IN (select * from #customer)  and roleid=1 -- and cs.bettype = 1201 and cs.sporttype= 180
    and (cs.apositiontaking<0 or cs.mpositiontaking<0 or cs.spositiontaking<0
        or cs.apositiontaking + cs.mpositiontaking + cs.spositiontaking > 0.9
    )

--------------------------------------------------------------------------------------
/*   
Checking PT values of Agent

    A2 < N2
    M3 < M2 + A2 (IM2 = 0)
    A4 < A2
*/
-- A2 < N2
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custoverride  co WITH (NOLOCK) ON co.custid=ci.custid and co.sporttype=cs.sporttype and co.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=2 -- and cs.bettype = 1201 and cs.sporttype= 180
    and cs.apositiontaking < co.minpositiontaking
and ci.enabled = 1
-- M3 < M2 + A2 (IM2 = 0)   
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custsetting  mcs WITH (NOLOCK) ON mcs.custid=ci.mrecommend and mcs.sporttype=cs.sporttype and mcs.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=2 -- and cs.bettype = 1201 and cs.sporttype= 180
    and cs.isautompositiontaking = 0
    and mcs.mpositiontaking < cs.mpositiontaking + cs.apositiontaking
   
-- A4 < A2
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custsetting  scs WITH (NOLOCK) ON scs.custid=ci.srecommend and scs.sporttype=cs.sporttype and scs.bettype=cs.bettype
WHERE srecommend IN (select * from #customer)  and roleid=2 -- and cs.bettype = 1201 and cs.sporttype= 180
    and scs.apositiontaking < cs.apositiontaking
   
--------------------------------------------------------------------------------------   
/*

Checking PT values of Master/Super

    S4 < S3 + M3 (IS3 = 0)
    M3 < N3
    M4 < M3
    S4 < N4
*/
-- S4 < S3 + M3 (IS3 = 0)
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custsetting  scs WITH (NOLOCK) ON scs.custid=ci.srecommend and scs.sporttype=cs.sporttype and scs.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=3 --and cs.bettype = 1201 and cs.sporttype= 180
    and cs.isautopositiontaking = 0
    and scs.spositiontaking < cs.spositiontaking + cs.mpositiontaking
       
-- M3 < N3   
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custoverride  co WITH (NOLOCK) ON co.custid=ci.custid and co.sporttype=cs.sporttype and co.bettype=cs.bettype
WHERE srecommend IN (select * from #customer)  and roleid=3 --and cs.bettype = 1201 and cs.sporttype= 180   
    and cs.mpositiontaking < co.minpositiontaking
-- M4 < M3
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custsetting  scs WITH (NOLOCK) ON scs.custid=ci.srecommend and scs.sporttype=cs.sporttype and scs.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=3 --and cs.bettype = 1201 and cs.sporttype= 180   
    and scs.mpositiontaking < cs.mpositiontaking

-- S4 < N4
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custoverride  co WITH (NOLOCK) ON co.custid=ci.custid and co.sporttype=cs.sporttype and co.bettype=cs.bettype
WHERE srecommend IN (select * from #customer)  and roleid=4 --and cs.bettype = 1201 and cs.sporttype= 180   
    and cs.spositiontaking < co.minpositiontaking
    
    
    
/*
	Live ball
*/



-- S4 < S1 + M1 + A1
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custsetting  scs WITH (NOLOCK) ON scs.custid=ci.srecommend and scs.sporttype=cs.sporttype and scs.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=1  and cs.bettype IN (1,3,7,8) and cs.sporttype= 1
    and scs.slivepositiontaking < cs.slivepositiontaking + cs.mlivepositiontaking + cs.alivepositiontaking

--N4 > S1 + M1 + A1   
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custoverride  sco WITH (NOLOCK) ON sco.custid=ci.srecommend and sco.sporttype=cs.sporttype and sco.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=1  and cs.bettype IN (1,3,7,8) and cs.sporttype= 1
and sco.minlivepositiontaking > cs.slivepositiontaking + cs.mlivepositiontaking + cs.alivepositiontaking

--M3 < M1 + A1
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custsetting  mcs WITH (NOLOCK) ON mcs.custid=ci.mrecommend and mcs.sporttype=cs.sporttype and mcs.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=1  and cs.bettype IN (1,3,7,8) and cs.sporttype= 1
    and mcs.mlivepositiontaking < cs.mlivepositiontaking + cs.alivepositiontaking

-- N3 > M1 + A1
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custoverride  mco WITH (NOLOCK) ON mco.custid=ci.mrecommend and mco.sporttype=cs.sporttype and mco.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=1  and cs.bettype IN (1,3,7,8) and cs.sporttype= 1
    and mco.minlivepositiontaking > cs.mlivepositiontaking + cs.alivepositiontaking
   
--N2 > A1
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custoverride  aco WITH (NOLOCK) ON aco.custid=ci.recommend and aco.sporttype=cs.sporttype and aco.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=1  and cs.bettype IN (1,3,7,8) and cs.sporttype= 1
    and aco.minlivepositiontaking > cs.alivepositiontaking
   
--A4 < A1
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custsetting  sco WITH (NOLOCK) ON sco.custid=ci.srecommend and sco.sporttype=cs.sporttype and sco.bettype=cs.bettype
WHERE srecommend IN (select * from #customer)  and roleid=1  and cs.bettype IN (1,3,7,8) and cs.sporttype= 1
    and sco.alivepositiontaking < cs.alivepositiontaking
   
--S1 < 0 || M1 < 0 || A1 < 0
--S1 + M1 + A1 > 0.9   

SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
WHERE srecommend IN (select * from #customer)  and roleid=1  and cs.bettype IN (1,3,7,8) and cs.sporttype= 1
    and (cs.alivepositiontaking<0 or cs.mlivepositiontaking<0 or cs.slivepositiontaking<0
        or cs.alivepositiontaking + cs.mlivepositiontaking + cs.slivepositiontaking > 0.9
    )

--------------------------------------------------------------------------------------
/*   
Checking PT values of Agent

    A2 < N2
    M3 < M2 + A2 (IM2 = 0)
    A4 < A2
*/
-- A2 < N2
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custoverride  co WITH (NOLOCK) ON co.custid=ci.custid and co.sporttype=cs.sporttype and co.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=2  and cs.bettype IN (1,3,7,8) and cs.sporttype= 1
    and cs.alivepositiontaking < co.minlivepositiontaking
and ci.enabled = 1
-- M3 < M2 + A2 (IM2 = 0)   
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custsetting  mcs WITH (NOLOCK) ON mcs.custid=ci.mrecommend and mcs.sporttype=cs.sporttype and mcs.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=2  and cs.bettype IN (1,3,7,8) and cs.sporttype= 1
    and cs.isautolivempositiontaking = 0
    and mcs.mlivepositiontaking < cs.mlivepositiontaking + cs.alivepositiontaking
   
-- A4 < A2
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custsetting  scs WITH (NOLOCK) ON scs.custid=ci.srecommend and scs.sporttype=cs.sporttype and scs.bettype=cs.bettype
WHERE srecommend IN (select * from #customer)  and roleid=2  and cs.bettype IN (1,3,7,8) and cs.sporttype= 1
    and scs.alivepositiontaking < cs.alivepositiontaking
   
--------------------------------------------------------------------------------------   
/*

Checking PT values of Master/Super

    S4 < S3 + M3 (IS3 = 0)
    M3 < N3
    M4 < M3
    S4 < N4
*/
-- S4 < S3 + M3 (IS3 = 0)
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custsetting  scs WITH (NOLOCK) ON scs.custid=ci.srecommend and scs.sporttype=cs.sporttype and scs.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=3 and cs.bettype IN (1,3,7,8) and cs.sporttype= 1
    and cs.isautopositiontaking = 0
    and scs.slivepositiontaking < cs.slivepositiontaking + cs.mlivepositiontaking
       
-- M3 < N3   
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custoverride  co WITH (NOLOCK) ON co.custid=ci.custid and co.sporttype=cs.sporttype and co.bettype=cs.bettype
WHERE srecommend IN (select * from #customer)  and roleid=3 and cs.bettype IN (1,3,7,8) and cs.sporttype= 1
    and cs.mlivepositiontaking < co.minlivepositiontaking
-- M4 < M3
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custsetting  scs WITH (NOLOCK) ON scs.custid=ci.srecommend and scs.sporttype=cs.sporttype and scs.bettype=cs.bettype    
WHERE srecommend IN (select * from #customer)  and roleid=3 and cs.bettype IN (1,3,7,8) and cs.sporttype= 1  
    and scs.mlivepositiontaking < cs.mlivepositiontaking

-- S4 < N4
SELECT ci.custid
FROM custinfo ci WITH (NOLOCK)
    JOIN dbo.custsetting  cs WITH (NOLOCK) ON cs.custid=ci.custid
    JOIN dbo.custoverride  co WITH (NOLOCK) ON co.custid=ci.custid and co.sporttype=cs.sporttype and co.bettype=cs.bettype
WHERE srecommend IN (select * from #customer)  and roleid=4 and cs.bettype IN (1,3,7,8) and cs.sporttype= 1
    and cs.slivepositiontaking < co.minlivepositiontaking
    