-- DDL - the following commands should run in order, otherwise there will be constraints errors or reference errors.

CREATE TABLE Education (
    ID serial primary key, 
    Level varchar(100)
);

CREATE TABLE City (
    ID serial primary key,
    State varchar(2), 
    Name varchar(150)
);

CREATE TABLE Office (
    ID serial primary key, 
    Location varchar(250),
    Address varchar(500),
    City_ID int references City(ID)
);

CREATE TABLE Department (
    ID serial primary key, 
    Name varchar(100)
);

CREATE TABLE Salary (
    ID serial primary key, 
    Amount int
);

CREATE TABLE Job (
    ID serial primary key, 
    Title varchar(100)
); 

CREATE TABLE Employee (
ID varchar(8) primary key, 
Name varchar(100),
Email varchar(150)
);

CREATE TABLE Employee_History (
    Start_Date date,
    End_Date date,
    Hire_date date,
    Employee_ID varchar(8) references Employee(ID),
    Education_ID int references Education(ID),
    Department_ID int references Department(ID),
    Salary_ID int references Salary(ID),
    Manager_ID varchar(8) references Employee(ID),
    Office_ID int references Office(ID),
    Job_ID int references Job(ID),
    primary key (Start_Date, End_Date, Employee_ID)
);


-- DML

INSERT INTO Department (name)
SELECT DISTINCT department_nm 
FROM proj_stg;

INSERT INTO Education (level) 
SELECT DISTINCT education_lvl 
FROM proj_stg;

INSERT INTO City (name, state)
SELECT DISTINCT city, state
FROM proj_stg;

INSERT INTO Office (location, address, city_id)
SELECT DISTINCT st.location, st.address, c.id
FROM proj_stg AS st 
JOIN city AS c 
ON st.city = c.name;

INSERT INTO Salary (amount)
SELECT salary 
FROM proj_stg;

INSERT INTO Job (title) 
SELECT Distinct job_title 
FROM proj_stg;

INSERT INTO employee(id, name, email)
SELECT DISTINCT emp_id, emp_nm, email 
FROM proj_stg;

INSERT INTO employee_history(start_date, end_date, hire_date, employee_id, education_id, department_id, salary_id, manager_id, office_id, job_id)
SELECT st.start_dt, st.end_dt, st.hire_dt, e.id, ed.id, d.id, s.id, st2.emp_id, o.id, j.id  
FROM proj_stg AS st 
JOIN employee AS e
ON st.emp_id = e.id 
JOIN education AS ed 
ON st.education_lvl = ed.level 
JOIN department AS d
ON st.department_nm = d.name 
JOIN salary AS s 
ON st.salary = s.amount 
LEFT JOIN proj_stg as st2
ON st.manager = st2.emp_nm 
JOIN office AS o 
ON st.location = o.location
JOIN job AS j 
ON st.job_title = j.title;



-- Queries Suggested 

-- List of employees with Job Titles and Department Names
SELECT e.name, d.name AS Department, j.title AS Job 
FROM employee_history AS eh 
JOIN employee AS e
ON eh.employee_id = e.id 
JOIN department AS d 
ON eh.department_id =  d.id 
JOIN job AS j 
ON eh.job_id = j.id;
 
-- Insert Web Programmer as a new job title
INSERT INTO job (title) 
values('Web Programmer');

-- Correct the job title from web programmer to web developer
UPDATE job 
SET title = 'Web Developer'
WHERE title = 'Web Programmer';

-- Delete the job title Web Developer from the database
DELETE FROM job 
WHERE title = 'Web Developer';

-- How many employees are in each department
SELECT count(eh.employee_id), d.name 
FROM employee_history as eh
JOIN department AS d 
ON eh.department_id = d.id  
GROUP BY d.name;

-- A query that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) for employee Toni Lembeck.
SELECT e.name, j.title, d.name AS department, em.name as manager, eh.start_date, eh.end_date 
FROM employee_history AS eh 
JOIN employee AS e 
ON eh.employee_id = e.id 
JOIN job AS j 
ON eh.job_id = j.id 
JOIN department AS d 
ON eh.department_id = d.id 
JOIN employee AS em 
ON eh.manager_id = em.id
WHERE e.name = 'Toni Lembeck';

-- Create a view that returns all employee attributes;
CREATE VIEW Employee_Attriutes AS 
SELECT e.name, ed.level AS Education_Level, d.name AS department, s.amount AS Salary, em.name AS Manager, o.location AS Location, c.state AS State, c.name AS city, j.title AS job, eh.start_date, eh.end_date, eh.hire_date 
FROM employee_history AS eh 
JOIN employee AS e
ON eh.employee_id = e.id 
JOIN education AS ed 
ON eh.education_id = ed.id
JOIN department AS d
ON eh.department_id = d.id 
JOIN salary AS s 
ON eh.salary_id = s.id 
JOIN employee AS em     
ON eh.manager_id = em.id
JOIN office AS o 
ON eh.office_id = o.id 
JOIN city AS c 
ON o.city_id = c.id 
JOIN job AS j 
ON eh.job_id = j.id;

-- Running the view 
SELECT * FROM Employee_Attriutes;

-- A stored procedure with parameters that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) when given an employee name
CREATE PROCEDURE SelectCurrentAndPastJobOfAnEmployee(name varchar(100))
LANGUAGE SQL
AS $$ 
BEGIN 
    SELECT e.name, j.title, d.name AS department, em.name as manager, eh.start_date, eh.end_date 
    FROM employee_history AS eh 
    JOIN employee AS e 
    ON eh.employee_id = e.id 
    JOIN job AS j 
    ON eh.job_id = j.id 
    JOIN department AS d 
    ON eh.department_id = d.id 
    JOIN employee AS em 
    ON eh.manager_id = em.id
    WHERE e.name = (name);
END 
$$;


-- User security on the restricted salary attribute.
CREATE USER NoMgr;

GRANT ALL PRIVILEGES ON DATABASE postgres to NoMgr; 

REVOKE ALL ON salary FROM NoMgr;