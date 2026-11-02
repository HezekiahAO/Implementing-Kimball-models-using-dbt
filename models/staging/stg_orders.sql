select
    order_id,
    customer_id,
    cast(total_amount as numeric(18, 4)) as order_total_amount,
    upper(currency)                      as order_currency,
    lower(status)                        as order_status,
    created_at                           as order_created_at,
    updated_at                           as order_updated_at
from {{ source('raw', 'orders') }}
