USE bodb_RMS
GO

ALTER table rmSumWinloss Add recommend2 int null
GO

ALTER table rmSumWinloss_Old Add recommend int null
GO


/****** Object:  Index [IX_recommend]    Script Date: 09/24/2013 09:35:40 ******/
CREATE NONCLUSTERED INDEX [IX_recommend] ON [dbo].[rmSumWinloss] 
(
	[recommend] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

GO


/****** Object:  Index [IX_recommend]    Script Date: 09/24/2013 09:35:58 ******/
CREATE NONCLUSTERED INDEX [IX_recommend] ON [dbo].[rmSumWinloss_Old] 
(
	[recommend] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


GO
/****** Object:  Index [IX_recommend]    Script Date: 09/24/2013 10:07:37 ******/
CREATE NONCLUSTERED INDEX [IX_recommend] ON [dbo].[rmBettrans] 
(
	[recommend] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]