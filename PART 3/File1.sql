SELECT 
    A.Highest_Education_Level, 
    B.Application_Source_Channel
FROM Job_Applicant A
JOIN Job_Application B 
    ON A.Applicant_ID = B.Applicant_ID
WHERE A.Current_Employment_Status = 'Employed'    -- 1st constraint: Text value
  AND B.Expected_Salary > 1000.00;                -- 2nd constraint: Numeric value