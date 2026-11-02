select
    {{ dbt_utils.generate_surrogate_key(['account_id']) }} as account_key,
    account_id,
    customer_id,
    account_number,
    account_type,
    account_currency,
    account_status,
    account_created_at
from {{ ref('stg_accounts') }}
