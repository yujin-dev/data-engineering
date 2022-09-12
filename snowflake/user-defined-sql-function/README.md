# User-Defined SQL Functions
[Getting Started With User-Defined SQL Functions](https://quickstarts.snowflake.com/guide/getting_started_with_user_defined_sql_functions/index.html?index=..%2F..index#0)에 따라 Snowflake에서 UDF를 생성하는 과정

## Steps
- `setup.sql`

## Results
```sql
select * from table(udf_db.udf_schema_public.get_market_basket(6139));
/*
+------------+----------------+-------------+                                   
| INPUT_ITEM | BASKET_ITEM_SK | NUM_BASKETS |
|------------+----------------+-------------|
|       6139 |           6139 |        1200 |
|       6139 |           7116 |         316 |
|       6139 |           7115 |         256 |
|       6139 |           7114 |         187 |
|       6139 |           9258 |         131 |
|       6139 |           9257 |         101 |
|       6139 |         186644 |          32 |
|       6139 |         200511 |          26 |
|       6139 |         259450 |          24 |
|       6139 |           9256 |          20 |
|       6139 |         187451 |          14 |
|       6139 |         164960 |           4 |
+------------+----------------+-------------+
12 Row(s) produced. Time Elapsed: 7.255s
*/
```