select aca.*
from addon_coll_case acc 
join addon_coll_action aca on acc.uuid = aca.case_uuid 
join lcase lc on acc.bus_case = lc.uuid 
where lc.oid = '0000072115'


insert into addon_coll_action values
('BDF3A18CA75672C448B589B91966A520','0','COL01','010','2021-09-07',null,'odenishi her ayin 10 u odeyecek',null,false,
 null,null,'2021-09-07',null,'A24C1A676CF849299FC568CF14BA1175',null,'2021-09-07 14:40:57.429','2021-09-07 14:40:57.429','9BF0579DF09C40C1919F8AC8A5E40303')

 
 --uuid-ler deqiq secilmelidir