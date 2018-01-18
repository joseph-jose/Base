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
And     sc.name = 'GISId'

Declare @SQL Nvarchar(Max),
        @schema Nvarchar(256),
        @table Nvarchar(256),
        @iter Int = 1

While   Exists (Select  1
                From    #tables)
Begin

        Select  @schema = SchemaName,
                @table = TableName
        From    #tables
        Where   tID = @iter

        If      Exists (Select  1
                        From    sysobjects o
                        Join    sys.schemas s1
                                On  o.uid = s1.schema_id
                        Join    sysforeignkeys fk
                                On  o.id = fk.rkeyid
                        Join    sysobjects o2
                                On  fk.fkeyid = o2.id
                        Join    sys.schemas s2
                                On  o2.uid = s2.schema_id
                        Join    #tables t
                                On  o2.name = t.TableName Collate Database_Default
                                And s2.name = t.SchemaName Collate Database_Default
                        Where   o.name = @table
                        And     s1.name = @schema)
        Begin
                Update  t
                Set     tID = (Select Max(tID) From #tables) + 1
                From    #tables t
                Where   tableName = @table
                And     schemaName = @schema

                Set     @iter = @iter + 1
        End
        Else
        Begin
                Set     @Sql = 'Select t
                                From    [' + @schema + '].[' + @table + '] t
                                Where   CorporationId = ''' + @corpID + ''''

                Exec    sp_executeSQL @SQL;

                Delete  t
                From    #tables t
                Where   tableName = @table
                And     schemaName = @schema

                Set     @iter = @iter + 1

        End
End