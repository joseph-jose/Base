/****** Script for SelectTopNRows command from SSMS  ******/
select * 
  FROM [GISNet2].[GISWSL].[WA_Netview_View]
  where UnitId2<> 'NA' and UnitId not in
  (
SELECT UNITID
  FROM [GISNet2].[GISWSL].[WA_Netview_View]
  group by UnitId
  having count(UnitId) > 1
  )