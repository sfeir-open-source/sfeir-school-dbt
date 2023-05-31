<!-- .slide -->
# References

References are how dbt handle models dependecies between models and build the DAG at runtime.

It's handled by dbt with the `ref()` macro and it should be the only way for you to reference other models in a `.sql` file.

