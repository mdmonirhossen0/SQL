use TspDB
go

								--------Insert--------
	----Course-----
Insert into Course(CourseID,CourseName,DurationMonth)
			values (1,'ESAD-CS',12),
					(2,'WDPF',11),
					(3,'Gave',9),
					(4,'ESAD-JEE',12),
					(5,'NT',11),
					(6,'DDD',12)
select * from Course

	----Round----
Insert into Round(RoundID,RoundName)
			values (1,'R-41'),
					(2,'R-43'),
					(3,'R-48'),
					(4,'R-51'),
					(5,'R-54'),
					(6,'R-55')
select * from Round
	----Tsp----
Insert into Tsp(TspID,TspName)
		values (1,'USSL'),
				(2,'Cogent'),
				(3,'APCL'),
				(4,'BITI'),
				(5,'BITL')
select * from Tsp

	----Trainee----
Insert into Trainee(TraineeID,TraineeName,RoundID,TspID,CourseID)
			values (0101,'Tanvir Ahmed',1,1,1),
					(0102,'Asaduzzaman',2,1,2),
					(0103,'Fahim Saleh',3,2,3),
					(0104,'Imteaj Sharif',4,3,4),
					(0105,'Saif Hassan',5,4,5),
					(0106,'Omar',6,5,6)
select * from Trainee

								--------Join--------
Select tr.TraineeID,tr.TraineeName,r.RoundName,t.TspName,c.CourseName  from Trainee tr
join Round r
on tr.RoundID=r.RoundID
join Tsp t
on tr.TspID=t.TspID
join Course c
on tr.CourseID=c.CourseID
where CourseName='ESAD-CS'

								--------Sub-Query--------
Select tr.TraineeID,tr.TraineeName,r.RoundName,t.TspName,c.CourseName  from Trainee tr
join Round r
on tr.RoundID=r.RoundID
join Tsp t
on tr.TspID=t.TspID
join Course c
on tr.CourseID=c.CourseID
where t.TspName in(select TspName from Tsp where TspID=4)
								--------Aggregate Function--------
		----Delete----
	---Delte a single Row---
Delete from Trainee where TraineeID=0103

	----Delete All Records----
Delete from Trainee

	----Count All Row----
select COUNT(*) as 'Number of Trainee' from Trainee

	----Count Only one Column Row----
Select COUNT(TraineeID) as 'Number of Trainee' from Trainee
	
	----Average----
Select AVG(DurationMonth) as 'AverageDuration' from Course

	----Summetion----
Select SUM(DurationMonth) as TotalCourseTime from Course

	----Maximum----
Select MAX(DurationMonth) as MaxCourseTime from Course

	----Minimum----
Select MIN(DurationMonth) as MinCourseTime from Course

			-----Order By-----
Select * from Course order by CourseID desc;

								--------Summary--------
	----Group By----
Select COUNT(TraineeID) as TotalCount,TraineeName from Trainee
Group By TraineeName

	----Having----
Select COUNT(DurationMonth) as [Number],CourseName from Course
Group By CourseName having Count(CourseID)<3
order by COUNT(CourseID) desc;

	----RollUp----
Select COUNT (TraineeID) as [ID],TraineeName from Trainee
Group By Rollup (TraineeName);

	----Cube----
Select CourseID,SUM(DurationMonth) as Length from Course
Group By Cube(CourseID)
Order By CourseID;

	----Grouping Sets----
Select CourseID,CourseName,DurationMonth from Course
Group By Grouping Sets(CourseID,CourseName,DurationMonth)

	----Over----
Select CourseID,CourseName,DurationMonth, Count(*) over(Partition By coursename) as OverColumn
from Course

			-----Exist-----
Select * From Course
Where Exists  (
Select *
From Trainee
Where Course.CourseId = Trainee.CourseId
);

			-----Not Exist-----
Select * From Course
Where Not Exists  (
Select *
From Trainee
Where Course.CourseId = Trainee.CourseId
);

			-----Any-----
Select * from Course
where CourseID>Any
(
Select CourseID from Trainee
);

			-----All-----
Select * from Tsp
where TspID>All
(
Select TspID from Trainee
);

			------Cast-----
Select CAST('Graphics Animation & Video Editing' as varchar)
			------Convert----
Select DateTime=Convert(dateTime,'06-June-2023 09:10:15')

