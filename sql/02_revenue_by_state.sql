-- Вопрос 2: в каких штатах покупают больше всего?
-- Штат = место жительства покупателя. Доля штата считается оконной функцией.
WITH state_revenue AS (
  SELECT c.customer_state,
         count(DISTINCT o.order_id) AS orders,
         round(sum(i.price), 2) AS revenue
  FROM olist_orders_dataset o
  JOIN olist_customers_dataset c ON c.customer_id = o.customer_id
  JOIN olist_order_items_dataset i ON i.order_id = o.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY 1
)
SELECT customer_state,
       orders,
       revenue,
       round(revenue * 100 / sum(revenue) OVER (), 1) AS pct
FROM state_revenue
ORDER BY revenue DESC;
