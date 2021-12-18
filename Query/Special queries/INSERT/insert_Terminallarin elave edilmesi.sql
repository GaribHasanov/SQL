select * from integr_mapping

select * from movement_form
select * from movement_form_tx

insert into movement_form values ('050');
insert into movement_form_tx values ('050','Yigim','AZ');
insert into movement_form_tx values ('050','Yigim','EN');
insert into movement_form_tx values ('050','Yigim','RU');
insert into integr_mapping values ('ONLINE_PAYMENT_SERVICE_SYSTEM_ID','CAB5E39144E4FF5573153E144264','Movement form -> Yigim','050')

Daha sonra LW-den ADMIM adli funksiya ilə deploy edilir