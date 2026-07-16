SELECT DISTINCT
    P.Person_Name,
    JA.Highest_Education_Level,
    E.Employee_Position,
    QR.Inspection_Phase,
    DG.Digital_AutomationLevel,
    INF.IS_RoadAccessSpec,
    PT.Timeline_PhaseName,
    SS.ESG_ComplianceStatus
FROM Person P
JOIN Job_Applicant JA 
    ON P.Person_ID = JA.Person_ID
JOIN Employee_JobApplicant EJA 
    ON JA.Applicant_ID = EJA.Applicant_ID AND JA.Applicant_Portal_Username = EJA.Applicant_Portal_Username
JOIN Employee E 
    ON EJA.Employee_ID = E.Employee_ID AND EJA.Employee_Contract_No = E.Employee_Contract_No
JOIN Employee_QualityRecord EQR 
    ON E.Employee_ID = EQR.Employee_ID AND E.Employee_Contract_No = EQR.Employee_Contract_No
JOIN Quality_Record QR 
    ON EQR.Inspection_ID = QR.Inspection_ID AND EQR.Inspection_Date = QR.Inspection_Date
JOIN Digitalisation DG 
    ON QR.Digital_ID = DG.Digital_ID
JOIN Infrastructure INF 
    ON QR.IS_ID = INF.IS_ID
JOIN Project_Timeline PT 
    ON QR.Timeline_ID = PT.Timeline_MilestoneID
JOIN Sustainability_Score SS 
    ON QR.Inspection_ID = SS.Inspection_ID
WHERE E.Employee_Access_Level = 'Manager'            
  AND P.Person_Nationality = 'Malaysian'             
  AND JA.Total_Years_Experience >= 0                 
  AND QR.Inspection_CompletionPercent >= 0.00        
  AND PT.Timeline_PhaseNo > 0                        
ORDER BY P.Person_Name DESC;