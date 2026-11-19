-- Rolling up must neither lose nor invent money or transactions.
select a.cnt as agg_count, f.cnt as fact_count, a.amt as agg_amt, f.amt as fact_amt
from (select sum(txn_count) cnt, sum(total_amount) amt from {{ ref('agg_account_daily') }}) a,
     (select count(*) cnt, sum(amount) amt from {{ ref('fact_transactions') }}) f
where a.cnt <> f.cnt or a.amt <> f.amt
