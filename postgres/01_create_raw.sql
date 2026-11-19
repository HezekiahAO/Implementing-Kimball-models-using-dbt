-- Raw (source) tables for the fintech app. dbt never writes to these.
-- Timestamps are relative to "now" (UTC) so source freshness checks pass on a fresh load.
create schema if not exists raw;  -- schema that dbt treats as read-only.

drop table if exists raw.transactions cascade;
drop table if exists raw.kyc cascade;
drop table if exists raw.orders cascade;
drop table if exists raw.accounts cascade;
drop table if exists raw.customers cascade;

create table raw.customers (
    customer_id  integer      primary key,
    name         varchar(100) not null,
    email        varchar(150),
    country      varchar(10),
    kyc_status   varchar(30),
    created_at   timestamp    not null
);

create table raw.kyc (
    kyc_id              integer      primary key,
    customer_id         integer      not null references raw.customers (customer_id),
    tier_level          varchar(20),
    id_type             varchar(30),
    id_number           varchar(60),
    document_url        varchar(300),
    verification_status varchar(30),
    verified_at         timestamp,
    created_at          timestamp    not null
);

create table raw.accounts (
    account_id     integer      primary key,
    customer_id    integer      not null references raw.customers (customer_id),
    account_number varchar(20)  not null,
    account_type   varchar(30),
    currency       varchar(3),
    status         varchar(20),
    created_at     timestamp    not null
);

create table raw.orders (
    order_id     integer       primary key,
    customer_id  integer       not null references raw.customers (customer_id),
    total_amount numeric(18,2),
    currency     varchar(3),
    status       varchar(20),
    created_at   timestamp     not null,
    updated_at   timestamp     not null
);

create table raw.transactions (
    transaction_id   integer       primary key,
    account_id       integer       not null references raw.accounts (account_id),
    order_id         integer       references raw.orders (order_id),   -- null for deposits/withdrawals
    amount           numeric(18,2) not null,
    currency         varchar(3),
    transaction_type varchar(30),
    status           varchar(20),
    refrence_code    varchar(30),                                       -- sic: typo exists in the source
    created_at       timestamp     not null,
    debited_at       timestamp                                          -- null until money actually leaves
);

insert into raw.customers values
 (1,'Ada Obi','ADA@MAIL.COM','ng','verified',(now() at time zone 'utc') - interval '5 hours'),
 (2,'Bayo Ade','bayo@mail.com','ng','verified',(now() at time zone 'utc') - interval '5 hours'),
 (3,'Cara Lee','cara@mail.com','gb','pending',(now() at time zone 'utc') - interval '5 hours');

insert into raw.kyc values
 (1,1,'Tier 2','passport','A1234567','https://docs.example/1','Verified',(now() at time zone 'utc') - interval '4 hours',(now() at time zone 'utc') - interval '5 hours'),
 (2,2,'Tier 1','national_id','N7654321','https://docs.example/2','Verified',(now() at time zone 'utc') - interval '4 hours',(now() at time zone 'utc') - interval '5 hours'),
 (3,3,'Tier 1','passport','B9988776','https://docs.example/3','Pending',null,(now() at time zone 'utc') - interval '5 hours');

insert into raw.accounts values
 (10,1,'0011','Wallet','ngn','Active',(now() at time zone 'utc') - interval '5 hours'),
 (11,1,'0012','Savings','ngn','Active',(now() at time zone 'utc') - interval '5 hours'),
 (12,2,'0021','Wallet','ngn','Active',(now() at time zone 'utc') - interval '5 hours'),
 (13,3,'0031','Wallet','gbp','Frozen',(now() at time zone 'utc') - interval '5 hours');

insert into raw.orders values
 (100,1,5000.00,'ngn','Paid',(now() at time zone 'utc') - interval '4 hours',(now() at time zone 'utc') - interval '4 hours'),
 (101,2,1200.50,'ngn','Paid',(now() at time zone 'utc') - interval '4 hours',(now() at time zone 'utc') - interval '3 hours'),
 (102,3,80.00,'gbp','Open',(now() at time zone 'utc') - interval '3 hours',(now() at time zone 'utc') - interval '3 hours');

-- order 100 is paid in two instalments: two transactions share one order
insert into raw.transactions values
 (1,10,100,2500.00,'ngn','Payment','Completed','R-001',(now() at time zone 'utc') - interval '4 hours',(now() at time zone 'utc') - interval '4 hours'),
 (2,10,100,2500.00,'ngn','Payment','Completed','R-002',(now() at time zone 'utc') - interval '4 hours',(now() at time zone 'utc') - interval '4 hours'),
 (3,12,101,1200.50,'ngn','Payment','Completed','R-003',(now() at time zone 'utc') - interval '3 hours',(now() at time zone 'utc') - interval '3 hours'),
 (4,11,null,300.00,'ngn','Deposit','Completed','R-004',(now() at time zone 'utc') - interval '3 hours',(now() at time zone 'utc') - interval '3 hours'),
 (5,11,null,150.00,'ngn','Withdrawal','Failed','R-005',(now() at time zone 'utc') - interval '2 hours',null),
 (6,12,null,75.25,'ngn','Withdrawal','Pending','R-006',(now() at time zone 'utc') - interval '2 hours',null),
 (7,13,102,80.00,'gbp','Payment','Completed','R-007',(now() at time zone 'utc') - interval '1 hours',(now() at time zone 'utc') - interval '1 hours'),
 (8,10,null,500.00,'ngn','Deposit','Completed','R-008',(now() at time zone 'utc') - interval '1 hours',(now() at time zone 'utc') - interval '1 hours');
