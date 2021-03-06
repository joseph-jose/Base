
Select r.* from
(
select *, ROW_NUMBER()
over (partition by subtype order by subtype asc) as m
  FROM [GISNet2].[GISWSL].[WL_VALVE]
) r where r.m < 10
order by r.SUBTYPE

