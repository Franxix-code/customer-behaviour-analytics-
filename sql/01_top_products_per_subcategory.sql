/*
    Business Question:
    Which are the top 3 best-selling products (by quantity) within each product subcategory?

    Why it matters:
    Helps identify hero products per category for inventory prioritization,
    marketing focus, or reorder planning.
*/

select *
from (
    select
        *,
        rank() over (partition by ProductSubcategoryID order by OrderQty desc) QtyRank
    from (
        select
            p.ProductSubcategoryID,
            p.ProductID,
            sum(sod.OrderQty) OrderQty
        from Sales.SalesOrderDetail sod
        inner join Production.Product p
            on sod.ProductID = p.ProductID
        group by p.ProductSubcategoryID, p.ProductID
    ) t
) r
where QtyRank < 4
order by ProductSubcategoryID, QtyRank;
