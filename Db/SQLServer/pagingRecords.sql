    /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 100 *
  FROM GISNet2.[GISWSL].WA_Admin_View 
  where (DATASOURCE  ='R0006515')
  order by FCLASS asc
  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM GISNet2.[GISWSL].WA_Admin_View 
  where (DATASOURCE  ='R0006515')
  order by FCLASS asc
  offset 30 rows
  fetch next 10 rows only


