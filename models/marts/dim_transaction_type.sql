select distinct
    {{ dbt_utils.generate_surrogate_key(['transaction_type']) }} as transaction_type_key,
    transaction_type
from {{ ref('stg_transactions') }}
