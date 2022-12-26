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
SELECT DISTINCT department_nm FROM proj_stg;

INSERT INTO Education (level) 
SELECT DISTINCT education_lvl FROM proj_stg;

INSERT INTO City (name)
SELECT DISTINCT city FROM proj_stg;

INSERT INTO Office (location, address, city_id)
SELECT DISTINCT st.location, st.address, c.id
FROM proj_stg AS st 
JOIN city AS c 
ON st.city = c.name;

INSERT INTO Salary (amount)
SELECT salary FROM proj_stg;

INSERT INTO Job (title) 
SELECT Distinct job_title FROM proj_stg;

INSERT INTO employee (id, name, email, education_id, department_id, salary_id, office_id, job_id, manager_id)
SELECT st.emp_id, st.emp_nm, st.email, e.id, d.id, s.id, o.id, j.id, stm.emp_id 
FROM proj_stg AS st  
JOIN education AS e 
ON st.education_lvl = e.level 
JOIN department AS d 
ON st.department_nm = d.name 
JOIN salary AS s 
ON st.salary = s.amount 
JOIN office AS o 
ON st.location = o.location  
JOIN job AS j 
ON st.job_title = j.title
LEFT JOIN proj_stg AS stm
ON stm.emp_nm = st.manager;


