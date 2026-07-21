SELECT 
    IL.Department_Name, 
    COUNT(A.Agreement_ID) AS Total_Agreements, 
    MAX(C.Company_PaidUpCapital) AS Max_Capital
FROM Invest_Labuan IL
JOIN Agreement A 
    ON IL.Department_ID = A.Department_ID
JOIN Company_Agreement CA 
    ON A.Agreement_ID = CA.Agreement_ID AND A.Agreement_StampDutyID = CA.Agreement_StampDutyID
JOIN Company C 
    ON CA.Company_ID = C.Company_ID AND CA.Company_SSM_No = C.Company_SSM_No
JOIN Approval APP 
    ON A.Approval_ID = APP.Approval_ID 
WHERE IL.Department_Operation_Budget > 8000000.00                    
  AND C.Company_PaidUpCapital > 0.00                                 
  AND A.Agreement_EffectiveDate >= TO_DATE('2026-01-01', 'YYYY-MM-DD') 
GROUP BY IL.Department_Name;