/*
    Business Question:
    What does the sales trend look like month over month, smoothed
    with a 3-month moving average?

    Why it matters:
    Raw monthly sales figures are noisy. A moving average smooths out
    short-term fluctuations to reveal the underlying trend.

    Note: the window is NOT partitioned. Partitioning by the same
    year/month columns used to aggregate the data would put each row
    in its own single-row partition, making the moving average
    meaningless (it would just return the row's own value every time).
*/

select
    OrderYear,
    OrderMonth,
    TotalDue,
    avg(TotalDue) over (
        order by OrderYear, OrderMonth
        rows between 2 preceding and current row
    ) as MovingAverage
from (
    select
        year(OrderDate) OrderYear,
        month(OrderDate) OrderMonth,
        sum(TotalDue) TotalDue
    from Sales.SalesOrderHeader
    group by year(OrderDate), month(OrderDate)
) t
order by OrderYear, OrderMonth;
