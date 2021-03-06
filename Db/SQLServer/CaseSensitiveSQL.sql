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

---select all uppercase characters

  select distinct(username)  
  FROM 
  [AT_Reports].[dbo].[SM_PREPRODPORTALUSAGELOGS] 
  where
  USERNAME = upper(username) collate SQL_Latin1_General_CP1_CS_AS
  order by username desc

---select all lowercase characters
  select distinct(username)  
  FROM 
  [AT_Reports].[dbo].[SM_PREPRODPORTALUSAGELOGS] 
  where
  USERNAME = lower(username) collate SQL_Latin1_General_CP1_CS_AS
    order by username desc

---select all titlecase characters
select distinct(username)  FROM 
  [AT_Reports].[dbo].[SM_PREPRODPORTALUSAGELOGS] 
where username not in
(
  select distinct(username)  
  FROM 
  [AT_Reports].[dbo].[SM_PREPRODPORTALUSAGELOGS] 
  where
  USERNAME = upper(username) collate SQL_Latin1_General_CP1_CS_AS
  union
  select distinct(username)  
  FROM 
  [AT_Reports].[dbo].[SM_PREPRODPORTALUSAGELOGS] 
  where
  USERNAME = lower(username) collate SQL_Latin1_General_CP1_CS_AS
	)
order by username desc