CREATE DATABASE hr_analytics;
USE hr_analytics;	
SELECT * FROM hr_1;
SELECT * FROM hr_2;

##############################################################################################
# 1. Total Employee  

SELECT 
      COUNT(*) total_employee 
FROM hr_1;

################################################################################################
# 2. Gender Count  

CREATE VIEW GenderCount AS
SELECT 
     gender,
     COUNT(gender) AS gender_count 
FROM hr_1
GROUP BY gender;

SELECT * FROM GenderCount;
################################################################################################
# 3. Current Employe 

SELECT 
     COUNT(Attrition) AS Current_employee
FROM hr_1
WHERE Attrition = "No";

#################################################################################################
# 4. Attrition Employee 

SELECT 
     COUNT(Attrition) AS Current_employee
FROM hr_1
WHERE Attrition = "Yes";    

############################################################################################################
# 5. TOTAL ATTRITION COUNT FOR ALL DEPARTMENT

SELECT * FROM hr_1;
SELECT 
     Department,
     COUNT(Attrition) AS Total_Attrition_Employee
FROM hr_1
WHERE Attrition = "Yes"
GROUP BY Department;     

##########################################################################################################
# 6.  Education vs attrition

SELECT 
     EducationField, 
     COUNT(Attrition) AS Current_Employee FROM hr_1
WHERE Attrition = 'yes'
GROUP BY Educationfield;

##########################################################################################################
# 7. Average Attrition rate for all Departments 

SELECT 
     Department,
     CONCAT(ROUND((COUNT(Attrition) / (SELECT COUNT(EmployeeNumber) FROM hr_1)*100),2),'%') AS Attrition_Rate
FROM hr_1
WHERE Attrition = "Yes"
GROUP BY Department
ORDER BY Attrition_Rate DESC;     

##########################################################################################################
# 8. Job Role Vs Work life balance

SELECT 
     H1.JobRole,
     count(H2.WorkLifeBalance)
FROM hr_1 H1
JOIN hr_2 H2 ON H1.EmployeeNumber = H2.EmployeeID;

##########################################################################################################
# 9. Average Hourly rate of Male Research Scientist

SELECT 
    JobRole,
    ROUND(AVG(HourlyRate),2) AS AvgHourly_Rate
FROM hr_1
WHERE JobRole = 'Research Scientist';
   
____________________________________________________________________________________________
   
# Finding Hourly Rate of specific gender and job role

DELIMITER //
CREATE PROCEDURE Hourly_Rate( IN input_gender VARCHAR (10), IN input_jobrole VARCHAR (30))
BEGIN
    SELECT 
          Gender,
          JobRole,
          CONCAT(ROUND(AVG(HourlyRate),1),'  ','Rs') AS Avg_Hourly_Rate
    FROM hr_1
    WHERE Gender = input_gender AND JobRole = input_jobrole 
    GROUP BY Gender,JobRole;      
END //
DELIMITER ;

CALL Hourly_Rate('Female','Developer');

##########################################################################################################
# 10. Attrition rate Vs Average Monthly Income By Department

SELECT 
      H1.Department,
      CONCAT(ROUND(COUNT(H1.Attrition) / (SELECT COUNT(H1.EmployeeNumber) FROM hr_1 H1)*100,2),' ','%') AS Attrition_rate,
      CONCAT(ROUND(AVG(H2.MonthlyIncome),1),' ','Rs') AS Avg_MonthlyIncome
FROM hr_1 H1
JOIN hr_2 H2 ON H1.EmployeeNumber = H2.EmployeeID
WHERE Attrition = 'Yes'
GROUP BY H1.Department;

##########################################################################################################
# 11. Average working years for each Department and job role

SELECT 
     H1.Department,
     H1.JobRole,
     CONCAT(ROUND(AVG(H2.TotalWorkingYears),0),' ','Years') AS Avg_WorkingYear
FROM hr_1 H1
JOIN hr_2 H2 ON H1.EmployeeNumber = H2.EmployeeID
GROUP BY H1.Department,H1.JobRole
ORDER BY H1.Department;

##########################################################################################################
# 12. Attrition rate Vs Year since last promotion BY education field

SELECT 
     H1.EducationField,
     CONCAT(H2.YearsSinceLastPromotion,' ' , 'Years') AS YearsSince_Promotion,
     CONCAT(ROUND(COUNT(H1.Attrition) / (SELECT COUNT(H1.EmployeeNumber) FROM hr_1 H1)*100,2),' ','%') AS Attrition_rate
FROM hr_1 H1
JOIN hr_2 H2 ON H1.EmployeeNumber = H2.EmployeeID
GROUP BY H1.EducationField,H2.YearsSinceLastPromotion
ORDER BY H2.YearsSinceLastPromotion DESC;








