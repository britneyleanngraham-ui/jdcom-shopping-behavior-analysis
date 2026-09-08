/* JD.com Search and Shopping Behavior Analysis
   Script 01: Database Setup and Import Template
   Canonical schema: jdcom_analysis
   Grain: one recorded positive query-candidate interaction per row. */

CREATE SCHEMA IF NOT EXISTS jdcom_analysis;
SET search_path TO jdcom_analysis, public;
DROP TABLE IF EXISTS jdcom_analysis.customer_interactions CASCADE;
CREATE TABLE jdcom_analysis.customer_interactions (
 query TEXT, interaction_label SMALLINT NOT NULL, candidate_record_id BIGINT NOT NULL,
 query_record_id BIGINT NOT NULL, product_id BIGINT NOT NULL, product_name_tokens TEXT,
 brand_id BIGINT NOT NULL, category_level_4_id BIGINT NOT NULL, shop_id BIGINT NOT NULL,
 interaction_type VARCHAR(20) NOT NULL, added_to_cart_or_purchased SMALLINT NOT NULL, purchased SMALLINT NOT NULL,
 CONSTRAINT chk_interaction_label CHECK (interaction_label IN (1,2,3)),
 CONSTRAINT chk_interaction_type CHECK (interaction_type IN ('Click','Add to Cart','Purchase')),
 CONSTRAINT chk_cart_or_purchase CHECK (added_to_cart_or_purchased IN (0,1)),
 CONSTRAINT chk_purchased CHECK (purchased IN (0,1)),
 CONSTRAINT chk_interaction_field_mapping CHECK (
  (interaction_label=1 AND interaction_type='Click' AND added_to_cart_or_purchased=0 AND purchased=0) OR
  (interaction_label=2 AND interaction_type='Add to Cart' AND added_to_cart_or_purchased=1 AND purchased=0) OR
  (interaction_label=3 AND interaction_type='Purchase' AND added_to_cart_or_purchased=1 AND purchased=1))
);

/* Import data/cleaned/jdsearch_cleaned_interactions.csv with Header=Yes into
   jdcom_analysis.customer_interactions using pgAdmin Import/Export Data. */
SELECT COUNT(*) AS total_rows FROM jdcom_analysis.customer_interactions;
-- Expected: 320132
