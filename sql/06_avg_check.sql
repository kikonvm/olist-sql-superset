-- Средний чек по месяцам.
-- Сначала сумма каждого заказа, потом среднее по заказам:
-- так заказы с несколькими позициями не искажают результат.
WITH order_totals AS (
  SELECT o.order_id,
         date_trunc('month', o.order_purchase_timestamp)::date AS month,
         sum(i.price) AS order_value
  FROM olist_orders_dataset o
  JOIN olist_order_items_dataset i ON i.order_id = o.order_id
  WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp < '2018-09-01'
  GROUP BY 1, 2
)
SELECT month,
       count(*) AS orders,
       round(avg(order_value), 2) AS avg_check
FROM order_totals
GROUP BY 1
ORDER BY 1;
