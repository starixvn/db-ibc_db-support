/*
	Author: Elodie
	Created date: 2015-02-05
	Task: [RedmineID #30672]: Manually add missing headline for case "Inform New Brand Name"
	DB: bodb_crm
	SERVER: DBCRM
*/
USE [bodb_CRM]

DECLARE @TitleID INT, @Creator INT
--SELECT @TitleID = ID FROM crmInformTitle WITH (NOLOCK) WHERE Title = 'Inform New Brand Name'
SELECT @TitleID = 11
SELECT @Creator = 998152
 
 --88 row affected
INSERT INTO crmInformHeadline (	HeadlineID
								,TitleID
								,CreatedTime
								,StatusID
								,UpdatedTime  
								,Remark
								,Creator
								,UpdatedBy
								,Extension
								,ProductStatus) 

SELECT ca.custid		HeadlineID,
		@TitleID		TitleID,
		getdate()		CreatedTime,
		7				StatusID,
		NULL			UpdatedTime,
		''				Remark,
		@Creator		Creator,
		NULL			UpdatedBy,
		0				Extension,
		0				ProductStatus
FROM crmHeadLine ca WITH(NOLOCK)
WHERE 1 = CASE WHEN ca.ActiveMembers > 0 AND (ca.ClosedHeadLine=1 OR ca.Reject=1 OR ca.Enabled=0) THEN 1 WHEN ca.ClosedHeadLine=0 AND ca.Reject=0 AND ca.Enabled=1 THEN 1 ELSE 0 END
	AND ca.CustID NOT IN (SELECT HeadlineID FROM crmInformHeadline WITH (NOLOCK) WHERE TitleID = @TitleID)
	