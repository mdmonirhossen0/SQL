								----------Create Database----------

Create Database TspDB
on primary
(
Name='TspDB_Data_1',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\TspDB_Data_1.mdf',
Size=25mb,
MaxSize=100mb,
FileGrowth=5%
)

log on
(
Name='TspDB_Log_1',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\TspDB_Log_1.ldf',
Size=2mb,
MaxSize=25mb,
FileGrowth=1%
)

								--------Use This Database--------	
Use TspDB
Go

								--------Table Create--------
								
	-----Course-----
Create Table Course
(
CourseID int primary key,
CourseName Varchar (50),
DurationMonth int null
)

	-----Round-----
Create Table Round
(
RoundID int primary key,
RoundName Varchar (30)
)
	-----TSP-----
Create Table Tsp
(
TspID int primary key,
TspName Varchar (50)
)

	-----Trainee-----
Create Table Trainee
(
TraineeID int primary key,
TraineeName Varchar (50),
RoundID int References Round(RoundID),
TspID int References Tsp(TspID),
CourseID int References Course(CourseID)
)

								-----Index-----
	-----Create Clustered Index-----
Create Clustered Index
on();

---Show Index In Query
Exec sp_helpindex TableName
	
	-----Create Non-Clustered Index-----

Create NonClustered Index CourseInfo
on Course(CourseName,DurationMonth)

---Show Index In Query
Exec sp_helpindex Course

								-----Alter Table-----
---Add a Column
Alter Table Tsp
Add AttendanceType Varchar(30)

---Drop column
Alter Table Tsp
Drop Column AttendanceType

								-----Drop Table-----
Drop Table Course;
Drop Table Round;
Drop Table Tsp;
Drop Table Trainee;

								-----Create View-----
go
Create View VwShortCourse As
Select CourseID,CourseName,DurationMonth From Course
Where DurationMonth<10
go
	----Create View with Only Encryption----
go
Create view vw_enc 
With Encryption
as
Select RoundID From Round;
go

	----Create View with Only Schemabinding----
go
Create view vw_sch
With Schemabinding 
as
select TspID
from dbo.Tsp
go

	----Create View with Encryption and Schemabinding Together----
go
Create view vw_together 
With Encryption,Schemabinding 
as
select CourseName from dbo.Course
go
	---Show View---
select * from VwShortCourse
select * from vw_enc
select * from vw_sch
select * from vw_together

								-----Function-----
			----Table valued Funtion----
go
create function fn_tr()
returns table
return
(
select * from trainee
)
go
select * from dbo.fn_tr()

			----Scalar Valued Function----
go
create function fn_Tsp()
returns int
begin
declare @k int
select @k=COUNT(*) from Tsp
return @k
end
go
select dbo.fn_Tsp()

			----Multi State Function----
go
create function fn_crs()
returns @OutTable 
table(courseID int,DurationMonth int ,Extendedmonth int)
begin
insert into @OutTable(courseID ,DurationMonth ,Extendedmonth)
select courseID,DurationMonth,DurationMonth+1
from course
return
end
go
select * from dbo.fn_crs()

								-----Other Function-----
	----Case----
go
Select DurationMonth,
Case
When DurationMonth < 10 then 'Short Course'
When DurationMonth > 11 then 'Long Course'
Else 'Normal'
End as CourseTime
from Course
go
	----Isnull----
go
Select CourseName,
ISNULL(CourseName,'ESAD-CS') as CourseTitle
from Course
go
	----Coalesce----
go
Select CourseName,
coalesce(CourseName,'ESAD-JEE') as CourseTitle
from Course
go
		----IIF----
go
select CourseName,
IIF (CourseName='ESAD-CS','Hard','Easy')
from Course
go
	----Choose----
go
Select courseID,courseName,
Choose(courseID, 'Demnadable','Requisition','Stipulation','Desired','provisional','Importunity')
as CourseReview
from course
go
	----Grouping----
go
Select TraineeID,TraineeName,CourseID,RoundID,TspID from Trainee
Where CourseID=3
group by TraineeID,TraineeName,CourseID,RoundID,TspID
go
	----Ranking----
 Select CourseID,CourseName, 
ROW_NUMBER() Over (Order By CourseID  Desc) as RowNumber, 
RANK() Over (Order By CourseID Desc) as CourseRank, 
DENSE_RANK() Over (Order By CourseID Desc) as DenseRank, 
NTILE(4) Over (Order By CourseID Desc) as CourseGroup
From Course;
	
	----Analytic----
go
Select TraineeID,TraineeName,
First_Value(TraineeName) Over (Order BY TraineeID) as FirstTraineeName,
Last_Value(TraineeName) Over (Order BY TraineeID) as LastTraineeName,
LEAD(TraineeName) Over (Order BY TraineeID) as NextTrainee,
LAG(TraineeName) Over (Order BY TraineeID) as PreviousTrainee,
PERCENT_RANK() Over (Order BY TraineeName) as PercentofTrainee,
CUME_DIST() Over (Order BY TraineeName) as CumulativeDist,
PERCENTILE_CONT(0.5) Within Group (Order BY TraineeID) Over () as PctTrainee,
PERCENTILE_DISC(0.75) Within Group (Order BY TraineeID) Over () as PtdTrainee
From Trainee;
go
								-----Merge-----
Create Table Faculty
(
FacultyID int primary key Identity(1,1),
FacultyName varchar (50)
)

Create Table Faculty_merge
(
FacultyID int primary key Identity(1,1),
FacultyName varchar (50)
)

merge into dbo.Faculty_merge as m
using dbo.Faculty as f
on m.FacultyID = f.FacultyID
when matched then 
update set m.FacultyName = f.FacultyName
when not matched then
insert(FacultyName)values(f.FacultyName); 

insert into Faculty(FacultyName)values('Umme Aimun Nesa');


select * from Faculty_merge
								-----Stored procedure-----
Go
create proc sp_Tsp
as
select * from Tsp
go

exec sp_Tsp

	----SP Insert----
go
create proc sp_insertTsp
@TspID int,
@TspName varchar(50)
as
insert into Tsp(TspID,TspName)
		values (@TspID,@TspName)
go

exec Sp_insertTsp
exec Sp_insertTsp '6','Jupiter IT'

select * from Tsp

	----SP Update----
go
create proc Sp_UpdateTsp
@TspID int,
@TspName varchar (50)
as
Update Tsp set TspName=@TspName
where TspID=@TspID
go

exec Sp_UpdateTsp '6','Dot com systems Ltd'
select * from Tsp

	----Sp Delete----
go
create proc sp_DeleteTsp
@TspID int
as
delete from Tsp where TspID=@TspID
go

exec sp_DeleteTsp '6'

select * from Tsp

	----SP with in Parameter----
go
create procedure SP_In
(@Tsp int output)
as
select COUNT(@Tsp) from Tsp

exec Sp_In '5'
	----SP Validation----

go
create proc SP_Exception
@tspID int
as
if 
@tspID>2
print 'Ok'
Else 
Throw 50001,'Notvalid',1;
go

exec SP_Exception 2