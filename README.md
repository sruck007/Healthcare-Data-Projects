# Healthcare Readmittance Anlyysis (Portfolio Project)

Welcome to my data portfolio! This repository showcases my projects in healthcare informatics, business intelligence, and revenue cycle management (RCM).

## Projects
### 1. [Healthcare Billing Automation with Python](link to project folder)
- **Description:** Automated AR data extraction, transformation, and reporting using Python.
- **Skills:** Python (Pandas, NumPy), Excel, Google Sheets API
- import pandas as pd
import pyodbc

# Load the CSV file (update the file path as necessary)
df = pd.read_csv(r'C:\Users\SamRucker\Downloads\claim_data.csv')

# Print the actual column names in the CSV to debug (you can remove this after debugging)
print(df.columns)

# Rename the columns (adapt to your new column names without spaces)
df.rename(columns={
    'Claim ID': 'Claim_ID', 
    'Date of Service': 'Date_Of_Service', 
    'Procedure Code': 'Procedure_Code',
    'Billed Amount': 'Billed_Amount',
    'Paid Amount': 'Paid_Amount',
    'Insurance Type': 'Insurance_Type',
    'Outcome': 'Outcome'
}, inplace=True)

# Keep only the required columns
df = df[['Claim_ID', 'Date_Of_Service', 'Procedure_Code', 'Billed_Amount', 'Paid_Amount', 'Insurance_Type', 'Outcome']]

# Remove rows with any null (NaN) values
df.dropna(inplace=True)

# Data type conversions: Ensure data types match the SQL Server schema
df['Claim_ID'] = df['Claim_ID'].astype(str)
df['Date_Of_Service'] = pd.to_datetime(df['Date_Of_Service'])  # Convert to datetime
df['Procedure_Code'] = df['Procedure_Code'].astype(str)
df['Billed_Amount'] = df['Billed_Amount'].astype(float)
df['Paid_Amount'] = df['Paid_Amount'].astype(float)
df['Insurance_Type'] = df['Insurance_Type'].astype(str)
df['Outcome'] = df['Outcome'].astype(str)

# Connect to SQL Server using pyodbc
conn = pyodbc.connect('DRIVER={SQL Server};'
                      'SERVER=DESKTOP-4LBGUE0\\SQLEXPRESS02;'
                      'DATABASE=master;'
                      'Trusted_Connection=yes;')

# Insert cleaned data into the dbo.claims table
cursor = conn.cursor()

# Insert the records into dbo.claims table
for index, row in df.iterrows():
    cursor.execute('''
        INSERT INTO dbo.claims (Claim_ID, Date_Of_Service, Procedure_Code, Billed_Amount, Paid_Amount, Insurance_Type, Outcome)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', row.Claim_ID, row.Date_Of_Service, row.Procedure_Code, row.Billed_Amount, row.Paid_Amount, row.Insurance_Type, row.Outcome)

# Commit the transaction to SQL Server
conn.commit()


### 2. [SQL-Based Patient Outcomes Analysis]
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

### 3. [Provider YTD Metrics Dashboard (Tableau)](link to Tableau dashboard or project folder)
- **Description:** Interactive Tableau dashboard for tracking YTD metrics for healthcare providers.
- **Skills:** Tableau, SQL queries calculations
https://10ay.online.tableau.com/t/ruckerspark-3023265e6e/views/heatmap/HealthsystemDashboard
