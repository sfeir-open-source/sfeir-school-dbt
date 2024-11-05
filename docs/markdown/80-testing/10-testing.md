<!-- .slide: class="transition"-->

# Testing

## Highlight potential risk in code

##==##

<!-- .slide: class="two-column"-->

# Don't trust anyone

Test and QA have existed in software development for decades.

Delivering qualitative models and allowing robust data-driven decision require testing.

dbt tests helps ensure the accuracy and reliability of data transformations and models.

Tests in dbt are powerful, and convenient!

##--##

<!-- .slide: data-background="./assets/images/docs/markdown/80-testing/tester_douter.jpg"-->

Notes:
Ensemble de symboles représentant tout objet, événements, etc. susceptible d’être interprété.

La donnée produit de l’information (au sens modification de la connaissance)

En ce sens, elle va pouvoir servir de base au raisonnement, à la recherche

##==##

# What are test good for in dbt?

Tests in dbt help you:

- Provide **data integrity**

- **Detect** regression

- **Prevent** unreliable deployment

- **Build trust** in the data your provide

- **Collaborate** with others

##==##

# What could go wrong ?

There are many situations that tests will help detect or mitigate:

- **Staleness** of sources data

  - You may expose obsolete data to your data consumers without knowing it

- **Unexpected change** in structure of sources or others’ models

  - Late detection can leave your data warehouse in inconsistent state

- Unforeseen change in **volumes**

- Unexpected **values or types**

- **Orphean rows** and missing relationship
