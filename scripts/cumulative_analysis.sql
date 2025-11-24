/* =====================================================================================
    SECTION: RUNNING TOTAL + MOVING AVERAGE (POSTGRESQL)
    -------------------------------------------------------------------------------------
    Purpose:
        • Aggregate revenue by year
        • Compute cumulative running revenue over time
        • Calculate moving average price (per year)
        • Useful for sales trend analysis and dashboarding

    Output Columns:
        - order_year
        - revenue
        - running_total_sales_cumulative
        - moving_average_price
====================================================================================== */

WITH yearly_sales AS (
    SELECT
        TO_CHAR(DATE_TRUNC('year', order_date), 'YYYY-MM-DD') AS order_year,
        SUM(sales_amount) AS revenue,
        ROUND(AVG(price), 0) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY order_year
)

SELECT
    order_year,
    revenue,

    /* Running cumulative revenue */
    SUM(revenue) OVER(
        ORDER BY order_year ASC
    ) AS running_total_sales_cumulative,

    /* Moving average of avg_price */
    ROUND(
        AVG(avg_price) OVER(
            ORDER BY order_year ASC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 0
    ) AS moving_average_price

FROM yearly_sales
ORDER BY order_year ASC;

