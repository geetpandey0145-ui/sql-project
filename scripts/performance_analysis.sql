/* =====================================================================================
    SECTION: PRODUCT PERFORMANCE ANALYSIS (POSTGRESQL)
    -------------------------------------------------------------------------------------
    Purpose:
        Analyze product revenue trends over the years, including:
            • Yearly revenue by product
            • Product-wise average revenue
            • Above/Below Average performance
            • Year-over-year (YoY) revenue change
            • Trend labels (increasing / decreasing / no change)

    Output Columns:
        - order_year
        - product_name
        - current_revenue
        - avg_revenue
        - diff (current - average)
        - avg_change (above/below average)
        - py_revenue (last year)
        - py_diff (YoY difference)
        - revenue_change (trend label)

====================================================================================== */

WITH performance AS (
    SELECT
        EXTRACT(YEAR FROM f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_revenue
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY order_year, p.product_name
)

SELECT
    order_year,
    product_name,
    current_revenue,

    /* Average revenue per product */
    ROUND(AVG(current_revenue) OVER (
        PARTITION BY product_name
    ), 0) AS avg_revenue,

    /* Difference from average */
    current_revenue -
        ROUND(AVG(current_revenue) OVER (
            PARTITION BY product_name
        ), 0) AS diff,

    /* Above / Below Average Classification */
    CASE 
        WHEN current_revenue >
             ROUND(AVG(current_revenue) OVER (PARTITION BY product_name), 0)
             THEN 'above average'
        WHEN current_revenue <
             ROUND(AVG(current_revenue) OVER (PARTITION BY product_name), 0)
             THEN 'below average'
        ELSE 'average'
    END AS avg_change,

    /* Previous Year Revenue */
    LAG(current_revenue) OVER (
        PARTITION BY product_name
        ORDER BY order_year
    ) AS py_revenue,

    /* Differences vs previous year */
    current_revenue -
        LAG(current_revenue) OVER (
            PARTITION BY product_name
            ORDER BY order_year
        ) AS py_diff,

    /* Trend classification: YoY change */
    CASE 
        WHEN current_revenue >
            LAG(current_revenue) OVER (PARTITION BY product_name ORDER BY order_year)
            THEN 'increasing revenue'
        WHEN current_revenue <
            LAG(current_revenue) OVER (PARTITION BY product_name ORDER BY order_year)
            THEN 'decreasing revenue'
        ELSE 'no change'
    END AS revenue_change

FROM performance
ORDER BY product_name, order_year;

