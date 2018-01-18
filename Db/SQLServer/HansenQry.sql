Select * from XAPUTILITY 

select * from SysObjects where name like '%XAPUTILITY%'

select * from Syscolumns where name like 'acctkey%' or name like 'apkey%'

select * from Sysobjects where id = 1782297409


select * from Sysobjects where id in
(
select id from Syscolumns where name like 'acctkey%' or name like 'apkey%'
)