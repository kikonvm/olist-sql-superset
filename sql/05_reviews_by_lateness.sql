-- Заказы группируются по числу дней опоздания (сравнение по датам),
-- для каждой группы считается средняя оценка.
-- Результат (5 строк) сохраняется в таблицу: график в Superset строится на ней.
-- Причина: Superset добавляет LIMIT к запросу графика, и с LIMIT PostgreSQL
-- выбрал очень медленный план (Nested Loop) - запрос висел минутами.
DROP TABLE IF EXISTS public.reviews_by_lateness;

CREATE TABLE public.reviews_by_lateness AS
WITH o AS (
  SELECT order_id,
         order_delivered_customer_date::date - order_estimated_delivery_date::date AS days_late
  FROM olist_orders_dataset
  WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
)
SELECT CASE WHEN days_late <= 0  THEN '1) on time'
            WHEN days_late <= 3  THEN '2) 1-3 days late'
            WHEN days_late <= 7  THEN '3) 4-7 days late'
            WHEN days_late <= 14 THEN '4) 8-14 days late'
            ELSE '5) 15+ days late' END AS late_group,
       count(*) AS reviews,
       round(avg(r.review_score), 2) AS avg_score
FROM o
JOIN olist_order_reviews_dataset r ON r.order_id = o.order_id
GROUP BY 1;

SELECT * FROM public.reviews_by_lateness ORDER BY 1;
