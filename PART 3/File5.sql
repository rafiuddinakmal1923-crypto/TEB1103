DROP VIEW V_Syariah_Representatives;

CREATE VIEW V_Syariah_Representatives AS
SELECT 
    I.Investor_ID, 
    A.Application_ID, 
    R.Rep_ID,
    I.Investor_Type || ' represented by ' || R.Rep_Corporate_Role AS Investor_Representation,
    A.Application_CurrentStatus || ' - ' || R.Rep_Authorization_Type AS Application_Auth_Status
FROM Investor I
JOIN Investment_Application A 
    ON I.Investor_ID = A.Investor_ID
JOIN Representative R 
    ON A.Rep_ID = R.Rep_ID
WHERE I.Syariah_Compliant_Status = 'Yes';

SELECT * FROM V_Syariah_Representatives;