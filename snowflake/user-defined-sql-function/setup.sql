-- create database
create database udf_db;
-- create schema
create schema if not exists udf_db.udf_schema_public;
-- copy sample data
create or replace table udf_db.udf_schema_public.sales as 
    (select * from snowflake_sample_data.tpcds_sf10tcl.store_sales sample block (1));
-- create scalar UDF(User-Defined Function) : SS_LIST_PRICE가 가장 큰 값을 반환
create function udf_db.udf_schema_public.udf_max() returns NUMBER(7,2)
    as 
    $$
     select max(SS_LIST_PRICE) from udf_db.udf_schema_public.sales
    $$
;
-- call function
select udf_max();
/*
+-----------+                                                                   
| UDF_MAX() |
|-----------|
|    200.00 |
+-----------+
1 Row(s) produced. Time Elapsed: 1.273s
*/
-- create a UDTF(User-Defined Table Function) : market basket 분석 결과값을 반환
create or replace function udf_db.udf_schema_public.get_market_basket(input_item_sk number(38))
    returns table (input_item NUMBER(38,0), basket_item_sk NUMBER(38,0), num_baskets NUMBER(38,0)) as 
        'select input_item_sk, ss_item_sk basket_Item, count(distinct ss_ticket_number) baskets
        from udf_db.udf_schema_public.sales
        where ss_ticket_number in (select ss_ticket_number from udf_db.udf_schema_public.sales where ss_item_sk=input_item_sk)
        group by ss_item_sk 
        order by 3 desc, 2';