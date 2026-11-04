
/*
PROJECT: WorkforceIQ Analytics
FILE: 04_Operations_Analysis.sql
PURPOSE: Analyze operational productivity, quality exceptions
         and process delays.
*/

-- ==========================================
-- 1. OVERALL OPERATIONS SUMMARY
-- ==========================================

SELECT
    SUM(UnitsProcessed) AS TotalUnitsProcessed,
    SUM(QualityOrHandlingExceptions) AS TotalExceptions,
    SUM(ProcessDelayEvents) AS TotalDelayEvents,
    CAST(
        1000.0 * SUM(QualityOrHandlingExceptions)
        / NULLIF(SUM(UnitsProcessed), 0)
        AS DECIMAL(10,2)
    ) AS ExceptionsPer1000Units,
    CAST(
        1000.0 * SUM(ProcessDelayEvents)
        / NULLIF(SUM(UnitsProcessed), 0)
        AS DECIMAL(10,2)
    ) AS DelaysPer1000Units
FROM dbo.Monthly_Operations;


-- ==========================================
-- 2. DEPARTMENT-WISE OPERATIONS PERFORMANCE
-- ==========================================

SELECT
    Department,
    SUM(UnitsProcessed) AS TotalUnits,
    SUM(QualityOrHandlingExceptions) AS TotalExceptions,
    SUM(ProcessDelayEvents) AS TotalDelayEvents,
    CAST(
        1000.0 * SUM(QualityOrHandlingExceptions)
        / NULLIF(SUM(UnitsProcessed), 0)
        AS DECIMAL(10,2)
    ) AS ExceptionsPer1000Units,
    CAST(
        1000.0 * SUM(ProcessDelayEvents)
        / NULLIF(SUM(UnitsProcessed), 0)
        AS DECIMAL(10,2)
    ) AS DelaysPer1000Units
FROM dbo.Monthly_Operations
GROUP BY Department
ORDER BY TotalUnits DESC;


-- ==========================================
-- 3. MONTHLY OPERATIONS TREND
-- ==========================================

SELECT
    Month,
    SUM(UnitsProcessed) AS TotalUnits,
    SUM(QualityOrHandlingExceptions) AS TotalExceptions,
    SUM(ProcessDelayEvents) AS TotalDelayEvents,
    CAST(
        1000.0 * SUM(QualityOrHandlingExceptions)
        / NULLIF(SUM(UnitsProcessed), 0)
        AS DECIMAL(10,2)
    ) AS ExceptionsPer1000Units,
    CAST(
        1000.0 * SUM(ProcessDelayEvents)
        / NULLIF(SUM(UnitsProcessed), 0)
        AS DECIMAL(10,2)
    ) AS DelaysPer1000Units
FROM dbo.Monthly_Operations
GROUP BY Month
ORDER BY Month;


-- ==========================================
-- 4. DEPARTMENT-WISE MONTHLY PERFORMANCE
-- ==========================================

SELECT
    Department,
    Month,
    SUM(UnitsProcessed) AS TotalUnits,
    SUM(QualityOrHandlingExceptions) AS TotalExceptions,
    SUM(ProcessDelayEvents) AS TotalDelayEvents,
    CAST(
        1000.0 * SUM(QualityOrHandlingExceptions)
        / NULLIF(SUM(UnitsProcessed), 0)
        AS DECIMAL(10,2)
    ) AS ExceptionsPer1000Units,
    CAST(
        1000.0 * SUM(ProcessDelayEvents)
        / NULLIF(SUM(UnitsProcessed), 0)
        AS DECIMAL(10,2)
    ) AS DelaysPer1000Units
FROM dbo.Monthly_Operations
GROUP BY Department, Month
ORDER BY Department, Month;


-- ==========================================
-- 5. DEPARTMENT RANKING BY PRODUCTION OUTPUT
-- ==========================================

SELECT
    Department,
    SUM(UnitsProcessed) AS TotalUnits,
    DENSE_RANK() OVER (
        ORDER BY SUM(UnitsProcessed) DESC
    ) AS ProductionRank
FROM dbo.Monthly_Operations
GROUP BY Department
ORDER BY ProductionRank;


-- ==========================================
-- 6. DEPARTMENT RANKING BY QUALITY EXCEPTIONS
-- ==========================================

SELECT
    Department,
    SUM(UnitsProcessed) AS TotalUnits,
    SUM(QualityOrHandlingExceptions) AS TotalExceptions,
    CAST(
        1000.0 * SUM(QualityOrHandlingExceptions)
        / NULLIF(SUM(UnitsProcessed), 0)
        AS DECIMAL(10,2)
    ) AS ExceptionsPer1000Units,
    DENSE_RANK() OVER (
        ORDER BY
        1.0 * SUM(QualityOrHandlingExceptions)
        / NULLIF(SUM(UnitsProcessed), 0) DESC
    ) AS ExceptionRateRank
FROM dbo.Monthly_Operations
GROUP BY Department
ORDER BY ExceptionRateRank;


-- ==========================================
-- 7. EMPLOYEE-WISE OPERATIONS CONTRIBUTION
-- ==========================================

SELECT
    EmployeeID,
    Department,
    SUM(UnitsProcessed) AS TotalUnits,
    SUM(QualityOrHandlingExceptions) AS TotalExceptions,
    SUM(ProcessDelayEvents) AS TotalDelayEvents,
    CAST(
        1000.0 * SUM(QualityOrHandlingExceptions)
        / NULLIF(SUM(UnitsProcessed), 0)
        AS DECIMAL(10,2)
    ) AS ExceptionsPer1000Units
FROM dbo.Monthly_Operations
GROUP BY EmployeeID, Department
ORDER BY TotalUnits DESC;


-- ==========================================
-- 8. OPERATIONS DATA QUALITY CHECK
-- ==========================================

SELECT *
FROM dbo.Monthly_Operations
WHERE UnitsProcessed < 0
   OR QualityOrHandlingExceptions < 0
   OR ProcessDelayEvents < 0;


-- ==========================================
-- 9. MONTHLY PRODUCTION OUTPUT RANKING
-- ==========================================

SELECT
    Month,
    SUM(UnitsProcessed) AS TotalUnits,
    DENSE_RANK() OVER (
        ORDER BY SUM(UnitsProcessed) DESC
    ) AS MonthlyProductionRank
FROM dbo.Monthly_Operations
GROUP BY Month
ORDER BY MonthlyProductionRank;
