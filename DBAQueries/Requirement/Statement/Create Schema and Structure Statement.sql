USE [bodb_report]
GO
----------
--1
--Create file group 
ALTER DATABASE bodb_report ADD filegroup [rptSTATEMENT_14M01]
ALTER DATABASE bodb_report ADD filegroup [rptSTATEMENT_14M02]
ALTER DATABASE bodb_report ADD filegroup [rptSTATEMENT_14M03]
ALTER DATABASE bodb_report ADD filegroup [rptSTATEMENT_14M04]
ALTER DATABASE bodb_report ADD filegroup [rptSTATEMENT_14M05]
ALTER DATABASE bodb_report ADD filegroup [rptSTATEMENT_14M06]
ALTER DATABASE bodb_report ADD filegroup [rptSTATEMENT_14M07]
ALTER DATABASE bodb_report ADD filegroup [rptSTATEMENT_14M08]
ALTER DATABASE bodb_report ADD filegroup [rptSTATEMENT_14M09]
ALTER DATABASE bodb_report ADD filegroup [rptSTATEMENT_14M10]
ALTER DATABASE bodb_report ADD filegroup [rptSTATEMENT_14M11]
ALTER DATABASE bodb_report ADD filegroup [rptSTATEMENT_14M12]

ALTER DATABASE bodb_report ADD FILE (name = 'rptSTATEMENT_14M01', filename ='D:\IBC_DB\bodb_Report\rptSTATEMENTSTATEMENT_14M01.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [rptSTATEMENT_14M01]
ALTER DATABASE bodb_report ADD FILE (name = 'rptSTATEMENT_14M02', filename ='D:\IBC_DB\bodb_Report\rptSTATEMENTSTATEMENT_14M02.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [rptSTATEMENT_14M02]
ALTER DATABASE bodb_report ADD FILE (name = 'rptSTATEMENT_14M03', filename ='D:\IBC_DB\bodb_Report\rptSTATEMENTSTATEMENT_14M03.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [rptSTATEMENT_14M03]
ALTER DATABASE bodb_report ADD FILE (name = 'rptSTATEMENT_14M04', filename ='D:\IBC_DB\bodb_Report\rptSTATEMENTSTATEMENT_14M04.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [rptSTATEMENT_14M04]
ALTER DATABASE bodb_report ADD FILE (name = 'rptSTATEMENT_14M05', filename ='D:\IBC_DB\bodb_Report\rptSTATEMENTSTATEMENT_14M05.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [rptSTATEMENT_14M05]
ALTER DATABASE bodb_report ADD FILE (name = 'rptSTATEMENT_14M06', filename ='D:\IBC_DB\bodb_Report\rptSTATEMENTSTATEMENT_14M06.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [rptSTATEMENT_14M06]
ALTER DATABASE bodb_report ADD FILE (name = 'rptSTATEMENT_14M07', filename ='D:\IBC_DB\bodb_Report\rptSTATEMENTSTATEMENT_14M07.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [rptSTATEMENT_14M07]
ALTER DATABASE bodb_report ADD FILE (name = 'rptSTATEMENT_14M08', filename ='D:\IBC_DB\bodb_Report\rptSTATEMENTSTATEMENT_14M08.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [rptSTATEMENT_14M08]
ALTER DATABASE bodb_report ADD FILE (name = 'rptSTATEMENT_14M09', filename ='D:\IBC_DB\bodb_Report\rptSTATEMENTSTATEMENT_14M09.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [rptSTATEMENT_14M09]
ALTER DATABASE bodb_report ADD FILE (name = 'rptSTATEMENT_14M10', filename ='D:\IBC_DB\bodb_Report\rptSTATEMENTSTATEMENT_14M10.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [rptSTATEMENT_14M10]
ALTER DATABASE bodb_report ADD FILE (name = 'rptSTATEMENT_14M11', filename ='D:\IBC_DB\bodb_Report\rptSTATEMENTSTATEMENT_14M11.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [rptSTATEMENT_14M11]
ALTER DATABASE bodb_report ADD FILE (name = 'rptSTATEMENT_14M12', filename ='D:\IBC_DB\bodb_Report\rptSTATEMENTSTATEMENT_14M12.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [rptSTATEMENT_14M12]
----------
--2
--Create partition function
CREATE PARTITION FUNCTION pf_rptSTATEMENT_monthly (DATE) AS
RANGE LEFT FOR VALUES
(    
    '2014/01/31 00:00:00.000',
    '2014/02/28 00:00:00.000',
    '2014/03/31 00:00:00.000',
    '2014/04/30 00:00:00.000',
    '2014/05/31 00:00:00.000',
    '2014/06/30 00:00:00.000',
    '2014/07/31 00:00:00.000',
    '2014/08/31 00:00:00.000',
    '2014/09/30 00:00:00.000',
    '2014/10/31 00:00:00.000',
    '2014/11/30 00:00:00.000'
)
----------
--3
--Create partition schema
CREATE PARTITION SCHEME ps_rptSTATEMENT_monthly
AS PARTITION pf_rptSTATEMENT_monthly
TO
    (
	[rptSTATEMENT_14M01], 
	[rptSTATEMENT_14M02], 
	[rptSTATEMENT_14M03], 
	[rptSTATEMENT_14M04], 
	[rptSTATEMENT_14M05], 
	[rptSTATEMENT_14M06], 
	[rptSTATEMENT_14M07], 
	[rptSTATEMENT_14M08], 
	[rptSTATEMENT_14M09], 
	[rptSTATEMENT_14M10], 
	[rptSTATEMENT_14M11], 
	[rptSTATEMENT_14M12]
 )                
GO
 
----------
--4
--Create rptStatementOld table


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS(SELECT TOP 1 1 FROM sys.objects
	WHERE name = 'rptStatement_Old' AND type='U'
	)
BEGIN
	DROP TABLE [dbo].[rptStatement_Old]
END

CREATE TABLE [dbo].[rptStatement_Old](
	[WinlostDate] [DATE] NOT NULL,
	[Custid] [int] NOT NULL,
	[OpeningBalance] [money] NULL,
	[VoidAmt] [money] NULL,
	[Turnover] [money] NULL,
	[NetTurnover] [money] NULL,
	[TransferAmt] [money] NULL,
	[Winlost] [money] NULL,	
	[Comm] [money] NULL,
	[ClosingBalance] [money] NULL,
 CONSTRAINT [CIX_rptStatement_Old_winlostdate_custid] PRIMARY KEY CLUSTERED 
(
	[WinlostDate] ASC,
	[Custid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON ps_rptSTATEMENT_monthly ([WinlostDate])
) ON ps_rptSTATEMENT_monthly ([WinlostDate])

GO