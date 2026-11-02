-- Aggregate fact. Grain: one row per account x day x currency.
-- Built FROM fact_transactions (never from raw) so it can't drift from the model.
select
    f.account_key,
    f.date_key,
    f.currency,                                   -- never SUM across currencies

    count(*)                                      as txn_count,
    sum(f.amount)                                 as total_amount,
    avg(f.amount)                                 as avg_amount,
    min(f.amount)                                 as min_amount,
    max(f.amount)                                 as max_amount,

    count(case when ts.transaction_status = 'completed' then 1 end)       as completed_count,
    count(case when ts.transaction_status = 'failed'    then 1 end)       as failed_count,
    coalesce(sum(case when ts.transaction_status = 'completed'
                      then f.amount end), 0)                              as completed_amount
from {{ ref('fact_transactions') }} f
join {{ ref('dim_transaction_status') }} ts
  on f.transaction_status_key = ts.transaction_status_key
group by f.account_key, f.date_key, f.currency
