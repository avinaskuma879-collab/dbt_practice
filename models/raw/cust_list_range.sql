{{ config(
    materialized='table',
    enabled=true
) }}

{%- set range_bounds = var('range_a')['ranges'] -%}
{%- set b_bounds = var('range_b')['ranges'] -%}
{%- set list_bounds = var('listed_a')['lists'] -%}
{%- set list_b_bounds = var('listed_b')['lists'] -%}
{% set expressions = var('s_exp_list') %}

select
    'b' as user_id,
    99 as transaction_amount,
    
    -- 1. Evaluates range_a bounds [['1', '100']]
    case
        {% for bounds in range_bounds %}
        when transaction_amount::numeric >= {{ bounds[0] }} 
         and transaction_amount::numeric <= {{ bounds[1] }} then true
        {% endfor %}
        else false
    end as is_in_range_a,

    1 as amount,
    
    -- 2. Evaluates flat list items from listed_a ['10'] (Removed the [0] string index bug)
    case
        {% for items in list_bounds %}
        when amount::numeric >= {{ items }} then true
        {% endfor %}
        else false
    end as is_in_listed_a,

    3 as amount_value,

    -- 3. Evaluates flat list items from listed_b ['1', '2', '3']
    case
        when 
        {% for items in list_b_bounds %}
            (amount_value::numeric >= {{ items }})
            {% if not loop.last %} or {% endif %}
        {% endfor %}
        then true
        else false
    end as is_in_listed_b,
    
    102 as secondary_amount_value, -- Fixed: Renamed from duplicate 'amount_value'

    -- 4. Evaluates range_b bounds [['1', '100'], ['101', '200']]
    case
        when 
        {% for bounds in b_bounds %}
            -- Fixed: Swapped missing column 'metric_value' with 'secondary_amount_value'
            (secondary_amount_value::numeric >= {{ bounds[0] }} and secondary_amount_value::numeric <= {{ bounds[1] }})
            {% if not loop.last %} or {% endif %}
        {% endfor %}
        then true
        else false
    end as is_in_range_b,
    

    * -- Pulls remaining default raw columns from source table

from dbt_sql.raw.customer_raw limit 100



/*

-- 1. Extract your wildcard string list variable
{% set like_patterns = var('like_exp_list') %}

select
    customer_id,
    category_code,

    -- 2. Loop through each item to evaluate pattern matching
    case
        when 
        {% for pattern in like_patterns %}
            category_code like '{{ pattern }}'
            {% if not loop.last %} or {% endif %}
        {% endfor %}
        then true
        else false
    end as matches_like_exp
 from {{ ref('customer') }}


-----------------------------------------------------------------------


{% set expressions = var('s_exp_list') %}

select
    customer_id,
    status_code,

    -- 2. Loop through each text string to flag individual matches
    case
        when 
        {% for exp in expressions %}
            status_code = '{{ exp }}'
            {% if not loop.last %} or {% endif %}
        {% endfor %}
        then true
        else false
    end as matches_s_exp

from {{ ref('customer') }}


-----------------------------------------------------
select
    customer_id,
    status_code
from {{ ref('customer') }}
-- Uses Jinja filter to compile: where status_code in ('a', 'b')
where status_code in ('{{ var("s_exp_list") | join("', '") }}')


*/
