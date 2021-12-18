SELECT t.day::date as calendar
FROM   
generate_series(timestamp '2021-07-23',  date(now()), interval  '1 day') AS t(day);