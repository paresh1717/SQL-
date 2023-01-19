--Answers--

--Practical Question-1
USE [Finaldb]
GO
CREATE OR ALTER PROC [Sales].[SP_BOOKS_QUANTITY] 
(
	@book varchar(50),
	@PRICE INT Output,
	@bookname varchar(50) Output,
	@qty int Output,
	@totalprice int Output
	
)
WITH ENCRYPTION
AS
BEGIN
BEGIN TRY
	SELECT  @bookname=p.productname,@PRICE=p.unitprice,@qty = o.qty, @totalprice=(p.unitprice*o.qty)
	from Production.Products p Inner Join [Sales].[OrderDetails] o on o.productid=p.productid inner join  
	Production.Categories c ON p.categoryid=c.categoryid
	where c.categoryname like @book
	END TRY  
BEGIN CATCH
    THROW 50005, N'An error occurred',1;  
	
	SELECT ERROR_NUMBER() as ErrorNumber,
			  ERROR_MESSAGE() as ErrorMessage,
			  ERROR_PROCEDURE() as ErrorProcedure,
			  ERROR_STATE() as ErrorState,
			  ERROR_SEVERITY() as ErrorSeverity,
			  ERROR_LINE() as ErrorLine
			  
END CATCH;
END 
GO 


--execution
USE [Finaldb]
GO

DECLARE	@return_value int,
		@PRICE int,
		@bookname varchar(50),
		@qty int,
		@totalprice int

EXEC	@return_value = [Sales].[SP_BOOKS_QUANTITY]
		@book = N'Books',
		@PRICE = @PRICE OUTPUT,
		@bookname = @bookname OUTPUT,
		@qty = @qty OUTPUT,
		@totalprice = @totalprice OUTPUT

SELECT	@PRICE as N'@PRICE',
		@bookname as N'@bookname',
		@qty as N'@qty',
		@totalprice as N'@totalprice'

SELECT	'Return Value' = @return_value

GO
		
		
--Practical Question-2


USE [Finaldb]
GO
CREATE OR ALTER PROC [Sales].[EMPLOYEE_PERFORMANCE] 
(
	@hiredate datetime output,
	@empid varchar(50) Output,
	@empname varchar(50) Output,
	@bossid varchar(50) Output,
	@bossname varchar(50) Output,
	@outcome varchar(50) Output
)
WITH ENCRYPTION

AS
BEGIN
BEGIN TRY
	SELECT  @hiredate=e.hiredate,@empid=e.empid,@empname=e.firstname+' '+e.lastname,
	@bossid = e.mgrid,
	@bossname =e.firstname+' '+e.lastname 
	,@outcome=o.freight
	from [HR].[EMPLOYEES] e right join [Sales].[Orders] o on e.empid=o.empid 

	END TRY  
BEGIN CATCH
    THROW 50005, N'An error occurred',1; 
	
	SELECT ERROR_NUMBER() as ErrorNumber,
			  ERROR_MESSAGE() as ErrorMessage,
			  ERROR_PROCEDURE() as ErrorProcedure,
			  ERROR_STATE() as ErrorState,
			  ERROR_SEVERITY() as ErrorSeverity,
			  ERROR_LINE() as ErrorLine
END CATCH;
END
GO 
--Execution

DECLARE	@return_value int,
		@hiredate datetime,
		@empid varchar(50),
		@empname varchar(50),
		@bossid varchar(50),
		@bossname varchar(50),
		@outcome varchar(50)

EXEC	@return_value = [Sales].[EMPLOYEE_PERFORMANCE]
		@hiredate = @hiredate OUTPUT,
		@empid = @empid OUTPUT,
		@empname = @empname OUTPUT,
		@bossid = @bossid OUTPUT,
		@bossname = @bossname OUTPUT,
		@outcome = @outcome OUTPUT

SELECT	@hiredate as N'@hiredate',
		@empid as N'@empid',
		@empname as N'@empname',
		@bossid as N'@bossid',
		@bossname as N'@bossname',
		@outcome as N'@outcome'

SELECT	'Return Value' = @return_value

GO
--------Practical Question-3
USE [Finaldb]
GO

	CREATE OR ALTER PROC [Sales].[SP_all_record] 
( @custid int,
	 @supid int Output,
      @vender varchar(50) Output,
      @contactname varchar(50) Output,
      @country varchar(50) Output,
	  @prdid int Output,
	  @prdname varchar(50) Output,
	  @unitprice int Output,
	  @categoryname varchar(50) Output,
	  @categoryid int Output,
	  @shipname varchar(50) Output,
	@ship_city varchar(50) Output,
	@ship_region varchar(50) Output,
	@ship_country varchar(50) Output,
	@cmp_name varchar(50) Output
)
AS
BEGIN
BEGIN TRY
SELECT @supid=s.supplierid
      ,@vender=s.companyname
      ,@contactname=s.contactname
      ,@country=s.country
	  ,@prdid=p.productid
	  ,@prdname=p.productname
	  ,@unitprice=p.unitprice
	  ,@categoryname=c.categoryname
	  ,@categoryid=c.categoryid,
	  @shipname = o.shipname,
	@ship_city=o.shipcity,
	@ship_region =o.shipregion,
	@ship_country=o.shipcountry,
	@cmp_name=ss.companyname 
  FROM  Sales.Orders o inner join  Sales.Shippers ss on o.shipperid=ss.shipperid
  inner join  Sales.OrderDetails od on o.orderid=od.orderid
  inner join  [Production].[Products] p on od.productid=p.productid
  inner join  [Production].[Categories] c on p.categoryid=c.categoryid
  inner join  [Production].[Suppliers] s on s.supplierid=p.supplierid where o.custid=@custid
  	END TRY  
BEGIN CATCH
    THROW 50005, N'An error occurred',1; 
	
	SELECT ERROR_NUMBER() as ErrorNumber,
			  ERROR_MESSAGE() as ErrorMessage,
			  ERROR_PROCEDURE() as ErrorProcedure,
			  ERROR_STATE() as ErrorState,
			  ERROR_SEVERITY() as ErrorSeverity,
			  ERROR_LINE() as ErrorLine
END CATCH;
END
GO


-----Execution
USE [Finaldb]
GO

DECLARE	@return_value int,
		@supid int,
		@vender varchar(50),
		@contactname varchar(50),
		@country varchar(50),
		@prdid int,
		@prdname varchar(50),
		@unitprice int,
		@categoryname varchar(50),
		@categoryid int,
		@shipname varchar(50),
		@ship_city varchar(50),
		@ship_region varchar(50),
		@ship_country varchar(50),
		@cmp_name varchar(50)

EXEC	@return_value = [Sales].[SP_all_record]
		@custid = 1,
		@supid = @supid OUTPUT,
		@vender = @vender OUTPUT,
		@contactname = @contactname OUTPUT,
		@country = @country OUTPUT,
		@prdid = @prdid OUTPUT,
		@prdname = @prdname OUTPUT,
		@unitprice = @unitprice OUTPUT,
		@categoryname = @categoryname OUTPUT,
		@categoryid = @categoryid OUTPUT,
		@shipname = @shipname OUTPUT,
		@ship_city = @ship_city OUTPUT,
		@ship_region = @ship_region OUTPUT,
		@ship_country = @ship_country OUTPUT,
		@cmp_name = @cmp_name OUTPUT

SELECT	@supid as N'@supid',
		@vender as N'@vender',
		@contactname as N'@contactname',
		@country as N'@country',
		@prdid as N'@prdid',
		@prdname as N'@prdname',
		@unitprice as N'@unitprice',
		@categoryname as N'@categoryname',
		@categoryid as N'@categoryid',
		@shipname as N'@shipname',
		@ship_city as N'@ship_city',
		@ship_region as N'@ship_region',
		@ship_country as N'@ship_country',
		@cmp_name as N'@cmp_name'

SELECT	'Return Value' = @return_value

GO

-------Practical Question-4

CREATE OR ALTER PROC [Sales].[SP_5_groupby] 
AS
BEGIN
BEGIN TRY
SELECT o.custid, count(o.orderid)as FREQ, o.shipcity,o.shipregion,c.companyname from Sales.Orders o
inner join Sales.Customers c on o.custid=c.custid
group by o.custid,o.shipcity,o.shipregion,c.companyname
  	END TRY  
BEGIN CATCH
    THROW 50005, N'An error occurred',1; 
	
	SELECT ERROR_NUMBER() as ErrorNumber,
			  ERROR_MESSAGE() as ErrorMessage,
			  ERROR_PROCEDURE() as ErrorProcedure,
			  ERROR_STATE() as ErrorState,
			  ERROR_SEVERITY() as ErrorSeverity,
			  ERROR_LINE() as ErrorLine
END CATCH;
END

---Execution--

USE [Finaldb]
GO

DECLARE	@return_value int

EXEC	@return_value = [Sales].[SP_5_groupby]

SELECT	'Return Value' = @return_value

GO

----Practical Question-5






	USE [Finaldb]
GO
	CREATE OR ALTER PROC [Sales].[SP_SHIPPED_RECORDS] 
(
	@custid int,
	@ship_name varchar(50) Output,
	@ship_city varchar(50) Output,
	@ship_region varchar(50) Output,
	@ship_country varchar(50) Output,
	@cmp_name varchar(50) Output,
	@datediff int output
)
AS
BEGIN
BEGIN TRY
	SELECT  
	@ship_name = o.shipname,
	@ship_city=o.shipcity,
	@ship_region =o.shipregion,
	@ship_country=o.shipcountry,
	@cmp_name=s.companyname 
	from [Sales].[Orders] o Inner Join [Sales].[Shippers] s ON o.shipperid=s.shipperid
	where o.custid = @custid

	SELECT DATEDIFF(DAY,orderdate,shippeddate) as datediff from [Sales].[Orders]  where custid = @custid

	END TRY  
BEGIN CATCH
    THROW 50005, N'An error occurred',1; 
	
	SELECT ERROR_NUMBER() as ErrorNumber,
			  ERROR_MESSAGE() as ErrorMessage,
			  ERROR_PROCEDURE() as ErrorProcedure,
			  ERROR_STATE() as ErrorState,
			  ERROR_SEVERITY() as ErrorSeverity,
			  ERROR_LINE() as ErrorLine
END CATCH;
END 
GO 

--Execution
USE [Finaldb]
GO

DECLARE	@return_value int,
		@ship_name varchar(50),
		@ship_city varchar(50),
		@ship_region varchar(50),
		@ship_country varchar(50),
		@cmp_name varchar(50),
		@datediff int

EXEC	@return_value = [Sales].[SP_SHIPPED_RECORDS]
		@custid = 1,
		@ship_name = @ship_name OUTPUT,
		@ship_city = @ship_city OUTPUT,
		@ship_region = @ship_region OUTPUT,
		@ship_country = @ship_country OUTPUT,
		@cmp_name = @cmp_name OUTPUT,
		@datediff = @datediff OUTPUT

SELECT	@ship_name as N'@ship_name',
		@ship_city as N'@ship_city',
		@ship_region as N'@ship_region',
		@ship_country as N'@ship_country',
		@cmp_name as N'@cmp_name',
		@datediff as N'@datediff'

SELECT	'Return Value' = @return_value

GO
----Practical Question-6
USE [Finaldb]
GO
CREATE OR ALTER PROC [Sales].[SP_QTY_PRICE_CITY_EVAULATION] WITH ENCRYPTION
	AS
	BEGIN
	BEGIN TRY
		SELECT  c.city AS City_Code 
			  , sum(o_det.qty) AS 'Total Product Units Sold to city'
			  , sum(cast(((o_det.[unitprice]*o_det.[qty]) -(o_det.[unitprice]*o_det.[qty])*o_det.[discount]) as decimal(10,2))) AS 'Total Revenue Earned'
		FROM (([Sales].[Orders] o INNER JOIN [Sales].[OrderDetails] o_det ON o.orderid= o_det.orderid) 
		INNER JOIN [Sales].[Customers] c ON o.custid=c.custid) group by c.city;
	END TRY  
BEGIN CATCH
    THROW 50005, N'An error occurred',1; 
	
	SELECT ERROR_NUMBER() as ErrorNumber,
			  ERROR_MESSAGE() as ErrorMessage,
			  ERROR_PROCEDURE() as ErrorProcedure,
			  ERROR_STATE() as ErrorState,
			  ERROR_SEVERITY() as ErrorSeverity,
			  ERROR_LINE() as ErrorLine
END CATCH;		
	END
	GO

	

--ExecutionUSE B
USE [Finaldb]
GO

DECLARE	@return_value int

EXEC	@return_value = [Sales].[SP_QTY_PRICE_CITY_EVAULATION]

SELECT	'Return Value' = @return_value


---------------Practical Question-7

	CREATE OR ALTER PROC [Sales].[SP_7_discount_total_final] 
AS
BEGIN
BEGIN TRY
select o.orderid,p.productname,o.discount,(o.unitprice*o.qty) as total_price,
cast((o.unitprice*o.qty)-(o.discount*o.unitprice*o.qty) as decimal(10,4)) as final_price,
cast((o.unitprice*o.qty*o.discount) as decimal(8,2)) as discount_price from Sales.OrderDetails o inner join
Production.Products p on p.productid=o.productid
  	END TRY  
BEGIN CATCH
    THROW 50005, N'An error occurred',1; 
	
	SELECT ERROR_NUMBER() as ErrorNumber,
			  ERROR_MESSAGE() as ErrorMessage,
			  ERROR_PROCEDURE() as ErrorProcedure,
			  ERROR_STATE() as ErrorState,
			  ERROR_SEVERITY() as ErrorSeverity,
			  ERROR_LINE() as ErrorLine
END CATCH;
END
GO

--ExecutionUSE B

USE [Finaldb]
GO

DECLARE	@return_value int

EXEC	@return_value = [Sales].[SP_7_discount_total_final]

SELECT	'Return Value' = @return_value

GO


---------------Practical Question-8
CREATE OR ALTER PROC [Sales].[SP_8_freight ratio] 
AS
BEGIN
BEGIN TRY
select ode.orderid,p.productname,(ode.unitprice*ode.qty) as total_product_cost,
o.freight as Frieght_cost, o.freight/10 as freight_ratio from Sales.OrderDetails ode inner join
Production.Products p on p.productid=ode.productid inner join Sales.Orders o on o.orderid=ode.orderid
  	END TRY  
BEGIN CATCH
    THROW 50005, N'An error occurred',1; 
	
	SELECT ERROR_NUMBER() as ErrorNumber,
			  ERROR_MESSAGE() as ErrorMessage,
			  ERROR_PROCEDURE() as ErrorProcedure,
			  ERROR_STATE() as ErrorState,
			  ERROR_SEVERITY() as ErrorSeverity,
			  ERROR_LINE() as ErrorLine
END CATCH;
END
----EXECUTE
USE [Finaldb]
GO

DECLARE	@return_value int

EXEC	@return_value = [Sales].[SP_8_freight ratio]

SELECT	'Return Value' = @return_value

GO






--------------------------------------9 and 10------------------
-- Validate the ordered quanity is greater than the quantity present in stock
--why ?
--To ensure the avaliability of products in the placed orders. 
GO
CREATE OR ALTER TRIGGER product_stock ON [Sales].[OrderDetails] 
AFTER INSERT
AS
BEGIN
DECLARE @productid int
DECLARE @qnty int
DECLARE @orderid int
DECLARE @instock int


SELECT @productid =i.productid,@qnty=i.qty,@orderid=i.orderid from inserted i

--customer order quanity
SELECT @qnty=qty from Sales.OrderDetails where productid=@productid and orderid=@orderid
--Available stock
select @instock=instock from Production.Products where productid=@productid

if (@instock-@qnty)<0
	print(N'cannot place order as currently available stock is ')
	print(@instock)
END
GO

GO
DROP TRIGGER IF EXISTS product_stock

delete Sales.OrderDetails where orderid=10
INSERT Sales.OrderDetails (orderid, productid, unitprice, qty, discount,[Discounted_Values],Status) 
VALUES
(10, 5, 900,60, 0.1,1200,'Shipped')
SELECT * FROM Sales.OrderDetails


------------------------------------10-------------------------
--once order is Cancelled in Orders table the value in  Order_state will  change to "Cancelled" similarly we have to change the value in orderdetails table in status column.
---------------------------------------------------------------------------------------- 



CREATE TABLE Sales.Orders
(
  orderid        INT          NOT NULL IDENTITY,
  custid         INT          NULL,
  empid          INT          NOT NULL,
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
  Shipment_days  INT          NOT NULL,
  PromoNo		 INT NOT NULL DEFAULT (1),
  
  Payment_Type	 NVARCHAR(20) NOT NULL DEFAULT('Cash'),
  Order_state [nvarchar](50) NULL,

  CONSTRAINT PK_Orders PRIMARY KEY(orderid),
  CONSTRAINT FK_Orders_Customers FOREIGN KEY(custid)
    REFERENCES Sales.Customers(custid),
  CONSTRAINT FK_Orders_Employees FOREIGN KEY(empid)
    REFERENCES HR.Employees(empid),
  CONSTRAINT FK_Orders_Shippers FOREIGN KEY(shipperid)
    REFERENCES Sales.Shippers(shipperid),
	CONSTRAINT FK_Order_Discount FOREIGN KEY(PromoNo)
    REFERENCES Sales.Promo_code(PromoNo)
);

CREATE NONCLUSTERED INDEX idx_nc_custid         ON Sales.Orders(custid);
CREATE NONCLUSTERED INDEX idx_nc_empid          ON Sales.Orders(empid);
CREATE NONCLUSTERED INDEX idx_nc_shipperid      ON Sales.Orders(shipperid);
CREATE NONCLUSTERED INDEX idx_nc_orderdate      ON Sales.Orders(orderdate);
CREATE NONCLUSTERED INDEX idx_nc_shippeddate    ON Sales.Orders(shippeddate);
CREATE NONCLUSTERED INDEX idx_nc_shippostalcode ON Sales.Orders(shippostalcode);

GO

 Create table Sales.OrderDetails
CREATE TABLE Sales.OrderDetails
(
  orderid   INT           NOT NULL,
  productid INT           NOT NULL,
  unitprice MONEY         NOT NULL
  CONSTRAINT DFT_OrderDetails_unitprice DEFAULT(0),
  Ship_Type NVARCHAR(40)  DEFAULT (NULL),
  qty       SMALLINT      NOT NULL
    CONSTRAINT DFT_OrderDetails_qty DEFAULT(1),
  discount  NUMERIC(4, 3) NOT NULL
    CONSTRAINT DFT_OrderDetails_discount DEFAULT(0),
	Discounted_Values  MONEY  NOT NULL,
	Status nchar(10) NULL,
  CONSTRAINT PK_OrderDetails PRIMARY KEY(orderid, productid),
  CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY(orderid)
    REFERENCES Sales.Orders(orderid),
  CONSTRAINT FK_OrderDetails_Products FOREIGN KEY(productid)
    REFERENCES Production.Products(productid),
  CONSTRAINT CHK_discount  CHECK (discount BETWEEN 0 AND 1),
  CONSTRAINT CHK_qty  CHECK (qty > 0),
  CONSTRAINT CHK_unitprice CHECK (unitprice >= 0)
)
GO
CREATE NONCLUSTERED INDEX idx_nc_orderid   ON Sales.OrderDetails(orderid);
CREATE NONCLUSTERED INDEX idx_nc_productid ON Sales.OrderDetails(productid);
GO


UPDATE [Sales].[Orders]
   SET Order_state='Shipped'
 WHERE orderid in (9,10,11,12)

 UPDATE [Sales].[Orders]
   SET Order_state='Cancelled'
 WHERE orderid in (5,6,7,8)

 UPDATE [Sales].[Orders]
   SET Order_state='Active'
 WHERE orderid in (1,2,3,4)
 
 
------------------------------------------------------------------------------------
GO
CREATE OR ALTER TRIGGER order_sts ON [Sales].[Orders] 
AFTER UPDATE
AS
DECLARE @orderid int
DECLARE @status char

--DECLARE @orderid int
SELECT @status=i.Order_state,@orderid=i.orderid from inserted i

--customer order quanity
SELECT @status=Order_state from Sales.Orders where orderid=@orderid
--Available stock
--select @instock=instock from Production.Products where productid=@productid

if (@status='Cancelled')
BEGIN
	print(N'Order is cancelled ')
	print(@orderid)
	UPDATE [Sales].[OrderDetails]
	SET Status='Cancelled'
	WHERE orderid in (@orderid)


END


GO
select * from [Sales].[Orders]



UPDATE [Sales].[Orders]
   SET Order_state='Cancelled'
 WHERE orderid in (2)
 select * from [Sales].[Orders]
select * from [Sales].[OrderDetails]
