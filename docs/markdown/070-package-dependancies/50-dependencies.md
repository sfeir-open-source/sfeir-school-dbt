<!-- .slide: class="transition"-->

# Packages and dependencies

## What about dependencies ?


##==##


# Dependencies in dbt cloud

A specific way to declare project to project dependencies

- _dbt_ introduced `dependencies.yml` in version 1.5-ish of dbt
- `dependencies.yml` is used to declare related projects only
- even if it works, you shouldn't declare packages in `dependencies.yml`

<br/>

Jinja parsing is disabled in `dependencies.yml`

<!-- .element: class="admonition warning" -->
