{%- set global_region = 'list_range' -%}
-- to refer a model
-- SELECT * FROM {{ ref('customer') }}

-- to refer global variable
-- SELECT * FROM {{ ref('customer_' ~ var('asp_region_name')) }}

-- to ref seed file

-- SELECT * FROM {{ ref('region_code') }}





-- dbt run --select ref --vars "{global_region: 'us_east'}"

SELECT * FROM {{ ref('cust_' ~ global_region) }}



