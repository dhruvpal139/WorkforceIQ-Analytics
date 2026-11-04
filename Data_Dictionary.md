# Data Dictionary – WorkforceIQ Analytics

## Overview
This document describes the tables and key columns used in the WorkforceIQ Analytics project.

The project uses synthetic manufacturing data covering the year 2025.

## 1. Employees

Contains employee-level information.

| Column | Description |
|---|---|
| EmployeeID | Unique employee identifier |
| EmployeeName | Employee name |
| Department | Employee department |
| JobRole | Employee job role |
| Gender | Gender category |
| Age | Employee age |
| JoinDate | Employee joining date |
| ExitDate | Employee exit date, where applicable |
| Attrition | Indicates whether the employee has left |
| MonthlyIncomeINR | Monthly income in INR |
| OverTimePreference | Indicates overtime preference |
| JobSatisfactionScore | Employee job satisfaction score |
| WorkLifeBalanceScore | Work-life balance score |
| ShiftType | Employee shift category |
| ResidenceCity | Employee residence city |

## 2. Monthly_Attendance

Contains employee-wise monthly attendance information.

| Column | Description |
|---|---|
| EmployeeID | Employee identifier |
| Month | Reporting month in YYYY-MM format |
| ScheduledWorkingDays | Total scheduled working days |
| PresentDays | Days the employee was present |
| AbsentOrLeaveDays | Absent or leave days |
| OvertimeHours | Monthly overtime hours |
| AttendancePct | Attendance percentage |

## 3. Monthly_Operations

Contains monthly operational performance information.

| Column | Description |
|---|---|
| EmployeeID | Employee identifier |
| Month | Reporting month |
| Department | Department associated with the record |
| UnitsProcessed | Number of units processed |
| QualityOrHandlingExceptions | Quality or handling exceptions |
| ProcessDelayEvents | Number of process delay events |

## 4. Purchase_Orders

Contains procurement and supplier delivery information.

| Column | Description |
|---|---|
| PurchaseOrderID | Unique purchase order identifier |
| BuyerEmployeeID | Employee responsible for the purchase |
| OrderDate | Purchase order date |
| Category | Purchased material or category |
| SupplierID | Supplier identifier |
| OrderValueINR | Purchase order value in INR |
| PlannedLeadTimeDays | Planned delivery lead time |
| ActualLeadTimeDays | Actual delivery lead time |
| DeliveryStatus | Delivery classification: On Time or Delayed |

## 5. Data_Dictionary

Contains reference information describing the dataset and its fields.

## Notes
- EmployeeID connects employee information with attendance and operations records.
- Month represents the reporting period in YYYY-MM format.
- Attrition is stored as a Boolean/bit indicator.
- All monetary values are represented in Indian Rupees (INR).
- The dataset is synthetic and does not contain actual company performance records.

