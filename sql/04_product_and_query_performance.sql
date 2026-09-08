/* Script 04: Product and Query Performance
20+ interactions is an exploratory ranking screen only. */
SET search_path TO jdcom_analysis, public;
CREATE OR REPLACE VIEW jdcom_analysis.product_performance AS
SELECT product_id,brand_id,category_level_4_id,shop_id,COUNT(*) AS total_interactions,COUNT(*) FILTER(WHERE interaction_label=1) AS clicks,COUNT(*) FILTER(WHERE interaction_label=2) AS cart_additions,COUNT(*) FILTER(WHERE interaction_label=3) AS purchases,COUNT(DISTINCT query_record_id) AS unique_query_records,ROUND(COUNT(*) FILTER(WHERE interaction_label=3)*100.0/NULLIF(COUNT(*),0),2) AS purchase_share_percent
FROM jdcom_analysis.customer_interactions GROUP BY product_id,brand_id,category_level_4_id,shop_id;
SELECT COUNT(*) AS total_product_records FROM jdcom_analysis.product_performance; -- Expected 237814
SELECT * FROM jdcom_analysis.product_performance ORDER BY total_interactions DESC LIMIT 10;
SELECT * FROM jdcom_analysis.product_performance ORDER BY purchases DESC,total_interactions DESC LIMIT 10;
SELECT * FROM jdcom_analysis.product_performance WHERE total_interactions>=20 ORDER BY purchase_share_percent DESC,total_interactions DESC LIMIT 10;
SELECT SUM(total_interactions),SUM(clicks),SUM(cart_additions),SUM(purchases) FROM jdcom_analysis.product_performance; -- Expected 320132 | 223909 | 75407 | 20816

CREATE OR REPLACE VIEW jdcom_analysis.query_performance AS
SELECT query_record_id,COUNT(*) AS total_interactions,COUNT(*) FILTER(WHERE interaction_label=1) AS clicks,COUNT(*) FILTER(WHERE interaction_label=2) AS cart_additions,COUNT(*) FILTER(WHERE interaction_label=3) AS purchases,COUNT(DISTINCT product_id) AS unique_products,ROUND(COUNT(*) FILTER(WHERE interaction_label=3)*100.0/NULLIF(COUNT(*),0),2) AS purchase_share_percent
FROM jdcom_analysis.customer_interactions GROUP BY query_record_id;
SELECT COUNT(*) AS total_query_records FROM jdcom_analysis.query_performance; -- Expected 110393
SELECT * FROM jdcom_analysis.query_performance ORDER BY total_interactions DESC LIMIT 10;
SELECT * FROM jdcom_analysis.query_performance ORDER BY purchases DESC,total_interactions DESC LIMIT 10;
SELECT * FROM jdcom_analysis.query_performance WHERE total_interactions>=20 ORDER BY purchase_share_percent DESC,total_interactions DESC LIMIT 10;
SELECT SUM(total_interactions),SUM(clicks),SUM(cart_additions),SUM(purchases) FROM jdcom_analysis.query_performance; -- Expected 320132 | 223909 | 75407 | 20816
