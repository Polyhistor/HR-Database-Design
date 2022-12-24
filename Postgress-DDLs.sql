-- DDL - the following commands should run in order, otherwise there will be constraints errors or reference errors.

CREATE TABLE Education (
    ID serial primary key, 
    Level varchar(100)
);

CREATE TABLE Office (
    ID serial primary key, 
    Location varchar(250),
    Address varchar(500),
    City_ID int references City(ID)
);

CREATE TABLE City (
    ID serial primary key, 
    Name varchar(150)
);

CREATE TABLE Department (
    ID serial primary key, 
    Name varchar(100)
);

CREATE TABLE Salary (
    ID serial primary key, 
    Amount money
);

CREATE TABLE Job (
    ID serial primary key, 
    Title varchar(100)
); 


CREATE TABLE Employee (
ID serial primary key, 
Name varchar(100),
Email varchar(150), 
Education_ID int references Education(ID),
Department_ID int references Department(ID),
Salary_ID int references Salary(ID),
Manager_ID int references Employee(ID),
Office_ID int references Office(ID),
Job_ID int references Job(ID)
);

CREATE TABLE Employee_History (
    ID serial, 
    Start_Date date,
    End_Date date,
    Employee_ID int references Employee(ID),
    primary key (ID, Start_Date, End_Date, Employee_ID) 
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
FROM proj_stg as st 
JOIN city as c 
ON st.city = c.name;

INSERT INTO Salary (amount)
SELECT salary FROM proj_stg;

INSERT INTO job (title) 
SELECT Distinct job_title from proj_stg;

INSERT 