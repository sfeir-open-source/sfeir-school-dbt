<!-- .slide: class="transition"-->

# Packages and dependencies

## Build your own package

##==##

# Why build your own package ?

- Provide your organization with common, reusable macros and tests you want to use in different projects

- Provide your organization or the dbt community with models and macros dedicated to specific adapter, source or datasets

##==##

# How is a package built ?

- A package is structured like a **light version of a dbt project**

- The name of the project is the name of the package

- It usually only contains **macros, models** or both

- If you plan to release your package publicly, it should work with as many adapters as possible (unless specific to one)

- **Prefix your package models** with your package name for better portability

- A package’s macro or model is referenced with the package name :

```sql
SELECT * FROM {{ mypackage.custom_ref("mymodel") }}
```

##==##

# Hosting your dbt packages

**Privately**

- Using a private git repository
- Link to a local path on the host running dbt
- Internal URL of a tarball

**Publicly**

- Using a public **github** repository
- Pushing the package to the official dbt packages hub

Notes:
Github only for now
