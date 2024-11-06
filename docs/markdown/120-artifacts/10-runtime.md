<!-- .slide: class="transition"-->

# Leveraging generated artifacts

## Files generated at runtime

##==##

<!-- .slide:-->

# Files generated at runtime

dbt generates and saves a list of files at each run in the target folder. Those files are called artefacts and have multiple purposes:

- Power the generated documentation
- Record run statistics and timing
- Save state of execution
- etc.

dbt has committed to provide a stable format for all the produced artefacts, and publishes JSON schema on a [dedicated website](http://schemas.getdbt.com).
