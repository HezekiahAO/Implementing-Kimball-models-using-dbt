-- Run before building the fact. Is transaction_id really the grain of the source?, helping calculate the number of duplicate rows in the source table. If this is not 0, then the grain of the source is not transaction_id and we need to investigate further.
select
    count(*)                       as total_rows,
    count(distinct transaction_id) as distinct_transactions,
    count(*) - count(distinct transaction_id) as duplicate_rows   -- must be 0
from {{ ref('stg_transactions') }}
