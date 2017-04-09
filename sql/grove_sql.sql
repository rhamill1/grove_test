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
