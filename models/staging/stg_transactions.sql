select
    transaction_id,
    account_id,
    order_id,
    cast(amount as numeric(18, 4))   as amount,
    upper(currency)                  as currency,
    lower(transaction_type)          as transaction_type,
    lower(status)                    as transaction_status,
    refrence_code                    as reference_code,  -- fixes source typo
    created_at                       as transaction_created_at,
    debited_at
from {{ source('raw', 'transactions') }}
