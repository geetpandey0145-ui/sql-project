/* =====================================================================================
    SECTION: CUSTOMER SEGMENTATION MODEL (POSTGRESQL)
    -------------------------------------------------------------------------------------
    Logic:
        • Calculate total spending per customer
        • Determine first & last order date
        • Calculate customer lifespan in months
        • Segment customers into:
              - VIP
              - Regular
              - New
        • Count customers in each segment
====================================================================================== */

WITH customer_spending AS (
    SELECT 
        c.customer_key,
        SUM(s.sales_amount) AS total_amount,
        MIN(s.order_date) AS first_order,
        MAX(s.order_date) AS last_order,

        -- lifespan in MONTHS (PostgreSQL correct version)
        (DATE_PART('year', AGE(MAX(s.order_date), MIN(s.order_date))) * 12) +
        (DATE_PART('month', AGE(MAX(s.order_date), MIN(s.order_date)))) 
        AS lifespan

    FROM gold.dim_customers c
    LEFT JOIN gold.fact_sales s
        ON c.customer_key = s.customer_key
    GROUP BY c.customer_key
)

SELECT 
    customer_category,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT
        customer_key,
        CASE 
            WHEN lifespan >= 10 AND total_amount > 4500 THEN 'VIP'
            WHEN lifespan >= 8  AND total_amount <= 4000 THEN 'Regular'
            ELSE 'New'
        END AS customer_category
    FROM customer_spending
) AS categorized
GROUP BY customer_category
ORDER BY total_customers DESC;

