CREATE VIEW V_Syariah_Investors AS
SELECT 
    I.MIDA_Registration_Ref, 
    A.Application_ID, 
    P.Payment_ID,
    I.Investor_Type || ' - ' || I.Investor_Risk_Appetite AS Investor_Profile,
    P.Payment_BankName || ' via ' || P.Payment_Method AS Payment_Details
FROM Investor I
JOIN Investment_Application A 
    ON I.Investor_ID = A.Investor_ID
JOIN Payment P 
    ON A.Application_ID = P.Application_ID
WHERE I.Syariah_Compliant_Status = 'Yes'; -- Constraint 1


SELECT * FROM V_SYARIAH_INVESTORS;