update raw.transactions
   set status = 'Completed', debited_at = (now() at time zone 'utc')
 where transaction_id = 6;

insert into raw.transactions values
 (9,10,null,100.00,'ngn','Deposit','Completed','R-009',
  (now() at time zone 'utc') - interval '10 minutes',(now() at time zone 'utc') - interval '10 minutes');
