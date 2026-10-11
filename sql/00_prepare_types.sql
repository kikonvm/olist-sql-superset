-- Подготовка типов колонок после загрузки CSV.
-- Зачем: при импорте зип-коды становятся integer (теряются ведущие нули),
-- даты остаются текстом, а цены получают тип real (ломает round()).

-- Зип-коды: обратно в text с нулями до 5 знаков
ALTER TABLE public.olist_customers_dataset ALTER COLUMN customer_zip_code_prefix TYPE text USING lpad(customer_zip_code_prefix::text, 5, '0');
ALTER TABLE public.olist_sellers_dataset ALTER COLUMN seller_zip_code_prefix TYPE text USING lpad(seller_zip_code_prefix::text, 5, '0');

-- Даты: text -> timestamp (всё, что не похоже на дату, становится NULL)
ALTER TABLE public.olist_orders_dataset ALTER COLUMN order_purchase_timestamp TYPE timestamp USING CASE WHEN order_purchase_timestamp ~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$' THEN order_purchase_timestamp::timestamp END;
ALTER TABLE public.olist_orders_dataset ALTER COLUMN order_approved_at TYPE timestamp USING CASE WHEN order_approved_at ~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$' THEN order_approved_at::timestamp END;
ALTER TABLE public.olist_orders_dataset ALTER COLUMN order_delivered_carrier_date TYPE timestamp USING CASE WHEN order_delivered_carrier_date ~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$' THEN order_delivered_carrier_date::timestamp END;
ALTER TABLE public.olist_orders_dataset ALTER COLUMN order_delivered_customer_date TYPE timestamp USING CASE WHEN order_delivered_customer_date ~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$' THEN order_delivered_customer_date::timestamp END;
ALTER TABLE public.olist_orders_dataset ALTER COLUMN order_estimated_delivery_date TYPE timestamp USING CASE WHEN order_estimated_delivery_date ~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$' THEN order_estimated_delivery_date::timestamp END;
ALTER TABLE public.olist_order_items_dataset ALTER COLUMN shipping_limit_date TYPE timestamp USING CASE WHEN shipping_limit_date ~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$' THEN shipping_limit_date::timestamp END;

-- Деньги: real -> numeric(10,2)
ALTER TABLE public.olist_order_items_dataset ALTER COLUMN price TYPE numeric(10,2) USING round(price::numeric, 2);
ALTER TABLE public.olist_order_items_dataset ALTER COLUMN freight_value TYPE numeric(10,2) USING round(freight_value::numeric, 2);

-- Индексы под JOIN по order_id / customer_id
CREATE INDEX IF NOT EXISTS idx_orders_order_id ON public.olist_orders_dataset (order_id);
CREATE INDEX IF NOT EXISTS idx_reviews_order_id ON public.olist_order_reviews_dataset (order_id);
CREATE INDEX IF NOT EXISTS idx_items_order_id ON public.olist_order_items_dataset (order_id);
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON public.olist_orders_dataset (customer_id);
ANALYZE;
