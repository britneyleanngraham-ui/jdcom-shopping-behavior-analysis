/* Script 02: Category Performance Analysis
Purchase Share = Purchases / recorded positive interactions. Not a conversion rate.
20+ interactions is an exploratory ranking screen only. */
SET search_path TO jdcom_analysis, public;
CREATE OR REPLACE VIEW jdcom_analysis.category_performance AS
SELECT category_level_4_id, COUNT(*) AS total_interactions,
 COUNT(*) FILTER (WHERE interaction_label=1) AS clicks,
 COUNT(*) FILTER (WHERE interaction_label=2) AS cart_additions,
 COUNT(*) FILTER (WHERE interaction_label=3) AS purchases,
 COUNT(DISTINCT product_id) AS unique_products,
 ROUND(COUNT(*) FILTER (WHERE interaction_label=3)*100.0/NULLIF(COUNT(*),0),2) AS purchase_share_percent
FROM jdcom_analysis.customer_interactions GROUP BY category_level_4_id;
SELECT COUNT(*) AS total_categories FROM jdcom_analysis.category_performance; -- Expected 4777
SELECT * FROM jdcom_analysis.category_performance ORDER BY total_interactions DESC LIMIT 10;
SELECT * FROM jdcom_analysis.category_performance ORDER BY purchases DESC,total_interactions DESC LIMIT 10;
SELECT * FROM jdcom_analysis.category_performance WHERE total_interactions>=20 ORDER BY purchase_share_percent DESC,total_interactions DESC LIMIT 10;
WITH overall AS (SELECT COUNT(*) FILTER (WHERE interaction_label=3)*100.0/NULLIF(COUNT(*),0) AS ps FROM jdcom_analysis.customer_interactions),
threshold AS (SELECT AVG(total_interactions) AS avg_volume FROM jdcom_analysis.category_performance)
SELECT cp.* FROM jdcom_analysis.category_performance cp CROSS JOIN overall o CROSS JOIN threshold t
WHERE cp.total_interactions>=t.avg_volume AND cp.purchase_share_percent<o.ps
ORDER BY cp.total_interactions DESC,cp.purchase_share_percent ASC;
SELECT SUM(total_interactions),SUM(clicks),SUM(cart_additions),SUM(purchases) FROM jdcom_analysis.category_performance;
-- Expected: 320132 | 223909 | 75407 | 20816
