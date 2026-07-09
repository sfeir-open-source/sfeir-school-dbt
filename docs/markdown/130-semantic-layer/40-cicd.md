# Semantic Layer & CI/CD ?

**In every Pull Request, run**

```bash
$ mf validate-config
```

Catches missing dimensions, broken entity references, invalid metric graph before they hit production

**MetricFlow Predicate Pushdown**

MetricFlow automatically pushes "WHERE" filters down to the earliest point in the generated SQL, minimizing data scanned and reducing warehouse costs
