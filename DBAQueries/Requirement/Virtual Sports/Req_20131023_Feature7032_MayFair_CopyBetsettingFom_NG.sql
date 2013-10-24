/*
	20131023@Johnson
	MayFair licensee customers 
	Virtual soccer: copy bet setting from NG 
*/

	DECLARE @maxCustID INT

	SET @maxCustID = xxx

	--1189 rows affected
	UPDATE vs WITH(ROWLOCK,UPDLOCK)
	SET  minbet = ng.minbet
		,maxbet = ng.maxbet
		,vs.apositiontaking = ng.apositiontaking			
		,vs.mpositiontaking = ng.mpositiontaking
		,vs.spositiontaking = ng.spositiontaking
	FROM Dep_Custsetting3rd vs
		INNER JOIN custinfo c WITH(NOLOCK) ON c.custid = vs.custid 		
		INNER JOIN Dep_Custsetting3rd ng WITH(NOLOCK) ON vs.custid = ng.custid
			AND vs.sporttype = 180 AND vs.bettype = 1201 AND ng.sporttype = 161 AND ng.bettype = 81
	WHERE vs.custid <= @maxCustID
		AND
		(		
			vs.minbet <> ng.minbet
			OR
			vs.maxbet <> ng.maxbet
			OR
			vs.apositiontaking <> ng.apositiontaking
			OR 
			vs.mpositiontaking <> ng.mpositiontaking
			OR 
			vs.spositiontaking <> ng.spositiontaking
		)
		AND srecommend IN (SELECT custid 
							from Dep_CustSuper with(nolock) 
							where site = 'Mayfair' and currency IN  (2, 4, 15, 13, 3, 32)
						)
GO

--update maxpermatch
	DECLARE @maxCustID INT

	SET @maxCustID = xxx		
	
	--1157 customers affected
	UPDATE custinfo WITH(ROWLOCK,UPDLOCK)
	SET maxpermatch180 = maxpermatch161
	WHERE srecommend IN (SELECT custid 
								from Dep_CustSuper with(nolock) 
								where site = 'Mayfair' and currency IN  (2, 4, 15, 13, 3, 32)
							)
		AND (maxpermatch180 <> maxpermatch161 OR maxpermatch180 IS NULL)
		AND custid <= @maxCustID
				
