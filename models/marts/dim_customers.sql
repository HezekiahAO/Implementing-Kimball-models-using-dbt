select
    {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_key,
    customer_id,
    customer_name,
    customer_email,
    customer_country,
    kyc_status,
    customer_signup_date
from {{ ref('stg_customers') }}
