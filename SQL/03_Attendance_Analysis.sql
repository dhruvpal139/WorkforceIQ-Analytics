
/*
PROJECT: WorkforceIQ Analytics
FILE: 03_Attendance_Analysis.sql
PURPOSE: Analyze employee attendance, absenteeism,
         overtime and monthly attendance trends.
*/

-- ==========================================
-- 1. OVERALL ATTENDANCE SUMMARY
-- ==========================================

SELECT
    COUNT(*) AS TotalRecords,
    COUNT(DISTINCT EmployeeID) AS TotalEmployees,
    SUM(ScheduledWorkingDays) AS TotalScheduledDays,
    SUM(PresentDays) AS TotalPresentDays,
    SUM(AbsentOrLeaveDays) AS TotalAbsentDays,
    SUM(OvertimeHours) AS TotalOvertimeHours,
    CAST(
        100.0 * SUM(PresentDays)
        / NULLIF(SUM(ScheduledWorkingDays), 0)
        AS DECIMAL(10,2)
    ) AS OverallAttendanceRatePct
FROM dbo.Monthly_Attendance;


-- ==========================================
-- 2. MONTHLY ATTENDANCE TREND
-- ==========================================

SELECT
    Month,
    SUM(ScheduledWorkingDays) AS TotalScheduledDays,
    SUM(PresentDays) AS TotalPresentDays,
    SUM(AbsentOrLeaveDays) AS TotalAbsentDays,
    CAST(
        100.0 * SUM(PresentDays)
        / NULLIF(SUM(ScheduledWorkingDays), 0)
        AS DECIMAL(10,2)
    ) AS AttendanceRatePct,
    SUM(OvertimeHours) AS TotalOvertimeHours
FROM dbo.Monthly_Attendance
GROUP BY Month
ORDER BY Month;


-- ==========================================
-- 3. DEPARTMENT-WISE ATTENDANCE
-- ==========================================

SELECT
    E.Department,
    SUM(A.ScheduledWorkingDays) AS TotalScheduledDays,
    SUM(A.PresentDays) AS TotalPresentDays,
    SUM(A.AbsentOrLeaveDays) AS TotalAbsentDays,
    CAST(
        100.0 * SUM(A.PresentDays)
        / NULLIF(SUM(A.ScheduledWorkingDays), 0)
        AS DECIMAL(10,2)
    ) AS AttendanceRatePct,
    SUM(A.OvertimeHours) AS TotalOvertimeHours
FROM dbo.Monthly_Attendance A
INNER JOIN dbo.Employees E
    ON A.EmployeeID = E.EmployeeID
GROUP BY E.Department
ORDER BY AttendanceRatePct DESC;


-- ==========================================
-- 4. MONTHLY ABSENT / LEAVE ANALYSIS
-- ==========================================

SELECT
    Month,
    SUM(AbsentOrLeaveDays) AS TotalAbsentDays,
    SUM(ScheduledWorkingDays) AS TotalScheduledDays,
    CAST(
        100.0 * SUM(AbsentOrLeaveDays)
        / NULLIF(SUM(ScheduledWorkingDays), 0)
        AS DECIMAL(10,2)
    ) AS AbsenceRatePct
FROM dbo.Monthly_Attendance
GROUP BY Month
ORDER BY Month;


-- ==========================================
-- 5. DEPARTMENT-WISE OVERTIME ANALYSIS
-- ==========================================

SELECT
    E.Department,
    SUM(A.OvertimeHours) AS TotalOvertimeHours,
    COUNT(DISTINCT A.EmployeeID) AS EmployeesRecorded,
    CAST(
        AVG(1.0 * A.OvertimeHours)
        AS DECIMAL(10,2)
    ) AS AverageOvertimeHoursPerRecord
FROM dbo.Monthly_Attendance A
INNER JOIN dbo.Employees E
    ON A.EmployeeID = E.EmployeeID
GROUP BY E.Department
ORDER BY TotalOvertimeHours DESC;


-- ==========================================
-- 6. EMPLOYEE-WISE ATTENDANCE SUMMARY
-- ==========================================

SELECT
    A.EmployeeID,
    E.EmployeeName,
    E.Department,
    SUM(A.ScheduledWorkingDays) AS ScheduledDays,
    SUM(A.PresentDays) AS PresentDays,
    SUM(A.AbsentOrLeaveDays) AS AbsentDays,
    CAST(
        100.0 * SUM(A.PresentDays)
        / NULLIF(SUM(A.ScheduledWorkingDays), 0)
        AS DECIMAL(10,2)
    ) AS AttendanceRatePct,
    SUM(A.OvertimeHours) AS TotalOvertimeHours
FROM dbo.Monthly_Attendance A
INNER JOIN dbo.Employees E
    ON A.EmployeeID = E.EmployeeID
GROUP BY
    A.EmployeeID,
    E.EmployeeName,
    E.Department
ORDER BY AttendanceRatePct ASC;


-- ==========================================
-- 7. LOW ATTENDANCE EMPLOYEE ANALYSIS
-- ==========================================

SELECT
    A.EmployeeID,
    E.EmployeeName,
    E.Department,
    SUM(A.PresentDays) AS PresentDays,
    SUM(A.ScheduledWorkingDays) AS ScheduledDays,
    CAST(
        100.0 * SUM(A.PresentDays)
        / NULLIF(SUM(A.ScheduledWorkingDays), 0)
        AS DECIMAL(10,2)
    ) AS AttendanceRatePct
FROM dbo.Monthly_Attendance A
INNER JOIN dbo.Employees E
    ON A.EmployeeID = E.EmployeeID
GROUP BY
    A.EmployeeID,
    E.EmployeeName,
    E.Department
HAVING
    100.0 * SUM(A.PresentDays)
    / NULLIF(SUM(A.ScheduledWorkingDays), 0) < 85
ORDER BY AttendanceRatePct ASC;


-- ==========================================
-- 8. ATTENDANCE DATA RECONCILIATION
-- ==========================================

SELECT *
FROM dbo.Monthly_Attendance
WHERE PresentDays + AbsentOrLeaveDays
      <> ScheduledWorkingDays;


-- ==========================================
-- 9. ATTENDANCE PERCENTAGE VALIDATION
-- ==========================================

SELECT
    EmployeeID,
    Month,
    AttendancePct,
    CAST(
        100.0 * PresentDays
        / NULLIF(ScheduledWorkingDays, 0)
        AS DECIMAL(10,2)
    ) AS CalculatedAttendancePct
FROM dbo.Monthly_Attendance
WHERE ABS(
    AttendancePct -
    100.0 * PresentDays
    / NULLIF(ScheduledWorkingDays, 0)
) > 0.01;


-- ==========================================
-- 10. MONTHLY ATTENDANCE RANKING
-- ==========================================

SELECT
    Month,
    CAST(
        100.0 * SUM(PresentDays)
        / NULLIF(SUM(ScheduledWorkingDays), 0)
        AS DECIMAL(10,2)
    ) AS AttendanceRatePct,
    DENSE_RANK() OVER (
        ORDER BY
        1.0 * SUM(PresentDays)
        / NULLIF(SUM(ScheduledWorkingDays), 0) DESC
    ) AS AttendanceRank
FROM dbo.Monthly_Attendance
GROUP BY Month
ORDER BY AttendanceRank;
