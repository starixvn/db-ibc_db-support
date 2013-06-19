--2. UPDATE MIN BET FOR DIRECT MASTERS 
ALTER PROCEDURE [dbo].[Acc_ExecRep_09]	

	@ids varchar(max)

AS

SET NOCOUNT ON

/*

	script: Update Min Bet for direct masters, copied value from dummy super

*/

BEGIN

	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('custsetting','custInfo') AND type = 'U') <> 2

		RETURN

	-- The maximum about 29,222 records are effected
	UPDATE csm 
	SET csm.minbet=cs.minbet
	FROM custSetting csm
	INNER JOIN custInfo c WITH (nolock) ON c.custid=csm.custid
	INNER JOIN custSetting cs WITH (nolock) ON c.srecommend=cs.custid
	WHERE c.roleid=3 AND cs.sporttype=csm.sporttype AND cs.bettype=csm.bettype
	AND c.srecommend<=100 
	AND (csm.minbet<>0 and cs.minbet<>0) 
	AND (csm.minbet > cs.minbet)
	AND c.enabled=1

END
