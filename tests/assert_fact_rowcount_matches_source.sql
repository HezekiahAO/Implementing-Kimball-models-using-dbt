-- A join that fans out (or a filter that drops rows) changes the row count.
select s.n as source_rows, f.n as fact_rows
from (select count(*) n from {{ ref('stg_transactions') }}) s,
     (select count(*) n from {{ ref('fact_transactions') }}) f
where s.n <> f.n
