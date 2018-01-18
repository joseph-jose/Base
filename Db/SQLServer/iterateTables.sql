--select top 100 * from Sys.schemas 
Declare @corpID Nvarchar(256)
Set     @corpID = 'xxx'

If      Object_ID('tempdb..#tables') Is Not Null Drop Table #tables
Create  Table #tables (tID Int, SchemaName Nvarchar(256), TableName Nvarchar(256))

Insert  #tables
Select  Row_Number() Over (Order By s.name, so.name), s.name, so.name
From    sysobjects so
Join    sys.schemas s
        On  so.uid = s.schema_id
Join    syscolumns sc
        On  so.id = sc.id
Where   so.xtype = 'u'
And     sc.name = 'GA_ID'

Declare @SQL Nvarchar(Max),
        @schema Nvarchar(256),
        @table Nvarchar(256),
        @iter Int = 1

While   Exists (Select  1
                From    #tables)
Begin

        Select  @schema = SchemaName Collate Database_Default,
                @table = TableName Collate Database_Default
        From    #tables
        Where   tID = @iter

		Set     @Sql = 'Select top 10 *
						From    [' + @schema + '].[' + @table + '] t'
						--Where   CorporationId = ''' + @corpID + ''''

		Exec    sp_executeSQL @SQL;
		--Select @Sql

		Delete  t
		From    #tables t
		Where   tableName = @table
		And     schemaName = @schema

		Set     @iter = @iter + 1
End