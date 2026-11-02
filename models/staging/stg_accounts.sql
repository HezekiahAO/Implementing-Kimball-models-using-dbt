select
    account_id,
    customer_id,
    account_number,
    lower(account_type)  as account_type,
    upper(currency)      as account_currency,
    lower(status)        as account_status,
    created_at           as account_created_at
from {{ source('raw', 'accounts') }}
