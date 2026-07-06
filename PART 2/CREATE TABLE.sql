-- =====================================================================
-- LEVEL 0: No FK dependencies 
-- =====================================================================

CREATE TABLE Person (
    Person_ID VARCHAR2(15) NOT NULL,
    Person_IC VARCHAR2(20) NOT NULL UNIQUE,
    Person_Type VARCHAR2(20) NOT NULL CHECK (Person_Type IN ('Employee', 'Applicant', 'Representative', 'Inspector', 'Investment Committee')),
    Person_Name VARCHAR2(100) NOT NULL,
    Person_Nationality VARCHAR2(50) NOT NULL,
    Person_Email VARCHAR2(100) NOT NULL,
    Person_ContactNo VARCHAR2(15) NOT NULL,
    Person_Address VARCHAR2(255) NOT NULL,
    Person_DateOfBirth DATE NOT NULL,
    Person_Race VARCHAR2(20) NOT NULL CHECK (Person_Race IN ('Malay', 'Chinese', 'Indian', 'Bumiputera Sabah', 'Bumiputera Sarawak', 'Others')),
    CONSTRAINT pk_person PRIMARY KEY (Person_ID, Person_IC),
    CONSTRAINT uq_person_id UNIQUE (Person_ID)
);

CREATE TABLE Invest_Labuan (
    Department_ID               VARCHAR2(15) NOT NULL,
    Department_Code             VARCHAR2(10) NOT NULL,
    Department_Name             VARCHAR2(50) NOT NULL,
    Office_Email                VARCHAR2(100) NOT NULL,
    Office_ContactNo            VARCHAR2(15) NOT NULL,
    Office_Address              VARCHAR2(255) NOT NULL,
    Department_Operation_Budget NUMBER(15,2) NOT NULL CHECK (Department_Operation_Budget >= 0.00),
    Department_Function_Desc    VARCHAR2(255),
    Department_KPI              NUMBER(5,2) CHECK (Department_KPI BETWEEN 0.00 AND 100.00),
    Department_Routing_No       VARCHAR2(10) NOT NULL,
    CONSTRAINT pk_invest_labuan PRIMARY KEY (Department_ID, Department_Code),
    CONSTRAINT uq_invest_labuan_id UNIQUE (Department_ID)
);

CREATE TABLE Proposal_Screening (
    Screening_MeetingID VARCHAR2(20) NOT NULL,
    Screening_MOM_ID VARCHAR2(25) NOT NULL,
    Screening_Score INTEGER NOT NULL CHECK (Screening_Score BETWEEN 0 AND 100),
    Screening_ProposalCOIDesc VARCHAR2(255),
    Screening_ConflictOfInterest VARCHAR2(3) NOT NULL CHECK (Screening_ConflictOfInterest IN ('Yes', 'No')),
    Screening_Result VARCHAR2(25) NOT NULL CHECK (Screening_Result IN ('Shortlisted', 'Rejected', 'KIV', 'Requires Revision')),
    Screening_Date_Time DATE NOT NULL,
    Screening_Duration INTEGER NOT NULL CHECK (Screening_Duration > 0),
    Screening_ReviewCyclePhase VARCHAR2(30) NOT NULL CHECK (Screening_ReviewCyclePhase IN ('Preliminary', 'Technical', 'Financial', 'Final Review')),
    Screening_Amendment VARCHAR2(255),
    CONSTRAINT pk_proposal_screening PRIMARY KEY (Screening_MeetingID, Screening_MOM_ID),
    CONSTRAINT uq_screening_id UNIQUE (Screening_MeetingID)
);

CREATE TABLE Job_Description (
    Job_ID                      VARCHAR2(15) NOT NULL,
    Job_PublishDate             DATE NOT NULL,
    Job_Title                   VARCHAR2(50) NOT NULL,
    Job_RoleLevel               VARCHAR2(15) NOT NULL CHECK (Job_RoleLevel IN ('Fresh/Entry', 'Junior', 'Mid-Level', 'Senior', 'Director')),
    Job_EmploymentType          VARCHAR2(15) NOT NULL CHECK (Job_EmploymentType IN ('Full-Time', 'Part-Time', 'Contract', 'Internship')),
    Job_RequiredQualification   VARCHAR2(50) NOT NULL CHECK (Job_RequiredQualification IN ('Diploma', 'Bachelor Degree', 'Master Degree', 'PhD', 'Professional Cert')),
    Job_BudgetedSalary          NUMBER(10,2) NOT NULL CHECK (Job_BudgetedSalary > 0.00),
    Job_WorkModel               VARCHAR2(15) NOT NULL CHECK (Job_WorkModel IN ('On-Site', 'Remote', 'Hybrid')),
    Job_ClosingDate             DATE NOT NULL,
    Job_ActiveStatus            VARCHAR2(10) DEFAULT 'Open' CHECK (Job_ActiveStatus IN ('Open', 'Closed', 'Draft', 'Suspended')),
    CONSTRAINT pk_job_description PRIMARY KEY (Job_ID, Job_PublishDate),
    CONSTRAINT CHK_Job_Dates CHECK (Job_ClosingDate > Job_PublishDate),
    CONSTRAINT uq_job_id UNIQUE (Job_ID)
);

-- =====================================================================
-- LEVEL 1: Depends on Level 0
-- =====================================================================

CREATE TABLE Representative (
    Rep_ID VARCHAR2(15) NOT NULL,
    Board_Resolution_Ref VARCHAR2(30) NOT NULL,
    Rep_PositionTitle VARCHAR2(50) NOT NULL,
    Rep_Corporate_Role VARCHAR2(25) NOT NULL CHECK (Rep_Corporate_Role IN ('Lead Bidder', 'Technical Liaison', 'Legal Counsel', 'Financial Officer')),
    Rep_AppointedDate DATE NOT NULL,
    Rep_Active_Status VARCHAR2(10) DEFAULT 'Active' CHECK (Rep_Active_Status IN ('Active', 'Suspended', 'Revoked')),
    Rep_Authorization_Type VARCHAR2(30) NOT NULL CHECK (Rep_Authorization_Type IN ('Full Power of Attorney', 'Limited Signing Rights', 'Liaison Only')),
    Rep_Authorization_Expiry_Date DATE,
    Rep_Primary_Signatory_Flag VARCHAR2(3) DEFAULT 'No' CHECK (Rep_Primary_Signatory_Flag IN ('Yes', 'No')),
    Rep_ReportingLevel VARCHAR2(30) NOT NULL CHECK (Rep_ReportingLevel IN ('L1 - Executive Board', 'L2 - Senior Management', 'L3 - Middle Management', 'L4 - Operational Staff')),
    Department_ID VARCHAR2(15) NOT NULL,
    Person_ID VARCHAR2(15) NOT NULL,
    CHECK (Rep_Authorization_Expiry_Date > Rep_AppointedDate),
    CONSTRAINT pk_representative PRIMARY KEY (Rep_ID, Board_Resolution_Ref),
    CONSTRAINT fk_rep_dept FOREIGN KEY (Department_ID) REFERENCES Invest_Labuan(Department_ID),
    CONSTRAINT fk_rep_person FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID),
    CONSTRAINT uq_rep_id UNIQUE (Rep_ID)
);

CREATE TABLE Job_Applicant (
    Applicant_ID                VARCHAR2(15) NOT NULL,
    Applicant_Portal_Username   VARCHAR2(30) NOT NULL,
    Highest_Education_Level     VARCHAR2(50) NOT NULL CHECK (Highest_Education_Level IN ('Diploma', 'Bachelor', 'Master', 'PhD')),
    Total_Years_Experience      NUMBER(2) DEFAULT 0 CHECK (Total_Years_Experience >= 0),
    Current_Employment_Status   VARCHAR2(30) NOT NULL CHECK (Current_Employment_Status IN ('Employed', 'Unemployed', 'Self-Employed')),
    Linkedin_Profile_Link       VARCHAR2(255),
    Applicant_Major             VARCHAR2(50) NOT NULL,
    Applicant_Relocate_Flag     VARCHAR2(3) NOT NULL CHECK (Applicant_Relocate_Flag IN ('Yes', 'No')),
    Applicant_Education_Cert_Name VARCHAR2(100) NOT NULL,
    Applicant_Reference_PhoneNo VARCHAR2(15) NOT NULL,
    Person_ID                   VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_job_applicant PRIMARY KEY (Applicant_ID, Applicant_Portal_Username),
    CONSTRAINT fk_jobapp_person FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID),
    CONSTRAINT uq_applicant_id UNIQUE (Applicant_ID)
);

CREATE TABLE Employee (
    Employee_ID           VARCHAR2(15) NOT NULL,
    Employee_Contract_No  VARCHAR2(20) NOT NULL,
    Employee_Type         VARCHAR2(15) NOT NULL CHECK (Employee_Type IN ('Permanent', 'Contract', 'Intern')),
    Employee_Status       VARCHAR2(15) DEFAULT 'Active' CHECK (Employee_Status IN ('Active', 'Suspended', 'Resigned', 'Retired')),
    Employee_Hire_Date    DATE NOT NULL,
    Employee_Salary       NUMBER(10,2) NOT NULL CHECK (Employee_Salary > 0.00),
    Employee_KPI_Flag     VARCHAR2(3) NOT NULL CHECK (Employee_KPI_Flag IN ('Yes', 'No')),
    Employee_Position     VARCHAR2(50) NOT NULL,
    Employee_Bonus_Amount NUMBER(10,2) DEFAULT 0.00 CHECK (Employee_Bonus_Amount >= 0.00),
    Employee_KPI_Rating   NUMBER(5,2) CHECK (Employee_KPI_Rating BETWEEN 0.00 AND 100.00),
    Employee_Access_Level VARCHAR2(15) NOT NULL CHECK (Employee_Access_Level IN ('Admin', 'Manager', 'Staff', 'Viewer')),
    Department_ID         VARCHAR2(15) NOT NULL,
    Person_ID             VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_employee PRIMARY KEY (Employee_ID, Employee_Contract_No),
    CONSTRAINT fk_emp_dept FOREIGN KEY (Department_ID) REFERENCES Invest_Labuan(Department_ID),
    CONSTRAINT fk_emp_person FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID),
    CONSTRAINT uq_employee_id UNIQUE (Employee_ID)
);

CREATE TABLE Advertisement (
    Advertisement_ID           VARCHAR2(15) NOT NULL,
    Advertisement_StartDate    DATE NOT NULL,
    Advertisement_Type         VARCHAR2(30) NOT NULL CHECK (Advertisement_Type IN ('Digital', 'Billboard', 'Print', 'Social Media')),
    Advertisement_Title        VARCHAR2(100) NOT NULL,
    Advertisement_Duration     VARCHAR2(30) NOT NULL,
    Advertisement_Publication  VARCHAR2(50) NOT NULL,
    Advertisement_Remark       VARCHAR2(255),
    Advertisement_EndDate      DATE NOT NULL,
    Advertisement_Budget       NUMBER(10,2) DEFAULT 0.00 CHECK (Advertisement_Budget >= 0.00),
    Advertisement_Target_Group VARCHAR2(50) NOT NULL,
    Department_ID              VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_advertisement PRIMARY KEY (Advertisement_ID, Advertisement_StartDate),
    CONSTRAINT chk_advertisement_dates CHECK (Advertisement_EndDate >= Advertisement_StartDate),
    CONSTRAINT fk_adv_dept FOREIGN KEY (Department_ID) REFERENCES Invest_Labuan(Department_ID),
    CONSTRAINT uq_advertisement_id UNIQUE (Advertisement_ID)
);

-- =====================================================================
-- LEVEL 2: Depends on Level 1
-- =====================================================================

CREATE TABLE Company (
    Company_ID                VARCHAR2(15) NOT NULL,
    Company_SSM_No            VARCHAR2(20) NOT NULL,
    Company_Name              VARCHAR2(100) NOT NULL,
    Company_Entity_Type       VARCHAR2(30) NOT NULL CHECK (Company_Entity_Type IN ('Sdn Bhd', 'Bhd', 'LLP', 'Sole Proprietorship')),
    Company_Origin            VARCHAR2(15) NOT NULL CHECK (Company_Origin IN ('Local', 'Foreign')),
    Company_PaidUpCapital     NUMBER(15,2) NOT NULL CHECK (Company_PaidUpCapital > 0.00),
    Company_HQ_Address        VARCHAR2(255) NOT NULL,
    Company_Domain            VARCHAR2(100),
    Company_General_Email     VARCHAR2(100) NOT NULL,
    Company_General_ContactNo VARCHAR2(15) NOT NULL,
    Rep_ID                    VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_company PRIMARY KEY (Company_ID, Company_SSM_No),
    CONSTRAINT fk_comp_rep FOREIGN KEY (Rep_ID) REFERENCES Representative(Rep_ID),
    CONSTRAINT uq_company_id UNIQUE (Company_ID)
);


CREATE TABLE Investment_Committee (
    Committee_ID                 VARCHAR2(15) NOT NULL,
    Committee_TermSessionCode    VARCHAR2(20) NOT NULL,
    Committee_Expertise          VARCHAR2(50) NOT NULL CHECK (Committee_Expertise IN ('Technical', 'Financial', 'Environmental', 'Legal', 'Socio-Economic')),
    Committe_StartDate           DATE NOT NULL,
    Committee_EndDate            DATE NOT NULL,
    Committee_AuthorityCode      VARCHAR2(15) NOT NULL CHECK (Committee_AuthorityCode IN ('AUTH-HIGH', 'AUTH-MID', 'AUTH-LOW')),
    Committee_ReviewScopeDesc    VARCHAR2(255),
    Committee_AttendanceRate     NUMBER(5,2) DEFAULT 100.00 CHECK (Committee_AttendanceRate BETWEEN 0.00 AND 100.00),
    Committee_MeetingFrequency   VARCHAR2(15) NOT NULL CHECK (Committee_MeetingFrequency IN ('Weekly', 'Bi-Weekly', 'Monthly', 'Quarterly')),
    Voting_Power_Weight          NUMBER(3,2) DEFAULT 1.00 CHECK (Voting_Power_Weight > 0.00),
    Employee_ID                  VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_investment_committee PRIMARY KEY (Committee_ID, Committee_TermSessionCode),
    CONSTRAINT chk_committee_dates CHECK (Committee_EndDate >= Committe_StartDate),
    CONSTRAINT fk_invcom_emp FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID),
    CONSTRAINT uq_committee_id UNIQUE (Committee_ID)
);

CREATE TABLE Inspector (
    Inspector_ID                VARCHAR2(15) NOT NULL,
    DOSH_Registration_No        VARCHAR2(30) NOT NULL,
    Inspector_Specialization    VARCHAR2(50) NOT NULL CHECK (Inspector_Specialization IN ('Structural Safety', 'Mechanical and Electrical', 'Environmental Hazard', 'Fire Protection', 'Civil Construction')),
    Last_Safety_Training_Date   DATE NOT NULL,
    Active_Field_Zone           VARCHAR2(15) NOT NULL CHECK (Active_Field_Zone IN ('Zone A', 'Zone B', 'Zone C', 'Zone D')),
    Inspector_Rating_Score      NUMBER(3,2) CHECK (Inspector_Rating_Score BETWEEN 1.00 AND 5.00),
    Total_Inspection_Completed  NUMBER(4) DEFAULT 0 CHECK (Total_Inspection_Completed >= 0),
    Emergency_Contact_No        VARCHAR2(15) NOT NULL,
    Cert_End_Date               DATE NOT NULL,
    Professional_Cert_No        VARCHAR2(30) NOT NULL,
    Employee_ID                 VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_inspector PRIMARY KEY (Inspector_ID, DOSH_Registration_No),
    CONSTRAINT CHK_Inspector_Dates CHECK (Cert_End_Date > Last_Safety_Training_Date),
    CONSTRAINT fk_insp_emp FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID),
    CONSTRAINT uq_inspector_id UNIQUE (Inspector_ID)
);

CREATE TABLE Job_Application (
    Job_Application_ID          VARCHAR2(15) NOT NULL,
    Job_Application_Timestamp   TIMESTAMP NOT NULL,
    Notice_Period_Day           NUMBER(3) DEFAULT 0 CHECK (Notice_Period_Day >= 0),
    Expected_Salary             NUMBER(10,2) NOT NULL CHECK (Expected_Salary > 0.00),
    Application_Source_Channel  VARCHAR2(30) NOT NULL,
    Screening_Score             NUMBER(5,2) CHECK (Screening_Score BETWEEN 0.00 AND 100.00),
    Interview_Date              DATE,
    Offer_Acceptance_Flag       VARCHAR2(3) CHECK (Offer_Acceptance_Flag IN ('Yes', 'No')),
    Recruitment_Status          VARCHAR2(20) DEFAULT 'Applied' CHECK (Recruitment_Status IN ('Applied', 'Screening', 'Interviewing', 'Offered', 'Rejected', 'Withdrawn')),
    Interviewer_Remark          VARCHAR2(255),
    Applicant_ID                VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_job_application PRIMARY KEY (Job_Application_ID, Job_Application_Timestamp),
    CONSTRAINT fk_jobapp_applicant FOREIGN KEY (Applicant_ID) REFERENCES Job_Applicant(Applicant_ID),
    CONSTRAINT uq_job_app_id UNIQUE (Job_Application_ID)
);

-- =====================================================================
-- LEVEL 3: Depends on Level 2
-- =====================================================================

CREATE TABLE Investor (
    MIDA_Registration_Ref       VARCHAR2(30) NOT NULL,
    Investor_ID                 VARCHAR2(15) NOT NULL,
    Preferred_Investment_Sector VARCHAR2(50) NOT NULL CHECK (Preferred_Investment_Sector IN ('Manufacturing', 'Services', 'Primary', 'Infrastructure', 'Digital Tech')),
    Investor_Type               VARCHAR2(20) NOT NULL CHECK (Investor_Type IN ('Institutional', 'Corporate', 'Venture Capital', 'Angel Investor')),
    Investor_Portfolio_Size     NUMBER(15,2) NOT NULL CHECK (Investor_Portfolio_Size > 0.00),
    Total_Active_Project        NUMBER(3) DEFAULT 0 CHECK (Total_Active_Project >= 0),
    Investor_Risk_Appetite      VARCHAR2(15) NOT NULL CHECK (Investor_Risk_Appetite IN ('Conservative', 'Moderate', 'Aggressive')),
    Investment_Horizon_Year     NUMBER(2) NOT NULL CHECK (Investment_Horizon_Year > 0),
    Syariah_Compliant_Status    VARCHAR2(3) NOT NULL CHECK (Syariah_Compliant_Status IN ('Yes', 'No')),
    Agency_Credit_Rating        VARCHAR2(10) CHECK (Agency_Credit_Rating IN ('AAA', 'AA', 'A', 'BBB', 'BB', 'B', 'CCC', 'C', 'D')),
    Company_ID                  VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_investor PRIMARY KEY (MIDA_Registration_Ref, Investor_ID),
    CONSTRAINT fk_inv_comp FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID),
    CONSTRAINT uq_investor_id UNIQUE (Investor_ID)
);

CREATE TABLE Developer (
    Developer_ID                VARCHAR2(20) NOT NULL,
    CIDB_Registration_No        VARCHAR2(20) NOT NULL,
    Developer_DurationInBusiness VARCHAR2(30) NOT NULL,
    Developer_ProjectDone       NUMBER(3) DEFAULT 0 CHECK (Developer_ProjectDone >= 0),
    Developer_TotalProjectValue NUMBER(15,2) DEFAULT 0.00 CHECK (Developer_TotalProjectValue >= 0.00),
    Developer_Experience_Year   NUMBER(2) NOT NULL CHECK (Developer_Experience_Year >= 0),
    Developer_FinancialStatus   VARCHAR2(15) NOT NULL CHECK (Developer_FinancialStatus IN ('Excellent', 'Good', 'Stable', 'Audited')),
    Developer_NoOfEmployee      NUMBER(4) NOT NULL CHECK (Developer_NoOfEmployee > 0),
    Developer_Expertise         VARCHAR2(100) NOT NULL,
    Developer_Rating            NUMBER(2,1) CHECK (Developer_Rating BETWEEN 1.0 AND 5.0),
    Company_ID                  VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_developer PRIMARY KEY (Developer_ID, CIDB_Registration_No),
    CONSTRAINT fk_dev_comp FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID),
    CONSTRAINT uq_developer_id UNIQUE (Developer_ID)
);

-- =====================================================================
-- LEVEL 4: Depends on Level 3
-- =====================================================================

CREATE TABLE Investment_Application (
    Application_ID VARCHAR2(15) NOT NULL,
    Application_Submission_Date DATE NOT NULL,
    Application_Review_Date DATE,
    Application_CurrentStatus VARCHAR2(50) NOT NULL CHECK (Application_CurrentStatus IN ('Pending', 'Under Review', 'Approved', 'Rejected')),
    Application_Remark VARCHAR2(255),
    Application_ProcessingTime VARCHAR2(30) NOT NULL,
    Application_Fee NUMBER(8,2) NOT NULL,
    Application_Method VARCHAR2(30) NOT NULL CHECK (Application_Method IN ('LinkedIn', 'Company Page', 'Physical Form', 'Official Email', 'Agency Referral')),
    Application_Expiration_Date DATE,
    Application_Description VARCHAR2(255),
    Investor_ID VARCHAR2(20) NOT NULL,
    Rep_ID VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_investment_application PRIMARY KEY (Application_ID, Application_Submission_Date),
    CONSTRAINT chk_application_dates CHECK (Application_Review_Date >= Application_Submission_Date),
    CONSTRAINT fk_invapp_inv FOREIGN KEY (Investor_ID) REFERENCES Investor(Investor_ID),
    CONSTRAINT fk_invapp_rep FOREIGN KEY (Rep_ID) REFERENCES Representative(Rep_ID),
    CONSTRAINT uq_inv_application_id UNIQUE (Application_ID)
);

CREATE TABLE Termination (
    Termination_ID VARCHAR2(15) NOT NULL,
    Termination_Date DATE NOT NULL,
    Termination_Status VARCHAR2(25) NOT NULL CHECK (Termination_Status IN ('Pending', 'Under Legal Review', 'Executed', 'Appealed')),
    Termination_Settlement NUMBER(9,2) DEFAULT 0.00 CHECK (Termination_Settlement >= 0.00),
    Term_AssetHandoverStatus VARCHAR2(20) DEFAULT 'Pending' CHECK (Term_AssetHandoverStatus IN ('Pending', 'In Progress', 'Completed', 'Failed')),
    Termination_ServedDate DATE NOT NULL,
    Termination_SiteSecuredTime DATE,
    Termination_EvictionStatus VARCHAR2(20) CHECK (Termination_EvictionStatus IN ('Not Required', 'Notice Served', 'Evicted', 'Resisting')),
    Term_BreachContractCode VARCHAR2(15) NOT NULL,
    Term_AssetHandoverPeriod INTEGER NOT NULL CHECK (Term_AssetHandoverPeriod BETWEEN 0 AND 90),
    Investor_ID VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_termination PRIMARY KEY (Termination_ID, Termination_Date),
    CONSTRAINT fk_term_inv FOREIGN KEY (Investor_ID) REFERENCES Investor(Investor_ID),
    CONSTRAINT uq_termination_id UNIQUE (Termination_ID)
);

-- =====================================================================
-- LEVEL 5: Proposal_Content (The Superclass)
-- =====================================================================

CREATE TABLE Proposal_Content (
    Proposal_ID VARCHAR2(20) NOT NULL,
    Component_ID VARCHAR2(20) NOT NULL,
    Submission_Date DATE NOT NULL,
    Reviewed_Status VARCHAR2(25) DEFAULT 'Pending' CHECK (Reviewed_Status IN ('Pending', 'Under Review', 'Approved', 'Requires Revision')),
    Expert_Credential VARCHAR2(25) CHECK (Expert_Credential IN ('Verified', 'Pending Verification', 'Not Applicable')),
    Credential_Name VARCHAR2(100),
    Developer_ID VARCHAR2(20) NOT NULL,
    Rep_ID VARCHAR2(15) NOT NULL,
    Screening_MeetingID VARCHAR2(20) NOT NULL,
    Application_ID VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_proposal_content PRIMARY KEY (Proposal_ID, Component_ID),
    CONSTRAINT fk_prop_dev FOREIGN KEY (Developer_ID) REFERENCES Developer(Developer_ID),
    CONSTRAINT fk_prop_rep FOREIGN KEY (Rep_ID) REFERENCES Representative(Rep_ID),
    CONSTRAINT fk_prop_screen FOREIGN KEY (Screening_MeetingID) REFERENCES Proposal_Screening(Screening_MeetingID),
    CONSTRAINT fk_prop_app FOREIGN KEY (Application_ID) REFERENCES Investment_Application(Application_ID),
    CONSTRAINT uq_proposal_id UNIQUE (Proposal_ID)
);

-- =====================================================================
-- LEVEL 6: Depends on Proposal_Content
-- =====================================================================

CREATE TABLE Approval (
    Approval_ID               VARCHAR2(15) NOT NULL,
    Approval_LetterID         VARCHAR2(20) NOT NULL,
    Approval_Date             DATE NOT NULL,
    Approval_Condition        VARCHAR2(255),
    Approval_Status           VARCHAR2(20) DEFAULT 'Pending' CHECK (Approval_Status IN ('Approved', 'Conditional Approval', 'Rejected')),
    Approval_Duration         VARCHAR2(30) NOT NULL,
    Approval_Remark           VARCHAR2(255),
    Approval_ExpiryDate       DATE NOT NULL,
    Appeal_Allowed_Flag       VARCHAR2(3) NOT NULL CHECK (Appeal_Allowed_Flag IN ('Yes', 'No')),
    Approval_Voting_Margin    VARCHAR2(35) NOT NULL,
    Proposal_ID               VARCHAR2(20) NOT NULL,
    Screening_MeetingID       VARCHAR2(20) NOT NULL,
    Company_ID                VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_approval PRIMARY KEY (Approval_ID, Approval_LetterID),
    CONSTRAINT chk_approval_dates CHECK (Approval_ExpiryDate >= Approval_Date),
    CONSTRAINT fk_appr_prop FOREIGN KEY (Proposal_ID) REFERENCES Proposal_Content(Proposal_ID),
    CONSTRAINT fk_appr_screen FOREIGN KEY (Screening_MeetingID) REFERENCES Proposal_Screening(Screening_MeetingID),
    CONSTRAINT fk_appr_comp FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID),
    CONSTRAINT uq_approval_id UNIQUE (Approval_ID)
);

CREATE TABLE Project_Timeline (
    Timeline_MilestoneID VARCHAR2(20) NOT NULL,
    Timeline_ID VARCHAR2(20) NOT NULL,
    Timeline_MilestoneName VARCHAR2(100) NOT NULL,
    Timeline_TargetCompletionDate DATE NOT NULL,
    Timeline_PhaseNo INTEGER NOT NULL CHECK (Timeline_PhaseNo > 0),
    Timeline_DeliverableDesc VARCHAR2(255),
    Timeline_EstimatedDuration INTEGER NOT NULL CHECK (Timeline_EstimatedDuration > 0),
    Timeline_PhaseType VARCHAR2(30) NOT NULL CHECK (Timeline_PhaseType IN ('Initiation', 'Planning', 'Execution', 'Monitoring', 'Closure')),
    Timeline_PhaseName VARCHAR2(50) NOT NULL,
    Timeline_CompletionPercentage NUMBER(5,2) DEFAULT 0.00 CHECK (Timeline_CompletionPercentage BETWEEN 0.00 AND 100.00),
    Proposal_ID VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_project_timeline PRIMARY KEY (Timeline_MilestoneID, Timeline_ID),
    CONSTRAINT fk_projtime_prop FOREIGN KEY (Proposal_ID) REFERENCES Proposal_Content(Proposal_ID),
    CONSTRAINT uq_timeline_milestone_id UNIQUE (Timeline_MilestoneID)
);

CREATE TABLE Infrastructure (
    IS_ID                       VARCHAR2(15) NOT NULL,
    IS_SiteNo                   VARCHAR2(20) NOT NULL,
    IS_RoadAccessSpec           VARCHAR2(30) NOT NULL CHECK (IS_RoadAccessSpec IN ('Single Lane', 'Dual Carriageway', 'Heavy Haul', 'Unpaved')),
    IS_WaterSupplyVolReq        NUMBER(10,2) NOT NULL CHECK (IS_WaterSupplyVolReq >= 0.00),
    IS_ElectricityLoadCapacity  NUMBER(10,2) NOT NULL CHECK (IS_ElectricityLoadCapacity >= 0.00),
    IS_TelecomBandwidthReq      VARCHAR2(25) NOT NULL CHECK (IS_TelecomBandwidthReq IN ('Basic Voice/Data', 'High-Speed Fiber', 'Dedicated Leased Line')),
    IS_MaintenanceResponsibility VARCHAR2(30) NOT NULL CHECK (IS_MaintenanceResponsibility IN ('Labuan Corp', 'Private Developer', 'Joint Sharing')),
    IS_EstimatedInfrastructureCost NUMBER(15,2) DEFAULT 0.00 CHECK (IS_EstimatedInfrastructureCost >= 0.00),
    IS_RoadLoadCapacity_Ton     NUMBER(3) NOT NULL CHECK (IS_RoadLoadCapacity_Ton > 0),
    IS_Heritage_Fusion_Flag     VARCHAR2(3) NOT NULL CHECK (IS_Heritage_Fusion_Flag IN ('Yes', 'No')),
    Proposal_ID                 VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_infrastructure PRIMARY KEY (IS_ID, IS_SiteNo),
    CONSTRAINT fk_infra_prop FOREIGN KEY (Proposal_ID) REFERENCES Proposal_Content(Proposal_ID),
    CONSTRAINT uq_infrastructure_id UNIQUE (IS_ID)
);

CREATE TABLE Digitalisation (
    Digital_ID                 VARCHAR2(15) NOT NULL,
    MDEC_Approval_Ref          VARCHAR2(30) NOT NULL,
    Digital_Smart_Domain       VARCHAR2(100),
    Digital_AutomationLevel    VARCHAR2(15) NOT NULL CHECK (Digital_AutomationLevel IN ('Low', 'Medium', 'High', 'Fully Automated')),
    Digital_AI_Implementation  VARCHAR2(3) NOT NULL CHECK (Digital_AI_Implementation IN ('Yes', 'No')),
    Digital_IOT_Implementation VARCHAR2(3) NOT NULL CHECK (Digital_IOT_Implementation IN ('Yes', 'No')),
    Digital_CloudHostingProvider VARCHAR2(30) NOT NULL CHECK (Digital_CloudHostingProvider IN ('AWS', 'Azure', 'Google Cloud', 'Alibaba Cloud', 'Private Cloud', 'Others')),
    Digital_CyberSec_Status    VARCHAR2(20) DEFAULT 'Pending' CHECK (Digital_CyberSec_Status IN ('Compliant', 'Non-Compliant', 'Pending')),
    Digital_InnovationScore    NUMBER(3) NOT NULL CHECK (Digital_InnovationScore BETWEEN 0 AND 100),
    Digital_IntegrationReadiness VARCHAR2(15) NOT NULL CHECK (Digital_IntegrationReadiness IN ('Ready', 'In Progress', 'Not Ready')),
    Proposal_ID                VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_digitalisation PRIMARY KEY (Digital_ID, MDEC_Approval_Ref),
    CONSTRAINT fk_digi_prop FOREIGN KEY (Proposal_ID) REFERENCES Proposal_Content(Proposal_ID),
    CONSTRAINT uq_digitalisation_id UNIQUE (Digital_ID)
);

CREATE TABLE Business_Plan (
    Plan_ID                    VARCHAR2(15) NOT NULL,
    Project_Title              VARCHAR2(100) NOT NULL,
    Business_Start_Date        DATE NOT NULL,
    Business_End_Date          DATE NOT NULL,
    Business_Model_Description VARCHAR2(255) NOT NULL,
    Business_Domain            VARCHAR2(30) NOT NULL,
    Target_Customer_Demographic VARCHAR2(100) NOT NULL,
    Strategic_Partnership_Status VARCHAR2(15) DEFAULT 'Negotiating' CHECK (Strategic_Partnership_Status IN ('Secured', 'Negotiating', 'None Required')),
    Primary_Revenue_Stream     VARCHAR2(30) NOT NULL CHECK (Primary_Revenue_Stream IN ('Subscription Fees', 'Direct Sales', 'Transaction Commissions', 'Licensing/Royalties')),
    Market_Competition_Level   VARCHAR2(10) NOT NULL CHECK (Market_Competition_Level IN ('Low', 'Moderate', 'High')),
    Proposal_ID                VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_business_plan PRIMARY KEY (Plan_ID, Project_Title),
    CONSTRAINT chk_business_plan_dates CHECK (Business_End_Date > Business_Start_Date),
    CONSTRAINT fk_bizplan_prop FOREIGN KEY (Proposal_ID) REFERENCES Proposal_Content(Proposal_ID),
    CONSTRAINT uq_business_plan_id UNIQUE (Plan_ID)
);

CREATE TABLE Method_Term (
    Method_TermID VARCHAR2(15) NOT NULL,
    Method_Type VARCHAR2(30) NOT NULL CHECK (Method_Type IN ('Lease', 'Joint Venture', 'Revenue Sharing', 'Build-Operate-Transfer (BOT)', 'Concession', 'Others')),
    Method_PaymentFrequency VARCHAR2(15) NOT NULL CHECK (Method_PaymentFrequency IN ('Monthly', 'Quarterly', 'Semi-Annually', 'Annually')),
    Method_GracePeriodMonths NUMBER(2) DEFAULT 0 CHECK (Method_GracePeriodMonths >= 0),
    Method_EscalationRatePercent NUMBER(4,2) DEFAULT 0.00 CHECK (Method_EscalationRatePercent >= 0.00),
    Method_SecurityDepoAmount NUMBER(12,2) NOT NULL CHECK (Method_SecurityDepoAmount >= 0.00),
    Method_CommencementDate DATE NOT NULL,
    Method_TerminationPeriod VARCHAR2(30) NOT NULL,
    Method_RevenueSharePercent NUMBER(4,2) DEFAULT 0.00 CHECK (Method_RevenueSharePercent BETWEEN 0.00 AND 100.00),
    Method_TransferConditionDesc VARCHAR2(255),
    Proposal_ID VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_method_term PRIMARY KEY (Method_TermID, Method_Type),
    CONSTRAINT fk_meth_prop FOREIGN KEY (Proposal_ID) REFERENCES Proposal_Content(Proposal_ID),
    CONSTRAINT uq_method_term_id UNIQUE (Method_TermID)
);

CREATE TABLE Impact (
    Assessment_ID          VARCHAR2(15) NOT NULL,
    Impact_Assessment_Date DATE NOT NULL,
    Impact_Level           VARCHAR2(15) NOT NULL CHECK (Impact_Level IN ('Low', 'Moderate', 'High', 'Severe')),
    Overall_Impact_Status  VARCHAR2(20) DEFAULT 'Pending' CHECK (Overall_Impact_Status IN ('Pass', 'Fail', 'Conditional', 'Pending')),
    Next_Review_Deadline   DATE NOT NULL,
    Internal_Remark        VARCHAR2(255),
    Result_Flag            VARCHAR2(3) NOT NULL CHECK (Result_Flag IN ('Yes', 'No')),
    Proposal_ID            VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_impact PRIMARY KEY (Assessment_ID, Impact_Assessment_Date),
    CONSTRAINT chk_impact_dates CHECK (Next_Review_Deadline > Impact_Assessment_Date),
    CONSTRAINT fk_imp_prop FOREIGN KEY (Proposal_ID) REFERENCES Proposal_Content(Proposal_ID),
    CONSTRAINT uq_impact_assessment_id UNIQUE (Assessment_ID)
);

CREATE TABLE Investment_Viability (
    Investment_ViabilityID      VARCHAR2(15) NOT NULL,
    Investment_RevisionNo       NUMBER(2) NOT NULL,
    Investment_Value            NUMBER(15,2) NOT NULL CHECK (Investment_Value > 0.00),
    Investment_Revenue          NUMBER(15,2) DEFAULT 0.00 CHECK (Investment_Revenue >= 0.00),
    Investment_Profit           NUMBER(15,2) DEFAULT 0.00,
    Investment_ROI              NUMBER(5,2) NOT NULL,
    Investment_Source           VARCHAR2(30) NOT NULL CHECK (Investment_Source IN ('Private Capital', 'Foreign Direct Investment', 'Government Grant', 'Joint Venture')),
    Investment_RiskLevel        VARCHAR2(15) NOT NULL CHECK (Investment_RiskLevel IN ('Low', 'Moderate', 'High', 'Speculative')),
    Investment_Capital          NUMBER(15,2) NOT NULL CHECK (Investment_Capital > 0.00),
    Investment_CAPEX            NUMBER(15,2) NOT NULL CHECK (Investment_CAPEX >= 0.00),
    Investment_OPEX             NUMBER(15,2) NOT NULL CHECK (Investment_OPEX >= 0.00),
    Investment_Type             VARCHAR2(30) NOT NULL CHECK (Investment_Type IN ('Infrastructure', 'Commercial Lease', 'Industrial Hub', 'Digital Tech Upgrade')),
    Investment_ViabilityScore   NUMBER(3) NOT NULL CHECK (Investment_ViabilityScore BETWEEN 0 AND 100),
    Investment_FinancingStrategy VARCHAR2(50) NOT NULL,
    Investment_CompletionValue   NUMBER(15,2) DEFAULT 0.00 CHECK (Investment_CompletionValue >= 0.00),
    Proposed_Lease_Period       VARCHAR2(30) NOT NULL,
    Proposed_Lease_Payment      NUMBER(12,2) DEFAULT 0.00 CHECK (Proposed_Lease_Payment >= 0.00),
    Proposal_ID                 VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_investment_viability PRIMARY KEY (Investment_ViabilityID, Investment_RevisionNo),
    CONSTRAINT fk_invvia_prop FOREIGN KEY (Proposal_ID) REFERENCES Proposal_Content(Proposal_ID),
    CONSTRAINT uq_inv_viability_id UNIQUE (Investment_ViabilityID)
);

-- =====================================================================
-- LEVEL 7: Depends on Level 6
-- =====================================================================

CREATE TABLE Agreement (
    Agreement_ID VARCHAR2(15) NOT NULL,
    Agreement_StampDutyID VARCHAR2(20) NOT NULL,
    Agreement_Date DATE NOT NULL,
    Agreement_Status VARCHAR2(20) DEFAULT 'Draft' CHECK (Agreement_Status IN ('Draft', 'Active', 'Expired', 'Terminated')),
    Agreement_Venue VARCHAR2(100) NOT NULL,
    Agreement_Title VARCHAR2(100) NOT NULL,
    Agreement_Description VARCHAR2(255),
    Agreement_EffectiveDate DATE NOT NULL,
    Agreement_GoverningLaw VARCHAR2(30) DEFAULT 'Laws of Malaysia' NOT NULL,
    Agreement_StampDutyReceipt VARCHAR2(30) NOT NULL,
    Proposal_ID VARCHAR2(20) NOT NULL,
    Department_ID VARCHAR2(15) NOT NULL,
    Approval_ID VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_agreement PRIMARY KEY (Agreement_ID, Agreement_StampDutyID),
    CONSTRAINT chk_agreement_dates CHECK (Agreement_EffectiveDate >= Agreement_Date),
    CONSTRAINT fk_agr_prop FOREIGN KEY (Proposal_ID) REFERENCES Proposal_Content(Proposal_ID),
    CONSTRAINT fk_agr_dept FOREIGN KEY (Department_ID) REFERENCES Invest_Labuan(Department_ID),
    CONSTRAINT fk_agr_appr FOREIGN KEY (Approval_ID) REFERENCES Approval(Approval_ID),
    CONSTRAINT uq_agreement_id UNIQUE (Agreement_ID)
);

CREATE TABLE Social (
    Social_ID VARCHAR2(10) NOT NULL,
    Community_Consultation_Ref VARCHAR2(30) NOT NULL,
    Social_Score NUMBER(3) NOT NULL CHECK (Social_Score BETWEEN 0 AND 100),
    Community_Impact_Score NUMBER(3) NOT NULL CHECK (Community_Impact_Score BETWEEN 0 AND 100),
    Social_Benefit_Description VARCHAR2(255),
    Urbanisation_Level VARCHAR2(20) NOT NULL CHECK (Urbanisation_Level IN ('Rural', 'Suburban', 'Urban', 'Highly Urbanized')),
    Local_Vendor_Engagement_Target NUMBER(5,2) DEFAULT 0.00 CHECK (Local_Vendor_Engagement_Target BETWEEN 0.00 AND 100.00),
    Social_Compliance_Status VARCHAR2(20) DEFAULT 'Pending' CHECK (Social_Compliance_Status IN ('Compliant', 'Non-Compliant', 'Pending')),
    Public_Safety_Rating NUMBER(2,1) CHECK (Public_Safety_Rating BETWEEN 1.0 AND 5.0),
    Traffic_Congest_Impact_Rating VARCHAR2(10) NOT NULL CHECK (Traffic_Congest_Impact_Rating IN ('Low', 'Medium', 'High')),
    Assessment_ID VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_social PRIMARY KEY (Social_ID, Community_Consultation_Ref),
    CONSTRAINT fk_soc_ass FOREIGN KEY (Assessment_ID) REFERENCES Impact(Assessment_ID),
    CONSTRAINT uq_social_id UNIQUE (Social_ID)
);

CREATE TABLE Economic (
    Economic_ID              VARCHAR2(10) NOT NULL,
    MOF_Tracking_Code        VARCHAR2(30) NOT NULL,
    Economic_Impact_Score    NUMBER(3) NOT NULL CHECK (Economic_Impact_Score BETWEEN 0 AND 100),
    Job_Creation_Multiplier  NUMBER(3,1) NOT NULL CHECK (Job_Creation_Multiplier >= 1.0),
    Export_Potential_Value   NUMBER(15,2) DEFAULT 0.00 CHECK (Export_Potential_Value >= 0.00),
    Regional_Impact_Level    VARCHAR2(15) NOT NULL CHECK (Regional_Impact_Level IN ('Local', 'State', 'National', 'Regional')),
    Local_Supply_Chain       VARCHAR2(3) NOT NULL CHECK (Local_Supply_Chain IN ('Yes', 'No')),
    Tax_Revenue_Estimation   NUMBER(15,2) DEFAULT 0.00 CHECK (Tax_Revenue_Estimation >= 0.00),
    Trade_Contribution_Score NUMBER(3) NOT NULL CHECK (Trade_Contribution_Score BETWEEN 0 AND 100),
    Economic_Priority_Rank   VARCHAR2(15) NOT NULL CHECK (Economic_Priority_Rank IN ('Low', 'Medium', 'High', 'Critical')),
    Assessment_ID            VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_economic PRIMARY KEY (Economic_ID, MOF_Tracking_Code),
    CONSTRAINT fk_eco_ass FOREIGN KEY (Assessment_ID) REFERENCES Impact(Assessment_ID),
    CONSTRAINT uq_economic_id UNIQUE (Economic_ID)
);

CREATE TABLE Environmental (
    Environmental_ID              VARCHAR2(10) NOT NULL,
    DOE_Reference_Number          VARCHAR2(30) NOT NULL,
    Carbon_Emission_Target        NUMBER(5,2) NOT NULL CHECK (Carbon_Emission_Target >= 0.00),
    Renewable_Energy_Ratio        NUMBER(5,2) DEFAULT 0.00 CHECK (Renewable_Energy_Ratio BETWEEN 0.00 AND 100.00),
    Environment_Score             NUMBER(3) NOT NULL CHECK (Environment_Score BETWEEN 0 AND 100),
    Environmental_Risk_Level      VARCHAR2(15) NOT NULL CHECK (Environmental_Risk_Level IN ('Low', 'Medium', 'High', 'Critical')),
    Waste_Reduction_Plan_Summary  VARCHAR2(255),
    Energy_Efficiency_Level       VARCHAR2(10) NOT NULL CHECK (Energy_Efficiency_Level IN ('1-Star', '2-Star', '3-Star', '4-Star', '5-Star')),
    Eco_Tourism_Potential_Flag    VARCHAR2(3) NOT NULL CHECK (Eco_Tourism_Potential_Flag IN ('Yes', 'No')),
    Environ_Compliance_Status     VARCHAR2(20) DEFAULT 'Pending' CHECK (Environ_Compliance_Status IN ('Compliant', 'Non-Compliant', 'Pending')),
    Assessment_ID                 VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_environmental PRIMARY KEY (Environmental_ID, DOE_Reference_Number),
    CONSTRAINT fk_env_ass FOREIGN KEY (Assessment_ID) REFERENCES Impact(Assessment_ID),
    CONSTRAINT uq_environmental_id UNIQUE (Environmental_ID)
);

-- =====================================================================
-- LEVEL 8: Depends on Level 7
-- =====================================================================

CREATE TABLE Land (
    Land_ID                     VARCHAR2(15) NOT NULL,
    Land_Master_Survey_Plan_No  VARCHAR2(30) NOT NULL,
    Land_Title                  VARCHAR2(50) NOT NULL,
    Land_Size                   NUMBER(10,2) NOT NULL CHECK (Land_Size > 0.00),
    Land_TotalLot               NUMBER(4) NOT NULL CHECK (Land_TotalLot > 0),
    Land_Status                 VARCHAR2(20) DEFAULT 'Available' CHECK (Land_Status IN ('Available', 'Reserved', 'Leased', 'Disputed')),
    Land_Loc                    VARCHAR2(100) NOT NULL,
    Land_Type                   VARCHAR2(20) NOT NULL CHECK (Land_Type IN ('Bare Land', 'Forested', 'Hilly/Sloped', 'Swampland')),
    Land_Zoning_Type            VARCHAR2(20) NOT NULL CHECK (Land_Zoning_Type IN ('Residential', 'Commercial', 'Industrial', 'Agricultural', 'Special Economic')),
    Land_OwnershipType          VARCHAR2(15) NOT NULL CHECK (Land_OwnershipType IN ('Freehold', 'Leasehold', 'State-Owned')),
    Land_Encumbrances_Ref_No    VARCHAR2(30),
    CONSTRAINT pk_land PRIMARY KEY (Land_ID, Land_Master_Survey_Plan_No),
    CONSTRAINT uq_land_id UNIQUE (Land_ID)
);

CREATE TABLE Quality_Record (
    Inspection_ID VARCHAR2(15) NOT NULL,
    Inspection_Date DATE NOT NULL,
    Inspection_Finding VARCHAR2(50) NOT NULL,
    Inspection_Phase VARCHAR2(30) NOT NULL CHECK (Inspection_Phase IN ('Foundation', 'Structural', 'M and E', 'Finishing', 'Final Handover')),
    Inspection_Result VARCHAR2(20) NOT NULL CHECK (Inspection_Result IN ('Pass', 'Fail', 'Conditional Pass')),
    Inspection_CompletionPercent NUMBER(5,2) DEFAULT 0.00 CHECK (Inspection_CompletionPercent BETWEEN 0.00 AND 100.00),
    Inspection_RiskAssesment VARCHAR2(15) NOT NULL CHECK (Inspection_RiskAssesment IN ('Low', 'Medium', 'High', 'Critical')),
    Inspection_DefectCount INTEGER DEFAULT 0 CHECK (Inspection_DefectCount >= 0),
    Inspection_DefectDesc VARCHAR2(255),
    Inspect_Remedial_Action_Req VARCHAR2(3) NOT NULL CHECK (Inspect_Remedial_Action_Req IN ('Yes', 'No')),
    Investor_ID VARCHAR2(15) NOT NULL,
    Timeline_ID VARCHAR2(20) NOT NULL,
    IS_ID VARCHAR2(15) NOT NULL,
    Digital_ID VARCHAR2(15) NOT NULL,
    Agreement_ID VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_quality_record PRIMARY KEY (Inspection_ID, Inspection_Date),
    CONSTRAINT fk_qual_inv FOREIGN KEY (Investor_ID) REFERENCES Investor(Investor_ID),
    CONSTRAINT fk_qual_time FOREIGN KEY (Timeline_ID) REFERENCES Project_Timeline(Timeline_MilestoneID),
    CONSTRAINT fk_qual_infra FOREIGN KEY (IS_ID) REFERENCES Infrastructure(IS_ID),
    CONSTRAINT fk_qual_digi FOREIGN KEY (Digital_ID) REFERENCES Digitalisation(Digital_ID),
    CONSTRAINT fk_qual_agr FOREIGN KEY (Agreement_ID) REFERENCES Agreement(Agreement_ID),
    CONSTRAINT uq_inspection_id UNIQUE (Inspection_ID)
);

-- =====================================================================
-- LEVEL 9: Depends on Level 8
-- =====================================================================

CREATE TABLE Lot (
    Lot_ID VARCHAR2(15) NOT NULL,
    Lot_TitleNo VARCHAR2(30) NOT NULL,
    Lot_Name VARCHAR2(50) NOT NULL,
    Lot_EnroachmentFlag VARCHAR2(3) NOT NULL CHECK (Lot_EnroachmentFlag IN ('Yes', 'No')),
    Lot_Status VARCHAR2(20) DEFAULT 'Vacant' CHECK (Lot_Status IN ('Vacant', 'Developed', 'Under Construction', 'On Hold')),
    Lot_OwnershipType VARCHAR2(15) NOT NULL CHECK (Lot_OwnershipType IN ('Freehold', 'Leasehold', 'State Land')),
    Lot_Size NUMBER(10,2) NOT NULL CHECK (Lot_Size > 0.00),
    Lot_Price_Per_SqFt NUMBER(10,2) NOT NULL CHECK (Lot_Price_Per_SqFt > 0),
    Lot_VertexCount NUMBER(4) NOT NULL CHECK (Lot_VertexCount >= 3),
    Lot_SlopeDegree NUMBER(4,2) NOT NULL CHECK (Lot_SlopeDegree BETWEEN 0.00 AND 90.00),
    Land_ID VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_lot PRIMARY KEY (Lot_ID, Lot_TitleNo),
    CONSTRAINT fk_lot_land FOREIGN KEY (Land_ID) REFERENCES Land(Land_ID),
    CONSTRAINT uq_lot_id UNIQUE (Lot_ID)
);

CREATE TABLE Penalty (
    Penalty_ID VARCHAR2(15) NOT NULL,
    Penalty_IssueDate DATE NOT NULL,
    Penalty_Type VARCHAR2(30) NOT NULL CHECK (Penalty_Type IN ('Late Delivery', 'HSE Violation', 'Environmental Breach', 'Non-Compliance', 'Contract Abandonment')),
    Penalty_AmountApplied NUMBER(12,2) DEFAULT 0.00 CHECK (Penalty_AmountApplied >= 0.00),
    Penalty_ReasonDesc VARCHAR2(255),
    Penalty_SettlementStatus VARCHAR2(20) DEFAULT 'Pending' CHECK (Penalty_SettlementStatus IN ('Pending', 'Paid', 'Appealed', 'Overdue')),
    Penalty_PaymentDue DATE NOT NULL,
    Penalty_LegalReferenceCode VARCHAR2(20) NOT NULL,
    Penalty_Result VARCHAR2(25) NOT NULL CHECK (Penalty_Result IN ('Warning', 'Fine Imposed', 'Suspension', 'Contract Terminated')),
    Penalty_InterestRate NUMBER(4,2) DEFAULT 0.00 CHECK (Penalty_InterestRate BETWEEN 0.00 AND 15.00),
    Investor_ID VARCHAR2(15) NOT NULL,
    Inspection_ID VARCHAR2(15) NOT NULL,
    Termination_ID VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_penalty PRIMARY KEY (Penalty_ID, Penalty_IssueDate),
    CONSTRAINT fk_pen_inv FOREIGN KEY (Investor_ID) REFERENCES Investor(Investor_ID),
    CONSTRAINT fk_pen_insp FOREIGN KEY (Inspection_ID) REFERENCES Quality_Record(Inspection_ID),
    CONSTRAINT fk_pen_term FOREIGN KEY (Termination_ID) REFERENCES Termination(Termination_ID),
    CONSTRAINT uq_penalty_id UNIQUE (Penalty_ID)
);

CREATE TABLE Sustainability_Score (
    ESG_ID VARCHAR2(15) NOT NULL,
    Revision_Date DATE NOT NULL,
    ESG_EnvironmentScore INTEGER NOT NULL CHECK (ESG_EnvironmentScore BETWEEN 0 AND 100),
    ESG_SocialScore INTEGER NOT NULL CHECK (ESG_SocialScore BETWEEN 0 AND 100),
    ESG_GovernanceScore INTEGER NOT NULL CHECK (ESG_GovernanceScore BETWEEN 0 AND 100),
    ESG_CarbonEmissionLevel VARCHAR2(15) NOT NULL CHECK (ESG_CarbonEmissionLevel IN ('Low', 'Medium', 'High', 'Critical')),
    ESG_ResourceManagement VARCHAR2(20) NOT NULL CHECK (ESG_ResourceManagement IN ('Optimized', 'Standard', 'Poor', 'Critical')),
    ESG_ComplianceFlag VARCHAR2(3) NOT NULL CHECK (ESG_ComplianceFlag IN ('Yes', 'No')),
    ESG_EnergyEfficiencyLevel VARCHAR2(15) NOT NULL CHECK (ESG_EnergyEfficiencyLevel IN ('Excellent', 'Good', 'Average', 'Poor')),
    ESG_ComplianceStatus VARCHAR2(20) DEFAULT 'Pending' CHECK (ESG_ComplianceStatus IN ('Compliant', 'Non-Compliant', 'Pending')),
    ESG_SustainabilityRating NUMBER(3,1) NOT NULL CHECK (ESG_SustainabilityRating BETWEEN 1.0 AND 5.0),
    Inspection_ID VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_sustainability_score PRIMARY KEY (ESG_ID, Revision_Date),
    CONSTRAINT fk_sust_insp FOREIGN KEY (Inspection_ID) REFERENCES Quality_Record(Inspection_ID),
    CONSTRAINT uq_esg_id UNIQUE (ESG_ID)
);

-- =====================================================================
-- LEVEL 10: Most Dependent Tables
-- =====================================================================

CREATE TABLE Payment (
    Payment_ID VARCHAR2(15) NOT NULL,
    Payment_TransactionID VARCHAR2(50) NOT NULL,
    Payment_ReceiptNo VARCHAR2(30) NOT NULL UNIQUE,
    Payment_BankName VARCHAR2(50) NOT NULL,
    Payment_AccountNo VARCHAR2(20) NOT NULL,
    Payment_Date DATE NOT NULL,
    Payment_Amount NUMBER(12,2) NOT NULL CHECK (Payment_Amount > 0.00),
    Payment_TransactionDate DATE NOT NULL,
    Payment_Method VARCHAR2(20) NOT NULL,
    Payment_VerifiedBy VARCHAR2(50),
    Payment_VerifiedDate DATE,
    Investor_ID VARCHAR2(15) NOT NULL,
    Employee_ID VARCHAR2(15) NOT NULL,
    Agreement_ID VARCHAR2(15) NOT NULL,
    Penalty_ID VARCHAR2(15) NOT NULL,
    Application_ID VARCHAR2(15) NOT NULL,
    Department_ID VARCHAR2(15) NOT NULL,
    CHECK (Payment_VerifiedDate >= Payment_Date),
    CONSTRAINT pk_payment PRIMARY KEY (Payment_ID, Payment_TransactionID),
    CONSTRAINT fk_pay_inv FOREIGN KEY (Investor_ID) REFERENCES Investor(Investor_ID),
    CONSTRAINT fk_pay_emp FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID),
    CONSTRAINT fk_pay_agr FOREIGN KEY (Agreement_ID) REFERENCES Agreement(Agreement_ID),
    CONSTRAINT fk_pay_pen FOREIGN KEY (Penalty_ID) REFERENCES Penalty(Penalty_ID),
    CONSTRAINT fk_pay_app FOREIGN KEY (Application_ID) REFERENCES Investment_Application(Application_ID),
    CONSTRAINT fk_pay_dept FOREIGN KEY (Department_ID) REFERENCES Invest_Labuan(Department_ID),
    CONSTRAINT uq_payment_id UNIQUE (Payment_ID)
);

CREATE TABLE Document (
    Doc_ID                     VARCHAR2(15) NOT NULL,
    Folder_ID                  VARCHAR2(15) NOT NULL,
    Doc_Type                   VARCHAR2(15) NOT NULL CHECK (Doc_Type IN ('PDF', 'DOCX', 'XLSX', 'PNG', 'JPG', 'ZIP', 'Others')),
    File_Name                  VARCHAR2(100) NOT NULL,
    Storage_Directory_Path     VARCHAR2(255) NOT NULL,
    File_Size                  NUMBER(5,2) NOT NULL CHECK (File_Size > 0.00),
    Doc_Status                 VARCHAR2(20) DEFAULT 'Pending' CHECK (Doc_Status IN ('Pending', 'Verified', 'Rejected')),
    Doc_VerificationDate       DATE,
    Doc_Remark                 VARCHAR2(255),
    Doc_VerifiedBy             VARCHAR2(100),
    Doc_FolderName             VARCHAR2(50) NOT NULL,
    Lot_ID                     VARCHAR2(15) NOT NULL,
    Land_ID                    VARCHAR2(15) NOT NULL,
    Proposal_ID                VARCHAR2(20) NOT NULL,
    Screening_MeetingID        VARCHAR2(20) NOT NULL,
    Termination_ID             VARCHAR2(15) NOT NULL,
    Agreement_ID               VARCHAR2(15) NOT NULL,
    Approval_ID                VARCHAR2(15) NOT NULL,
    Penalty_ID                 VARCHAR2(15) NOT NULL,
    Inspection_ID              VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_document PRIMARY KEY (Doc_ID, Folder_ID),
    CONSTRAINT fk_doc_lot FOREIGN KEY (Lot_ID) REFERENCES Lot(Lot_ID),
    CONSTRAINT fk_doc_land FOREIGN KEY (Land_ID) REFERENCES Land(Land_ID),
    CONSTRAINT fk_doc_prop FOREIGN KEY (Proposal_ID) REFERENCES Proposal_Content(Proposal_ID),
    CONSTRAINT fk_doc_screen FOREIGN KEY (Screening_MeetingID) REFERENCES Proposal_Screening(Screening_MeetingID),
    CONSTRAINT fk_doc_term FOREIGN KEY (Termination_ID) REFERENCES Termination(Termination_ID),
    CONSTRAINT fk_doc_agr FOREIGN KEY (Agreement_ID) REFERENCES Agreement(Agreement_ID),
    CONSTRAINT fk_doc_appr FOREIGN KEY (Approval_ID) REFERENCES Approval(Approval_ID),
    CONSTRAINT fk_doc_pen FOREIGN KEY (Penalty_ID) REFERENCES Penalty(Penalty_ID),
    CONSTRAINT fk_doc_insp FOREIGN KEY (Inspection_ID) REFERENCES Quality_Record(Inspection_ID),
    CONSTRAINT uq_document_id UNIQUE (Doc_ID)
);

CREATE TABLE Investor_Advertisement (
    Investor_ID VARCHAR2(15) NOT NULL,
    MIDA_Registration_Ref VARCHAR2(30) NOT NULL,
    Advertisement_ID VARCHAR2(15) NOT NULL,
    Advertisement_StartDate DATE NOT NULL,
    
    -- Primary Key Constraint (Composite Key)
    CONSTRAINT pk_investor_adv PRIMARY KEY (Advertisement_ID, Advertisement_StartDate, Investor_ID, MIDA_Registration_Ref),
    
    -- Foreign Key Constraints
    CONSTRAINT fk_adv_advertisement FOREIGN KEY (Advertisement_ID, Advertisement_StartDate) REFERENCES Advertisement(Advertisement_ID, Advertisement_StartDate),
    CONSTRAINT fk_adv_investor FOREIGN KEY (Investor_ID, MIDA_Registration_Ref) REFERENCES Investor(Investor_ID, MIDA_Registration_Ref)
);

CREATE TABLE Employee_Advertisement (
    Employee_ID VARCHAR2(15) NOT NULL,
    Employee_Contract_No VARCHAR2(30) NOT NULL,
    Advertisement_ID VARCHAR2(15) NOT NULL,
    Advertisement_StartDate DATE NOT NULL,
    
    -- Primary Key Constraint (Composite Key)
    CONSTRAINT pk_emp_adv PRIMARY KEY (Employee_ID, Employee_Contract_No, Advertisement_ID, Advertisement_StartDate),
    
    -- Foreign Key Constraints
    CONSTRAINT fk_emp_adv_advertisement FOREIGN KEY (Advertisement_ID, Advertisement_StartDate) REFERENCES Advertisement(Advertisement_ID, Advertisement_StartDate),
    CONSTRAINT fk_emp_adv_employee FOREIGN KEY (Employee_ID, Employee_Contract_No) REFERENCES Employee(Employee_ID, Employee_Contract_No)
);

CREATE TABLE Employee_JobDescription (
    Employee_ID VARCHAR2(15) NOT NULL,
    Employee_Contract_No VARCHAR2(30) NOT NULL,
    Job_ID VARCHAR2(15) NOT NULL,
    Job_PublishDate DATE NOT NULL,
    
    -- Primary Key Constraint (Composite Key)
    CONSTRAINT pk_emp_jobdesc PRIMARY KEY (Employee_ID, Employee_Contract_No, Job_ID, Job_PublishDate),
    
    -- Foreign Key Constraints
    CONSTRAINT fk_ejd_employee FOREIGN KEY (Employee_ID, Employee_Contract_No) REFERENCES Employee(Employee_ID, Employee_Contract_No),
    CONSTRAINT fk_ejd_job FOREIGN KEY (Job_ID, Job_PublishDate) REFERENCES Job_Description(Job_ID, Job_PublishDate)
);

CREATE TABLE Employee_Agreement (
    Employee_ID VARCHAR2(15) NOT NULL,
    Employee_Contract_No VARCHAR2(30) NOT NULL,
    Agreement_ID VARCHAR2(15) NOT NULL,
    Agreement_StampDutyID VARCHAR2(30) NOT NULL,
    
    -- Primary Key Constraint (Composite Key)
    CONSTRAINT pk_emp_agreement PRIMARY KEY (Employee_ID, Employee_Contract_No, Agreement_ID, Agreement_StampDutyID),
    
    -- Foreign Key Constraints
    CONSTRAINT fk_ea_employee FOREIGN KEY (Employee_ID, Employee_Contract_No) REFERENCES Employee(Employee_ID, Employee_Contract_No),
    CONSTRAINT fk_ea_agreement FOREIGN KEY (Agreement_ID, Agreement_StampDutyID) REFERENCES Agreement(Agreement_ID, Agreement_StampDutyID)
);

CREATE TABLE Person_Document (
    Person_ID VARCHAR2(15) NOT NULL,
    Person_IC VARCHAR2(20) NOT NULL,
    Doc_ID VARCHAR2(15) NOT NULL,
    Folder_ID VARCHAR2(15) NOT NULL,
    
    -- Primary Key Constraint (Composite Key)
    CONSTRAINT pk_per_document PRIMARY KEY (Person_ID, Person_IC, Doc_ID, Folder_ID),
    
    -- Foreign Key Constraints
    CONSTRAINT fk_pd_person FOREIGN KEY (Person_ID, Person_IC) REFERENCES Person(Person_ID, Person_IC),
    CONSTRAINT fk_pd_document FOREIGN KEY (Doc_ID, Folder_ID) REFERENCES Document(Doc_ID, Folder_ID)
);

CREATE TABLE Employee_Penalty (
    Employee_ID VARCHAR2(15) NOT NULL,
    Employee_Contract_No VARCHAR2(30) NOT NULL,
    Penalty_ID VARCHAR2(15) NOT NULL,
    Penalty_IssueDate DATE NOT NULL,
    
    -- Primary Key Constraint (Composite Key)
    CONSTRAINT pk_emp_penalty PRIMARY KEY (Employee_ID, Employee_Contract_No, Penalty_ID, Penalty_IssueDate),
    
    -- Foreign Key Constraints
    CONSTRAINT fk_ep_employee FOREIGN KEY (Employee_ID, Employee_Contract_No) REFERENCES Employee(Employee_ID, Employee_Contract_No),
    CONSTRAINT fk_ep_penalty FOREIGN KEY (Penalty_ID, Penalty_IssueDate) REFERENCES Penalty(Penalty_ID, Penalty_IssueDate)
);

CREATE TABLE Employee_Termination (
    Employee_ID VARCHAR2(15) NOT NULL,
    Employee_Contract_No VARCHAR2(30) NOT NULL,
    Termination_ID VARCHAR2(15) NOT NULL,
    Termination_Date DATE NOT NULL,
    
    -- Primary Key Constraint (Composite Key)
    CONSTRAINT pk_emp_termination PRIMARY KEY (Employee_ID, Employee_Contract_No, Termination_ID, Termination_Date),
    
    -- Foreign Key Constraints
    CONSTRAINT fk_et_employee FOREIGN KEY (Employee_ID, Employee_Contract_No) REFERENCES Employee(Employee_ID, Employee_Contract_No),
    CONSTRAINT fk_et_termination FOREIGN KEY (Termination_ID, Termination_Date) REFERENCES Termination(Termination_ID, Termination_Date)
);

CREATE TABLE Employee_JobApplication (
    Employee_ID VARCHAR2(15) NOT NULL,
    Employee_Contract_No VARCHAR2(30) NOT NULL,
    Job_Application_ID VARCHAR2(15) NOT NULL,
    Job_Application_TimeStamp TIMESTAMP NOT NULL,
    
    -- Primary Key Constraint (Composite Key)
    CONSTRAINT pk_emp_jobapp PRIMARY KEY (Employee_ID, Employee_Contract_No, Job_Application_ID, Job_Application_TimeStamp),
    
    -- Foreign Key Constraints
    CONSTRAINT fk_eja_employee FOREIGN KEY (Employee_ID, Employee_Contract_No) REFERENCES Employee(Employee_ID, Employee_Contract_No),
    CONSTRAINT fk_eja_application FOREIGN KEY (Job_Application_ID, Job_Application_TimeStamp) REFERENCES Job_Application(Job_Application_ID, Job_Application_TimeStamp)
);

CREATE TABLE Inspector_Land (
    Inspector_ID VARCHAR2(15) NOT NULL,
    DOSH_Registration_No VARCHAR2(30) NOT NULL,
    Land_ID VARCHAR2(15) NOT NULL,
    Land_Master_Survey_Plan_No VARCHAR2(30) NOT NULL,
    
    -- Primary Key Constraint (Composite Key)
    CONSTRAINT pk_inspector_land PRIMARY KEY (Inspector_ID, DOSH_Registration_No, Land_ID, Land_Master_Survey_Plan_No),
    
    -- Foreign Key Constraints
    CONSTRAINT fk_il_inspector FOREIGN KEY (Inspector_ID, DOSH_Registration_No) REFERENCES Inspector(Inspector_ID, DOSH_Registration_No),
    CONSTRAINT fk_il_land FOREIGN KEY (Land_ID, Land_Master_Survey_Plan_No) REFERENCES Land(Land_ID, Land_Master_Survey_Plan_No)
);

CREATE TABLE Inspector_Lot (
    Inspector_ID VARCHAR2(15) NOT NULL,
    DOSH_Registration_No VARCHAR2(30) NOT NULL,
    Lot_ID VARCHAR2(15) NOT NULL,
    Lot_TitleNo VARCHAR2(30) NOT NULL,
    
    -- Primary Key Constraint (Composite Key)
    CONSTRAINT pk_inspector_lot PRIMARY KEY (Inspector_ID, DOSH_Registration_No, Lot_ID, Lot_TitleNo),
    
    -- Foreign Key Constraints
    CONSTRAINT fk_ilot_inspector FOREIGN KEY (Inspector_ID, DOSH_Registration_No) REFERENCES Inspector(Inspector_ID, DOSH_Registration_No),
    CONSTRAINT fk_ilot_lot FOREIGN KEY (Lot_ID, Lot_TitleNo) REFERENCES Lot(Lot_ID, Lot_TitleNo)
);

-- 11. InvestmentCommittee_ProposalScreening
CREATE TABLE InvestmentCommittee_Screening (
    Committee_ID VARCHAR2(15) NOT NULL,
    Committee_TermSessionCode VARCHAR2(20) NOT NULL,
    Screening_MeetingID VARCHAR2(20) NOT NULL,
    Screening_MOM_ID VARCHAR2(25) NOT NULL,
    
    CONSTRAINT pk_ic_propscreen PRIMARY KEY (Committee_ID, Committee_TermSessionCode, Screening_MeetingID, Screening_MOM_ID),
    CONSTRAINT fk_icps_committee FOREIGN KEY (Committee_ID, Committee_TermSessionCode) REFERENCES Investment_Committee(Committee_ID, Committee_TermSessionCode),
    CONSTRAINT fk_icps_screening FOREIGN KEY (Screening_MeetingID, Screening_MOM_ID) REFERENCES Proposal_Screening(Screening_MeetingID, Screening_MOM_ID)
);

-- 12. InvestmentCommittee_Approval
CREATE TABLE InvestmentCommittee_Approval (
    Committee_ID VARCHAR2(15) NOT NULL,
    Committee_TermSessionCode VARCHAR2(20) NOT NULL,
    Approval_ID VARCHAR2(15) NOT NULL,
    Approval_LetterID VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_ic_approval PRIMARY KEY (Committee_ID, Committee_TermSessionCode, Approval_ID, Approval_LetterID),
    CONSTRAINT fk_icapp_committee FOREIGN KEY (Committee_ID, Committee_TermSessionCode) REFERENCES Investment_Committee(Committee_ID, Committee_TermSessionCode),
    CONSTRAINT fk_icapp_approval FOREIGN KEY (Approval_ID, Approval_LetterID) REFERENCES Approval(Approval_ID, Approval_LetterID)
);

-- 13. InvestmentCommittee_ProposalContent
CREATE TABLE InvestmentCommittee_Proposal (
    Committee_ID VARCHAR2(15) NOT NULL,
    Committee_TermSessionCode VARCHAR2(20) NOT NULL,
    Proposal_ID VARCHAR2(20) NOT NULL,
    Component_ID VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_ic_propcontent PRIMARY KEY (Committee_ID, Committee_TermSessionCode, Proposal_ID, Component_ID),
    CONSTRAINT fk_icpc_committee FOREIGN KEY (Committee_ID, Committee_TermSessionCode) REFERENCES Investment_Committee(Committee_ID, Committee_TermSessionCode),
    CONSTRAINT fk_icpc_proposal FOREIGN KEY (Proposal_ID, Component_ID) REFERENCES Proposal_Content(Proposal_ID, Component_ID)
);

-- 14. InvestmentCommittee_Termination
CREATE TABLE InvestmentCommittee_Terminate (
    Committee_ID VARCHAR2(15) NOT NULL,
    Committee_TermSessionCode VARCHAR2(20) NOT NULL,
    Termination_ID VARCHAR2(15) NOT NULL,
    Termination_Date DATE NOT NULL,
    
    CONSTRAINT pk_ic_termination PRIMARY KEY (Committee_ID, Committee_TermSessionCode, Termination_ID, Termination_Date),
    CONSTRAINT fk_icterm_committee FOREIGN KEY (Committee_ID, Committee_TermSessionCode) REFERENCES Investment_Committee(Committee_ID, Committee_TermSessionCode),
    CONSTRAINT fk_icterm_term FOREIGN KEY (Termination_ID, Termination_Date) REFERENCES Termination(Termination_ID, Termination_Date)
);

-- 15. Representative_Agreement
CREATE TABLE Representative_Agreement (
    Rep_ID VARCHAR2(15) NOT NULL,
    Board_Resolution_Ref VARCHAR2(30) NOT NULL,
    Agreement_ID VARCHAR2(15) NOT NULL,
    Agreement_StampDutyID VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_rep_agreement PRIMARY KEY (Rep_ID, Board_Resolution_Ref, Agreement_ID, Agreement_StampDutyID),
    CONSTRAINT fk_repagr_rep FOREIGN KEY (Rep_ID, Board_Resolution_Ref) REFERENCES Representative(Rep_ID, Board_Resolution_Ref),
    CONSTRAINT fk_repagr_agr FOREIGN KEY (Agreement_ID, Agreement_StampDutyID) REFERENCES Agreement(Agreement_ID, Agreement_StampDutyID)
);

-- 16. Representative_Employee
CREATE TABLE Representative_Employee (
    Rep_ID VARCHAR2(15) NOT NULL,
    Board_Resolution_Ref VARCHAR2(30) NOT NULL,
    Employee_ID VARCHAR2(15) NOT NULL,
    Employee_Contract_No VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_rep_employee PRIMARY KEY (Rep_ID, Board_Resolution_Ref, Employee_ID, Employee_Contract_No),
    CONSTRAINT fk_repemp_rep FOREIGN KEY (Rep_ID, Board_Resolution_Ref) REFERENCES Representative(Rep_ID, Board_Resolution_Ref),
    CONSTRAINT fk_repemp_emp FOREIGN KEY (Employee_ID, Employee_Contract_No) REFERENCES Employee(Employee_ID, Employee_Contract_No)
);

-- 17. Advertisement_JobDescription
CREATE TABLE Advertisement_JobDescription (
    Advertisement_ID VARCHAR2(15) NOT NULL,
    Advertisement_StartDate DATE NOT NULL,
    Job_ID VARCHAR2(15) NOT NULL,
    Job_PublishDate DATE NOT NULL,
    
    CONSTRAINT pk_adv_jobdesc PRIMARY KEY (Advertisement_ID, Advertisement_StartDate, Job_ID, Job_PublishDate),
    CONSTRAINT fk_advjd_adv FOREIGN KEY (Advertisement_ID, Advertisement_StartDate) REFERENCES Advertisement(Advertisement_ID, Advertisement_StartDate),
    CONSTRAINT fk_advjd_job FOREIGN KEY (Job_ID, Job_PublishDate) REFERENCES Job_Description(Job_ID, Job_PublishDate)
);

-- 18. Lot_Approval
CREATE TABLE Lot_Approval (
    Lot_ID VARCHAR2(15) NOT NULL,
    Lot_TitleNo VARCHAR2(30) NOT NULL,
    Approval_ID VARCHAR2(15) NOT NULL,
    Approval_LetterID VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_lot_approval PRIMARY KEY (Lot_ID, Lot_TitleNo, Approval_ID, Approval_LetterID),
    CONSTRAINT fk_lotapp_lot FOREIGN KEY (Lot_ID, Lot_TitleNo) REFERENCES Lot(Lot_ID, Lot_TitleNo),
    CONSTRAINT fk_lotapp_appr FOREIGN KEY (Approval_ID, Approval_LetterID) REFERENCES Approval(Approval_ID, Approval_LetterID)
);

-- 19. Land_Approval
CREATE TABLE Land_Approval (
    Land_ID VARCHAR2(15) NOT NULL,
    Land_Master_Survey_Plan_No VARCHAR2(30) NOT NULL,
    Approval_ID VARCHAR2(15) NOT NULL,
    Approval_LetterID VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_land_approval PRIMARY KEY (Land_ID, Land_Master_Survey_Plan_No, Approval_ID, Approval_LetterID),
    CONSTRAINT fk_landapp_land FOREIGN KEY (Land_ID, Land_Master_Survey_Plan_No) REFERENCES Land(Land_ID, Land_Master_Survey_Plan_No),
    CONSTRAINT fk_landapp_appr FOREIGN KEY (Approval_ID, Approval_LetterID) REFERENCES Approval(Approval_ID, Approval_LetterID)
);

-- 20. Impact_QualityRecord
CREATE TABLE Impact_QualityRecord (
    Assessment_ID VARCHAR2(15) NOT NULL,
    Impact_Assessment_Date DATE NOT NULL,
    Inspection_ID VARCHAR2(15) NOT NULL,
    Inspection_Date DATE NOT NULL,
    
    CONSTRAINT pk_impact_quality PRIMARY KEY (Assessment_ID, Impact_Assessment_Date, Inspection_ID, Inspection_Date),
    CONSTRAINT fk_impqual_impact FOREIGN KEY (Assessment_ID, Impact_Assessment_Date) REFERENCES Impact(Assessment_ID, Impact_Assessment_Date),
    CONSTRAINT fk_impqual_insp FOREIGN KEY (Inspection_ID, Inspection_Date) REFERENCES Quality_Record(Inspection_ID, Inspection_Date)
);

-- 21. Company_Agreement
CREATE TABLE Company_Agreement (
    Company_ID VARCHAR2(15) NOT NULL,
    Company_SSM_No VARCHAR2(20) NOT NULL,
    Agreement_ID VARCHAR2(15) NOT NULL,
    Agreement_StampDutyID VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_comp_agreement PRIMARY KEY (Company_ID, Company_SSM_No, Agreement_ID, Agreement_StampDutyID),
    CONSTRAINT fk_cagr_company FOREIGN KEY (Company_ID, Company_SSM_No) REFERENCES Company(Company_ID, Company_SSM_No),
    CONSTRAINT fk_cagr_agreement FOREIGN KEY (Agreement_ID, Agreement_StampDutyID) REFERENCES Agreement(Agreement_ID, Agreement_StampDutyID)
);

-- 22. Land_Advertisement
CREATE TABLE Land_Advertisement (
    Land_ID VARCHAR2(15) NOT NULL,
    Land_Master_Survey_Plan_No VARCHAR2(30) NOT NULL,
    Advertisement_ID VARCHAR2(15) NOT NULL,
    Advertisement_StartDate DATE NOT NULL,
    
    CONSTRAINT pk_land_advertisement PRIMARY KEY (Land_ID, Land_Master_Survey_Plan_No, Advertisement_ID, Advertisement_StartDate),
    CONSTRAINT fk_ladv_land FOREIGN KEY (Land_ID, Land_Master_Survey_Plan_No) REFERENCES Land(Land_ID, Land_Master_Survey_Plan_No),
    CONSTRAINT fk_landadv_adv FOREIGN KEY (Advertisement_ID, Advertisement_StartDate) REFERENCES Advertisement(Advertisement_ID, Advertisement_StartDate)
);

-- 23. Lot_Advertisement
CREATE TABLE Lot_Advertisement (
    Lot_ID VARCHAR2(15) NOT NULL,
    Lot_TitleNo VARCHAR2(30) NOT NULL,
    Advertisement_ID VARCHAR2(15) NOT NULL,
    Advertisement_StartDate DATE NOT NULL,
    
    CONSTRAINT pk_lot_advertisement PRIMARY KEY (Lot_ID, Lot_TitleNo, Advertisement_ID, Advertisement_StartDate),
    CONSTRAINT fk_ladv_lot FOREIGN KEY (Lot_ID, Lot_TitleNo) REFERENCES Lot(Lot_ID, Lot_TitleNo),
    CONSTRAINT fk_lotadv_adv FOREIGN KEY (Advertisement_ID, Advertisement_StartDate) REFERENCES Advertisement(Advertisement_ID, Advertisement_StartDate)
);

-- 24. Inspector_Infrastructure
CREATE TABLE Inspector_Infrastructure (
    Inspector_ID VARCHAR2(15) NOT NULL,
    DOSH_Registration_No VARCHAR2(30) NOT NULL,
    IS_ID VARCHAR2(15) NOT NULL,
    IS_SiteNo VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_inspector_infra PRIMARY KEY (Inspector_ID, DOSH_Registration_No, IS_ID, IS_SiteNo),
    CONSTRAINT fk_iinfra_inspector FOREIGN KEY (Inspector_ID, DOSH_Registration_No) REFERENCES Inspector(Inspector_ID, DOSH_Registration_No),
    CONSTRAINT fk_iinfra_infra FOREIGN KEY (IS_ID, IS_SiteNo) REFERENCES Infrastructure(IS_ID, IS_SiteNo)
);

-- 25. Company_Relation (Self-referencing Many-to-Many)
CREATE TABLE Company_Relation (
    Company_ID VARCHAR2(15) NOT NULL,
    Company_SSM_No VARCHAR2(20) NOT NULL,
    Related_Company_ID VARCHAR2(15) NOT NULL,
    Related_Company_SSM_No VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_company_relation PRIMARY KEY (Company_ID, Company_SSM_No, Related_Company_ID, Related_Company_SSM_No),
    CONSTRAINT fk_crel_company1 FOREIGN KEY (Company_ID, Company_SSM_No) REFERENCES Company(Company_ID, Company_SSM_No),
    CONSTRAINT fk_crel_company2 FOREIGN KEY (Related_Company_ID, Related_Company_SSM_No) REFERENCES Company(Company_ID, Company_SSM_No)
);

-- 26. Employee_JobApplicant
CREATE TABLE Employee_JobApplicant (
    Employee_ID VARCHAR2(15) NOT NULL,
    Employee_Contract_No VARCHAR2(20) NOT NULL,
    Applicant_ID VARCHAR2(15) NOT NULL,
    Applicant_Portal_Username VARCHAR2(30) NOT NULL,
    
    CONSTRAINT pk_emp_jobapplicant PRIMARY KEY (Employee_ID, Employee_Contract_No, Applicant_ID, Applicant_Portal_Username),
    CONSTRAINT fk_ejat_employee FOREIGN KEY (Employee_ID, Employee_Contract_No) REFERENCES Employee(Employee_ID, Employee_Contract_No),
    CONSTRAINT fk_ejat_applicant FOREIGN KEY (Applicant_ID, Applicant_Portal_Username) REFERENCES Job_Applicant(Applicant_ID, Applicant_Portal_Username)
);

-- 27. Inspector_ProjectTimeline
CREATE TABLE Inspector_ProjectTimeline (
    Inspector_ID VARCHAR2(15) NOT NULL,
    DOSH_Registration_No VARCHAR2(30) NOT NULL,
    Timeline_MilestoneID VARCHAR2(20) NOT NULL,
    Timeline_ID VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_inspector_timeline PRIMARY KEY (Inspector_ID, DOSH_Registration_No, Timeline_MilestoneID, Timeline_ID),
    CONSTRAINT fk_itime_inspector FOREIGN KEY (Inspector_ID, DOSH_Registration_No) REFERENCES Inspector(Inspector_ID, DOSH_Registration_No),
    CONSTRAINT fk_itime_timeline FOREIGN KEY (Timeline_MilestoneID, Timeline_ID) REFERENCES Project_Timeline(Timeline_MilestoneID, Timeline_ID)
);

-- 28. Inspector_Impact
CREATE TABLE Inspector_Impact (
    Inspector_ID VARCHAR2(15) NOT NULL,
    DOSH_Registration_No VARCHAR2(30) NOT NULL,
    Assessment_ID VARCHAR2(15) NOT NULL,
    Impact_Assessment_Date DATE NOT NULL,
    
    CONSTRAINT pk_inspector_impact PRIMARY KEY (Inspector_ID, DOSH_Registration_No, Assessment_ID, Impact_Assessment_Date),
    CONSTRAINT fk_iimp_inspector FOREIGN KEY (Inspector_ID, DOSH_Registration_No) REFERENCES Inspector(Inspector_ID, DOSH_Registration_No),
    CONSTRAINT fk_iimp_impact FOREIGN KEY (Assessment_ID, Impact_Assessment_Date) REFERENCES Impact(Assessment_ID, Impact_Assessment_Date)
);

-- 29. Inspector_Digitalization
CREATE TABLE Inspector_Digitalization (
    Inspector_ID VARCHAR2(15) NOT NULL,
    DOSH_Registration_No VARCHAR2(30) NOT NULL,
    Digital_ID VARCHAR2(15) NOT NULL,
    MDEC_Approval_Ref VARCHAR2(30) NOT NULL,
    
    CONSTRAINT pk_inspector_digital PRIMARY KEY (Inspector_ID, DOSH_Registration_No, Digital_ID, MDEC_Approval_Ref),
    CONSTRAINT fk_idig_inspector FOREIGN KEY (Inspector_ID, DOSH_Registration_No) REFERENCES Inspector(Inspector_ID, DOSH_Registration_No),
    CONSTRAINT fk_idig_digital FOREIGN KEY (Digital_ID, MDEC_Approval_Ref) REFERENCES Digitalisation(Digital_ID, MDEC_Approval_Ref)
);

-- 30. Inspector_SustainabilityScore
CREATE TABLE Inspector_SustainabilityScore (
    Inspector_ID VARCHAR2(15) NOT NULL,
    DOSH_Registration_No VARCHAR2(30) NOT NULL,
    ESG_ID VARCHAR2(15) NOT NULL,
    Revision_Date DATE NOT NULL,
    
    CONSTRAINT pk_inspector_esg PRIMARY KEY (Inspector_ID, DOSH_Registration_No, ESG_ID, Revision_Date),
    CONSTRAINT fk_iesg_inspector FOREIGN KEY (Inspector_ID, DOSH_Registration_No) REFERENCES Inspector(Inspector_ID, DOSH_Registration_No),
    CONSTRAINT fk_iesg_score FOREIGN KEY (ESG_ID, Revision_Date) REFERENCES Sustainability_Score(ESG_ID, Revision_Date)
);

-- 31. Employee_InvestmentApplication
CREATE TABLE Employee_InvestmentApplication (
    Employee_ID VARCHAR2(15) NOT NULL,
    Employee_Contract_No VARCHAR2(20) NOT NULL,
    Application_ID VARCHAR2(15) NOT NULL,
    Application_SubmissionDate DATE NOT NULL,
    
    CONSTRAINT pk_emp_invapp PRIMARY KEY (Employee_ID, Employee_Contract_No, Application_ID, Application_SubmissionDate),
    CONSTRAINT fk_eia_employee FOREIGN KEY (Employee_ID, Employee_Contract_No) REFERENCES Employee(Employee_ID, Employee_Contract_No),
    CONSTRAINT fk_eia_application FOREIGN KEY (Application_ID, Application_SubmissionDate) REFERENCES Investment_Application(Application_ID, Application_Submission_Date)
);

-- 32. Company_Lot
CREATE TABLE Company_Lot (
    Company_ID VARCHAR2(15) NOT NULL,
    Company_SSM_No VARCHAR2(20) NOT NULL,
    Lot_ID VARCHAR2(15) NOT NULL,
    Lot_TitleNo VARCHAR2(30) NOT NULL,
    
    CONSTRAINT pk_company_lot PRIMARY KEY (Company_ID, Company_SSM_No, Lot_ID, Lot_TitleNo),
    CONSTRAINT fk_clot_company FOREIGN KEY (Company_ID, Company_SSM_No) REFERENCES Company(Company_ID, Company_SSM_No),
    CONSTRAINT fk_clot_lot FOREIGN KEY (Lot_ID, Lot_TitleNo) REFERENCES Lot(Lot_ID, Lot_TitleNo)
);

-- 33. Company_Land
CREATE TABLE Company_Land (
    Company_ID VARCHAR2(15) NOT NULL,
    Company_SSM_No VARCHAR2(20) NOT NULL,
    Land_ID VARCHAR2(15) NOT NULL,
    Land_Master_Survey_Plan_No VARCHAR2(30) NOT NULL,
    
    CONSTRAINT pk_company_land PRIMARY KEY (Company_ID, Company_SSM_No, Land_ID, Land_Master_Survey_Plan_No),
    CONSTRAINT fk_cland_comp FOREIGN KEY (Company_ID, Company_SSM_No) REFERENCES Company(Company_ID, Company_SSM_No),
    CONSTRAINT fk_cland_land FOREIGN KEY (Land_ID, Land_Master_Survey_Plan_No) REFERENCES Land(Land_ID, Land_Master_Survey_Plan_No)
);

-- 34. Company_ProposalContent
CREATE TABLE Company_ProposalContent (
    Company_ID VARCHAR2(15) NOT NULL,
    Company_SSM_No VARCHAR2(20) NOT NULL,
    Proposal_ID VARCHAR2(20) NOT NULL,
    Component_ID VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_company_prop PRIMARY KEY (Company_ID, Company_SSM_No, Proposal_ID, Component_ID),
    CONSTRAINT fk_cprop_comp FOREIGN KEY (Company_ID, Company_SSM_No) REFERENCES Company(Company_ID, Company_SSM_No),
    CONSTRAINT fk_cprop_prop FOREIGN KEY (Proposal_ID, Component_ID) REFERENCES Proposal_Content(Proposal_ID, Component_ID)
);

-- 35. Advertisement_JobApplication
CREATE TABLE Advertisement_JobApplication (
    Advertisement_ID VARCHAR2(15) NOT NULL,
    Advertisement_StartDate DATE NOT NULL,
    Job_Application_ID VARCHAR2(15) NOT NULL,
    Job_Application_TimeStamp TIMESTAMP NOT NULL,
    
    CONSTRAINT pk_adv_jobapp PRIMARY KEY (Advertisement_ID, Advertisement_StartDate, Job_Application_ID, Job_Application_TimeStamp),
    CONSTRAINT fk_advja_adv FOREIGN KEY (Advertisement_ID, Advertisement_StartDate) REFERENCES Advertisement(Advertisement_ID, Advertisement_StartDate),
    CONSTRAINT fk_advja_jobapp FOREIGN KEY (Job_Application_ID, Job_Application_TimeStamp) REFERENCES Job_Application(Job_Application_ID, Job_Application_Timestamp)
);

-- 36. Advertisement_InvestmentApplication
CREATE TABLE Advertisement_InvestmentApp (
    Advertisement_ID VARCHAR2(15) NOT NULL,
    Advertisement_StartDate DATE NOT NULL,
    Application_ID VARCHAR2(15) NOT NULL,
    Application_Submission_Date DATE NOT NULL,
    
    CONSTRAINT pk_adv_invapp PRIMARY KEY (Advertisement_ID, Advertisement_StartDate, Application_ID, Application_Submission_Date),
    CONSTRAINT fk_advia_adv FOREIGN KEY (Advertisement_ID, Advertisement_StartDate) REFERENCES Advertisement(Advertisement_ID, Advertisement_StartDate),
    CONSTRAINT fk_advia_app FOREIGN KEY (Application_ID, Application_Submission_Date) REFERENCES Investment_Application(Application_ID, Application_Submission_Date)
);

-- 37. Representative_ProposalContent
CREATE TABLE Representative_ProposalContent (
    Rep_ID VARCHAR2(15) NOT NULL,
    Board_Resolution_Ref VARCHAR2(30) NOT NULL,
    Proposal_ID VARCHAR2(20) NOT NULL,
    Component_ID VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_rep_propcont PRIMARY KEY (Rep_ID, Board_Resolution_Ref, Proposal_ID, Component_ID),
    CONSTRAINT fk_rprop_rep FOREIGN KEY (Rep_ID, Board_Resolution_Ref) REFERENCES Representative(Rep_ID, Board_Resolution_Ref),
    CONSTRAINT fk_rprop_prop FOREIGN KEY (Proposal_ID, Component_ID) REFERENCES Proposal_Content(Proposal_ID, Component_ID)
);

-- 38. Representative_ProposalScreening
CREATE TABLE Representative_Screening (
    Rep_ID VARCHAR2(15) NOT NULL,
    Board_Resolution_Ref VARCHAR2(30) NOT NULL,
    Screening_MeetingID VARCHAR2(20) NOT NULL,
    Screening_MOM_ID VARCHAR2(25) NOT NULL,
    
    CONSTRAINT pk_rep_propscreen PRIMARY KEY (Rep_ID, Board_Resolution_Ref, Screening_MeetingID, Screening_MOM_ID),
    CONSTRAINT fk_rscr_rep FOREIGN KEY (Rep_ID, Board_Resolution_Ref) REFERENCES Representative(Rep_ID, Board_Resolution_Ref),
    CONSTRAINT fk_rscr_screen FOREIGN KEY (Screening_MeetingID, Screening_MOM_ID) REFERENCES Proposal_Screening(Screening_MeetingID, Screening_MOM_ID)
);

-- 39. Employee_QualityRecord
CREATE TABLE Employee_QualityRecord (
    Employee_ID VARCHAR2(15) NOT NULL,
    Employee_Contract_No VARCHAR2(20) NOT NULL,
    Inspection_ID VARCHAR2(15) NOT NULL,
    Inspection_Date DATE NOT NULL,
    
    CONSTRAINT pk_emp_qualrec PRIMARY KEY (Employee_ID, Employee_Contract_No, Inspection_ID, Inspection_Date),
    CONSTRAINT fk_eqr_emp FOREIGN KEY (Employee_ID, Employee_Contract_No) REFERENCES Employee(Employee_ID, Employee_Contract_No),
    CONSTRAINT fk_eqr_qual FOREIGN KEY (Inspection_ID, Inspection_Date) REFERENCES Quality_Record(Inspection_ID, Inspection_Date)
);

-- 40. Lot_ProposalContent
CREATE TABLE Lot_ProposalContent (
    Lot_ID VARCHAR2(15) NOT NULL,
    Lot_TitleNo VARCHAR2(30) NOT NULL,
    Proposal_ID VARCHAR2(20) NOT NULL,
    Component_ID VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_lot_propcont PRIMARY KEY (Lot_ID, Lot_TitleNo, Proposal_ID, Component_ID),
    CONSTRAINT fk_lpc_lot FOREIGN KEY (Lot_ID, Lot_TitleNo) REFERENCES Lot(Lot_ID, Lot_TitleNo),
    CONSTRAINT fk_lpc_prop FOREIGN KEY (Proposal_ID, Component_ID) REFERENCES Proposal_Content(Proposal_ID, Component_ID)
);

-- 41. Lot_InvestmentApplication
CREATE TABLE Lot_InvestmentApplication (
    Lot_ID VARCHAR2(15) NOT NULL,
    Lot_TitleNo VARCHAR2(30) NOT NULL,
    Application_ID VARCHAR2(15) NOT NULL,
    Application_Submission_Date DATE NOT NULL,
    
    CONSTRAINT pk_lot_invapp PRIMARY KEY (Lot_ID, Lot_TitleNo, Application_ID, Application_Submission_Date),
    CONSTRAINT fk_lia_lot FOREIGN KEY (Lot_ID, Lot_TitleNo) REFERENCES Lot(Lot_ID, Lot_TitleNo),
    CONSTRAINT fk_lia_app FOREIGN KEY (Application_ID, Application_Submission_Date) REFERENCES Investment_Application(Application_ID, Application_Submission_Date)
);

-- 42. Land_ProposalContent
CREATE TABLE Land_ProposalContent (
    Land_ID VARCHAR2(15) NOT NULL,
    Land_Master_Survey_Plan_No VARCHAR2(30) NOT NULL,
    Proposal_ID VARCHAR2(20) NOT NULL,
    Component_ID VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_land_propcont PRIMARY KEY (Land_ID, Land_Master_Survey_Plan_No, Proposal_ID, Component_ID),
    CONSTRAINT fk_ldpc_land FOREIGN KEY (Land_ID, Land_Master_Survey_Plan_No) REFERENCES Land(Land_ID, Land_Master_Survey_Plan_No),
    CONSTRAINT fk_ldpc_prop FOREIGN KEY (Proposal_ID, Component_ID) REFERENCES Proposal_Content(Proposal_ID, Component_ID)
);

-- 43. Land_InvestmentApplication
CREATE TABLE Land_InvestmentApplication (
    Land_ID VARCHAR2(15) NOT NULL,
    Land_Master_Survey_Plan_No VARCHAR2(30) NOT NULL,
    Application_ID VARCHAR2(15) NOT NULL,
    Application_Submission_Date DATE NOT NULL,
    
    CONSTRAINT pk_land_invapp PRIMARY KEY (Land_ID, Land_Master_Survey_Plan_No, Application_ID, Application_Submission_Date),
    CONSTRAINT fk_ldia_land FOREIGN KEY (Land_ID, Land_Master_Survey_Plan_No) REFERENCES Land(Land_ID, Land_Master_Survey_Plan_No),
    CONSTRAINT fk_ldia_app FOREIGN KEY (Application_ID, Application_Submission_Date) REFERENCES Investment_Application(Application_ID, Application_Submission_Date)
);

-- 44. Inspector_BusinessPlan
CREATE TABLE Inspector_BusinessPlan (
    Inspector_ID VARCHAR2(15) NOT NULL,
    DOSH_Registration_No VARCHAR2(30) NOT NULL,
    Plan_ID VARCHAR2(15) NOT NULL,
    Project_Title VARCHAR2(100) NOT NULL,
    
    CONSTRAINT pk_insp_bizplan PRIMARY KEY (Inspector_ID, DOSH_Registration_No, Plan_ID, Project_Title),
    CONSTRAINT fk_ibp_insp FOREIGN KEY (Inspector_ID, DOSH_Registration_No) REFERENCES Inspector(Inspector_ID, DOSH_Registration_No),
    CONSTRAINT fk_ibp_plan FOREIGN KEY (Plan_ID, Project_Title) REFERENCES Business_Plan(Plan_ID, Project_Title)
);

-- 45. Land_Agreement
CREATE TABLE Land_Agreement (
    Land_ID VARCHAR2(15) NOT NULL,
    Land_Master_Survey_Plan_No VARCHAR2(30) NOT NULL,
    Agreement_ID VARCHAR2(15) NOT NULL,
    Agreement_StampDutyID VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_land_agreement PRIMARY KEY (Land_ID, Land_Master_Survey_Plan_No, Agreement_ID, Agreement_StampDutyID),
    CONSTRAINT fk_lagr_land FOREIGN KEY (Land_ID, Land_Master_Survey_Plan_No) REFERENCES Land(Land_ID, Land_Master_Survey_Plan_No),
    CONSTRAINT fk_lagr_agr FOREIGN KEY (Agreement_ID, Agreement_StampDutyID) REFERENCES Agreement(Agreement_ID, Agreement_StampDutyID)
);

-- 46. Lot_Agreement
CREATE TABLE Lot_Agreement (
    Lot_ID VARCHAR2(15) NOT NULL,
    Lot_TitleNo VARCHAR2(30) NOT NULL,
    Agreement_ID VARCHAR2(15) NOT NULL,
    Agreement_StampDutyID VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_lot_agreement PRIMARY KEY (Lot_ID, Lot_TitleNo, Agreement_ID, Agreement_StampDutyID),
    CONSTRAINT fk_lotagr_lot FOREIGN KEY (Lot_ID, Lot_TitleNo) REFERENCES Lot(Lot_ID, Lot_TitleNo),
    CONSTRAINT fk_lotagr_agr FOREIGN KEY (Agreement_ID, Agreement_StampDutyID) REFERENCES Agreement(Agreement_ID, Agreement_StampDutyID)
);