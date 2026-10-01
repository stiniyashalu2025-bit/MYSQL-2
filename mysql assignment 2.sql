USE employee;

-- 1. DISTINCT
SELECT DISTINCT salary
FROM Employees;

ALTER TABLE Employees
ADD age INT;

-- 2. ALIAS (AS)
SELECT age AS Employee_Age,
       salary AS Employee_Salary
FROM Employees;
describe employees;

ALTER TABLE Employees ADD COLUMN date_of_joining DATE;

SELECT *
FROM Employees
WHERE salary > 5000
AND date_of_joining < '2016-01-01';

SELECT *
FROM Employees
WHERE designation IS NULL;

UPDATE Employees
SET designation = 'Data Scientist'
WHERE designation IS NULL;

-- 4. Find employee whose designation is missing
SELECT *
FROM Employees
WHERE designation IS NULL;


-- Fill missing designation with Data Scientist
UPDATE Employees
SET designation = 'Data Scientist'
WHERE designation IS NULL;


-- 5. ORDER BY
SELECT *
FROM Employees
ORDER BY department_id ASC,
         salary DESC;


-- 6. LIMIT
-- First 5 employees hired in 2018
SELECT *
FROM Employees
WHERE YEAR(date_of_joining) = 2018
LIMIT 5;


-- 7. SUM of salaries in Finance department
SELECT SUM(e.salary) AS Total_Salary
FROM Employees e
JOIN Departments_Info d
ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';


-- 8. Minimum age among all employees
SELECT MIN(age) AS Minimum_Age
FROM Employees;


-- 9. GROUP BY: maximum salary for each location
SELECT l.location,
       MAX(e.salary) AS Maximum_Salary
FROM Employees e
JOIN Locations l
ON e.location_id = l.location_id
GROUP BY l.location;


-- 10. Average salary for each designation containing 'Analyst'
SELECT designation,
       AVG(salary) AS Average_Salary
FROM Employees
WHERE designation LIKE '%Analyst%'
GROUP BY designation;


-- 11. HAVING: departments with less than 3 employees
SELECT department_id,
       COUNT(*) AS Employee_Count
FROM Employees
GROUP BY department_id
HAVING COUNT(*) < 3;


-- 12. HAVING: locations with female employees
-- whose average age is below 30
SELECT l.location,
       AVG(e.age) AS Average_Age
FROM Employees e
JOIN Locations l
ON e.location_id = l.location_id
WHERE e.gender = 'F'
GROUP BY l.location
HAVING AVG(e.age) < 30;


-- 13. INNER JOIN
SELECT e.employee_name,
       e.designation,
       d.department_name
FROM Employees e
INNER JOIN Departments_Info d
ON e.department_id = d.department_id;


-- 14. LEFT JOIN
-- All departments including departments with no employees
SELECT d.department_name,
       COUNT(e.employee_id) AS Total_Employees
FROM Departments_Info d
LEFT JOIN Employees e
ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;


-- 15. RIGHT JOIN
-- All locations including locations with no employees
SELECT l.location,
       e.employee_name
FROM Employees e
RIGHT JOIN Locations l
ON e.location_id = l.location_id;