UPDATE loan set status='S005', reason=NULL, reason_descr=NULL, rej_date=NULL, rej_by_partner=NULL, rej_timestamp=NULL, completion_date=NULL 
WHERE contract_uuid=(SELECT uuid FROM contract c where c.oid='R0017080'); 
DELETE from loan_status_history 
WHERE new_status='S008' and loan_uuid=(SELECT uuid FROM contract c where c.oid=' R0017080');

--You can change cancelled outstanding loan status to outstanding.