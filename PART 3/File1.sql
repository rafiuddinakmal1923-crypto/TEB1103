SELECT 
    A.Highest_Education_Level, 
    B.Application_Source_Channel
FROM Job_Applicant A
JOIN Job_Application B 
    ON A.Applicant_ID = B.Applicant_ID
WHERE A.Current_Employment_Status = 'Employed'    
  AND B.Expected_Salary > 3000.00;                