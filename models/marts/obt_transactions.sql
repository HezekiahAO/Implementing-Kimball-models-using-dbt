-- One Big Table: fact + every dimension, flattened. Surrogate keys omitted.
select
    -- fact
    f.transaction_id,
    f.reference_code,
    tt.transaction_type,
    ts.transaction_status,
    f.amount,
    f.currency                 as transaction_currency,
    f.transaction_created_at,
    f.debited_at,

    -- accounts
    a.account_id,
    a.account_number,
    a.account_type,
    a.account_currency,
    a.account_status,

    -- customers
    c.customer_id,
    c.customer_name,
    c.customer_email,
    c.customer_country,
    c.kyc_status,
    c.customer_signup_date,

    -- orders
    o.order_id,
    o.order_total_amount,
    o.order_currency,
    o.order_status,
    o.order_created_at,
    o.order_updated_at,

    -- date
    d.full_date,
    d.day_of_week,
    d.week,
    d.month,
    d.quarter,
    d.year,
    d.is_weekend

from {{ ref('fact_transactions') }} f
left join {{ ref('dim_accounts') }}            a  on f.account_key            = a.account_key
left join {{ ref('dim_customers') }}           c  on f.customer_key           = c.customer_key
left join {{ ref('dim_orders') }}              o  on f.order_key              = o.order_key
left join {{ ref('dim_transaction_type') }}    tt on f.transaction_type_key   = tt.transaction_type_key
left join {{ ref('dim_transaction_status') }}  ts on f.transaction_status_key = ts.transaction_status_key
left join {{ ref('dim_date') }}                d  on f.date_key               = d.date_key
