#!/usr/bin/env python

import csv
import pycountry
import random
from faker import Faker

fake = Faker()

# Generate fake companies
companies = []
for _ in range(500):
    company_id = fake.unique.random_number(digits=6)
    company_name = fake.company()
    company_boss = fake.name()
    company_country = random.choice(list(pycountry.countries)).alpha_2

    company = [company_id, company_name, company_boss, company_country]
    companies.append(company)

# Write the companies to a CSV file
filename = '../dbt/seeds/companies.csv'
headers = ['company_id', 'company_name', 'company_boss', 'company_country']

with open(filename, 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(headers)
    writer.writerows(companies)

print(f"{filename} has been generated successfully.")
