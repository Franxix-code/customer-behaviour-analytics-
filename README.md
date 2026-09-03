# Customer Behavior Analytics Report

SQL-based analysis of customer purchasing behavior using the **AdventureWorks2022** sample database. This project answers a set of realistic business questions using window functions, CTEs, and gaps-and-islands / cohort analysis patterns — techniques commonly used in data engineering and analytics roles to understand customer engagement and retention.

## Business Questions Answered

| # | Question | Technique Used |
|---|----------|-----------------|
| 1 | Which products sell best within each subcategory? | `RANK()` / `DENSE_RANK()` |
| 2 | How long do customers typically go between purchases, and which customers have gone unusually long without ordering? | `LAG()`, `DATEDIFF` |
| 3 | Which customers order on consecutive days (highly engaged customers)? | Gaps-and-islands (`ROW_NUMBER()` trick) |
| 4 | How does customer retention look over time, grouped by when they first purchased? | Cohort analysis, `PIVOT` |
| 5 | What does month-over-month sales trend look like, smoothed over a 3-month window? | Moving average (`AVG() OVER`) |
| 6 | What's the value gap between a customer's first and most recent order? | `FIRST_VALUE()` / `LAST_VALUE()` |

## Repo Structure

```
customer-behavior-analytics/
├── README.md
└── sql/
    ├── 01_top_products_per_subcategory.sql
    ├── 02_purchase_gap_analysis.sql
    ├── 03_consecutive_day_orders.sql
    ├── 04_cohort_retention.sql
    ├── 05_moving_average_sales.sql
    └── 06_first_vs_last_order_value.sql
```

## Tools Used

- Microsoft SQL Server (SSMS)
- AdventureWorks2022 sample database ([Microsoft docs](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure))

## A Note on Debugging

Two bugs worth calling out from building this, since spotting and fixing them was part of understanding the techniques, not just writing them:

1. **`LAST_VALUE()` needs an explicit frame.** Without `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`, `LAST_VALUE()` uses the default frame (`UNBOUNDED PRECEDING` to `CURRENT ROW`), which means it just returns the current row's own value on every row — not the actual last value in the partition.

2. **A moving average partitioned too granularly returns the value unchanged.** If you partition by the same columns you're already aggregating by (e.g., partitioning by year+month when each row *is* one year+month), each partition only contains one row — so "N rows preceding" has nothing to average against. The fix was removing the partition and ordering across the full timeline instead.

## Author

Francis — built as part of self-directed SQL practice for a data engineering career path.
