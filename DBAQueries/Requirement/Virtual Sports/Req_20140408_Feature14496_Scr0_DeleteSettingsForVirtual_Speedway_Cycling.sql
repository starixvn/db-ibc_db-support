/*
	Created: Johnson
	Date: 2014-04-08
	Task: Delete existing settings of virtual speedway /cycling 
	DB: DBTXN/CustDB
*/ 

DELETE CustSetting3rd WITH(ROWLOCK,UPDLOCK)
WHERE sporttype IN (183,185) AND bettype = 1231