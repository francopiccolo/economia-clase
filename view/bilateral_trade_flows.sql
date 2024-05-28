DROP VIEW IF EXISTS views.bilateral_trade_flows;

CREATE VIEW views.bilateral_trade_flows AS (
WITH data AS (
SELECT  exporter_country_code, SUM(trade_value_current_usd) AS total_usd_per_country
FROM    fact.bilateral_trade_flows
GROUP   BY 1
)


SELECT  tf.year, 
        CASE WHEN  total_usd_per_country < 333953450236 THEN 'Other' ELSE ce.country END AS exporter_country,
        ci.country          AS importer_country,
        pc.*,
        tf.trade_value_current_usd,
        tf.qty_tons
FROM    fact.bilateral_trade_flows tf
JOIN    dim.country ce ON ce.country_code = tf.exporter_country_code
JOIN    dim.country ci ON ci.country_code = tf.importer_country_code
JOIN    dim.product_category pc ON pc.product_category_l4_code = tf.product_category
JOIN    data d ON d.exporter_country_code = tf.exporter_country_code
);