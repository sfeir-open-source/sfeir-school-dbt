SELECT *
FROM {{ source("seeds", "src__sales") }}
