 
 /*
	check minPT before check PT rule
 */
 
select *
from custoverride witH(nolock)
where custid in (select * from #customer) --- super, master, agent
and minpositiontaking <> 0.4

select *
from custoverride witH(nolock)
where custid in (select * from #customer) --- super, master, agent
and minlivepositiontaking <> 0.4
and sporttype = 1 and bettype in (1,3,7,8)
