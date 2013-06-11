
/*	Created by: Jamie@20130522
	Task: Affected Licensee List with Negative Balance 
*/


SELECT   DISTINCT b.username, b.custID
FROM Bettrans b WITH (NOLOCK)
	INNER JOIN Outright o WITH (NOLOCK) ON b.matchid = o.orid 
WHERE
( 
	(o.leagueid IN (
		16813	, --	BALLINA(AUS)
		29186	 --	BALLINA(AUS)(NSW)
	) AND o.groupmatch IN ('2','3'))
OR(	o.leagueID IN (
		16819	, --	CESSNOCK(AUS)
		22373	, --	CESSNOCK(AUS)
		29192	, --	CESSNOCK(AUS)(NSW)
		29315	  --	CESSNOCK(AUS)(NSW)
	)
	AND o.groupmatch IN ('4'))
	OR( o.LeagueID IN(
			23970	, --	GEELONG HR(AUS)
			29331	, --	GEELONG HR(AUS)(NSW)
			16699	, --	GEELONG(AUS)
			22334	, --	GEELONG(AUS)
			29276	, --	GEELONG(AUS)(NSW)
			29072	  --	GEELONG(AUS)(NSW)
		) AND o.groupmatch IN ('3','4'))
		
	OR( o.LeagueID IN(	
		16758	, --	TOWNSVILLE(AUS)
		22352	, --	TOWNSVILLE(AUS)
		29131	, --	TOWNSVILLE(AUS)(NSW)
		29294	  --	TOWNSVILLE(AUS)(NSW)
	) AND  o.groupmatch IN ('1','2'))
)
AND b.bettype BETWEEN 31 AND 33 
AND b.status NOT IN ('VOID','REJECT')
AND b.srecommend IN (SELECT custID FROM f_DepSuper_1('ALL'))
AND b.winlostdate ='2013-05-21'

ORDER BY b.username 