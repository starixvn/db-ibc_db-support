
/*
	Created by: Jamie
	Date: 2013-06-19
	Task: Refund race 1 of meeting Poole(UK)

*/

DECLARE
    @programID VARCHAR(10),
    @leagueID	INT,
    @eventdate SMALLDATETIME,
    @programdate SMALLDATETIME,
    @raceNumber INT,
    @runnerNumber INT,
    
    @Action	VARCHAR(10),
	@Result	INT,
    @userid INT ----doing update status userid
    
 
SELECT	@programID		= '48303'
		,@LeagueID		= 21082
		,@eventdate		= '2013-06-18 00:00:00'
		,@programdate	= '2013-06-18 00:00:00'
		,@raceNumber	= 1
		
		,@Action		='REFUND'
		,@Result		= 0 
		,@userid		= 151 
		
--1. DB02.dbodb02 - Check the status of outright before settlement : oddsstatus='Closed' and Calculate = 0 

SELECT	100 leagueid, programid, eventdate, programdate, placing,oddsstatus,odds, placeodds,isFavor, isSCR
FROM	Outright with (nolock)
WHERE	leagueid = xxx		 -- 21082
		AND eventdate='xxx'  --'2013-06-18'
		AND groupmatch='xxx' -- 1
		
SELECT	Calculate,* 
FROM	RaceInfo WITH (NOLOCK)
WHERE	leagueid = xxx			-- 21082
		AND	RaceNumber =xxx		-- 1
		AND	ProgramDate='xxx'	-- '2013-06-18'
		
	--1.1 DB06 or DB053 Checking detail 	
	SELECT	TOP 10 leagueid, leaguename, sporttype, *
	FROM	League WITH (NOLOCK)
	WHERE	leaguename LIKE '%xxx%'  --Poole(UK)

	SELECT   o.leagueid, o.groupmatch, b.custid, b.username,b.status, b.*
	FROM	Bettrans b WITH (NOLOCK)
			INNER JOIN Outright o WITH (NOLOCK) ON b.matchid = o.orid 
	WHERE	o.leagueid IN (
				xxx -- 21082
			) 
			AND o.groupmatch IN ('xxx') --1
			
		

--2. DB02.bodb02 - Check meeting calculated or not ?

EXEC DB02.bodb02.dbo.Admin_3rdAutoSettlement_s151_Admin_Step1 
@LeagueID = @LeagueID,
@raceNumber = @raceNumber,
@programdate = @programdate,
@Action = @Action,
@Result = @Result OUTPUT



--3. DBTRANS.bodb02 - Calculate tickets
EXEC [dbo].[Admin_3rdAutoSettlement_s151_Admin_Step2]
        @LeagueID = @LeagueID,
        @raceNumber = @raceNumber,
        @eventdate = @eventdate,
        @programdate = @programdate,
        @ACTION = @Action
        

--4. DB02.bodb02 - UPDATE Outright
EXEC DB02.bodb02.dbo.[Admin_3rdAutoSettlement_s151_Admin_Step3]
        @LeagueID = @LeagueID,
        @raceNumber = @raceNumber,
        @programdate = @programdate,
        @ACTION = @Action