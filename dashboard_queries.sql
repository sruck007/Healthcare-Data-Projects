##Reamision by Condtion Query


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

##Age vs Readmission Query
WITH ReadmissionByAge AS (
    SELECT 
        Age,
        COUNT(*) AS Total_Records,
        SUM(CASE WHEN Readmitted = 'yes' THEN 1 ELSE 0 END) AS Total_Readmitted
    FROM dbo.Readmin
    GROUP BY Age
)
SELECT 
    Age, 
    Total_Records,
    Total_Readmitted,
    CAST(Total_Readmitted AS FLOAT) / Total_Records * 100 AS Readmission_Rate
FROM ReadmissionByAge
ORDER BY Age;



##Colections Time Series Query
SELECT 
    Claim_ID, 
    Date_Of_Service,
    Paid_Amount,
    SUM(Paid_Amount) OVER (ORDER BY Date_Of_Service) AS Cumulative_Paid_Amount
FROM dbo.claim_data;

##Payer Mix Query
SELECT 
    Insurance_Type, 
    COUNT(*) AS Total_Claims,
    SUM(Paid_Amount) AS Total_Paid,
    AVG(Paid_Amount) AS Avg_Paid
FROM dbo.claim_data
GROUP BY Insurance_Type;

##Procedure code vs Payment Query
SELECT 
    Procedure_Code, 
    Outcome, 
    COUNT(*) AS Outcome_Count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Procedure_Code) AS Outcome_Percentage
FROM dbo.claim_data
GROUP BY Procedure_Code, Outcome;

