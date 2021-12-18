select ap.oid sifariş_kodu,brt.text filial,ls_.login isi_yaradan,ls_2.login imtina_vuran,
concat(coalesce(p.name,''),' ',coalesce (p.first_name,''),' ',coalesce (p.mid_name,''))asa,
pl.amount məbləğ,ap.rej_date imtina_tarixi,
case when an.rej_by_partner = true then 'bəli' else 'xeyr' end  Müştəri_imtinası,
rrt.text imtina_səbəbi,coalesce(an.reason_descr,'')Səbəbin_təsviri
from analysis an  
join application ap on an.appl_uuid = ap.uuid
join partner p on an.partner_uuid = p.uuid
join pending_loan pl on an.uuid = pl.analysis_uuid
join rej_reason_tx rrt on an.reason = rrt.pid 
join branch br on an.branch_uuid = br.uuid 
join branch_tx brt on br.uuid = brt.branch_uuid and brt.lang = 'AZ'
join luser ls_  on ls_.uuid  = an.loan_officer
join luser ls_2 on ls_2.uuid = an.changed_by
where an.rejected = true and ap.oid = 'Z0000052'
--and ap.rej_date = '2021-04-28'
