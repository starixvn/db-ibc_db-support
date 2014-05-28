 /*
	Created: Johnson
	Date: 2014-05-27
	Task: correct virtual speedway & cycling's maxpermatch for newly deposit customers
	DB: DBTXN/CustDB
 */
 DECLARE @max_Custid INT
 DECLARE @tmpCust TABLE (custid INT)
  
--lastest custid has been updated
SELECT @max_custid = 14670555
 
--1438 rows affected
INSERT INTO @tmpCust(custid)
SELECT custid
FROm custinfo WITH(NOLOCK)
WHERE srecommend IN (SELECT custid 
						FROM Dep_CustSuper WITH(NOLOCK)
						WHERE site IN('asiabet88','W88','alog','TLC','SunGame','MayFair','Zzun88','Bodog','Vwin'
								,'VCasia','OLE777','XTD1','XTD2','Boma365','Saloncs','Salon365','BlueOcean','Hengcai88','Happy1668')
							OR (site = '12bet' and currency not in (13,2,4,15,45,51))
						)
	AND custid> @max_Custid 						 
	AND roleid = 1
	AND (maxpermatch183 <> maxpermatch180 OR maxpermatch185 <> maxpermatch180)	
	
	
UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
SET maxpermatch183 = maxpermatch180,
	maxpermatch185 = maxpermatch180
WHERE Custid IN (SELECT custid from @tmpCust)	