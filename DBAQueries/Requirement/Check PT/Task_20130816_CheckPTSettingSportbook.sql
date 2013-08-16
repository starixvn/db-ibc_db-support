/*
	Created: Johnson
	Date: 2013-08-16
	Task: check pt setting on sportbook for credit
	DB: DBAGE/bodb02
*/ 

CREATE TABLE #Super (custid INT, sporttype int, isfinished bit default(0))

DECLARE @tmpSports (sporttype int)

INSERT INTO @tmpSports 
SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 5 UNION SELECT 8 
UNION SELECT 10 UNION SELECT 11 UNION SELECT 99

INSERT INTO #Super(custid, sporttype)
SELECT custid, sporttype
FROM custinfo WITH(NOLOCK),
	@tmpSports s
WHERE roleid = 4
	AND custid NOT IN (SELECT custid FROM f_DepSuper_1('All'))

DECLARE @custid INT, @sporttype INT
--SELECT @sporttype = 0

WHILE (1=1)
BEGIN
	SELECT @custid = top (1) custid FROM #super WHERE isfinished = 0
	
	IF @custid IS NULL 
		RETURN
	
	IF @sporttype = 0
	BEGIN
		EXEC CheckPTCustSetting @srecommend = @custid , @sporttype = 0
		
		UPDATE #super 
		SET isfinished = 1
		WHERE custid = @custid		
	END
	ELSE
	BEGIN
		WHILE (1=1)
		BEGIN
			SELECT @sporttype = top(1) sporttype FROM #super WHERE custid = @custid AND isfinished = 0
			
			EXEC CheckPTCustSetting @srecommend = @custid, @sportype = @sporttype
			
			UPDATE #super 
			SET isfinished = 1
			WHERE custid = @custid AND sporttype = @sporttype
		END	
	END
	
	WAITFOR DELAY '0:0:01'
END

GO


CREATE PROCEDURE [dbo].[CheckPTCustSetting]
	@srecommend INT,
	@sporttype INT = 0
AS
/*
	Checking PT values of member

		S4 < S1 + M1 + A1
		N4 > S1 + M1 + A1
		M3 < M1 + A1
		N3 > M1 + A1
		N2 > A1
		A4 < A1
		S1 < 0 || M1 < 0 || A1 < 0
	    S1 + M1 + A1 > 0.9
*/
BEGIN
	SET NOCOUNT ON
	SELECT @sporttype = CASE WHEN @sporttype = 0 THEN NULL ELSE @sporttype END
	-- S4 < S1 + M1 + A1
	SELECT ci.custid
	FROM custinfo ci WITH (NOLOCK)
		JOIN dbo.CustSetting3rd cs WITH (NOLOCK) ON cs.custid=ci.custid
		JOIN dbo.CustSetting3rd scs WITH (NOLOCK) ON scs.custid=ci.srecommend and scs.sporttype=cs.sporttype and scs.bettype=cs.bettype    
	WHERE ci.srecommend = @srecommend AND roleid=1 and cs.sporttype= ISNULL(@sporttype,cs.sporttype)
		and scs.spositiontaking < cs.spositiontaking + cs.mpositiontaking + cs.apositiontaking
		
	
END	
GO