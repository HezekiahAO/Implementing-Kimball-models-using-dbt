select
    {{ dbt_utils.generate_surrogate_key(['order_id']) }} as order_key,
    order_id,
    customer_id,
    order_total_amount,
    order_currency,
    order_status,
    order_created_at,
    order_updated_at
from {{ ref('stg_orders') }}
