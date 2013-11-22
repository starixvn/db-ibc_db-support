/*
	Created: Johnson
	Date: 20131122
	Task: Clear old setting on virtual greyhound and virtual motor racing for deposit customers
	DB: DBTXN/bodb02
*/ 

DELETE CustSetting3rd WITH(UPDLOCK,ROWLOCK)
WHERE sporttype