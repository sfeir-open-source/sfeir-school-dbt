#!/usr/bin/env python
import csv
from faker import Faker
import random
from datetime import datetime

# Create a Faker instance
fake = Faker()

# Define the list of possible order statuses
order_statuses = ['COMPLETED', 'CANCELLED', 'PROCESSING', 'WAITING_PAYMENT', 'SHIPPED']

# Define the number of rows you want to generate
num_rows = 10000

# Define the currency distribution percentages
eur_percentage = 95
usd_percentage = 100 - eur_percentage

# Define the start and end date range
start_date = datetime(2023, 1, 1)
end_date = datetime(2023, 6, 30)

# Define the CSV file path
csv_file_path = '../dbt/seeds/seed_sales.csv'

# Open the CSV file in write mode
with open(csv_file_path, 'w', newline='') as file:
    writer = csv.writer(file)

    # Write the header row
    writer.writerow(['order_id', 'order_line_id', 'product_id', 'base_price', 'quantity', 'rebate',
                     'currency', 'order_datetime', 'order_status', 'customer_id'])

    # Generate and write the data rows
    for i in range(num_rows):
        order_id = fake.random_number(digits=6)
        order_line_id = fake.random_number(digits=4)
        product_id = fake.random_number(digits=5)
        base_price = round(random.uniform(10, 100), 2)
        quantity = random.randint(1, 10)
        rebate = round(random.uniform(0, 10), 2)

        # Generate the currency based on the defined distribution
        currency_choices = ['EUR'] * eur_percentage + ['USD'] * usd_percentage
        currency = random.choice(currency_choices)

        # Generate a date within the specified range
        # order_datetime = fake.date_between(start_date=start_date, end_date=end_date).strftime('%Y-%m-%d')
        order_datetime = fake.date_time_between(start_date=start_date, end_date=end_date).strftime('%Y-%m-%d %H:%M:%S')

        order_status = random.choice(order_statuses)
        customer_id = fake.random_number(digits=4)

        writer.writerow([order_id, order_line_id, product_id, base_price, quantity, rebate,
                         currency, order_datetime, order_status, customer_id])

# Print the path to the generated CSV file
print(f"CSV file generated: {csv_file_path}")
