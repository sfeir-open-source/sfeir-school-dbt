#!/usr/bin/env python

import csv
import pycountry
import random
from faker import Faker

fake = Faker()

# Generate fake customers
customers = []
for _ in range(500):
    gender = fake.random_element(elements=('male', 'female'))
    customer_id = fake.unique.random_number(digits=6)
    customer_gender = gender
    customer_name = fake.name_male() if gender == 'male' else fake.name_female()
    customer_country = random.choice(list(pycountry.countries)).alpha_2
    customer_address = fake.address().replace('\n', ', ')

    customer = [customer_id, gender, customer_name, customer_country, customer_address]
    customers.append(customer)

# Write the customers to a CSV file
filename = '../seeds/customers.csv'
headers = ['customer_id', 'customer_gender', 'customer_name', 'customer_country', 'customer_address']

with open(filename, 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(headers)
    writer.writerows(customers)

print(f"{filename} has been generated successfully.")
