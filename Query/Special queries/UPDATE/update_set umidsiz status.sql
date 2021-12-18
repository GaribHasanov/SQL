update loan l
set loan_categ = '01' --status code
from contract c
where l.contract_uuid = c.uuid
and c.oid in
(
'R0005801',
'R0005824',
'R0005848'

)