creat database grove;


create table if not exists grove.fact_shipment_item (

    shipment_id int,
    customer_shipment_count int,
    shipment_type text,
    product_sku text,
    product_id int null,
    customer_id int,
    shipment_date date

    ) engine = innodb;


load data local infile '/Users/ryanhamill/web_apps/grove/data/customer_orders_n_products_data.csv'

into table grove.fact_shipment_item fields terminated by ','

    enclosed by '"'
    lines terminated by '\r'
    ignore 1 lines (

        shipment_id,
        customer_shipment_count,
        shipment_type,
        product_sku,
        @product_id,
        customer_id,
        @shipment_date
    )

    set shipment_date = str_to_date(@shipment_date, '%m/%d/%Y'),
        product_id = nullif(@product_id, '' );





--  INVESTIGATE TABLE/DATA

  select count(*) from grove.fact_shipment_item;
    -- 1043054

  select count(distinct shipment_id) from grove.fact_shipment_item;
    -- 163979

  select distinct shipment_type from grove.fact_shipment_item;
    -- 'Recurring'
    -- 'Other'
    -- 'First Order'
    -- 'Ship Now'

  select count(distinct customer_id)from grove.fact_shipment_item;
    -- 96281

  select min(shipment_date) from grove.fact_shipment_item;
    -- 2016-05-05

  select max(shipment_date) from grove.fact_shipment_item;
    -- 2016-08-28

  select count(*) from grove.fact_shipment_item where product_id is null;
    -- 3458




create table grove.fact_many_order_customer_shipment_items as

    select fsi.* from grove.fact_shipment_item fsi

    join (

        select customer_id, count(distinct shipment_id) as customer_shipments_in_set

        from grove.fact_shipment_item

        group by customer_id
        having count(distinct shipment_id) > 1) many_order_customers

    on many_order_customers.customer_id = fsi.customer_id;




create table grove.fact_multiple_customer_product_orders as

    select customer_id, product_id, count(*) as customer_product_order_count

    from grove.fact_many_order_customer_shipment_items

    group by customer_id, product_id
    having count(*) > 1;




ALTER TABLE grove.fact_many_order_customer_shipment_items
    ADD INDEX product_id (product_id),
    ADD INDEX customer_id (customer_id);

ALTER TABLE grove.fact_multiple_customer_product_orders
    ADD INDEX product_id (product_id),
    ADD INDEX customer_id (customer_id);




create table grove.fact_many_orders as

    select moc.* from grove.fact_many_order_customer_shipment_items moc

    join grove.fact_multiple_customer_product_orders mcp
        on moc.customer_id = mcp.customer_id
        and moc.product_id = mcp.product_id;


ALTER TABLE grove.fact_many_orders
    ADD INDEX product_id (product_id),
    ADD INDEX customer_id (customer_id),
    ADD INDEX customer_shipment_count (customer_shipment_count);


set @row := 0;
create table grove.fact_many_orders_id as

    select fmo.*, (@row := ifnull(@row, 0) + 1) as row_id

    from grove.fact_many_orders fmo

    order by customer_id, product_id;





-- SOLUTION 1 QUERY
select
    product_id,
    avg(time_between_ordering) as avg_time_between_orders,
    count(*) as data_point_count

from (

    select
        fmo.*,
        fmob.shipment_date as next_shipment_date,
        datediff(fmob.shipment_date, fmo.shipment_date) as time_between_ordering

    from grove.fact_many_orders_id fmo
    join grove.fact_many_orders_id fmob
        on fmo.product_id = fmob.product_id
        and fmo.customer_id = fmob.customer_id
        and fmo.row_id - 1 = fmob.row_id) a

group by product_id;
