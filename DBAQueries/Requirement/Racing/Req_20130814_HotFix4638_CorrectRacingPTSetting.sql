


/*
	correct racing MinPT setting for all affected members
	Using [Acc_CustSetting3rd_00] to correct by super
*/ 



create table #temp (custid int primary key, isfinished bit)

INSERT INTO #temp (custid, isfinished)
SELECT srecommend,0
from CustSetting3rd cs3 witH(nolock)
	 inner join custInfo c with(nolock) on cs3.custid = c.custid 
	 inner join custoverride3rd sco3 witH(nolock) on sco3.custid = c.srecommend
		 and sco3.sporttype = cs3.sporttype and cs3.bettype = sco3.bettype
	 inner join custoverride3rd mco3 witH(nolock) on mco3.custid = c.mrecommend
		 and mco3.sporttype = cs3.sporttype and cs3.bettype = mco3.bettype
	 inner join custoverride3rd aco3 witH(nolock) on aco3.custid = c.recommend
		 and aco3.sporttype = cs3.sporttype and cs3.bettype = aco3.bettype
where cs3.sporttype in (151,152,153)
--and (minbet = 0 and  maxbet = 0 )
--and (minbet <> 0 or maxbet <> 0 )
 and apositiontaking = 0 and mpositiontaking = 0 and spositiontaking = 0
and roleid = 1
and Enabled = 1 --and closed = 0 and reject = 0
and currency <> 20
and ( sco3.minpositiontaking <> 0 or mco3.minpositiontaking<>0
 or aco3.minpositiontaking <> 0)
 group by srecommend 
 
GO

declare @id int, @rowcnt int

while (1=1)
begin
	select @id = 0
	
	update TOP (1) #temp
	set @id = custid
		,isfinished = 1
	from #temp
	where isfinished = 0

	select @rowcnt = @@rowcount	
	
	EXEC [dbo].[Acc_CustSetting3rd_00]	@srecommend = @id,	@mode = 'horse'
	
	if @rowcnt < 1 RETURN

	WAITFOR DELAY '00:00:01'
end
