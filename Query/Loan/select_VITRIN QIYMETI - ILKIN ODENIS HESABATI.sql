select id,client,goods_price - down_payment "vitrin/q-ilkin/ö",
disb_date,shop,goods_price,loan_price,down_payment,loan_amount,
case when product = 'Mobil telefon krediti' then 'MOB'
     when product = 'Fast kredit' then 'FST' end as Product
from me_disb_loans dl