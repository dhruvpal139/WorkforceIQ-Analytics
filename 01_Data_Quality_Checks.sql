
/*
PROJECT: WorkforceIQ Analytics
FILE: 01_Data_Quality_Checks.sql
PURPOSE: Validate data quality across all major datasets.
*/

-- ==========================================
-- 1. TABLE ROW COUNTS
-- ==========================================

SELECT 'Employees' AS TableName, COUNT(*) AS TotalRows
FROM dbo.Employees

UNION ALL

SELECT 'Monthly_Attendance', COUNT(*)
FROM dbo.Monthly_Attendance

UNION ALL

SELECT 'Monthly_Operations', COUNT(*)
FROM dbo.Monthly_Operations

UNION ALL

SELECT 'Purchase_Orders', COUNT(*)
FROM dbo.Purchase_Orders;


-- ==========================================
-- 2. DUPLICATE CHECKS
-- ==========================================

-- Employees
SELECT EmployeeID, COUNT(*) AS DuplicateCount
FROM dbo.Employees
GROUP BY EmployeeID
HAVING COUNT(*) > 1;

-- Monthly Attendance
SELECT EmployeeID, Month, COUNT(*) AS DuplicateCount
FROM dbo.Monthly_Attendance
GROUP BY EmployeeID, Month
HAVING COUNT(*) > 1;

-- Monthly Operations
SELECT EmployeeID, Month, Department,
       COUNT(*) AS DuplicateCount
FROM dbo.Monthly_Operations
GROUP BY EmployeeID, Month, Department
HAVING COUNT(*) > 1;

-- Purchase Orders
SELECT PurchaseOrderID, COUNT(*) AS DuplicateCount
FROM dbo.Purchase_Orders
GROUP BY PurchaseOrderID
HAVING COUNT(*) > 1;


-- ==========================================
-- 3. MISSING VALUE CHECKS
-- ==========================================

-- Employees
SELECT
    SUM(CASE WHEN EmployeeID IS NULL THEN 1 ELSE 0 END) AS MissingEmployeeID,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS MissingDepartment,
    SUM(CASE WHEN JoinDate IS NULL THEN 1 ELSE 0 END) AS MissingJoinDate,
    SUM(CASE WHEN MonthlyIncomeINR IS NULL THEN 1 ELSE 0 END) AS MissingIncome
FROM dbo.Employees;

-- Monthly Attendance
SELECT
    SUM(CASE WHEN EmployeeID IS NULL THEN 1 ELSE 0 END) AS MissingEmployeeID,
    SUM(CASE WHEN Month IS NULL THEN 1 ELSE 0 END) AS MissingMonth,
    SUM(CASE WHEN AttendancePct IS NULL THEN 1 ELSE 0 END) AS MissingAttendancePct
FROM dbo.Monthly_Attendance;

-- Monthly Operations
SELECT
    SUM(CASE WHEN EmployeeID IS NULL THEN 1 ELSE 0 END) AS MissingEmployeeID,
    SUM(CASE WHEN Month IS NULL THEN 1 ELSE 0 END) AS MissingMonth,
    SUM(CASE WHEN UnitsProcessed IS NULL THEN 1 ELSE 0 END) AS MissingUnits
FROM dbo.Monthly_Operations;

-- Purchase Orders
SELECT
    SUM(CASE WHEN PurchaseOrderID IS NULL THEN 1 ELSE 0 END) AS MissingOrderID,
    SUM(CASE WHEN SupplierID IS NULL THEN 1 ELSE 0 END) AS MissingSupplierID,
    SUM(CASE WHEN OrderValueINR IS NULL THEN 1 ELSE 0 END) AS MissingOrderValue,
    SUM(CASE WHEN DeliveryStatus IS NULL THEN 1 ELSE 0 END) AS MissingDeliveryStatus
FROM dbo.Purchase_Orders;


-- ==========================================
-- 4. INVALID VALUE CHECKS
-- ==========================================

-- Employee age and income
SELECT *
FROM dbo.Employees
WHERE Age <= 0
   OR MonthlyIncomeINR < 0
   OR JobSatisfactionScore NOT BETWEEN 1 AND 4
   OR WorkLifeBalanceScore NOT BETWEEN 1 AND 4;

-- Attendance validation
SELECT *
FROM dbo.Monthly_Attendance
WHERE ScheduledWorkingDays < 0
   OR PresentDays < 0
   OR AbsentOrLeaveDays < 0
   OR PresentDays + AbsentOrLeaveDays <> ScheduledWorkingDays
   OR AttendancePct NOT BETWEEN 0 AND 100;

-- Operations validation
SELECT *
FROM dbo.Monthly_Operations
WHERE UnitsProcessed < 0
   OR QualityOrHandlingExceptions < 0
   OR ProcessDelayEvents < 0;

-- Purchase order validation
SELECT *
FROM dbo.Purchase_Orders
WHERE OrderValueINR < 0
   OR PlannedLeadTimeDays < 0
   OR ActualLeadTimeDays < 0
   OR DeliveryStatus NOT IN ('On Time', 'Delayed');


-- ==========================================
-- 5. REFERENTIAL INTEGRITY CHECKS
-- ==========================================

-- Attendance records without a matching employee
SELECT A.EmployeeID
FROM dbo.Monthly_Attendance A
LEFT JOIN dbo.Employees E
    ON A.EmployeeID = E.EmployeeID
WHERE E.EmployeeID IS NULL;

-- Operations records without a matching employee
SELECT O.EmployeeID
FROM dbo.Monthly_Operations O
LEFT JOIN dbo.Employees E
    ON O.EmployeeID = E.EmployeeID
WHERE E.EmployeeID IS NULL;

-- Purchase orders without a matching buyer
SELECT P.BuyerEmployeeID
FROM dbo.Purchase_Orders P
LEFT JOIN dbo.Employees E
    ON P.BuyerEmployeeID = E.EmployeeID
WHERE E.EmployeeID IS NULL;
