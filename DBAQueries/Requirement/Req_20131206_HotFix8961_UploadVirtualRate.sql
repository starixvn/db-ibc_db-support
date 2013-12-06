 /*
	Created by: Elodie
	Date: 2013-12-06
	Task: Upload Virtual Rate_Unexpected error shows when open excel file [Red:#8961]
*/

USE [bodb_ACC]

GO
ALTER TABLE dbo.Acc_CustVirtualRate ALTER COLUMN UserName [nvarchar](50) NOT NULL
       