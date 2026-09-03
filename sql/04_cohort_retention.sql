/*
    Business Question:
    Of customers who first purchased in a given month (their "cohort"),
    how many were still active in each following month?

    Why it matters:
    This is the standard cohort retention analysis used to measure how
    well a business retains customers over time, and to compare retention
    across different starting periods.
*/

with CohortBase as (
    select
        CustomerID,
        datefromparts(year(min(OrderDate)), month(min(OrderDate)), 1) as CohortMonth
    from Sales.SalesOrderHeader
    group by CustomerID
),

OrderMonths as (
    select
        CustomerID,
        datefromparts(year(OrderDate), month(OrderDate), 1) as OrderMonth
    from Sales.SalesOrderHeader
),

CohortActivity as (
    select
        cb.CohortMonth,
        datediff(month, cb.CohortMonth, om.OrderMonth) as MonthsSinceCohort,
        om.CustomerID
    from OrderMonths om
    inner join CohortBase cb
        on om.CustomerID = cb.CustomerID
),

CohortCounts as (
    select
        CohortMonth,
        MonthsSinceCohort,
        count(distinct CustomerID) as ActiveCustomers
    from CohortActivity
    group by CohortMonth, MonthsSinceCohort
)

-- Retention table: cohorts as rows, months-since-start as columns
select
    CohortMonth,
    isnull([0], 0) as Month0,
    isnull([1], 0) as Month1,
    isnull([2], 0) as Month2,
    isnull([3], 0) as Month3,
    isnull([4], 0) as Month4,
    isnull([5], 0) as Month5
from CohortCounts
pivot (
    sum(ActiveCustomers)
    for MonthsSinceCohort in ([0], [1], [2], [3], [4], [5])
) as PivotTable
order by CohortMonth;
