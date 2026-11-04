
/*
PROJECT: WorkforceIQ Analytics
FILE: 06_PowerBI_Views.sql
PURPOSE: Create analytical SQL views for Power BI reporting.
*/

-- ==========================================
-- 1. WORKFORCE SUMMARY VIEW
-- ==========================================

CREATE OR ALTER VIEW dbo.vw_Workforce_Summary
AS
SELECT
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 0 THEN 1 ELSE 0 END) AS ActiveEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    CAST(
        100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS AttritionRatePct,
    CAST(AVG(1.0 * Age) AS DECIMAL(10,2)) AS AverageAge,
    CAST(AVG(MonthlyIncomeINR) AS DECIMAL(12,2)) AS AverageMonthlyIncomeINR
FROM dbo.Employees;
GO


-- ==========================================
-- 2. WORKFORCE DEPARTMENT VIEW
-- ==========================================

CREATE OR ALTER VIEW dbo.vw_Workforce_Department
AS
SELECT
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    CAST(
        100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS AttritionRatePct,
    CAST(AVG(MonthlyIncomeINR) AS DECIMAL(12,2)) AS AverageIncomeINR,
    CAST(AVG(1.0 * JobSatisfactionScore) AS DECIMAL(10,2))
        AS AverageJobSatisfaction,
    CAST(AVG(1.0 * WorkLifeBalanceScore) AS DECIMAL(10,2))
        AS AverageWorkLifeBalance
FROM dbo.Employees
GROUP BY Department;
GO


-- ==========================================
-- 3. MONTHLY ATTENDANCE VIEW
-- ==========================================

CREATE OR ALTER VIEW dbo.vw_Attendance_Monthly
AS
SELECT
    Month,
    SUM(ScheduledWorkingDays) AS TotalScheduledDays,
    SUM(PresentDays) AS TotalPresentDays,
    SUM(AbsentOrLeaveDays) AS TotalAbsentDays,
    SUM(OvertimeHours) AS TotalOvertimeHours,
    CAST(
        100.0 * SUM(PresentDays)
        / NULLIF(SUM(ScheduledWorkingDays), 0)
        AS DECIMAL(10,2)
    ) AS AttendanceRatePct
FROM dbo.Monthly_Attendance
GROUP BY Month;
GO


-- ==========================================
-- 4. DEPARTMENT-WISE ATTENDANCE VIEW
-- ==========================================

CREATE OR ALTER VIEW dbo.vw_Attendance_Department
AS
SELECT
    E.Department,
    SUM(A.ScheduledWorkingDays) AS TotalScheduledDays,
    SUM(A.PresentDays) AS TotalPresentDays,
    SUM(A.AbsentOrLeaveDays) AS TotalAbsentDays,
    SUM(A.OvertimeHours) AS TotalOvertimeHours,
    CAST(
        100.0 * SUM(A.PresentDays)
        / NULLIF(SUM(A.ScheduledWorkingDays), 0)
        AS DECIMAL(10,2)
    ) AS AttendanceRatePct
FROM dbo.Monthly_Attendance A
INNER JOIN dbo.Employees E
    ON A.EmployeeID = E.EmployeeID
GROUP BY E.Department;
GO


-- ==========================================
-- 5. MONTHLY OPERATIONS BY DEPARTMENT VIEW
-- ==========================================

CREATE OR ALTER VIEW dbo.vw_Operations_MonthlyDepartment
AS
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
GROUP BY Department, Month;
GO


-- ==========================================
-- 6. MONTHLY PROCUREMENT VIEW
-- ==========================================

CREATE OR ALTER VIEW dbo.vw_Procurement_Monthly
AS
SELECT
    DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS PurchaseMonth,
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
GROUP BY YEAR(OrderDate), MONTH(OrderDate);
GO


-- ==========================================
-- 7. SUPPLIER PERFORMANCE VIEW
-- ==========================================

CREATE OR ALTER VIEW dbo.vw_Procurement_Supplier
AS
SELECT
    SupplierID,
    COUNT(*) AS TotalOrders,
    SUM(OrderValueINR) AS TotalSpendINR,
    AVG(OrderValueINR) AS AverageOrderValueINR,
    AVG(1.0 * PlannedLeadTimeDays) AS AveragePlannedLeadTimeDays,
    AVG(1.0 * ActualLeadTimeDays) AS AverageActualLeadTimeDays,
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
GROUP BY SupplierID;
GO


-- ==========================================
-- 8. VERIFY CREATED VIEWS
-- ==========================================

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME LIKE 'vw_%'
ORDER BY TABLE_NAME;
GO
