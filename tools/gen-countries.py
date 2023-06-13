#!/usr/bin/env python

import csv
import pycountry

# Generate a list of 100 countries
countries = []
for country in list(pycountry.countries):
    country_code = country.alpha_2
    country_name = country.name

    country = [country_code, country_name]
    countries.append(country)

# Write the countries to a CSV file
filename = '../seeds/countries.csv'
headers = ['country_code', 'country_name']

with open(filename, 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(headers)
    writer.writerows(countries)

print(f"{filename} has been generated successfully.")
