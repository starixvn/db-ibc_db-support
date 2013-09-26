/*
	Created by: Jamie
	Correct Casino Tickets

*/


DECLARE @ErrCode INT
DECLARE @ErrMsg NVARCHAR(400),
    @custid INT, @refno BIGINT, @sessionid INT, @turnover MONEY
    , @winlost MONEY, @swinlost MONEY, @mwinlost MONEY, @awinlost MONEY
    , @scomm MONEY, @acomm MONEY, @comm MONEY, @playercomm MONEY
    , @spt MONEY, @mpt MONEY, @apt MONEY 
SELECT @errcode = 0, @errmsg = ''

DECLARE @Casino_tmp_ticket TABLE(
	CustID INT, refno BIGINT, SessionID BIGINT, TurnOver MONEY
	, Winlost MONEY, swinlost MONEY, mwinlost MONEY, awinlost MONEY
	, scomm MONEY, acomm MONEY, comm MONEY, playercomm MONEY
    , spt MONEY, mpt MONEY, apt MONEY 
)

INSERT INTO @Casino_tmp_ticket(
	[CustID], [Refno], [SessionID], [TurnOver]
	, [Winlost], [Swinlost], [mwinlost], [awinlost]
	, [scomm], [acomm], [comm], [playercomm]
	, [spt]	,mpt, apt
)
		  SELECT 12371639,100334149784,7065501,18,0,0,0,16.74,0,0,0,0,0,0,0
UNION ALL SELECT 12359669,100333767547,7061887,114,83,0,0,28.83,0,0,0,0,0,0,0
UNION ALL SELECT 10434595,100334047792,7064404,16016,14579.5,43.095,244.205,861.9,0,0,0,0,0,0,0


DECLARE tmp CURSOR FOR SELECT * FROM @Casino_tmp_ticket
OPEN tmp
FETCH NEXT FROM tmp INTO @custid, @refno, @sessionid, @turnover
						, @winlost, @swinlost, @mwinlost, @awinlost
						, @scomm, @acomm, @comm, @playercomm
						, @spt, @mpt, @apt 

WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC dbo.DBA_Casino_UpdTicket 
	@CustID = @CustID,
	@refno = @refno,
	@sessionID = @sessionID,
	@CS_Turnover = @turnover,
	@CS_winlost = @winlost,
	@CS_swinlost = @swinlost,
	@CS_mwinlost = @mwinlost,
	@CS_awinlost = @awinlost,
	@CS_scomm = @scomm,
	@CS_mcomm = @acomm,
	@CS_acomm = @comm,
	@CS_playercomm = @playercomm,
	@CS_sposition = @spt,
	@CS_mposition = @mpt,
	@CS_aposition = @apt,
	@transdesc = '',
	@IP = '',
	@ErrCode = @ErrCode OUTPUT,
	@ErrMsg = @ErrMsg OUTPUT
   
    FETCH NEXT FROM tmp INTO @custid, @refno, @sessionid, @turnover
							, @winlost, @swinlost, @mwinlost, @awinlost
							, @scomm, @acomm, @comm, @playercomm
							, @spt, @mpt, @apt 

END
CLOSE tmp
DEALLOCATE tmp