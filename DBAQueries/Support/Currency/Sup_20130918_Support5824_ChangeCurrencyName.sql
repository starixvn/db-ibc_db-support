/*
	Created by: Jamie 
	Description: Change the currency Name of customer "H1" from RM to HK$ 
	Date: 2013-09-18
	
*/

EXEC dbo.DBA_ChangeCurrency 
@UserName = 'H1',
@NewCurrency = 'HK$',
@UserID = 5838421 --- DBAAdmin 