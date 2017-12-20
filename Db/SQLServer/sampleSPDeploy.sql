USE [GISAdmin]
GO

/****** Object:  StoredProcedure [GISWSL].[buildSQLfGisId]    Script Date: 9/03/2016 4:20:50 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [GISWSL].[buildSQLfGisId]
	-- Add the parameters for the stored procedure here
	@inTable varchar(100),
	@inGISIdValue numeric
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare	@inSql varchar(500)

	set @inSql = 'Select top 10 GIS_ID '

	if COL_LENGTH(@inTable, 'COMPKEY') is not null
		set @inSql = @inSql + ', COMPKEY'
	else
		set @inSql = @inSql + ', null as COMPKEY'
	if COL_LENGTH(@inTable, 'EQUIP_ID') is not null
		set @inSql = @inSql + ', EQUIP_ID'
	else
		set @inSql = @inSql + ', null as EQUIP_ID'
	if COL_LENGTH(@inTable, 'Comptype') is not null
		set @inSql = @inSql + ', Comptype'
	else
		set @inSql = @inSql + ', null as CompType'
	if COL_LENGTH(@inTable, 'DMS_LINK') is not null
		set @inSql = @inSql + ', DMS_LINK'
	else
		set @inSql = @inSql + ', null as DMS_LINK'
	if COL_LENGTH(@inTable, 'PHOTO_LINK') is not null
		set @inSql = @inSql + ', PHOTO_LINK'
	else
		set @inSql = @inSql + ', null asPHOTO_LINK'
	if COL_LENGTH(@inTable, 'ACCTNO') is not null
		set @inSql = @inSql + ', ACCTNO'
	else
		set @inSql = @inSql + ', null as ACCTNO'
	if COL_LENGTH(@inTable, 'METER_NO') is not null
		set @inSql = @inSql + ', METER_NO'
	else
		set @inSql = @inSql + ', null as METER_NO'
	if COL_LENGTH(@inTable, 'CONSENTNO') is not null
		set @inSql = @inSql + ', CONSENTNO'
	else
		set @inSql = @inSql + ', null as CONSENTNO'

	set @inSql = @inSql + ' FROM ' + @inTable 
	set @inSql = @inSql + ' WHERE GIS_ID = ' + TRY_CONVERT(varchar(20), @inGISIdValue)

	--select @inSql
	exec( @inSql)


END



GO


Grant exec on [GISWSL].[buildSQLfGisId] to GISEditor

GO