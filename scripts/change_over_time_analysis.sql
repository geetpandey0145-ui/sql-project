/* =====================================================================================
    SECTION: MONTHLY SALES SUMMARY (POSTGRESQL)
    -------------------------------------------------------------------------------------
    Purpose:
        Generate a clean monthly-level sales summary including:
            • Total sales amount
            • Total quantity sold
            • Unique customers per month
            • Year-Month breakdown (sortable for dashboards)

    Output Columns:
        - order_month
        - order_year
        - total_sales
        - quantity_sold
        - total_customers
====================================================================================== */

SELECT 
    EXTRACT(MONTH FROM order_date) AS order_month,
    EXTRACT(YEAR  FROM order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS quantity_sold,
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

