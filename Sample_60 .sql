
----------------------------------------------------
--PART-1
----------------------------------------------------

USE [SIS]
 
--1
SELECT *
 FROM [dbo].[AcademicStatus]
 
--2
SELECT [number],[academicStatusCode]
 FROM [dbo].[Student] WHERE [academicStatusCode] = 'D'
 ORDER BY [number] DESC
 
--3
SELECT [number],[academicStatusCode]
 FROM [dbo].[Student] WHERE [academicStatusCode] = 'D' or [academicStatusCode] = 'S'
 ORDER BY [number] ASC

--4
SELECT [number],[academicStatusCode]
 FROM [dbo].[Student] WHERE NOT [academicStatusCode] = 'N'
 ORDER BY [number] ASC

--5
SELECT [number],[academicStatusCode]
 FROM [dbo].[Student] WHERE [academicStatusCode] != 'N'
 ORDER BY [number] ASC
 
--6
SELECT DISTINCT [countryCode]
 FROM [dbo].[Person]
 
 --7
 SELECT [id]
 ,[amountPerSemester] as [Current Fee]
 ,[amountPerSemester]/100*10+[amountPerSemester] as [Increased Fee]
 ,[item] as [Incidental Fee Item]
 ,[frenchItem]
 FROM [dbo].[IncidentalFee] order by[item] asc

 --8
SELECT [studentNumber]
 ,[finalMark]
 FROM [dbo].[CourseStudent] where [finalMark] between 1 and 54 
 
 --9
 SELECT [number]
 FROM [dbo].[Room] where [memory] ='4GB' and [campusCode] = 'D' and [capacity] >= 40
 
 --10
 SELECT [number]
 FROM [dbo].[Employee] where [schoolCode]='TAP' and [campusCode] in ('D','G','W')
 
--------------------------------------------------------------------
 --PART-2
 -----------------------------------------------------------------
-- Using SIS Database--
		USE SIS
-- 1.getting list of courses which are available in the table
		SELECT DISTINCT [courseNumber] FROM [dbo].[CoursePrerequisiteAnd]

	--or 
		SELECT [courseNumber] FROM [dbo].[CoursePrerequisiteAnd]
		GROUP BY [courseNumber]

--result : there is 36 different course are available

-- 2.finding how many students got marks between 50 to 80 in finalmark 
		SELECT [studentNumber],[finalMark] FROM [dbo].[CourseStudent]
			WHERE [finalMark] BETWEEN 50 AND 80

		--or

		SELECT [studentNumber],[finalMark] FROM [dbo].[CourseStudent]
			WHERE [finalMark]>=50 AND [finalMark]<= 80

--result: there is 452 student who got finalmark between 50 to 80

-- 3.counting how many students are in course 1

		SELECT COUNT (DISTINCT [studentNumber]) AS [total_students] FROM [dbo].[CourseStudent]
			WHERE [CourseOfferingId] = 1

-- 4.selecting only those who have valid schoolCode

		SELECT *   FROM [dbo].[Employee]
			WHERE NOT [schoolCode] IS NULL

-- 5.selecting only those who have valid businessPhone and Fax.

	--using OR
		SELECT * FROM [dbo].[Employee]
			WHERE NOT ([businessPhone] IS NULL OR [fax] IS NULL)

	--or
	-- using AND
		SELECT * FROM dbo.Employee
			WHERE [businessPhone] IS NOT NULL AND [fax] IS NOT NULL


	--from Select fundamentals Part 2

-- 6.selecting data which contain 'doon' in location column.

		SELECT [number],[campusCode],location,[schoolCode] FROM [dbo].[Employee]
			WHERE [location] LIKE '%Doon%'

-- 7.summarizing(Average,maximum,minimum) of finalmark column from table CourseStudent, finalmark with 0 will not count
		SELECT AVG([finalMark]) as [Average],MAX([finalMark]) AS [Maximum], MIN([finalMark]) AS [minimum]
		FROM [dbo].[CourseStudent]
		WHERE NOT [finalMark] = 0

	


-- 8.getting maximum and minimum marks from individual courses

		 SELECT [CourseOfferingId],MAX([finalMark]) AS [Maximum_marks],MIN([finalMark]) AS [minimum_marks] FROM [dbo].[CourseStudent]
			GROUP BY [CourseOfferingId] HAVING MAX([finalMark])>0

--https://dev.mysql.com/doc/refman/8.0/en/select.html

-- 9.joining courseoffering and course table and showing importants column
		SELECT [c].[number],[c].[hours],[c].[credits],[c].[name],[co].[capacity],[co].[sessionCode]
		 from [dbo].[Course] as [c]
		 inner join [dbo].[CourseOffering] as [co]
		 on [co].[courseNumber]= [c].[number]
		 order by [c].[name] ASC

-- 10.joining two tables and fetching maximum time from individual course
  
		  SELECT cs.CourseOfferingId,MAX(time) as maximum_time,MIN(time) as minimum_time from dbo.ClassSchedule as cs
		  join dbo.[Day] as [day] on cs.dayCode = day.code
		  group by cs.CourseOfferingId
		  Having NOT Max(time)<10


-- 11.joining two tables and making campuscode and schoolcode single column as capus_school_code

		 SELECT [p].[code],[p].[acronym],[p].[campusCode]+'_'+[p].[schoolCode] as [campus_school_code],
		 [cr].[name] as [credential_name],[cr].[frenchName] as [credential_FrenchName]
		 from [dbo].[Credential] as [cr]
		 left join [dbo].[Program] as [p]
		 on [cr].[code] = [p].[credentialCode]
		 WHERE [p].[campusCode] = 'D'

-- 12.joining 3 tables and fetching only those data where time is greater than or equal to 10.

		 SELECT [cs].[id],[cs].[CourseOfferingId],[cs].[roomId],[cs].[time],[cs].[duration],
			[d].[name] as [day],[d].[frenchName] as [day_frenchname],
			[co].[courseNumber],[co].[sectionNumber],[co].[sessionCode],[co].[employeeNumber],[co].[capacity],[co].[enrollment]
		  FROM [dbo].[ClassSchedule] AS [cs]
		  left join [dbo].[Day] AS [d] ON [cs].[dayCode] = [d].[code]
		  left join [dbo].[CourseOffering] as [co] ON [cs].[CourseOfferingId] = [co].[id]
		  WHERE [cs].[time] >=10

  --from:https://dev.mysql.com/doc/refman/8.0/en/join.html

--13 List number and balance from student table where balance is less than or equal to zero
			select [number],[balance] from [Student] where [balance] <= 0

--14 List the data from student program and student table  where student semester is 3(innerjoin/where)
			SELECT [studentNumber]
      ,[programCode]
      ,[semester]
      ,[programStatusCode]
  		FROM [dbo].[StudentProgram] A inner join [dbo].[student] B on 
 		 A.[studentNumber] = B.[number] where [semester] = 3

--15 List the studentNumber,semester and explanation from StudentProgram and StudentProgramStatus (innerjoin)
			SELECT [studentNumber]
    	,[semester]
	  	,[explanation]
  		FROM [dbo].[StudentProgram] A inner join [dbo].[StudentProgramStatus] B on 
  		A.[programStatusCode] = B.[code] 

--16 List all the data from two [Student] and [StudentOffence](Full join/where)
			SELECT * FROM [dbo].[Student] A full join [dbo].[StudentOffence] B on
 		 A.[number] = B.[studentNumber] where B.[penaltyCode] = 'A'

--17 List the data product as Software from software table where product  containg sub string  "AutoCAD"
--, product end with "ft" and product start with Pu"(String "like")
			select [product] as [Software] from [dbo].[Software] A where A.[product] like '%AutoCAD%'
			select [product] as [Software] from [dbo].[Software] A where A.[product] like 'Pu%'
			select [product] as [Software] from [dbo].[Software] A where A.[product] like '%ft'

--18 List the code and name as SchoolName and name as ProgramName  from [School] and [Program]
--(left join, changing column name on Output)
  		SELECT A.[code],A.[name] as [SchoolName],B.[name] as [ProgramName]
  		FROM [dbo].[School] A left join [dbo].[Program] B on
  		A.[code] = B.[schoolcode] 
-- and 
  		SELECT A.[code],A.[name] as [SchoolName],B.[name] as [ProgramName]
 	 		FROM [dbo].[School] A right join [dbo].[Program] B on
 	 		A.[code] = B.[schoolcode] 

--19 List the data from [Program] and [ProgramCourse] where semester is less than 3
--and display the result in acsending order following semester. 
			SELECT A.[code],A.[name] as [ProgramName], B.[courseNumber],B.[semester]
  		FROM [dbo].[Program] A inner join [dbo].[ProgramCourse] B on
  		A.[code] = B.[programCode] where B.[semester]>3 order by[semester] asc

--20 Show the important data from [Program],[ProgramCourse], and ProgramFee] (Multiple joins) 
SELECT A.[code],A.[name] as [ProgramName], B.[courseNumber]  ,C.[semester]
    	,C.[tuition]
    	,C.[internationalTuition]
  		FROM [dbo].[Program] A inner join [dbo].[ProgramCourse] B on  A.[code] = B.[programCode]
  		inner join [dbo].[ProgramFee] C on B.[programCode] =  C.[code] order by C.[semester] asc


--21Show the important data from [Program],[ProgramCourse], and ProgramFee] where international 
-- fee and tution fee are not equal to zero  (Multiple joins/where/order/multiple conditions)
			SELECT A.[code],A.[name] as [ProgramName], B.[courseNumber]  ,C.[semester]
    	,C.[tuition]
    	,C.[internationalTuition]
 		 FROM [dbo].[Program] A inner join [dbo].[ProgramCourse] B on  A.[code] = B.[programCode]
 		 inner join [dbo].[ProgramFee] C on B.[programCode] =  C.[code] 
 		 where C.[internationalTuition] != 0 and C.[tuition] !=0
 		 order by C.[semester] asc

--22 List all the data from Room table where operatingsystem is not NULL and memory is equal tp 2GB.
--(use of is not null/and)
			select * from [dbo].[Room] where [operatingSystem] is not Null and [memory] = '2GB'


--23 List the important data from [Campus] and [room] where capacity is less than 35,
--not greater than 40 and order the data in ascending.(use of between/order)
			 select A.[name] as [CampusName]
	  	,[capacity]
      ,[operatingSystem]
      ,[dvd]
      ,[hardDriveSize]
      ,[memory]
      ,[monitor]
      ,[motherboard]
      ,[processor]
      ,[printer]
      ,[video]
      ,[switch]  from [dbo].[Campus] A inner join [dbo].[room] B 
	  on A.[code] = B.[campusCode] where B.[capacity] between 36 and  40 order by B.[capacity] asc

--24 List the data from [InvoiceItem]  where amount is 486.74 and line is 2(use of nested select)
			SELECT  * FROM  [dbo].[InvoiceItem] where amount = (select amount FROM  [dbo].[InvoiceItem] where line=2 )

--25  Which subject has 60 minutes lecture time and also has 4 credits
			SELECT  [name] as Subject
      ,[hours] as Lecture_time
      ,[credits] 
			FROM [SIS].[dbo].[Course]
			Where hours>= 60 AND credits =4;

--26 Which subject's number starts with CO pattern 
			SELECT [number],[name]
			FROM [SIS].[dbo].[Course]
			where [number] LIKE 'CO%';

--27 Its shows countrys which has length more than 7
			SELECT  [Code],[alpha2Code],[name],(LEN([name])) AS Country_length,[frenchName]
			FROM [SIS].[dbo].[Country] 
			Where LEN([name]) >7

--28 To shows userid, roleName and password together
			SELECT [Account].userId, [AccountRole].roleName, [Account].password
			FROM [SIS].[dbo].[Account]
			INNER JOIN [SIS].[dbo].[AccountRole] ON Account.userId=AccountRole.userId;

--29  A student who has sessioncode null, semester 3 and he is international student 
			SELECT [id],[date],[time],[userId],[studentNumber],[isInternational],[programCode]
      ,[semester],[sessionCode],[invoiceNumber],[paymentNumber]
			FROM [SIS].[dbo].[Audit]
			where [sessionCode] IS NULL AND [semester] = 3 AND [isInternational] = 1;  

--30 Howmany payment has done based on group of invoiceNumber
			SELECT [invoiceNumber] ,count([paymentNumber]) as Number_of_payment 
			FROM [SIS].[dbo].[Audit]  
			GROUP BY [invoiceNumber]  ;

--31 distinct studentNumber  who are not internal student
			SELECT  DISTINCT[studentNumber],[isInternational],[programCode],[semester]
			FROM [SIS].[dbo].[Audit]
			where [isInternational] = 0;
 
--32 Only distinct studentnumber who has amount only between 550 and 1000 
			SELECT Distinct [studentNumber],[programCode],[semester],[amount]
			FROM [SIS].[dbo].[Audit]
			where [amount] BETWEEN 500 AND 1000

--33 Average, Maximum and Minimum of those recored who is doing 1st semester and has amount more than 4000  
			SELECT AVG(balanceAfter) as Average,MAX(balanceAfter) AS Maximum, MIN(balanceAfter) AS minimum
			FROM [SIS].[dbo].[Audit]
			where semester = 1 and amount > 4000;
 
--34 Joining with Student, FinancialStatus, AcademicStatus where student is international and his academic status is only normal
			select  Distinct St.number,St.academicStatusCode ,Ac.explanation as Academic ,St.financialStatusCode , Fs.explanation As financial,
      St.isInternational, St.localCity, St.localPhone
			from SIS.dbo.Student as St
			JOIN AcademicStatus as Ac ON Ac.code = St.academicStatusCode
			JOIN FinancialStatus as Fs ON  Fs.code= St.financialStatusCode
			Where St.isInternational = 0 and Ac.explanation !='Discontinued';
 
--35 sorting by student number and amount
			SELECT [date],[time],[userId],[auditCategoryCode],[studentNumber]
      ,[amount],[isInternational],[programCode],[incidentalFee]
      ,[coopFeePerSemester],[coopFeeMultiplier],[coopFee]
      ,[balanceBefore],[balanceAfter]
			FROM [SIS].[dbo].[Audit]
			order by [studentNumber],[amount];


--36 Total number of invoice and total amount 
			SELECT count([invoiceNumber]) as total_invoice
			,sum([amount]) as total_amount
			FROM [SIS].[dbo].[InvoiceItem]


--37 Display only tution table 
            SELECT  DISTINCT  [tuition]
             FROM [SIS].[dbo].[ProgramFee]
			 

--38 To show only the data from semester 3 and one where only studentcode is displayed.
            SELECT * 
         FROM [SIS].[dbo].[ProgramCourse]
         where semester = 3;

         SELECT  [programCode] AS STUDENTCODE
         FROM [SIS].[dbo].[ProgramCourse]


--39  Display acronym which starts with IT.
	        SELECT 
         [code]
        ,[acronym]
        ,[campusCode]
        ,[schoolCode]
        ,[credentialCode]
        ,[name]
        ,[frenchName]
         FROM [SIS].[dbo].[Program]
         WHERE [acronym]LIKE'IT%';

--40   To show  Provincecode is null.
         SELECT  DISTINCT [COUNTRYCODE],[PROVINCECODE]
         FROM [SIS].[dbo].[Person]
         WHERE provinceCode IS NULL;

--41 Display Lastname ,Firstname and city in acsending order.
         SELECT  [lastName],[firstName],[city]
         FROM [SIS].[dbo].[Person]
         ORDER BY city ASC;

--42  Display time Between 8 and 11.
		  SELECT  [id]
         ,[CourseOfferingId]
         ,[roomId]
         ,[dayCode]
         ,[time]
         ,[duration]
          FROM [SIS].[dbo].[ClassSchedule]
          where [time] BETWEEN 8 AND 11 

--43   Duration of class schedule is not equal to 3.
		    
            SELECT  [id]
         ,[CourseOfferingId]
         ,[roomId]
         ,[dayCode]
         ,[time]
         ,[duration]
         FROM [SIS].[dbo].[ClassSchedule]
         WHERE duration != 3;

--44  Invoice item   amount is greater or equal to 3380.
		   SELECT [invoiceNumber]
         ,[line]
         ,[amount]
         ,[item]
         ,[frenchItem]
         FROM [SIS].[dbo].[InvoiceItem]
         where amount >= 3380;

--45  Program fee for international tuition is less than or equal to zero.
         SELECT  [code]
         ,[semester]
         ,[tuition]
         ,[internationalTuition]
         ,[chargeIncidentalFee]
         ,[coopFeeMultiplier]
          FROM [SIS].[dbo].[ProgramFee]
		  where internationalTuition <=0;

--46  Corurse offering with enrollment is less than 24.
           SELECT  [id]
         ,[sessionCode]
         ,[courseNumber]
         ,[sectionNumber]
         ,[employeeNumber]
         ,[capacity]
         ,[enrollment]
         FROM [SIS].[dbo].[CourseOffering]
          where enrollment <24;

--47 To show Program status code is A and semester is 1.
		    
         SELECT [studentNumber]
         ,[programCode]
         ,[semester]
         ,[programStatusCode]
         FROM [SIS].[dbo].[StudentProgram]
         WHERE [programStatusCode] = 'A'
         AND semester = 1;

 --48  Display Payment amount between 400 and 1000.
		  SELECT  [id]
         ,[studentNumber]
          ,[invoiceNumber]
          ,[number]
         ,[transactionDate]
         ,[paymentMethodId]
         ,[amount]
          FROM [SIS].[dbo].[Payment]
          WHERE amount BETWEEN 400 AND 1000; 

			

-- 49 Selecting the column name country and converting in to number_length and getting the length og the country whose number exceeds the 10 or equal to 10.
			SELECT  [Code],[alpha2Code],[name] AS Country,(LEN([name])) AS Country_length,[frenchName]
			FROM [SIS].[dbo].[Country] 
			Where LEN([name]) >10

-- 50. Selecting the amount from the InvoiceItem which is greater than 100.
			SELECT * FROM [SIS].[dbo].[InvoiceItem] 
			WHERE amount>=100;

-- 51 Selecting number and balance from the student table which is less than and equal to 0.
			SELECT [number],[balance] FROM [SIS].[dbo].[Student] WHERE [balance] <= 0

-- 52 Selecting the balance from the Student table which is greater than 0 and order by in the ascending number 
			SELECT [number], [localStreet], [localCity],[localCountryCode],[balance]    FROM [SIS].[dbo].[Student] WHERE [balance]>0  ORDER BY number ASC;

-- 53 Selecting the details from the Software where the column FrenchProduct Starts with A.
			SELECT * FROM [SIS].[dbo].[Software] WHERE [frenchProduct] LIKE'A%';

-- 54 Selecting some columns from the Audit table where sessionCode column's value is NULL.

			SELECT [studentNumber],[invoiceNumber],[paymentNumber],[programCode] FROM [SIS].[dbo].[Audit] WHERE [sessionCode] IS NULL;
-- 55 Selecting Code,semester,tution,internationalTuition,chargeIncidentalFee,coopFeeMultiplier, and the expression coopFeeMultiplier * 10 as "increasedMultiplier" from ProgramFee table
			SELECT [code],[semester],[tuition],[internationalTuition],[chargeIncidentalFee],[coopFeeMultiplier],[coopFeeMultiplier]*10 As "increasedMultiplier" FROM [SIS].[dbo].[ProgramFee] 


--  56 Selecting all columns from StudentProgram Where programStatusCode are either A and G
			SELECT * FROM [SIS].[dbo].[StudentProgram] WHERE programStatusCode IN ('A','G');

-- 57 Selecting all columns from StudentOffence where penaltycode is A
			SELECT * FROM [SIS].[dbo].[StudentOffence] WHERE penaltyCode='A';

-- 58 Selecting number, isInternational , balance, localcity, localphone from Student table where balance is Between 0 and 1000
			SELECT [number],[isInternational],[balance],[localCity],[localPhone] FROM [SIS].[dbo].[Student] WHERE [balance] BETWEEN 0 AND 1000;

-- 59 Selecting all columns from the Program where credentilaCode is either OCD and OCGC
			SELECT * FROM [SIS].[dbo].[Program] WHERE credentialCode IN('OCD','OCGC');

-- 60  Selecting all columns from Room table where dvd is not NULL and memory is greater than 2 or robotel is equal to 1
			SELECT * FROM [SIS].[dbo].[Room] WHERE [dvd] !=NULL AND [memory]>2 OR [robotel]=1; 