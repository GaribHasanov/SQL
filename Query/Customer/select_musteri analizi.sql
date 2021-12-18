WITH CTE AS (
select * from (
select dl.id,dl.shop,dl.lo,dl.operator,dl.underwriter,dl.goods_price,
       dl.loan_price,dl.down_payment,dl.loan_amount,dl.term,dl.client,dl.gender,
	   ml.status,ml.new_customer,ml.disbursement_date,ml.zgoods,ml.zarr_days,
	   p.birthday,p.birthplace,p.citizenship,p.nationality,p.marital_status,
       etx.text tehsil,pat.text fealiyyet_sahesi,iat.text veren_organ
from me_loan ml
join me_disb_loans dl on ml.oid = dl.id
join partner p on ml.partner = p.uuid
join idnumber id_ on p.uuid = id_.partner_uuid
join idnumber_authority_tx iat on id_.authority_id = iat.pid
left join education_tx etx on p.education = etx.education_id and etx.lang = 'AZ'
left join person_activity_tx pat on p.activity = pat.pid and pat.lang = 'AZ'
where ml.status in ('S005','S006') and id_.c_type = 'PASS'
)a
left join
(
select a.oid,XMLTABLE.*             
from (
select c.oid ,ad.content
from add_data ad
join addon_rclient_add_data anad on ad.uuid = anad.data_uuid
join addon_rclient arc on anad.rclient_uuid = arc.uuid
join addon_rappl ar on arc.rappl_uuid = ar.uuid
join analysis an on ar.analysis_uuid = an.uuid
join loan l on an.uuid = l.analysis_uuid
join contract c on l.contract_uuid = c.uuid
where ad.config_id = 'xe_rclient'
)a,XMLTABLE ('/rclient' PASSING cast(replace((a.content), 'encoding="utf-8"', '')as xml) 
                 COLUMNS
                   salary text PATH '(client_salary /@value)[1]' ,MKR text PATH '(mkr_history/title_az /@value)[1]' 
                    ) 

)b
on a.id = b.oid
)

select DISTINCT *,DATE_PART('year',CURRENT_DATE::date) - DATE_PART('year', birthday::date)age_
from cte
WHERE ID = 'R0001706'

