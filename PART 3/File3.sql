SELECT 
    L.Lot_Name, 
    L.Lot_Status,
    LD.Land_Title, 
    LD.Land_Zoning_Type,
    A.Approval_Duration, 
    A.Appeal_Allowed_Flag,
    AG.Agreement_Title, 
    AG.Agreement_Venue,
    P.Reviewed_Status, 
    P.Expert_Credential,
    PS.Screening_Score, 
    PS.Screening_Result
FROM Lot L
JOIN Land LD 
    ON L.Land_ID = LD.Land_ID
JOIN Land_Approval LA 
    ON LD.Land_ID = LA.Land_ID AND LD.Land_Master_Survey_Plan_No = LA.Land_Master_Survey_Plan_No
JOIN Approval A 
    ON LA.Approval_ID = A.Approval_ID AND LA.Approval_LetterID = A.Approval_LetterID
JOIN Agreement AG 
    ON A.Approval_ID = AG.Approval_ID
JOIN Proposal_Content P 
    ON A.Proposal_ID = P.Proposal_ID
JOIN Proposal_Screening PS 
    ON A.Screening_MeetingID = PS.Screening_MeetingID
WHERE AG.Agreement_Status = 'Active'                                 
  AND A.Approval_Status = 'Approved'                                 
  AND P.Submission_Date >= TO_DATE('2026-01-01', 'YYYY-MM-DD')       
  AND LD.Land_Size > 1000.00;          