SELECT
    unnest(ARRAY['product1', 'product2', 'product3', 'product4', 'product5']) AS product_name,
    unnest(ARRAY['category1', 'category2', 'category1', 'category2', 'category1']) AS product_category,
    unnest(ARRAY['type1', 'type2', 'type1', 'type2', 'type1']) AS product_type,
    unnest(ARRAY[100, 200, 150, 180, 120]) AS stock,
    unnest(ARRAY[0.5, 0.8, 0.6, 0.7, 0.9]) AS weight,
    unnest(ARRAY[5.99, 7.99, 6.99, 8.99, 6.99]) AS shipping_cost,
    unnest(ARRAY[10.99, 15.99, 9.99, 12.99, 8.99]) AS product_price;
