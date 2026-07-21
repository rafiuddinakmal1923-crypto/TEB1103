SELECT 
    C.Company_Name, 
    C.Company_Origin,
    L.Lot_Name, 
    L.Lot_Status,
    LD.Land_Title, 
    LD.Land_Zoning_Type,
    P.Reviewed_Status, 
    P.Expert_Credential,
    D.Developer_DurationInBusiness, 
    D.Developer_FinancialStatus,
    A.Approval_Status, 
    A.Approval_Duration
FROM Company C
JOIN Company_Lot CL 
    ON C.Company_ID = CL.Company_ID AND C.Company_SSM_No = CL.Company_SSM_No
JOIN Lot L 
    ON CL.Lot_ID = L.Lot_ID AND CL.Lot_TitleNo = L.Lot_TitleNo
JOIN Land LD 
    ON L.Land_ID = LD.Land_ID
JOIN Company_ProposalContent CPC 
    ON C.Company_ID = CPC.Company_ID AND C.Company_SSM_No = CPC.Company_SSM_No
JOIN Proposal_Content P 
    ON CPC.Proposal_ID = P.Proposal_ID AND CPC.Component_ID = P.Component_ID
JOIN Developer D 
    ON P.Developer_ID = D.Developer_ID
JOIN Approval A 
    ON P.Proposal_ID = A.Proposal_ID
WHERE C.Company_Entity_Type = 'Sdn Bhd'                              
  AND A.Approval_Date >= TO_DATE('2026-01-01', 'YYYY-MM-DD')         
  AND D.Developer_Experience_Year > 0                               
  AND LD.Land_Size > 1000.00;                                        