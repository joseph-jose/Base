USE [GISNet2]
GO

/****** Object:  View [GISWSL].[WA_Asset_View]    Script Date: 24/05/2016 12:55:40 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER view [GISWSL].[WA_Asset_View] (
"gis_id","equip_id","compkey","status","fclass", "Service", "NetViewLayer") 
as (
select gis_id,equip_id,compkey,status, 'W_FITTING' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer  from W_FITTING union all
select gis_id,equip_id,compkey,status,'W_HYDRANT' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer  from W_HYDRANT union all
select gis_id,equip_id,compkey,status,'W_METER' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer  from W_METER union all
select gis_id,equip_id,compkey,status,'W_PIPE' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer  from W_PIPE union all
select gis_id,equip_id,compkey,status,'W_STRUCTURE' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer  from W_STRUCTURE union all
select gis_id,equip_id,compkey,status,'W_VALVE' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer  from W_VALVE union all
select gis_id,equip_id,compkey,status,'WW_FITTING' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer  from WW_FITTING union all
select gis_id,equip_id,compkey,status,'WW_MANHOLE' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer  from WW_MANHOLE union all
select gis_id,equip_id,compkey,status,'WW_PIPE' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer  from WW_PIPE union all
select gis_id,equip_id,compkey,status,'WW_PUMPSTN' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer  from WW_PUMPSTN union all
select gis_id,equip_id,compkey,status,'WW_STRUCTURE' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer  from WW_STRUCTURE union all
select gis_id,equip_id,compkey,status,'W_PUMPSTN' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer  from W_PumpStn union all
select gis_id,equip_id,compkey,status,'OA_ECABLE' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer from OA_ECABLE union all
select gis_id,equip_id,compkey,status,'OA_ESTRUCTURE' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer from OA_ESTRUCTURE union all
select gis_id,equip_id,compkey,status,'OA_EPOINTS' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer from OA_EPOINTS union all
select gis_id,equip_id,compkey,status,'OA_OPOINTS' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer from OA_OPOINTS union all
select gis_id,equip_id,compkey,status,'OA_OLINES' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer from OA_OLINES union all
select gis_id,equip_id,compkey,status,'OA_OSHAPES' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer from OA_OSHAPES union all
select gis_id,equip_id,compkey,status,'W_TPLANT' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer from W_TPLANT union all
--select gis_id,equip_id,compkey,status,'WT_TPlant' FClass from W_TPlant
--select gis_id,equip_id,status,'O_Points' FClass from O_Points union all
--select gis_id,equip_id,status,'O_Lines' FClass from O_Lines union all
--select gis_id,equip_id,status,'O_Shapes' FClass from O_Shapes
select gis_id,equip_id,compkey,status,'W_RESERVOIR' FClass, Service, case Service when 'Transmission' then 'Trans' when 'Local' then 'Loc' end NetViewLayer  from W_Reservoir 
--select gis_id,'','',status,'','N_PIPE' FClass from N_PIPE union all
--select gis_id,equip_id,status,'CP_AnodeBed' FClass from CP_AnodeBed union all
--select gis_id,equip_id,status,'CP_Component' FClass from CP_Component union all
--select gis_id,equip_id,status,'CP_Unit' FClass from CP_Unit union all
--select gis_id,equip_id,status,'E_Cabinet' FClass from E_Cabinet union all
--select gis_id,equip_id,compkey,status,'E_Cable' FClass from E_Cable union all
--select gis_id,equip_id,compkey,status,'E_Pipe' FClass from E_Pipe union all
--select gis_id,equip_id,status,'E_Pole' FClass from E_Pole union all
--select gis_id,equip_id,status,'E_Radio' FClass from E_Radio union all
--select gis_id,equip_id,compkey,status,'E_Structure' FClass from E_Structure union all
--select gis_id,equip_id,status,'E_Unit' FClass from E_Unit union all
--select gis_id,equip_id,status,'WWT_Chamber' FClass from WW_Chamber union all
--select gis_id,equip_id,status,'WWT_PipeOther' FClass from WWT_PipeOther union all
--select gis_id,equip_id,compkey,status,'WWT_TPlant' FClass from WW_TPlant union all
--select gis_id,equip_id,status,'WT_Chamber' FClass from WT_Chamber union all
--select gis_id,equip_id,status,'WT_PipeOther' FClass from WT_PipeOther union all
)










GO


