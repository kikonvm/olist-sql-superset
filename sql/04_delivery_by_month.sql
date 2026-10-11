-- Вопрос 4: сколько занимает доставка и как часто заказы опаздывают?
-- avg_delivery_days: от покупки до получения, в днях.
-- late_pct: доля заказов, доставленных позже обещанной даты.
SELECT date_trunc('month', order_purchase_timestamp)::date AS month,
       round((avg(extract(epoch FROM (order_delivered_customer_date - order_purchase_timestamp)) / 86400))::numeric, 1) AS avg_delivery_days,
       round(100.0 * count(*) FILTER (WHERE order_delivered_customer_date > order_estimated_delivery_date) / count(*), 1) AS late_pct
FROM olist_orders_dataset
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp >= '2017-01-01'
  AND order_purchase_timestamp < '2018-09-01'
GROUP BY 1
ORDER BY 1;
