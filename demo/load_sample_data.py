import duckdb
con = duckdb.connect("demo/demo.duckdb")
con.execute("create schema if not exists raw")
con.execute("""
create or replace table raw.customers as select * from (values
 (1,'Ada Obi','ADA@MAIL.COM','ng','verified','2026-01-05'::timestamp),
 (2,'Bayo Ade','bayo@mail.com','ng','verified','2026-01-09'::timestamp),
 (3,'Cara Lee','cara@mail.com','gb','pending','2026-02-01'::timestamp)
) t(customer_id,name,email,country,kyc_status,created_at)""")
con.execute("""s
create or replace table raw.accounts as select * from (values
 (10,1,'0011','Wallet','ngn','Active','2026-01-05'::timestamp),
 (11,1,'0012','Savings','ngn','Active','2026-01-06'::timestamp),
 (12,2,'0021','Wallet','ngn','Active','2026-01-09'::timestamp),
 (13,3,'0031','Wallet','gbp','Frozen','2026-02-01'::timestamp)
) t(account_id,customer_id,account_number,account_type,currency,status,created_at)""")
con.execute("""
create or replace table raw.orders as select * from (values
 (100,1,5000.00,'ngn','Paid','2026-03-01 09:00'::timestamp,'2026-03-01 09:05'::timestamp),
 (101,2,1200.50,'ngn','Paid','2026-03-01 10:00'::timestamp,'2026-03-01 10:02'::timestamp),
 (102,3,80.00,'gbp','Open','2026-03-02 11:00'::timestamp,'2026-03-02 11:00'::timestamp)
) t(order_id,customer_id,total_amount,currency,status,created_at,updated_at)""")
# order 100 is paid in two instalments -> two transactions share one order (fan-out trap)
con.execute("""
create or replace table raw.transactions as select * from (values
 (1,10,100,2500.00,'ngn','Payment','Completed','R-001','2026-03-01 09:01'::timestamp,'2026-03-01 09:02'::timestamp),
 (2,10,100,2500.00,'ngn','Payment','Completed','R-002','2026-03-01 09:03'::timestamp,'2026-03-01 09:04'::timestamp),
 (3,12,101,1200.50,'ngn','Payment','Completed','R-003','2026-03-01 10:01'::timestamp,'2026-03-01 10:01'::timestamp),
 (4,11,null,300.00,'ngn','Deposit','Completed','R-004','2026-03-01 12:00'::timestamp,'2026-03-01 12:00'::timestamp),
 (5,11,null,150.00,'ngn','Withdrawal','Failed','R-005','2026-03-01 13:00'::timestamp,null),
 (6,12,null,75.25,'ngn','Withdrawal','Pending','R-006','2026-03-02 08:00'::timestamp,null),
 (7,13,102,80.00,'gbp','Payment','Completed','R-007','2026-03-02 11:01'::timestamp,'2026-03-02 11:01'::timestamp),
 (8,10,null,500.00,'ngn','Deposit','Completed','R-008','2026-03-02 14:00'::timestamp,'2026-03-02 14:00'::timestamp)
) t(transaction_id,account_id,order_id,amount,currency,transaction_type,status,refrence_code,created_at,debited_at)""")
print("Loaded your Data! You can now run dbt models to transform the data. :)")
