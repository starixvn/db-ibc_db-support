  /*
	Created: Johnson
	Date: 2014-04-08
	Task: Insert settings for virtual speedway/cycling from virtual soccer for credit customers
	DB: DBTXN/CustDB
 */
 
 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo') AND type = 'U' ) <> 1
		RETURN
	
	UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
	SET maxpermatch183 = maxpermatch180, 
		maxpermatch185 = maxpermatch180
	WHERE srecommend = @srecommend
		AND custid <= @maxcustid
	
	
END