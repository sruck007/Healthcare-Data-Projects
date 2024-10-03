# Healthcare Readmittance Analysis (Portfolio Project)

Welcome to my data portfolio! This repository showcases my projects in healthcare informatics, business intelligence, and revenue cycle management (RCM).

## Projects
### 1. [Healthcare Billing Automation with Python]
- **Description:** Automated AR data extraction, transformation, and reporting using Python.
- **Skills:** Python (Pandas, NumPy), Excel, Google Sheets API
- import pandas as pd
import pyodbc

# Load the CSV file (update the file path as necessary)
df = pd.read_csv(r'C:\Users\SamRucker\Downloads\claim_data.csv')
"C:\Users\SamRucker\Downloads\hospital_readmission.csv"

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

# Insert the records into dbo.claims table
for index, row in df.iterrows():
    cursor.execute('''
        INSERT INTO dbo.claims (Claim_ID, Date_Of_Service, Procedure_Code, Billed_Amount, Paid_Amount, Insurance_Type, Outcome)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', row.Claim_ID, row.Date_Of_Service, row.Procedure_Code, row.Billed_Amount, row.Paid_Amount, row.Insurance_Type, row.Outcome)

### 2. [SQL-Based Patient Outcomes Analysis]
- **Description:** SQL queries to extract patient outcomes and calculate key metrics.
- **Skills:** SQL (PostgreSQL/MySQL), Data Analysis
Link to queries feeding dashboard in dashboard_queries.sql file


### 3. [YTD Healthcare Metrics Dashboard (Tableau)](link to Tableau dashboard or project folder)
- **Description:** Interactive Tableau dashboard for tracking YTD metrics for healthcare providers.
- **Skills:** Tableau, SQL queries calculations
https://10ay.online.tableau.com/t/ruckerspark-3023265e6e/views/heatmap/HealthsystemDashboard

Dashboard Tableau preview
![image](https://github.com/user-attachments/assets/2570187d-6f69-4728-a09d-f8bc40d71604)


