/*
	Created: Victor.Su
	Date: 20141230
	Task: Enable sportting solution bet types 
*/

UPDATE Sport_Bettype_Reference WITH (UPDLOCK,ROWLOCK)
SET isactive = 1
WHERE Sporttype = 5
    AND bettype BETWEEN 153 AND 1324 