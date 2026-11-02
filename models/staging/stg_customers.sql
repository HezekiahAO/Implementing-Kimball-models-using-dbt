select
    customer_id,
    name                 as customer_name,
    lower(email)         as customer_email,
    upper(country)       as customer_country,
    lower(kyc_status)    as kyc_status,
    created_at           as customer_signup_date
from {{ source('raw', 'customers') }}
