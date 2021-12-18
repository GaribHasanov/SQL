SELECT uuid_in(md5(random()::text || clock_timestamp()::text)::cstring);
SELECT uuid_in(overlay(overlay(md5(random()::text || ':' || clock_timestamp()::text) placing '4' from 13) placing to_hex(floor(random()*(11-8+1) + 8)::int)::text from 17)::cstring);
     
	 
---WITH REPLASE AND UPPERCASE
SELECT UPPER
(REPLACE(cast(uuid_in(md5(random()::text || clock_timestamp()::text)::cstring) as  char (50) ), '-', '')
)
