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
  
  
  ---------------------------------------------------
  */*******Update duplicate records *******/
  with cte as
(
	select  objectId, ID , Route, FROMNAME, TONAME, DIRECTION, CATEGORY, 
	ROW_NUMBER() over (
	partition by
		ID , Route, FROMNAME, TONAME, DIRECTION, CATEGORY
	order by
		ID , Route, FROMNAME, TONAME, DIRECTION, CATEGORY
	) row_num  from EXT.gisadmin.SNITCH_ATTRIBUTEDATAMONTHLY_XR 
	where month = '2020/01' and CATEGORY = 'AM'
)
Update cte set Direction = Direction + 'Mod' where row_num > 1;

 ---------------------------------------------------
  */*******identify duplicate records using rank *******/
  
with cte as
(
	SELECT * , ROW_NUMBER() OVER(PARTITION BY ProjectNo_UniqueID  ORDER BY ProjectNo_UniqueID) AS RowNumberRank
	FROM [AT].[gisadmin].[PG_MIWPROJECTAREASEDIT_TE] 
)
select * from cte where RowNumberRank > 1
