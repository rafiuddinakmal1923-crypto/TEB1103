CREATE VIEW V_Syariah_Representatives AS
SELECT 
    I.Investor_ID, 
    A.Application_ID, 
    R.Rep_ID,
    I.Investor_Type || ' - ' || I.Investor_Risk_Appetite AS Investor_Profile,
    R.Rep_PositionTitle || ' (' || R.Rep_Corporate_Role || ')' AS Rep_Details
FROM Investor I
JOIN Investment_Application A 
    ON I.Investor_ID = A.Investor_ID
JOIN Representative R 
    ON A.Rep_ID = R.Rep_ID
WHERE I.Syariah_Compliant_Status = 'Yes';

SELECT * FROM V_Syariah_Representatives;
