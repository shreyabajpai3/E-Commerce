CREATE INDEX idx_orders_orderid
ON olist_orders_dataset(order_id);

CREATE INDEX idx_items_orderid
ON olist_order_items_dataset(order_id);

CREATE INDEX idx_customers_customerid
ON olist_customers_dataset(customer_id);

CREATE INDEX idx_items_seller
ON olist_order_items_dataset(seller_id);