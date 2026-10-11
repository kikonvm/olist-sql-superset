-- Вопрос 3: какие категории приносят больше всего денег?
-- LEFT JOIN сохраняет товары без перевода/категории,
-- COALESCE подписывает их как 'unknown'.
SELECT coalesce(t.product_category_name_english, 'unknown') AS category,
       count(DISTINCT o.order_id) AS orders,
       round(sum(i.price), 2) AS revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset i ON i.order_id = o.order_id
JOIN olist_products_dataset p ON p.product_id = i.product_id
LEFT JOIN product_category_name_translation t ON t.product_category_name = p.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY revenue DESC
LIMIT 10;
