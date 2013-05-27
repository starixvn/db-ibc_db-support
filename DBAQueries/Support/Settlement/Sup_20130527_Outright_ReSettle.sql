/*
	Created by: Jamie
	Date: 2013-05-27
	Task: Re-calculate Outright 
	
	Issue: Wrong key the result 
		+ for the selection of "Matteo Manassero " wrong key to LOSE 
			==> Need to change the status to "WON"
		+ for the selection of "Any Other Player" wrong key to WON status.
			==> Need to change the status to "LOSE"	
	
	TEST
	
*/

SELECT	t.teamname, o.* 
FROM	outright o WITH (nolock)
		INNER join team t WITH (nolock) ON o.teamid=t.teamid
WHERE	leagueid = 3841
		and teamname in ('Matteo Manassero','Any Other Player')


-- Matteo Manassero 2066034
EXEC DB02.bodb02.dbo.Dot_Admin_SettleOutright_Event
@matchid = 2066034,
@status = 'WON'
GO
EXEC dbo.Dot_Admin_SettleOutright_Trans
@matchid = 2066034,
@status = 'WON',
@deadheat = 1
GO


-- Any Other Player 2066041
EXEC DB02.bodb02.dbo.Dot_Admin_SettleOutright_Event
@matchid = 2066041,
@status = 'LOSE'
GO
EXEC dbo.Dot_Admin_SettleOutright_Trans
@matchid = 2066041,
@status = 'LOSE',
@deadheat = 1
GO