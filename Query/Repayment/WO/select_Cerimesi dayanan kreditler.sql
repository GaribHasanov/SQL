select c.oid,ca.uuid,l.status--sap.*
from
contract c
join loan l on c.uuid = l.contract_uuid 
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
--join susp_accr_period sap on la.contr_acc_uuid = sap.loan_acc_uuid
where l.status = 'S005' and
 exists (
select * from susp_accr_period sapp
	where la.contr_acc_uuid = sapp.loan_acc_uuid
)