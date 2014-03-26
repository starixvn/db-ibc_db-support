/*
	Created: Johnson
	Date: 2014-03-25
	Task: Insert default setting for racing bet setting for UT currency
	DB: DBTXN/CustDB
*/ 

INSERT INTO [RacingBetSetting]
           ([sporttype]
           ,[bettype]
           ,[currency]
           ,[minbet])
SELECT [sporttype]
       ,[bettype]
       ,64 as currency 
       ,[minbet]
FROM RacingBetSetting WITH(NOLOCK)
WHERE currency = 35--US$          