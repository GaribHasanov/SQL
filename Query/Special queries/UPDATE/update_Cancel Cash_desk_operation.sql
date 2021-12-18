update cash_desk_operation cdo
set cancelled = 'true'
from cash_desk cd 
,contract c 
where cdo.cash_desk_uuid = cd.uuid and
      cdo.loan_uuid = c.uuid and
cdo.oper_type = '040'
and cdo.c_date = '2021-12-02' 
and cd.title = 'Online kassa'
 and c.oid in (
'R0010273',
'R0015651',
'R0013087',
'R0004752',
'R0015914',
'R0007806',
'R0015827',
'R0008041',
'R0007981',
'R0006978',
'R0007224',
'R0007966',
'R0011434',
'R0010902',
'R0010391',
'R0023426',
'R0014837',
'R0009490',
'R0008007',
'R0017957',
'R0017898',
'R0021969'
)

and cdo.cancelled = 'false'