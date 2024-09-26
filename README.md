# Healthcare Data Projects Portfolio

Welcome to my data portfolio! This repository showcases my projects in healthcare informatics, business intelligence, and revenue cycle management (RCM).

## Projects
### 1. [Healthcare Billing Automation with Python](link to project folder)
- **Description:** Automated AR data extraction, transformation, and reporting using Python.
- **Skills:** Python (Pandas, NumPy), Excel, Google Sheets API

### 2. [Provider YTD Metrics Dashboard (Tableau)](link to Tableau dashboard or project folder)
- **Description:** Interactive Tableau dashboard for tracking YTD metrics for healthcare providers.
- **Skills:** Tableau, SQL, Excel
- https://10ay.online.tableau.com/t/ruckerspark-3023265e6e/authoring/heatmap/Sheet1/Health%20system%20Dashboard#3

### 3. [SQL-Based Patient Outcomes Analysis]
- **Description:** SQL queries to extract patient outcomes and calculate key metrics.
- **Skills:** SQL (PostgreSQL/MySQL), Data Analysis
SELECT 
    Procedure_Code, 
    Outcome, 
    COUNT(*) AS Outcome_Count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Procedure_Code) AS Outcome_Percentage
FROM dbo.claim_data
GROUP BY Procedure_Code, Outcome;

SELECT 
    Insurance_Type, 
    COUNT(*) AS Total_Claims,
    SUM(Paid_Amount) AS Total_Paid,
    AVG(Paid_Amount) AS Avg_Paid
FROM dbo.claim_data
GROUP BY Insurance_Type;


WITH ReadmissionByDiag AS (
    SELECT 
        Diag_1,
        COUNT(*) AS Total_Records,
        SUM(CASE WHEN Readmitted = 'yes' THEN 1 ELSE 0 END) AS Total_Readmitted,
        CAST(SUM(CASE WHEN Readmitted = 'yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS Readmission_Rate
    FROM dbo.Readmin
    GROUP BY Diag_1
)
SELECT 
    Diag_1,
    Total_Records,
    Total_Readmitted,
    Readmission_Rate,
    RANK() OVER (ORDER BY Readmission_Rate DESC) AS Rank_By_Readmission
FROM ReadmissionByDiag
ORDER BY Readmission_Rate DESC;
