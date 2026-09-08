/* Script 03: Brand and Shop Performance
shop_id=-1 is unidentified and excluded from shop analysis.
20+ interactions is an exploratory ranking screen only. */
SET search_path TO jdcom_analysis, public;
CREATE OR REPLACE VIEW jdcom_analysis.brand_performance AS
SELECT brand_id,COUNT(*) AS total_interactions,COUNT(*) FILTER(WHERE interaction_label=1) AS clicks,COUNT(*) FILTER(WHERE interaction_label=2) AS cart_additions,COUNT(*) FILTER(WHERE interaction_label=3) AS purchases,COUNT(DISTINCT product_id) AS unique_products,ROUND(COUNT(*) FILTER(WHERE interaction_label=3)*100.0/NULLIF(COUNT(*),0),2) AS purchase_share_percent
FROM jdcom_analysis.customer_interactions GROUP BY brand_id;
SELECT COUNT(*) AS total_brands FROM jdcom_analysis.brand_performance; -- Expected 47757
SELECT * FROM jdcom_analysis.brand_performance ORDER BY total_interactions DESC LIMIT 10;
SELECT * FROM jdcom_analysis.brand_performance ORDER BY purchases DESC,total_interactions DESC LIMIT 10;
SELECT * FROM jdcom_analysis.brand_performance WHERE total_interactions>=20 ORDER BY purchase_share_percent DESC,total_interactions DESC LIMIT 10;
SELECT SUM(total_interactions),SUM(clicks),SUM(cart_additions),SUM(purchases) FROM jdcom_analysis.brand_performance; -- Expected 320132 | 223909 | 75407 | 20816

CREATE OR REPLACE VIEW jdcom_analysis.shop_performance AS
SELECT shop_id,COUNT(*) AS total_interactions,COUNT(*) FILTER(WHERE interaction_label=1) AS clicks,COUNT(*) FILTER(WHERE interaction_label=2) AS cart_additions,COUNT(*) FILTER(WHERE interaction_label=3) AS purchases,COUNT(DISTINCT product_id) AS unique_products,COUNT(DISTINCT brand_id) AS unique_brands,ROUND(COUNT(*) FILTER(WHERE interaction_label=3)*100.0/NULLIF(COUNT(*),0),2) AS purchase_share_percent
FROM jdcom_analysis.customer_interactions WHERE shop_id<>-1 GROUP BY shop_id;
SELECT COUNT(*) AS total_identified_shops FROM jdcom_analysis.shop_performance; -- Expected 78975
SELECT * FROM jdcom_analysis.shop_performance ORDER BY total_interactions DESC LIMIT 10;
SELECT * FROM jdcom_analysis.shop_performance ORDER BY purchases DESC,total_interactions DESC LIMIT 10;
SELECT * FROM jdcom_analysis.shop_performance WHERE total_interactions>=20 ORDER BY purchase_share_percent DESC,total_interactions DESC LIMIT 10;
WITH overall AS (SELECT COUNT(*) FILTER(WHERE interaction_label=3)*100.0/NULLIF(COUNT(*),0) AS ps FROM jdcom_analysis.customer_interactions), t AS (SELECT AVG(total_interactions) AS avg_volume FROM jdcom_analysis.brand_performance) SELECT bp.* FROM jdcom_analysis.brand_performance bp CROSS JOIN overall o CROSS JOIN t WHERE bp.total_interactions>=t.avg_volume AND bp.purchase_share_percent<o.ps ORDER BY bp.total_interactions DESC,bp.purchase_share_percent ASC;
WITH overall AS (SELECT COUNT(*) FILTER(WHERE interaction_label=3)*100.0/NULLIF(COUNT(*),0) AS ps FROM jdcom_analysis.customer_interactions WHERE shop_id<>-1), t AS (SELECT AVG(total_interactions) AS avg_volume FROM jdcom_analysis.shop_performance) SELECT sp.* FROM jdcom_analysis.shop_performance sp CROSS JOIN overall o CROSS JOIN t WHERE sp.total_interactions>=t.avg_volume AND sp.purchase_share_percent<o.ps ORDER BY sp.total_interactions DESC,sp.purchase_share_percent ASC;
SELECT SUM(total_interactions),SUM(clicks),SUM(cart_additions),SUM(purchases) FROM jdcom_analysis.shop_performance;
-- Expected identified-shop totals: 318356 | 222676 | 74929 | 20751
