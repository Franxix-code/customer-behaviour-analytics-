/*
    Business Question:
    For each customer, how does their most recent order value compare
    to their very first order value?

    Why it matters:
    Signals whether individual customers are trending toward larger or
    smaller purchases over their lifetime with the business.

    Note: LAST_VALUE() requires an explicit frame
    (ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING).
    Without it, LAST_VALUE() uses the default frame and just returns
    each row's own value instead of the true last value in the partition.
*/

select
    CustomerID,
    FirstOrderValue,
    LastOrderValue,
    LastOrderValue - FirstOrderValue as ValueChange
from (
    select
        CustomerID,
        first_value(TotalDue) over (
            partition by CustomerID order by OrderDate
        ) FirstOrderValue,
        last_value(TotalDue) over (
            partition by CustomerID order by OrderDate
            rows between unbounded preceding and unbounded following
        ) LastOrderValue
    from Sales.SalesOrderHeader
) t
group by CustomerID, FirstOrderValue, LastOrderValue
order by CustomerID;
