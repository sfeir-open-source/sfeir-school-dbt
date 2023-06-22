<!-- .slide:class="with-code" -->
# Generating documentation

_dbt_ allows you to document almost everything in your project, and provides commands to generate and serve documentation as a website.

This allows you to find dependencies between objects and see the lineage of your data.

<br><br>

```shell[]
# Generate documentation
$ dbt docs generate

# Serve documentation on port 4242
$ dbt docs serve --port 4242 
```

##==##
# Sample documentation 1/2

![center hm-800](./assets/images/docs/markdown/40-source-and-ref/docs-1.png)

##==##
# Sample documentation 2/2

![center hm-800](./assets/images/docs/markdown/40-source-and-ref/docs-2.png)

##==##
# Sample lineage graph 1/2

<br><br>

![center hm-800](./assets/images/docs/markdown/40-source-and-ref/lineage-1.png)

##==##
# Sample lineage graph 2/2

![center hm-900](./assets/images/docs/markdown/40-source-and-ref/lineage-2.png)
