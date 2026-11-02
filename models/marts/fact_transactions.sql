-- Grain: one row per transaction
select
    t.transaction_id,

    -- foreign keys
    cast(
        extract(year from t.transaction_created_at) * 10000
        + extract(month from t.transaction_created_at) * 100
        + extract(day from t.transaction_created_at)
    as integer)                               as date_key,
    cast(
        extract(year from t.debited_at) * 10000
        + extract(month from t.debited_at) * 100
        + extract(day from t.debited_at)
    as integer)                               as debited_date_key,
    a.account_key,
    c.customer_key,
    o.order_key,
    tt.transaction_type_key,
    ts.transaction_status_key,

    -- measures
    t.amount,
    t.currency,

    -- degenerate dimension and timestamps
    t.reference_code,
    t.transaction_created_at,
    t.debited_at

from {{ ref('stg_transactions') }} t
left join {{ ref('dim_accounts') }}            a  on t.account_id         = a.account_id
left join {{ ref('dim_customers') }}           c  on a.customer_id        = c.customer_id
left join {{ ref('dim_orders') }}              o  on t.order_id           = o.order_id
left join {{ ref('dim_transaction_type') }}    tt on t.transaction_type   = tt.transaction_type
left join {{ ref('dim_transaction_status') }}  ts on t.transaction_status = ts.transaction_status
