/*
    Business Question:
    Which customers placed orders on consecutive days? These represent
    "islands" of highly engaged, back-to-back purchasing activity.

    Technique:
    Classic gaps-and-islands trick — subtracting a sequential ROW_NUMBER()
    (in days) from the order date produces a constant value for any run
    of consecutive dates. That constant becomes the grouping key.
*/

with OrderDays as (
    select distinct
        CustomerID,
        cast(OrderDate as date) as OrderDate
    from Sales.SalesOrderHeader
),

IslandGroups as (
    select
        CustomerID,
        OrderDate,
        dateadd(day, -row_number() over (partition by CustomerID order by OrderDate), OrderDate) as IslandKey
    from OrderDays
)

select
    CustomerID,
    min(OrderDate) as IslandStart,
    max(OrderDate) as IslandEnd,
    count(*) as ConsecutiveDays
from IslandGroups
group by CustomerID, IslandKey
having count(*) > 1
order by CustomerID, IslandStart;
