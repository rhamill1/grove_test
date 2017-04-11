## Data Set Questions

-  What specific customer touches do the different shipment_types represent?
-  Does this data exist for orders instead of shipments? Shipment time includes Grove's time to process the order.
-  Why do certain product IDs have different product SKUs? Ideally ID to SKU should be a 1-1 relationship.


## Questions & Solutions

#### Question 1: What are the average days between re-order by product?

##### Solution
```solutions/avg_time_between_orders.csv```

##### Assumptions

- Shipment date is very close to order date.
- Product ID is the unique identifier for products, not product SKU.

#### Question 2: Should the data from Question 1 be used as the basis of our product scheduling algorithm?

* Yes, it can be used but the source data should be groomed for null and duplicate product IDs.  There are 245,674 repeat customer-product-purchasing instances, drawing from 495 unique products.

* Agreed upon research for sufficient data points online range from 20-400.  Items ideally have at least 15-20 repeat purchase data points prior to having this analysis run or having a high confidence score.

* Depending on what percentage of all shipments the provided data constituted, accuracy could be improved by running this analysis on a larger set.

[stats.stackexchange.com/minimal-number-of-points-for-a-linear-regression](http://stats.stackexchange.com/questions/37833/minimal-number-of-points-for-a-linear-regression)

[stats.stackexchange.com/minimum-no-of-observations-required-for-statistical-distribution-fitting](http://stats.stackexchange.com/questions/55612/minimum-no-of-observations-required-for-statistical-distribution-fitting)

#### Question 3: Are there any strong correlations between products within the same shipment that could be used as a part of a product recommendation widget (e.g. like Amazon’s ‘people who bought this also purchased’ recommendations).

##### Notes
* This exercise was run for the first 100,000 rows, due to local python environment limitations.

``` SELECT * FROM fact_shipment_item limit 100000; ```

* For best results this would be run for the whole set at one time on a production server.

##### Solution


Yes there are some instances of medium to strong positive correlations.  The CSV provided is the correlation matrix.  The Excel file has some conditional formatting that makes it more visually digestible.  This part of the analysis could be further automated with more time.<br><br>
```solutions/products_correlation_table.csv```
```solutions/products_correlation_summary.xlsx```

#### Question 4: Briefly describe the process you went through to arrive at answers 1-3 (e.g. tools used, analyses run, etc…)


##### Q1

```sql/grove_sql.sql```

1. Load data into local MySQL Server
2. Investigate data
3. Transform data to time between orders and product ID
4. Calculate average

##### Q2
1. Calculated amount of unique data points
2. Search data science forums for sample size guidelines

##### Q3

```python/grove_python.py```

1. Get source data from MySQL into Python Pandas DataFrame
2. Pivot data so column 1 is a unique shipment ID and all other columns are product IDs, noting the presence of that item in that order
3. Create a correlation table with MatPlotLib
4. Utilize Excel conditional formatting and maximum logic to visualize medium and high correlations
