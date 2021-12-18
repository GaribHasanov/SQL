UPDATE loan set status='S006',completion_date = '2021-08-20'
where contract_uuid= (SELECT uuid FROM contract c where c.oid='R0017080')
---if the outstanding balance is zero but the loan was not completed yet.You can change the outstanding 'S005' status to completed 'S006' 