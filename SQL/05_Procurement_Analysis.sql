
/*
PROJECT: WorkforceIQ Analytics
FILE: 05_Procurement_Analysis.sql
PURPOSE: Analyze procurement expenditure, supplier performance,
         delivery delays and monthly spending trends.
*/

-- ==========================================
-- 1. OVERALL PROCUREMENT SUMMARY
-- ==========================================

SELECT
    COUNT(*) AS TotalPurchaseOrders,
    COUNT(DISTINCT SupplierID) AS TotalSuppliers,
    SUM(OrderValueINR) AS TotalProcurementSpendINR,
    AVG(OrderValueINR) AS AverageOrderValueINR,
    SUM(CASE WHEN DeliveryStatus = 'On Time' THEN 1 ELSE 0 END)
        AS OnTimeOrders,
    SUM(CASE WHEN DeliveryStatus = 'Delayed' THEN 1 ELSE 0 END)
        AS DelayedOrders,
    CAST(
        100.0 * SUM(CASE WHEN DeliveryStatus = 'On Time' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS OnTimeDeliveryRatePct
FROM dbo.Purchase_Orders;


-- ==========================================
-- 2. MONTHLY PROCUREMENT SPENDING
-- ==========================================

SELECT
    FORMAT(OrderDate, 'yyyy-MM') AS PurchaseMonth,
    COUNT(*) AS TotalOrders,
    SUM(OrderValueINR) AS TotalSpendINR,
    AVG(OrderValueINR) AS AverageOrderValueINR
FROM dbo.Purchase_Orders
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
ORDER BY PurchaseMonth;


-- ==========================================
-- 3. MONTH-OVER-MONTH SPENDING CHANGE
-- ==========================================

WITH MonthlySpend AS
(
    SELECT
        DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS PurchaseMonth,
        SUM(OrderValueINR) AS TotalSpendINR
    FROM dbo.Purchase_Orders
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
),
SpendWithPreviousMonth AS
(
    SELECT
        PurchaseMonth,
        TotalSpendINR,
        LAG(TotalSpendINR) OVER (
            ORDER BY PurchaseMonth
        ) AS PreviousMonthSpend
    FROM MonthlySpend
)
SELECT
    PurchaseMonth,
    TotalSpendINR,
    PreviousMonthSpend,
    CAST(
        100.0 * (TotalSpendINR - PreviousMonthSpend)
        / NULLIF(PreviousMonthSpend, 0)
        AS DECIMAL(10,2)
    ) AS MonthOverMonthChangePct
FROM SpendWithPreviousMonth
ORDER BY PurchaseMonth;


-- ==========================================
-- 4. SUPPLIER-WISE SPENDING ANALYSIS
-- ==========================================

SELECT
    SupplierID,
    COUNT(*) AS TotalOrders,
    SUM(OrderValueINR) AS TotalSpendINR,
    AVG(OrderValueINR) AS AverageOrderValueINR,
    SUM(CASE WHEN DeliveryStatus = 'On Time' THEN 1 ELSE 0 END)
        AS OnTimeOrders,
    SUM(CASE WHEN DeliveryStatus = 'Delayed' THEN 1 ELSE 0 END)
        AS DelayedOrders,
    CAST(
        100.0 * SUM(CASE WHEN DeliveryStatus = 'On Time' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS OnTimeDeliveryRatePct
FROM dbo.Purchase_Orders
GROUP BY SupplierID
ORDER BY TotalSpendINR DESC;


-- ==========================================
-- 5. SUPPLIER SPENDING RANKING
-- ==========================================

WITH SupplierSpend AS
(
    SELECT
        SupplierID,
        SUM(OrderValueINR) AS TotalSpendINR
    FROM dbo.Purchase_Orders
    GROUP BY SupplierID
)
SELECT
    SupplierID,
    TotalSpendINR,
    DENSE_RANK() OVER (
        ORDER BY TotalSpendINR DESC
    ) AS SupplierSpendRank
FROM SupplierSpend
ORDER BY SupplierSpendRank;


-- ==========================================
-- 6. SUPPLIER CONTRIBUTION TO TOTAL SPENDING
-- ==========================================

WITH SupplierSpend AS
(
    SELECT
        SupplierID,
        SUM(OrderValueINR) AS TotalSpendINR
    FROM dbo.Purchase_Orders
    GROUP BY SupplierID
),
SupplierContribution AS
(
    SELECT
        SupplierID,
        TotalSpendINR,
        CAST(
            100.0 * TotalSpendINR
            / SUM(TotalSpendINR) OVER ()
            AS DECIMAL(10,2)
        ) AS SpendContributionPct
    FROM SupplierSpend
)
SELECT
    SupplierID,
    TotalSpendINR,
    SpendContributionPct,
    SUM(SpendContributionPct) OVER (
        ORDER BY TotalSpendINR DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS CumulativeSpendPct
FROM SupplierContribution
ORDER BY TotalSpendINR DESC;


-- ==========================================
-- 7. DELIVERY PERFORMANCE BY SUPPLIER
-- ==========================================

SELECT
    SupplierID,
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN DeliveryStatus = 'On Time' THEN 1 ELSE 0 END)
        AS OnTimeOrders,
    SUM(CASE WHEN DeliveryStatus = 'Delayed' THEN 1 ELSE 0 END)
        AS DelayedOrders,
    CAST(
        100.0 * SUM(CASE WHEN DeliveryStatus = 'On Time' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS OnTimeDeliveryRatePct,
    AVG(1.0 * PlannedLeadTimeDays) AS AveragePlannedLeadTimeDays,
    AVG(1.0 * ActualLeadTimeDays) AS AverageActualLeadTimeDays
FROM dbo.Purchase_Orders
GROUP BY SupplierID
ORDER BY OnTimeDeliveryRatePct ASC;


-- ==========================================
-- 8. SUPPLIERS WITH WEAK DELIVERY PERFORMANCE
-- Minimum 10 orders considered
-- ==========================================

SELECT
    SupplierID,
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN DeliveryStatus = 'Delayed' THEN 1 ELSE 0 END)
        AS DelayedOrders,
    CAST(
        100.0 * SUM(CASE WHEN DeliveryStatus = 'On Time' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS OnTimeDeliveryRatePct
FROM dbo.Purchase_Orders
GROUP BY SupplierID
HAVING COUNT(*) >= 10
ORDER BY OnTimeDeliveryRatePct ASC;


-- ==========================================
-- 9. CATEGORY-WISE PROCUREMENT SPENDING
-- ==========================================

SELECT
    Category,
    COUNT(*) AS TotalOrders,
    SUM(OrderValueINR) AS TotalSpendINR,
    AVG(OrderValueINR) AS AverageOrderValueINR
FROM dbo.Purchase_Orders
GROUP BY Category
ORDER BY TotalSpendINR DESC;


-- ==========================================
-- 10. DELIVERY STATUS ANALYSIS
-- ==========================================

SELECT
    DeliveryStatus,
    COUNT(*) AS TotalOrders,
    SUM(OrderValueINR) AS TotalSpendINR,
    AVG(OrderValueINR) AS AverageOrderValueINR
FROM dbo.Purchase_Orders
GROUP BY DeliveryStatus;


-- ==========================================
-- 11. ACTUAL VS PLANNED LEAD TIME
-- ==========================================

SELECT
    SupplierID,
    AVG(1.0 * PlannedLeadTimeDays) AS AveragePlannedLeadTime,
    AVG(1.0 * ActualLeadTimeDays) AS AverageActualLeadTime,
    AVG(
        1.0 * (ActualLeadTimeDays - PlannedLeadTimeDays)
    ) AS AverageLeadTimeDifference
FROM dbo.Purchase_Orders
GROUP BY SupplierID
ORDER BY AverageLeadTimeDifference DESC;


-- ==========================================
-- 12. HIGH SPEND SUPPLIERS WITH WEAK DELIVERY
-- ==========================================

SELECT
    SupplierID,
    COUNT(*) AS TotalOrders,
    SUM(OrderValueINR) AS TotalSpendINR,
    CAST(
        100.0 * SUM(CASE WHEN DeliveryStatus = 'On Time' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS OnTimeDeliveryRatePct
FROM dbo.Purchase_Orders
GROUP BY SupplierID
HAVING COUNT(*) >= 10
ORDER BY TotalSpendINR DESC, OnTimeDeliveryRatePct ASC;


-- ==========================================
-- 13. PURCHASE ORDER DELIVERY VALIDATION
-- ==========================================

SELECT *
FROM dbo.Purchase_Orders
WHERE
    (DeliveryStatus = 'On Time'
        AND ActualLeadTimeDays > PlannedLeadTimeDays)
    OR
    (DeliveryStatus = 'Delayed'
        AND ActualLeadTimeDays <= PlannedLeadTimeDays);


-- ==========================================
-- 14. TOP 5 SUPPLIERS BY PROCUREMENT SPEND
-- ==========================================

SELECT TOP 5
    SupplierID,
    COUNT(*) AS TotalOrders,
    SUM(OrderValueINR) AS TotalSpendINR,
    CAST(
        100.0 * SUM(OrderValueINR)
        / SUM(SUM(OrderValueINR)) OVER ()
        AS DECIMAL(10,2)
    ) AS ShareOfTop5SpendPct
FROM dbo.Purchase_Orders
GROUP BY SupplierID
ORDER BY TotalSpendINR DESC;
