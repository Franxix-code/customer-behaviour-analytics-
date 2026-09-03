/*
    Business Question:
    How many days pass between a customer's consecutive orders, and which
    customers have gone more than 90 days without ordering (at-risk of churn)?

    Why it matters:
    Flagging large purchase gaps is a common early-warning signal for
    customer churn/disengagement.
*/

with CTE_Gaps as (
    select
        CustomerID,
        OrderDate,
        lag(OrderDate) over (partition by CustomerID order by OrderDate) PreviousOrderDate
    from Sales.SalesOrderHeader
)
select
    *,
    datediff(day, PreviousOrderDate, OrderDate) as GapDays
from CTE_Gaps
where datediff(day, PreviousOrderDate, OrderDate) > 90
order by CustomerID, OrderDate;
