 /*
	Created: Johnson
	Date: 20130527
	Task: Script to group NSW into AUS Racing
 */
 
 
 INSERT INTO RacingPartner(PartnerID,PartnerName,Description,ChannelID)
SELECT 6,'RACE-TABCORPNSW','TabCorp - NSW Australian Horse Racing',5
union 
SELECT 104,'GREY-TABCORPNSW','TabCorp - NSW Australian Greyhound Racing',5
union
SELECT 202,'HAR-TABCORPNSW','TabCorp - NSW Australian Harness Racing',5

declare @NSWMeeting TABLE(meetingID int)

INSERT INTO @NSWMeeting(meetingID)
SELECT leagueid 
FROM league WITH(NOLOCK)
WHERE leaguename LIKE '%(NSW)%' 
and sporttype BETWEEN 151 and 153

UPDATE rm
set rm.PartnerID = CASE rm.PartnerID when 5 then 6
									WHEN 103 THEN 104
									WHEN 201 THEN 202 END
from RacingMeeting rm
INNER JOIN @NSWMeeting n ON rm.MeetingID = n.meetingID






