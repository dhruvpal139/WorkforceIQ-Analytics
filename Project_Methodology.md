# Project Methodology – WorkforceIQ Analytics

## 1. Project Approach

WorkforceIQ Analytics follows an end-to-end data analytics workflow using synthetic manufacturing data. The objective is to transform raw datasets into meaningful business insights through SQL analysis and Power BI dashboards.

## 2. Dataset Understanding

The project uses five tables:

- Employees
- Monthly_Attendance
- Monthly_Operations
- Purchase_Orders
- Data_Dictionary

The datasets cover workforce, attendance, operational performance, and procurement activities for 2025.

## 3. Data Quality Validation

SQL Server was used to perform data quality checks, including:

- Duplicate record identification
- Missing value checks
- Invalid value checks
- Attendance reconciliation
- Attendance percentage validation
- Procurement delivery status validation

The validation process helped establish confidence in the dataset before analysis.

## 4. SQL Analysis

SQL queries were developed to analyze four major business areas.

### Workforce Analysis
- Employee headcount and active workforce
- Attrition rate
- Department-wise attrition
- Job satisfaction and work-life balance
- Age and income-based analysis

### Attendance Analysis
- Overall attendance percentage
- Monthly attendance trends
- Department-wise attendance
- Absence and overtime analysis

### Operations Analysis
- Total units processed
- Department-wise operational output
- Quality and handling exceptions
- Process delay events
- Exception and delay rates per 1,000 units

### Procurement Analysis
- Total procurement spending
- Monthly purchasing trends
- Supplier-wise spending
- On-time and delayed orders
- Supplier delivery performance

## 5. SQL Reporting Views

SQL views were created to prepare summarized datasets for Power BI:

- `vw_Workforce_Summary`
- `vw_Workforce_Department`
- `vw_Attendance_Monthly`
- `vw_Attendance_Department`
- `vw_Operations_MonthlyDepartment`
- `vw_Procurement_Monthly`
- `vw_Procurement_Supplier`

## 6. Power BI Development

The reporting datasets were imported into Power BI along with the detailed tables.

The development process included:

- Data modelling and relationship setup
- DAX measure creation
- KPI development
- Visual selection and formatting
- Slicer and filter configuration
- Dashboard interaction testing

## 7. Dashboard Structure

The final Power BI report contains four pages:

1. **Workforce Overview:** Workforce headcount, attrition, and department-level analysis.
2. **Attendance & Operations:** Attendance trends, operational output, exceptions, and delays.
3. **Procurement & Supplier Analytics:** Spending trends and supplier delivery performance.
4. **Executive Overview:** Consolidated KPIs and management-level insights.

## 8. Key Performance Indicators

The report includes the following major KPIs:

- Total Employees
- Attrition Rate
- Attendance Rate
- Total Absent/Leave Days
- Total Units Processed
- Quality Exceptions per 1,000 Units
- Process Delay Events per 1,000 Units
- Total Procurement Spend
- On-Time Delivery Rate

## 9. Final Outcome

The project demonstrates how SQL Server and Power BI can be used together to validate data, perform business analysis, develop KPIs, and create interactive dashboards.

It provides a portfolio example of analytical thinking, SQL querying, DAX calculations, and business reporting.

## 10. Data Disclaimer

This project uses synthetic data created for educational and portfolio purposes. The findings are illustrative and do not represent actual company operations or employee records.
