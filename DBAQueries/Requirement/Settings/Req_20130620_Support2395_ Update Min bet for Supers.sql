ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	

	@ids varchar(max)

AS

SET NOCOUNT ON

/*

	script: Update Min Bet for credit Supers from min bet setting at currenies

*/

BEGIN

	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('custsetting','custInfo','exchange') AND type = 'U') <> 3

		RETURN

	UPDATE cs 
	SET cs.minbet=ex.minbet
	FROM custSetting cs
	INNER JOIN custInfo c WITH (nolock) ON c.custid=cs.custid
	INNER JOIN exchange ex WITH (NOLOCK) ON c.currency=ex.exchangeid
	WHERE c.roleid=4
	AND c.custid NOT IN (SELECT custid FROM f_depSuper_1('All'))
	AND (cs.minbet<>0) 
	AND (cs.minbet<>ex.minbet)
	AND c.enabled=1

END
