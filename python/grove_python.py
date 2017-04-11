
import mysql.connector as sql
import pandas as pd
import pickle
import matplotlib.pyplot as plt
from matplotlib import style
style.use('fivethirtyeight')


db_connection = sql.connect(host='127.0.0.1', database='grove', user='root', password='')

input_df = pd.read_sql('SELECT * FROM fact_shipment_item limit 100000', con=db_connection)
pivot_df = pd.pivot_table(input_df, values='customer_id', index='shipment_id', columns='product_id', fill_value='0')


pickle_out = open('data/grove.pickle', 'wb')
pickle.dump(pivot_df, pickle_out)
pickle_out.close()


plot_data = pd.read_pickle('data/grove.pickle')
plot_data = plot_data.astype(float)


correlation_table = plot_data.corr()
correlation_table.to_csv('solutions/products_correlation_table.csv', sep=',', encoding='utf-8')
print(correlation_table)
