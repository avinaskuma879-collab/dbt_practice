{{ config(
    materialized='table',
    enabled=true
) }}

select '{{ var("asp_region_name") }}' as sap_system,* from dbt_sql.raw.customer_raw limit 100