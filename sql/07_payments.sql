-- Способы оплаты: доля каждого способа в сумме платежей (доставленные заказы).
SELECT p.payment_type,
       count(DISTINCT p.order_id) AS orders,
       round(sum(p.payment_value), 2) AS total,
       round(100.0 * sum(p.payment_value) / sum(sum(p.payment_value)) OVER (), 1) AS pct
FROM olist_order_payments_dataset p
JOIN olist_orders_dataset o ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY total DESC;

-- Рассрочки по кредитным картам: средний платёж по группам числа платежей.
SELECT CASE WHEN payment_installments <= 1  THEN '1) no installments'
            WHEN payment_installments <= 3  THEN '2) 2-3'
            WHEN payment_installments <= 6  THEN '3) 4-6'
            WHEN payment_installments <= 10 THEN '4) 7-10'
            ELSE '5) 11+' END AS installments_group,
       count(*) AS payments,
       round(avg(payment_value), 2) AS avg_payment
FROM olist_order_payments_dataset
WHERE payment_type = 'credit_card'
GROUP BY 1
ORDER BY 1;
