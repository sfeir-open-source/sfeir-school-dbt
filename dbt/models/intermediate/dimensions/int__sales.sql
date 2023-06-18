SELECT
  *
  , {{ turnover(false) }} AS turnover
  , {{ turnover(true) }} AS turnover2
FROM {{ ref("seed_sales") }} AS sales
