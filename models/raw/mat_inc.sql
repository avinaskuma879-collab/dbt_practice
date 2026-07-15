{# incremental model with unique_key #}
 {# unique_key=['fdmee_account','pnl_flag'] #} 
{{ 
    config(

    materialized='incremental',
   unique_key=['fdmee_account']
) 
}}
with mat_inc as (
select * 
from dbt_sql.raw.pnl

{% if is_incremental() %}
  -- Filter applied only during incremental runs
  where etl_last_updated_date >= (
      select coalesce(max(t.etl_last_updated_date), '1900-01-01'::date) 
      from {{ this }} as t
  )
{% endif %}
)
,
dedup as (
    select *
    from (
        select *,
               row_number() over (
                   partition by fdmee_account
                   order by etl_last_updated_date desc
               ) as rn
        from mat_inc
    ) sub
    where rn = 1
)
select * from dedup
