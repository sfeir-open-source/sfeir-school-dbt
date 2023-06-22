<!-- .slide -->

# Artifacts

Artifacts refer to the generated outputs of _dbt_ execution process. These artifacts include various files
and resources that are created or modified as part of running _dbt_ commands.

* manifest (produced by commands that read and understand your project)

* run results (produced by commands that run, compile, or catalog nodes in your DAG)

* catalog (produced by docs generate)

* sources (produced by source freshness)

You can use these file to create custom operation (such as Cosmos do) or, in advance use cases, you can update these file to
override configuration or add mandatory information for your organisation. 
