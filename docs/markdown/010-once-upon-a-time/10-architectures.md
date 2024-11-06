# Data Platforms evolution

![full-center](./assets/images/docs/markdown/10-once-upon-a-time/data-architectures.svg)

Notes:
Datalake

- Scalable and flexible storage for diverse, raw data types

Data Warehouse

- Centralized storage and analysis system for structured business data.

Lakehouse

- Unified data platform combining data lake and data warehouse capabilities.

Data Mesh

- Domain-oriented, self-serve data products

##==##

# 2012 Data Landscape

![center hm-800](./assets/images/docs/markdown/10-once-upon-a-time/2012-data-landscape.png)

##==##

# 2021 Data Landscape

![center hm-800](./assets/images/docs/markdown/10-once-upon-a-time/2021-data-landscape.png)

##==##

# Data Platform

## From ETL...

![center full-width](./assets/images/docs/markdown/10-once-upon-a-time/data-platforms.svg)

##==##

# Modern Data Platform

## ...to ELT

![center full-width](./assets/images/docs/markdown/10-once-upon-a-time/modern-data-platforms.svg)

##==##

<!-- .slide: class="two-column" -->

# <u>E</u>xtract <u>T</u>ransform <u>L</u>oad

![sfeir-icons big](git-merge) data is **extracted** from various sources

![sfeir-icons big](tool) **transformed** into a suitable form

![sfeir-icons big](upload) and then **loaded** into a target system for analysis.

##--##

<!-- .slide: data-background="var(--black)" -->

# <u>E</u>xtract <u>L</u>oad <u>T</u>ransform

![sfeir-icons big](git-merge) data is **extracted** from various sources

![sfeir-icons big](upload) **loaded** into a target system without immediate transformation

![sfeir-icons big](tool) **transformation** occurs when needed, to expose data products and use cases
