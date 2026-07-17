{# -----------------------Variable-----------------------------------#}
{% set my_string = "example" %}
{% set my_list = ["apple", "lemon"] %}
{% set my_dict = {"WatchEvent": "watch_user_count","ForkEvent": "fork_user_count" %}

{#--------------------- comment --------------------------#}

--------------trim whitespaces

{%- … %} Strips before

{%- … -%} Strips before and after

-------Loops 
{% … %} e.g.: loops, if
-------------EXpression
{{ … }} e.g.: ref(),source()

----------------- var()
SELECT
*
FROM events
WHERE event_type = '{{ var("event_type") }}'


---------Macros
Macros are reusable code snippets (func3ons) wri6en
in Jinja
{% macro cents_to_dollar(col_name, precision=2) %}
({{ col_name }} / 100)::numeric(16, {{ precision }})
{% endmacro %}

------------Run macro
{%- … %}
dbt run-operation <macro> --args '{example: value}'

-------------- Cast variable
# To string
{% set my_int_var = 2020 %}
{% set my_int_var|string %}
# To int
{% set my_str_var = "2020" %}
{% set my_str_var|int %}


-------------------------Length

{% set my_list = ["apple", "lemon"] %}
# Check if my_list has more than 3 element
{% if products|length > 3 %}

----------------------Manipulate objects
{% set numbers = [] %}
{%- for i in range(1, 10) %}
{%- do numbers.append(i) -%}
{%- endfor %}

---------------------Loop.last
To avoid trailing commas in loops use:
{% if not loop.last %},{% endif %}

--------------------------- Loops
-- Over list                                                                                   
{% set my_list = ['sales_x', 'sales_y'] %}
SELECT
id,
{%- for col_name in my_list %}
SUM({{ col_name }})
{%- if not loop.last -%}, {%- endif -%}
{% endfor %}
FROM example
GROUP BY 1

-- compiled 

-- Over list

SELECT
id,
SUM(sales_x),
SUM(sales_y)
FROM example
GROUP BY 1


----------dict 

-- Over dictionary
{% set payment_methods = {"type_0" : "bank_transfer",
"type_1" : "credit_card",
"type_2" : "gift_card"} %}
SELECT
order_id,
{%- for type, column_name in payment_methods.items()%}
sum(CASE
WHEN payment_method = ‘{{type}}'
THEN amount end) as {{ column_name }}_amt
{%- if not loop.last -%}, {%- endif -%}
{%- endfor -%}
FROM example
GROUP BY 1
--------------------compiled---
SELECT
order_id,
sum(CASE
WHEN payment_method = ’type_0’
THEN amount END) AS bank_transfer_amt,
sum(CASE
WHEN payment_method = ‘type_1’
THEN amount END) AS credit_card_amt,
sum(CASE
WHEN payment_method = ‘type_2’
THEN amount END) AS gift_card_amt
FROM example
GROUP BY


------------------------ Graph (dag)

{% macro example() %}
{% if execute %}
{% for node in graph.nodes.values() %}
{% do log(node.unique_id ~ ", config: " ~ node.config,
info=true) %}
{% endfor %}
{% endif %}
{% endmacro %}

-------------------------dbt.utils

dbt_u@ls
dbt_u3ls is a collec3on of reusable dbt macros
Examples:
deduplicate - remove duplicates from a model
group_by - build a group by statement for (1..N)

------------------if stmt --------------------


{% macro generate_schema_name() -%}
{%- if target.name == 'dev'-%}
{%- elif target.name == 'prod' -%}
{%- else -%}
{%- endif -%}
{%- endmacro %}

-------------Logging to Stdout--------
{{ log(”Some text" ~ my_string, info=True) }}



-------------Excep@ons
-- Warning
{% do exceptions.warn("Warning message") %}
-- Error
{{ exceptions.raise_compiler_error("Error message") }}

-----------------debug
Debug
The {{ debug() }} macro will open an iPython debugger in the
context of a compiled dbt macro
Usage:
...
{{ debug()}}

------------------------Run Query 

{% set results = run_query("select * from table") %}
{% do results.print_table() %}
------------------Return

{% macro example() %}
{{ return("Hello") }}
{% endmacro %}
 ----------------- env var--------------------------
 Enviroment variables
{{ env_var("VAR_NAME") }}
----------------------------------Print
{{ print((”My Message") }}