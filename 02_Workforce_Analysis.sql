
/*
PROJECT: WorkforceIQ Analytics
FILE: 02_Workforce_Analysis.sql
PURPOSE: Analyze employee demographics, attrition,
         departments, salaries and satisfaction.
*/

-- ==========================================
-- 1. OVERALL WORKFORCE SUMMARY
-- ==========================================

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


-- ==========================================
-- 2. DEPARTMENT-WISE ATTRITION ANALYSIS
-- ==========================================

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
GROUP BY Department
ORDER BY AttritionRatePct DESC;


-- ==========================================
-- 3. JOB ROLE-WISE ATTRITION
-- ==========================================

SELECT
    JobRole,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    CAST(
        100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS AttritionRatePct,
    CAST(AVG(MonthlyIncomeINR) AS DECIMAL(12,2)) AS AverageIncomeINR
FROM dbo.Employees
GROUP BY JobRole
ORDER BY AttritionRatePct DESC;


-- ==========================================
-- 4. AGE GROUP-WISE ATTRITION
-- ==========================================

SELECT
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS AgeGroup,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    CAST(
        100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS AttritionRatePct
FROM dbo.Employees
GROUP BY
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END
ORDER BY MIN(Age);


-- ==========================================
-- 5. SALARY GROUP-WISE ATTRITION
-- ==========================================

SELECT
    CASE
        WHEN MonthlyIncomeINR < 20000 THEN 'Below 20000'
        WHEN MonthlyIncomeINR < 25000 THEN '20000-24999'
        WHEN MonthlyIncomeINR < 30000 THEN '25000-29999'
        WHEN MonthlyIncomeINR < 35000 THEN '30000-34999'
        ELSE '35000+'
    END AS SalaryBand,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    CAST(
        100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS AttritionRatePct,
    CAST(AVG(MonthlyIncomeINR) AS DECIMAL(12,2)) AS AverageIncomeINR
FROM dbo.Employees
GROUP BY
    CASE
        WHEN MonthlyIncomeINR < 20000 THEN 'Below 20000'
        WHEN MonthlyIncomeINR < 25000 THEN '20000-24999'
        WHEN MonthlyIncomeINR < 30000 THEN '25000-29999'
        WHEN MonthlyIncomeINR < 35000 THEN '30000-34999'
        ELSE '35000+'
    END
ORDER BY MIN(MonthlyIncomeINR);


-- ==========================================
-- 6. JOB SATISFACTION ANALYSIS
-- ==========================================

SELECT
    JobSatisfactionScore,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    CAST(
        100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS AttritionRatePct
FROM dbo.Employees
GROUP BY JobSatisfactionScore
ORDER BY JobSatisfactionScore;


-- ==========================================
-- 7. WORK-LIFE BALANCE ANALYSIS
-- ==========================================

SELECT
    WorkLifeBalanceScore,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    CAST(
        100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS AttritionRatePct
FROM dbo.Employees
GROUP BY WorkLifeBalanceScore
ORDER BY WorkLifeBalanceScore;


-- ==========================================
-- 8. OVERTIME PREFERENCE ANALYSIS
-- ==========================================

SELECT
    CASE
        WHEN OverTimePreference = 1 THEN 'Prefers Overtime'
        ELSE 'Does Not Prefer Overtime'
    END AS OvertimePreference,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    CAST(
        100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS AttritionRatePct
FROM dbo.Employees
GROUP BY OverTimePreference;


-- ==========================================
-- 9. GENDER-WISE WORKFORCE ANALYSIS
-- ==========================================

SELECT
    Gender,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    CAST(
        100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS AttritionRatePct
FROM dbo.Employees
GROUP BY Gender;


-- ==========================================
-- 10. DEPARTMENT-WISE WORKFORCE RANKING
-- ==========================================

SELECT
    Department,
    COUNT(*) AS TotalEmployees,
    DENSE_RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS WorkforceRank
FROM dbo.Employees
GROUP BY Department
ORDER BY WorkforceRank;
