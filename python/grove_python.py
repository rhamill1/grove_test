import mysql.connector as sql
import pandas as pd

db_connection = sql.connect(host='127.0.0.1', database='grove', user='root', password='')

df = pd.read_sql('SELECT * FROM fact_shipment_item limit 1000', con=db_connection)

print(df.head())
