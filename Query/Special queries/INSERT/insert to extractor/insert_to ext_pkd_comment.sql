insert into ext_pkd_comment (kreditkodu,status,oid,case_status,login,Qrup,text,sistem_vaxti,qeyd_tarixi,tesviri,c_comment,söz_verib,söz_verdiyi_tarix,söz_verdiyi_mebleg,uuid)
select  distinct c.oid kreditkodu,
case when l.status = 'S005' then 'Cari' 
when l.status = 'S006' then 'Bitmis' end as status ,
lc.oid, 
case when lc.closed = 'true' then 'Bagli' 
when lc.closed = 'false' then 'Açiq' end as case_status,
ls.login, 
case when aca.division = 'LO' then 'Kredit'      
when aca.division = 'COL' then 'PKD qrupdan evvel'  
when aca.division = 'LEG' then 'Hüquq' 
when aca.division ='COL01'   then  'Qrup 1-10'
when aca.division ='COL11'   then  'Qrup 11-20'
when aca.division ='COL21'   then  'Qrup 21-30'
when aca.division ='COL31'   then  'Qrup 31-60'
when aca.division ='COL61'   then  'Qrup 61-120'
when aca.division ='COL121'  then  'Qrup 120+'
end as Qrup,      
acat.text,aca.c_date sistem_vaxti,aca.created qeyd_tarixi,
aca.c_descr tesviri,aca.c_comment, case 
when aca.ptp = 'true'  then 'Beli'      
when aca.ptp = 'false' then 'Xeyr' end  söz_verib, 
aca.ptp_date söz_verdiyi_tarix,coalesce(aca.ptp_amount,'0')söz_verdiyi_mebleg,
aca.uuid
from contract c 
join loan l on c.uuid = l.contract_uuid 
join addon_coll_case acc on l.contract_uuid = acc.loan_uuid  
join addon_coll_action aca on acc.uuid = aca.case_uuid 
join addon_coll_action_type acat on aca.type = acat.id 
join lcase lc on acc.bus_case = lc.uuid 
join luser ls on aca.created_by = ls.uuid 
where aca.created >= '2021-07-23' 
except
select * from ext_pkd_comment
