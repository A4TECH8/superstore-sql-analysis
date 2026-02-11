-- Dataset: Sample_Superstore
-- Database: PostgreSQL
-- Language: SQL
-- Author: Wilson Ivan
-- Date: 2026


/* understand which products, regions, 
categories and customer segments they should target or avoid.
*/


/* ------------------------------------------------------------
1. This query to know which region and customer segment needs
to boost or add certain strong selling products in a certain region.
---------------------------------------------------------------*/
SELECT
    segment,
    region,
    SUM(sales)  AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / NULLIF(SUM(sales),0) AS profit_margin
FROM 
    sample_superstore
GROUP BY 
    segment, 
    region
ORDER BY 
    total_profit DESC;


/*---------------------------------------------------------------- 
2.This query pinpoints a certain sub-category products per region
that needs to avoid or 'improved' like better marketing, change the 
item with the same category but different style.
------------------------------------------------------------------*/
SELECT
    sub_category,
    region,
    SUM(sales)  AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / NULLIF(SUM(sales),0) AS profit_margin
FROM
    sample_superstore

GROUP BY
    sub_category,
    region
HAVING
    SUM(profit) / NULLIF(SUM(sales),0) < 0.05 -- below 5% profit margin not profitable below average, needs review.
ORDER BY
    profit_margin;


/*---------------------------------------------------------------------------------- 
3.This query is to know which product, customer segment and region needs to add more
the same product with different style in order to boost more profit.
----------------------------------------------------------------------------------*/
SELECT
    sub_category,
    region,
    segment,
    SUM(profit) AS total_profit,
    SUM(profit) / NULLIF(SUM(sales),0) AS profit_margin,
    CASE
        WHEN SUM(profit) / NULLIF(SUM(sales),0) > 0.25 THEN 'Excellent' -- above %25 strong brand! excellent profit margin
        WHEN SUM(profit) / NULLIF(SUM(sales),0) >= 0.10 THEN 'Good' -- between %10 to %25 standard health profit margin
        ELSE 'Average' -- below %10 maybe break even and below 1% to negative some high cost products low profit or high competition.
    END AS performance_category
FROM
    sample_superstore
GROUP BY
    sub_category,
    region,
    segment
HAVING
    SUM(profit) > 100 
ORDER BY
    profit_margin DESC;


/*--------------------------------------------------------------------------------------
4.This query is to find high-margin Tables products (potential replacements)
Use case: Identify successful Table products to replicate 
--------------------------------------------------------------------------------------*/
SELECT
    product_name,
    sub_category,
    region,
    sales,
    profit,
    profit / NULLIF(sales,0) AS profit_margin
FROM 
    sample_superstore
WHERE sub_category = 'Tables' AND profit / NULLIF(sales,0) > 0.25
ORDER BY 
    profit_margin DESC;
