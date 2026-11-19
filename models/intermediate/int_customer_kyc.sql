
{{ config(materialized='table') }}

with ranked_kyc as (
    select
        *,
        row_number() over (
            partition by customer_id
            order by kyc_created_at desc, kyc_id desc
        ) as kyc_rank
    from {{ ref('stg_kyc') }}
)

select
    c.customer_id,
    c.customer_name,
    c.customer_email,
    c.customer_email_domain,
    c.customer_country,
    c.kyc_status,
    c.customer_created_at,
    k.kyc_id,
    k.kyc_tier_level,
    k.kyc_verification_status,
    k.kyc_verified_at,
    coalesce(k.is_kyc_verified, false)         as is_kyc_verified
from {{ ref('stg_customers') }} c
left join ranked_kyc k
    on c.customer_id = k.customer_id
   and k.kyc_rank = 1
