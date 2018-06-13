-- Order by name case sensitive
  select USERNAME  FROM [AT_Reports].[dbo].[SM_PREPRODPORTALUSAGELOGS] order by USERNAME
  COLLATE Latin1_General_CS_AS_KS_WS ASC  ;


-- Order by name case sensitive DISTINCT
  select 
  distinct(USERNAME) COLLATE Latin1_General_CS_AS As Shrt_text 
  FROM 
  [AT_Reports].[dbo].[SM_PREPRODPORTALUSAGELOGS] order by Shrt_text
  
-- where condition case sensitive 
select * 
  FROM 
  [AT_Reports].[dbo].[SM_PREPRODPORTALUSAGELOGS] 
  where
  USERNAME COLLATE Latin1_General_CS_AS = 'ANTHONHE1'

  select * 
  FROM 
  [AT_Reports].[dbo].[SM_PREPRODPORTALUSAGELOGS] 
  where
  USERNAME COLLATE Latin1_General_CS_AS = 'AnthonHe1'

-- update case sensitive 
update
  [AT_Reports].[dbo].[SM_PREPRODPORTALUSAGELOGS] 
  set Username = 'AnthonHe1'
  where
  USERNAME COLLATE Latin1_General_CS_AS = 'ANTHONHE1'


