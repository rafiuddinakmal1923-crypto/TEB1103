SELECT 
    C.Company_Name, 
    C.Company_Origin,
    L.Lot_Name, 
    L.Lot_Status,
    LD.Land_Title, 
    LD.Land_Zoning_Type,
    A.Approval_Status, 
    A.Approval_Duration,
    P.Reviewed_Status, 
    P.Expert_Credential,
    D.Developer_FinancialStatus, 
    D.Developer_DurationInBusiness
FROM Company C
JOIN Company_Lot CL 
    ON C.Company_ID = CL.Company_ID AND C.Company_SSM_No = CL.Company_SSM_No
JOIN Lot L 
    ON CL.Lot_ID = L.Lot_ID AND CL.Lot_TitleNo = L.Lot_TitleNo
JOIN Land LD 
    ON L.Land_ID = LD.Land_ID
JOIN Land_Approval LA 
    ON LD.Land_ID = LA.Land_ID AND LD.Land_Master_Survey_Plan_No = LA.Land_Master_Survey_Plan_No
JOIN Approval A 
    ON LA.Approval_ID = A.Approval_ID AND LA.Approval_LetterID = A.Approval_LetterID
JOIN Proposal_Content P 
    ON A.Proposal_ID = P.Proposal_ID
JOIN Developer D 
    ON P.Developer_ID = D.Developer_ID
WHERE A.Approval_Date >= TO_DATE('2026-08-25', 'YYYY-MM-DD') 
  AND LD.Land_Size > 0.00                                    
  AND C.Company_PaidUpCapital > 0.00                         
  AND D.Developer_ProjectDone >= 0;                          