## Data Set Questions

-  What specific customer touchs do the different shipment_types represent?
-  Does this data exist for orders instead of shipments? Shipment time includes Grove's time to process the order.

## Assumptions

- Shipment date is very close to order date.



## Questions & Solutions

#### Question 1: What are the average days between re-order by product?

```solutions/avg_time_between_orders.csv```

#### Question 2: Should the data from Question 1 be used as the basis of our product scheduling algorithm?

* Yes and no.  It can be used but the source data needs to be groomed more.  I would feel confident using it since there are 245,674 repeat instances, drawing from 495 unique products (uniqueness being determined by product_id, not product_sku).

* Ideally there should be a 1-1 relationship between product_id and product_sku.

* Agreed upon research for sufficient data points online range from 20-400.  This ETL should have a queue of items that have at least 15-20 data points before being considered reliable. Depending on what percentage of all shipments the provided data constituted it could be sufficient.

[stats.stackexchange.com/minimal-number-of-points-for-a-linear-regression](http://stats.stackexchange.com/questions/37833/minimal-number-of-points-for-a-linear-regression)

[stats.stackexchange.com/minimum-no-of-observations-required-for-statistical-distribution-fitting](http://stats.stackexchange.com/questions/55612/minimum-no-of-observations-required-for-statistical-distribution-fitting)

#### Question 3: Are there any strong correlations between products within the same shipment that could be used as a part of a product recommendation widget (e.g. like Amazon’s ‘people who bought this also purchased’ recommendations).

```solutions/avg_time_between_orders.csv```

#### Question 4: Briefly describe the process you went through to arrive at answers 1-3 (e.g. tools used, analyses run, etc…)
