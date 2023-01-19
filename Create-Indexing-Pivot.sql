


CREATE TABLE Customers
(
  Cust_ID  INT          NOT NULL IDENTITY,
  Name        NVARCHAR(20) NOT NULL,
  Street_Address         NVARCHAR(60) NOT NULL,
  city            NVARCHAR(15) NOT NULL,
  Province          NVARCHAR(15) NULL,
  postalcode      NVARCHAR(10) NULL,
  Telephone         NVARCHAR(24) NOT NULL,
  Date_of_Birth     DATETIME     NOT NULL, 
  Email     NVARCHAR(24) NOT NULL,
  CONSTRAINT PK_Customers PRIMARY KEY(Cust_ID),
  CONSTRAINT CHK_Date_of_Birth CHECK(Date_of_Birth <= CURRENT_TIMESTAMP)
);

CREATE NONCLUSTERED INDEX idx_nc_city        ON Customers(city);
CREATE NONCLUSTERED INDEX idx_nc_postalcode  ON Customers(postalcode);
CREATE NONCLUSTERED INDEX idx_nc_Province      ON Customers(Province);

CREATE TABLE Orders
(
  orderid        INT          NOT NULL IDENTITY,
  Cust_ID         INT          NULL,
  orderdate      DATETIME     NOT NULL,
  requireddate   DATETIME     NOT NULL,
  shippeddate    DATETIME     NULL,
  shipperid      INT          NOT NULL,
  freight        MONEY        NOT NULL
    CONSTRAINT DFT_Orders_freight DEFAULT(0),
  shipname       NVARCHAR(40) NOT NULL,
  shipaddress    NVARCHAR(60) NOT NULL,
  shipcity       NVARCHAR(15) NOT NULL,
  shipregion     NVARCHAR(15) NULL,
  shippostalcode NVARCHAR(10) NULL,
  shipcountry    NVARCHAR(15) NOT NULL,
  Final_Sales_Price MONEY NOT NULL,
  CONSTRAINT PK_Orders PRIMARY KEY(orderid),
  CONSTRAINT FK_Orders_Customers FOREIGN KEY(Cust_ID)
    REFERENCES Customers(Cust_ID),
);

CREATE NONCLUSTERED INDEX idx_nc_Cust_ID        ON Orders(Cust_ID);
CREATE NONCLUSTERED INDEX idx_nc_orderdate      ON Orders(orderdate);
CREATE NONCLUSTERED INDEX idx_nc_shippeddate    ON Orders(shippeddate);
CREATE NONCLUSTERED INDEX idx_nc_shippostalcode ON Orders(shippostalcode);



CREATE TABLE Vehicle
(
  VIN    INT          NOT NULL IDENTITY,
  Make  NVARCHAR(40) NOT NULL,
  Model  NVARCHAR(40) NOT NULL,
  Year_Manufactured      DATETIME     NOT NULL,
  Colour  NVARCHAR(40) NOT NULL,
  Milage  INT NOT NULL,
  supplierid   INT          NOT NULL,
  Finalprice    MONEY        NOT NULL
    CONSTRAINT DFT_Vehicle_Finalprice DEFAULT(0),
  CONSTRAINT PK_Vehicle PRIMARY KEY(VIN),
  CONSTRAINT CHK_Vehicle_Finalprice CHECK(Finalprice >= 0)
);


CREATE TABLE Suppliers
(
  supplier_id   INT          NOT NULL IDENTITY,
  Supplier_name  NVARCHAR(40) NOT NULL,
  Supplier_Location NVARCHAR(40) NOT NULL,
  contactname  NVARCHAR(30) NOT NULL,
  contacttitle NVARCHAR(30) NOT NULL,
  address      NVARCHAR(60) NOT NULL,
  city         NVARCHAR(15) NOT NULL,
  region       NVARCHAR(15) NULL,
  postalcode   NVARCHAR(10) NULL,
  country      NVARCHAR(15) NOT NULL,
  phone        NVARCHAR(24) NOT NULL,
  fax          NVARCHAR(24) NULL,
  CONSTRAINT PK_Suppliers PRIMARY KEY(supplier_id)
);

CREATE NONCLUSTERED INDEX idx_nc_companyname ON Suppliers(Supplier_name);
CREATE NONCLUSTERED INDEX idx_nc_postalcode  ON Suppliers(postalcode);


create table Accounts(
Account_ID  INT      NOT NULL IDENTITY,
Cust_ID INT          NOT NULL,
orderid   INT           NOT NULL,
orderdate      DATETIME     NOT NULL,
Final_Sales_Price MONEY NOT NULL,
Previous_Balance  INT      NOT NULL,
Last_Payment   INT          NOT NULL,
Last_Payment_Date     DATETIME    NOT NULL 
CONSTRAINT PK_Accounts PRIMARY KEY(Account_ID)
CONSTRAINT FK_Accounts_Customers FOREIGN KEY(Cust_ID)
    REFERENCES Customers(Cust_ID),
	CONSTRAINT FK_Accounts_Orders FOREIGN KEY(orderid)
    REFERENCES Orders(orderid),
)

CREATE TABLE Employees
(
  empid           INT          NOT NULL IDENTITY,
  lastname        NVARCHAR(20) NOT NULL,
  firstname       NVARCHAR(10) NOT NULL,
  title           NVARCHAR(30) NOT NULL,
  titleofcourtesy NVARCHAR(25) NOT NULL,
  birthdate       DATETIME     NOT NULL,
  hiredate        DATETIME     NOT NULL,
  address         NVARCHAR(60) NOT NULL,
  city            NVARCHAR(15) NOT NULL,
  region          NVARCHAR(15) NULL,
  postalcode      NVARCHAR(10) NULL,
  country         NVARCHAR(15) NOT NULL,
  phone           NVARCHAR(24) NOT NULL,
  mgrid           INT          NULL,
  CONSTRAINT PK_Employees PRIMARY KEY(empid),
  CONSTRAINT FK_Employees_Employees FOREIGN KEY(mgrid)
    REFERENCES Employees(empid),
  CONSTRAINT CHK_birthdate CHECK(birthdate <= CURRENT_TIMESTAMP)
);


ALTER TABLE Orders 
ADD  empid          INT          NOT NULL;

Alter table Orders add  CONSTRAINT FK_Orders_Employees FOREIGN KEY(empid)
REFERENCES Employees(empid)


























# queries Adventurework 2014
--1
select * from production.Product
--2
select ProductID,Name,ProductNumber,ListPrice from Production.Product
--3
select ProductID,Name,ProductNumber,ListPrice from Production.Product
where ListPrice = 0
--4
select ProductID,Name,ProductNumber,ListPrice from Production.Product
where ListPrice >0 and ListPrice <10
--5
select ProductID,Name,ProductNumber,ListPrice from Production.Product
where ListPrice =9.5 or ListPrice =2.29
  --6 
   select 
    FirstName, 
    MiddleName, 
    LastName,
     FirstName + ' ' + MiddleName + ' ' + LastName as MailingName
FROM Person.Person
--7
select  distinct(JobTitle) from HumanResources.Employee order by JobTitle desc
--8
select LastName+' '+FirstName as "Employee Name", jobTitle as "Job Title", HireDate as "Date Hired"  from Person.Person p
inner join HumanResources.Employee E on p.BusinessEntityID=E.BusinessEntityID order by 1,2;
--9


select LastName+' '+FirstName as "Employee Name", jobTitle as "Job Title", DATEDIFF(YY, E.BirthDate,GETDATE()) as AGE  from Person.Person p
inner join HumanResources.Employee E on p.BusinessEntityID=E.BusinessEntityID 
--10
select  LastName+' '+FirstName as "Employee Name", jobTitle as "Job Title", max(VacationHours) 
from Person.Person p
inner join HumanResources.Employee E on p.BusinessEntityID=E.BusinessEntityID 
--11
select top 1 P.LastName+' '+P.FirstName as "Employee Name", E.jobTitle as "Job Title", E.VacationHours  from Person.Person p
inner join HumanResources.Employee E on p.BusinessEntityID=E.BusinessEntityID
where VacationHours=(select max(VacationHours) from HumanResources.Employee)
--12
select count(P.TerritoryID) as"Number of Sales Territories"from Sales.SalesTerritory P ;
--13
select sum(P.SalesYTD) as"Sum of all Sales"from Sales.SalesTerritory P ;
--14

select sum(SalesYTD) as 'Sum of All Sale', avg(SalesYTD)  as 'Average Sale',
min(salesYTD) as 'Minimum Sale',max(salesYTD) as 'Maximum Sale' from Sales.SalesPerson
--15
Insert into Person.CountryRegion(CountryRegionCode,Name,ModifiedDate)values('Paresh','Paresh',GETDATE())
select * from person.CountryRegion P where P.CountryRegionCode='Paresh'
--16
update Person.CountryRegion set Name='Paresh',ModifiedDate=GETDATE() where CountryRegionCode='Paresh'
select * from person.CountryRegion p where p.CountryRegionCode='Paresh'
--17
delete from Person.CountryRegion  where CountryRegionCode='Paresh'
select * from person.CountryRegion p where p.CountryRegionCode='Paresh'
--18
SELECT GETDATE() 'Current date and time'
--19
SELECT  FORMAT(GETDATE(),'MMMM') 'Current Month'
--20
SELECT GETDATE() 'Today', 
           DATEADD(d,-2,GETDATE())







--cross tabs
--4
 SELECT lastname,"2018","2020"
FROM 
   ( SELECT lastname, year(o.orderdate) as Year
     FROM dbo.Employees E  join dbo.Orders O on E.empid=O.empid
   ) ps
PIVOT
   (count(Year)
     FOR Year IN ( [2018], [2020])
   ) AS pvt
   
   