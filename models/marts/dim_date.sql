with spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2020-01-01' as date)",
        end_date="cast('2035-01-01' as date)"
    ) }}
),

dates as (
    select cast(date_day as date) as full_date from spine
)

select
    cast(
        extract(year from full_date) * 10000
        + extract(month from full_date) * 100
        + extract(day from full_date)
    as integer)                                   as date_key,
    full_date,
    extract(day from full_date)                   as day_of_month,
    extract(dow from full_date)                   as day_of_week_num,  -- 0 = Sunday
    case extract(dow from full_date)
        when 0 then 'Sunday'    when 1 then 'Monday'
        when 2 then 'Tuesday'   when 3 then 'Wednesday'
        when 4 then 'Thursday'  when 5 then 'Friday'
        when 6 then 'Saturday'
    end                                           as day_of_week,
    extract(week from full_date)                  as week,
    extract(month from full_date)                 as month,
    extract(quarter from full_date)               as quarter,
    extract(year from full_date)                  as year,
    extract(dow from full_date) in (0, 6)         as is_weekend
    -- add is_holiday / fiscal_period via a seed or holiday table
from dates
