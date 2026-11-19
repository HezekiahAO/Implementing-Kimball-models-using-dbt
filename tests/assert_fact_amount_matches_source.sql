-- Money must reconcile exactly, per currency.
select coalesce(s.currency, f.currency) as currency, s.amt as source_amt, f.amt as fact_amt
from (select currency, sum(amount) amt from {{ ref('stg_transactions') }} group by currency) s
full join (select currency, sum(amount) amt from {{ ref('fact_transactions') }} group by currency) f
  on s.currency = f.currency
where s.amt is distinct from f.amt
