--Author: Nick Stevens (W0442783)
--Date: 01/30/2023
--Description: DBAS4002 Assignment 1

--1.(Chinook db) Display the First Name, Last Name of each customer along with the First Name and Last Name of their support rep, sorted by 
--	customer last and first names. Give the support rep columns an appropriate alias.  (59 records)
USE Chinook

SELECT CONCAT(cust.LastName, ', ', cust.FirstName) AS Customer,
	   CONCAT(emp.LastName, ', ', emp.FirstName) AS 'Support Rep'
	   

FROM Employee emp
	INNER JOIN Customer cust ON emp.EmployeeId = cust.SupportRepId
	
ORDER BY cust.LastName, cust.FirstName, emp.LastName, emp.FirstName
;

--2.(Chinook db) Display the track name, genre name, and mediatype name for each track in the database, sorted by track name. (3503 records)
USE Chinook

SELECT trk.Name,
	   gen.Name,
	   medT.Name

FROM Track trk
	INNER JOIN Genre gen	  ON gen.GenreId = trk.GenreId
	INNER JOIN MediaType medT ON medT.MediaTypeId = trk.MediaTypeId

ORDER BY trk.Name
;

--3.(Chinook db) Display the name of every artist and the total number of albums each artist has available for sale. 
--	Results should show the highest totals first. (275 records)
USE Chinook

SELECT art.Name,
	   COUNT(alb.AlbumId)

FROM Artist art
	INNER JOIN Album alb ON art.ArtistId = alb.ArtistId

GROUP BY art.name
;

--4.(Chinook db) Display the first name and last name of each customer along with a unique list of the types of media that they have purchased. (128 records)
USE Chinook

SELECT DISTINCT 
	   cust.FirstName,
	   cust.LastName,
	   medt.Name AS 'Media Type'
	   

FROM Customer cust
	INNER JOIN Invoice inv		ON cust.CustomerId = inv.CustomerId
	INNER JOIN InvoiceLine invL ON inv.InvoiceId = invL.InvoiceId
	INNER JOIN Track trk		ON trk.TrackId = invL.TrackId
	INNER JOIN MediaType medt	ON medt.MediaTypeId = trk.MediaTypeId

;

--5.(Chinook db) Display the first name and last name of the single customer who has purchased the most video tracks. (1 record)
USE Chinook

SELECT TOP 1
	   CONCAT(cust.FirstName, ', ', cust.LastName) AS 'Customer',
	   COUNT(inv.InvoiceId) AS 'VideoTracksPurchased'

FROM Customer cust
	INNER JOIN Invoice inv		ON cust.CustomerId = inv.CustomerId
	INNER JOIN InvoiceLine invL ON inv.InvoiceId = invL.InvoiceId
	INNER JOIN Track trk		ON trk.TrackId = invL.TrackId
	INNER JOIN MediaType medt	ON medt.MediaTypeId = trk.MediaTypeId

WHERE medt.Name LIKE '%Video%'

GROUP BY inv.InvoiceId, cust.FirstName, cust.LastName
ORDER BY VideoTracksPurchased DESC
;

--6.(Chinook db) Display the name of the artist and number of orders for the single artist who has had the highest number orders of his/her music placed. (1 record)
USE Chinook

SELECT TOP 1 
	   art.Name,
	   COUNT(art.artistId) AS 'NumSold'

FROM  Artist art
	INNER JOIN Album alb		ON art.ArtistId = alb.AlbumId
	INNER JOIN Track trk		ON alb.AlbumId = trk.AlbumId
	INNER JOIN InvoiceLine invL ON trk.TrackId = invL.TrackId
	INNER JOIN Invoice inv		ON inv.InvoiceId = invL.InvoiceId


GROUP BY art.ArtistId, art.Name
ORDER BY 'NumSold' DESC
;

--7.(Chinook db) Display the TrackID and Track Name of any tracks that have not yet been purchased. (1519 records)
USE Chinook

SELECT trk.TrackId,
	   trk.Name

FROM Track trk
	LEFT JOIN InvoiceLine invL ON trk.TrackId = invL.TrackId

WHERE invL.InvoiceLineId IS NULL
;

--8.(Bookstore db) Using the ?b_? tables, display the first and last names of all authors who currently do not have any books listed, 
--	sorted author last/first name. (2 records)
USE Bookstore

SELECT B_AUTHOR.Fname,
	   B_AUTHOR.Lname

FROM B_AUTHOR
	LEFT JOIN B_BOOKAUTHOR ON B_BOOKAUTHOR.AUTHORid = B_AUTHOR.AuthorID

WHERE ISBN IS NULL
;

--9.(Bookstore db) Using the ?b_? tables, display the Customer number, First name, and Last name of any customers who have yet to place an order, 
--sorted customer last/first name. (6 records)
USE Bookstore

SELECT B_CUSTOMERS.FirstName,
	   B_CUSTOMERS.LastName

FROM B_CUSTOMERS 
	LEFT JOIN B_ORDERS ON B_CUSTOMERS.Customer# = B_ORDERS.Customer#

WHERE OrderDate IS NULL
;
	
--10.(Cars db) Using the Cars_Car_Types, Cars_Number_Of_Doors and Cars_Colors tables, 
--	create a query that returns every possible combination of the values of each table. (Hint: The result set should contain 24 rows.)
USE CarsDB

SELECT *

FROM CARS_CAR_TYPES CROSS JOIN CARS_NUMBER_OF_DOORS CROSS JOIN CARS_COLORS
;

--11.(Lunches db) List the employee ID, last name, and phone number of each employee with the name and phone number of his or her manager. 
--	Make sure that every employee is listed, even those that do not have a manager. Sort by the employee?s id number. (10 records)
USE LunchesDB

SELECT CONCAT(employee.FIRST_NAME, ', ', employee.LAST_NAME) AS 'Employee_Name',
	   employee.PHONE_NUMBER AS 'Employee_Phone',
	   CONCAT(manager.FIRST_NAME, ', ', manager.LAST_NAME) AS 'Manager_Name',
	   manager.PHONE_NUMBER AS 'Manager_Phone'

FROM L_EMPLOYEES employee
	LEFT OUTER JOIN L_EMPLOYEES manager ON employee.MANAGER_ID = manager.EMPLOYEE_ID
;

--12.(Multiple dbs) Create one full list of first names and last names of all customers from the Chinook tables, all authors from the Bookstore tables, 
--	all customers from the Bookstore tables, and all employees from the Lunches tables. Sort the list by last name and first name in ascending order. (103 records) 	
-- *** See note about this query below rubric ***
SELECT [FirstName]COLLATE DATABASE_DEFAULT
      ,[LastName]COLLATE DATABASE_DEFAULT
FROM [Chinook].[dbo].[Customer]
UNION 
SELECT [Lname]COLLATE DATABASE_DEFAULT
      ,[Fname]COLLATE DATABASE_DEFAULT
FROM [Bookstore].[dbo].[B_AUTHOR]
UNION 
SELECT [LastName]COLLATE DATABASE_DEFAULT
      ,[FirstName]COLLATE DATABASE_DEFAULT
FROM [Bookstore].[dbo].[B_CUSTOMERS]
UNION
SELECT [FIRST_NAME]COLLATE DATABASE_DEFAULT
      ,[LAST_NAME]COLLATE DATABASE_DEFAULT
FROM [LunchesDB].[dbo].[L_EMPLOYEES];

--13.(Numbers db) Using the Numbers_Twos and Numbers_Threes tables, 
--	show the results of a query that only displays numbers that do not have a matching value in the other table. (51 records)
USE NumbersDB

SELECT *

FROM NUMBERS_TWOS
	FULL OUTER JOIN NUMBERS_THREES ON NUMBERS_TWOS.MULTIPLE_OF_2 = NUMBERS_THREES.MULTIPLE_OF_3

WHERE MULTIPLE_OF_2 IS NULL
	OR MULTIPLE_OF_3 IS NULL
;

--14.(Numbers db) Using the Numbers_Twos and Numbers_threes tables, show the results of a query that only displays numbers that have a matching value in the other 
--	table. Here?s the catch: You are not permitted to use a WHERE clause or JOINs for this query. (17 records)
USE NumbersDB

SELECT *

FROM NUMBERS_TWOS 

INTERSECT

SELECT *

FROM NUMBERS_THREES
;
