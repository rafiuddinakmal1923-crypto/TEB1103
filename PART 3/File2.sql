SELECT 
    I.Department_Name, 
    COUNT(A.Agreement_ID) AS Total_Active_Agreements, 
    MAX(D.Developer_TotalProjectValue) AS Max_Project_Value
FROM Invest_Labuan I
JOIN Agreement A 
    ON I.Department_ID = A.Department_ID
JOIN Proposal_Content P 
    ON A.Proposal_ID = P.Proposal_ID
JOIN Developer D 
    ON P.Developer_ID = D.Developer_ID
WHERE A.Agreement_GoverningLaw = 'National Land Code (Act 828)' 
  AND I.Department_Operation_Budget >= 1000000.00               
  AND D.Developer_Experience_Year > 0                           
GROUP BY I.Department_Name;