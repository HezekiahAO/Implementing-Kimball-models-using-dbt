select distinct
    {{ dbt_utils.generate_surrogate_key(['transaction_status']) }} as transaction_status_key,
    transaction_status
from {{ ref('stg_transactions') }}
