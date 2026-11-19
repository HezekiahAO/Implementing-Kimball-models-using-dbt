
{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='delete+insert',
    on_schema_change='fail'
) }}

select
    order_id,
    customer_id,
    order_total_amount,
    order_currency,
    order_status,
    order_created_at,
    order_updated_at,
    order_created_date,
    hours_to_last_update,
    order_status = 'open'                      as is_order_open,
    order_updated_at > order_created_at        as has_been_updated
from {{ ref('stg_orders') }}
{% if is_incremental() %}
where order_updated_at > (select max(order_updated_at) from {{ this }})
{% endif %}
