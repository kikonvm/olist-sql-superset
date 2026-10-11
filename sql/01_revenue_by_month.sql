-- Вопрос 1: как менялись заказы и выручка по месяцам?
-- Только доставленные заказы, период янв 2017 - авг 2018
-- (до и после данных мало, месяцы неполные).
-- Выручка = сумма price (без стоимости доставки).
SELECT date_trunc('month', o.order_purchase_timestamp)::date AS month,
       count(DISTINCT o.order_id) AS orders,
       round(sum(i.price), 2) AS revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset i ON i.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY 1
ORDER BY 1;
