
-- min PT
INSERT INTO CustOverride3rd([custId], [bettype], [sporttype], minpositiontaking, maxpositiontaking,minlivepositiontaking,maxlivepositiontaking)		
SELECT co.CustID, 1220, 186, minpositiontaking, 
	case when roleid = 4 then maxpositiontaking
		else 0.9 end as maxpositiontaking, 
	0 as minlivepositiontaking,0 as maxlivepositiontaking
FROM custinfo ci WITH(NOLOCK) 
	INNER JOIN custOverride3rd co WITH(NOLOCK)	ON ci.custid=co.custid 		
WHERE co.bettype = 1201 AND co.sporttype = 180
	 AND co.custid IN (
						SELECT c.custid
						FROM dbo.custinfo c WITH (NOLOCK)
							INNER JOIN CustOverride3rd co3 WITH(NOLOCK) ON c.custid = co3.custid AND co3.sporttype = 180 AND co3.bettype = 1201
						WHERE c.custid > 11759895
							AND roleid IN (2,3,4) AND srecommend NOT IN (SELECT custid FROM dbo.f_DepSuper_1('All'))
					
						)	

GO

-- PT setting
INSERT INTO CustSetting3rd([custId], [bettype], [sporttype], [apositiontaking], [mpositiontaking], [spositiontaking],  [playerdiscount], [discount], [adiscount], [sdiscount], [Minbet], [Maxbet], autopositiontaking, isautopositiontaking, autompositiontaking, isautompositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking, autolivepositiontaking, isautolivepositiontaking, autolivempositiontaking, isautolivempositiontaking)
SELECT cs.custid, 1220, 186, [apositiontaking], [mpositiontaking], [spositiontaking],  0 as [playerdiscount], 0 as [discount], 0 as [adiscount], 0 as [sdiscount], [Minbet], [Maxbet], autopositiontaking, isautopositiontaking, autompositiontaking, isautompositiontaking, 0 as alivepositiontaking,0 as mlivepositiontaking,0 as  slivepositiontaking, 0 as autolivepositiontaking, 0 as isautolivepositiontaking, 0 as autolivempositiontaking, 0 as isautolivempositiontaking
FROM CustSetting3rd cs WITH(NOLOCK)			
WHERE cs.bettype = 1201 AND cs.sporttype = 180
	AND cs.custid IN (
						SELECT c.custid
						FROM dbo.custinfo c WITH (NOLOCK)
							INNER JOIN custsetting3rd cs3 WITH(NOLOCK) ON cs3.custid = c.custid AND cs3.bettype = 1201 AND cs3.sporttype = 180
						WHERE c.custid > 11759895
							AND srecommend NOT IN (SELECT custid FROM dbo.f_DepSuper_1('all'))
					)

GO
-- maxpermatch
UPDATE custinfo WITH(ROWLOCK,UPDLOCK)
SET maxpermatch186 = maxpermatch180 -- virtual tennis		
WHERE custid IN (
					SELECT custid
					FROM dbo.custinfo c WITH (NOLOCK)
					WHERE custid > 11759895
						AND srecommend NOT IN (SELECT custid FROM dbo.f_DepSuper_1('all'))
						AND (maxpermatch186 IS NULL OR maxpermatch180 <> maxpermatch186)
				)

 