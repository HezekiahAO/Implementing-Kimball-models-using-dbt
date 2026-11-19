
{{ config(
    materialized='incremental',
    unique_key='transaction_id',
    incremental_strategy='delete+insert',
    on_schema_change='append_new_columns'
) }}

select
    t.transaction_id,
    t.account_id,
    a.customer_id,
    t.order_id,
    t.amount,
    t.currency,
    t.transaction_type,
    t.transaction_status,
    t.reference_code,
    t.transaction_created_at,
    cast(t.transaction_created_at as date)     as transaction_date,
    t.debited_at,
    t.is_completed,
    t.is_failed,
    t.is_debited,
    t.has_order,
    t.minutes_to_debit,
    case when t.transaction_type = 'deposit' then 'in' else 'out' end as amount_direction,
    case when t.transaction_type = 'deposit' then t.amount else -t.amount end as signed_amount
from {{ ref('stg_transactions') }} t
left join {{ ref('stg_accounts') }} a
    on t.account_id = a.account_id
{% if is_incremental() %}
where t.transaction_created_at >= (
    select max(transaction_created_at) - ({{ var('txn_lookback_days') }} * interval '1 day')
    from {{ this }}
)
{% endif %}
