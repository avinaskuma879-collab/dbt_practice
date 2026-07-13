{{ config(
    materialized='table',
    enabled=true
) }}

select {{ var("num_id") }} as system_id,'{{ var("is_region_active") }}' as is_region_active,* from dbt_sql.raw.customer_raw limit 100