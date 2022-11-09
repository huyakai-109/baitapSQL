create database QLSH

create table department 
(
  DID char(2) primary key ,
  DName nvarchar (50),
  Year int
)
create table student
(
	SID char(4) primary key,
	Name nvarchar(30) not null,
	Birthday  datetime,
	DID char(2) foreign key (DID) references department(DID)
)
create table courses
(
	CID char(4) primary key,
	Cname nvarchar(40),
	credit char(3),
	DID char(2) foreign key (DID) references department(DID)
)
create table Condition
(
	CID char(4) foreign key (CID) references courses(CID),
	PreCID char(4) foreign key (CID) references courses(CID),
	primary key (CID,PreCID)
)
create table results
(
	SID char (4) not null,
	CID char(4)  not null,
	Score float,
)
----------- insert query
insert into department(DID,DName,Year) values ('IT', 'Information Technology', 2012)
insert into department(DID,DName,Year) values ('ET', 'Electronic Technology', 1997)
insert into department(DID,DName,Year) values ('BT', 'Biotechnology', 1997)
insert into department(DID,DName,Year) values ('FL', 'Foreign language', 2000)
insert into department(DID,DName,Year) values ('CT', 'Chemical Technology', 2011)


insert into student(SID,Name,Birthday,DID) values ('S01',N'Phước Trần','1990/02/24','IT')
insert into student(SID,Name,Birthday,DID) values ('S02',N'Timothy','2000/12/12','IT')
insert into student(SID,Name,Birthday,DID) values ('S03',N'Kaily','2001/10/01','ET')
insert into student(SID,Name,Birthday,DID) values ('S04',N'Tâm Nguyễn','1998/12/20','ET')
insert into student(SID,Name,Birthday,DID) values ('S05',N'Lee Nguyễn','1999/02/28','BT')



insert into courses(CID,CName,Credit,DID) values ('OOP','Object oriented Programming','4','IT')
insert into courses(CID,CName,Credit,DID) values ('PM','Programming method','4','IT')
insert into courses(CID,CName,Credit,DID) values ('DBS','Database system','4','IT')
insert into courses(CID,CName,Credit,DID) values ('SE','Software engineering','4','IT')
insert into courses(CID,CName,Credit,DID) values ('CN','Computer network','3','IT')

insert into Condition(CID,PreCID) values ('OOP','PM')
insert into Condition(CID,PreCID) values ('DBS','PM')
insert into Condition(CID,PreCID) values ('DBS','OOP')
insert into Condition(CID,PreCID) values ('SE','OOP')
insert into Condition(CID,PreCID) values ('SE','DBS')

insert into results(SID,CID,Score) values ('S01','PM',9.5)
insert into results(SID,CID,Score) values ('S01','OOP',10)
insert into results(SID,CID,Score) values ('S02','PM',4.5)
insert into results(SID,CID,Score) values ('S02','DBS',6.0)
insert into results(SID,CID,Score) values ('S03','DBS',8.0)

------- update - delete querey
--a
update student 
set Birthday = '1999/02/20'
where SID = 'S01'
--b
update results
set Score = Score +1
where SID = 'S02' AND CID = 'PM' 
--c
delete from results
where Score < 5

------ Alter table
-- a
Alter table student add Phone int
--b
alter table student alter column Phone varchar(12)
-- c
alter table student add constraint value default 'None' for Phone
--d
alter table results add constraint PK_result primary key (SID,CID)
-- e
alter table results add  foreign key (SID) references student (SID)
alter table results add foreign key (CID) references Courses(CID);
-- f
alter table results add constraint CK_score check ( score >= 0 and score <= 10)
alter table Courses add constraint CK_credit check ( credit >= 1 and credit <= 12)
alter table Courses add constraint UQ_Name Unique (CName)
---g
alter table student drop constraint value	
alter table student drop column Phone 
alter table Courses drop constraint CK_credit

-----Select query
--- 1
select *  from student
where DID = 'IT'
--2
select *  from department
where  YEAR(GETDATE()) - Year > 20
--3
select courses.* FROM courses
where DID = 'IT' and credit >= 5

--4
select PreCID from Condition
where CID = 'DBS'

-- 5

select st.SID,st.Name,c.CID,c.Cname,rs.Score 
from student as st, courses as c,results as rs
where st.SID = rs.SID and st.DID = c.DID and c.CID = rs.CID


--6

select st.SID, rs.CID, rs.Score 
from student as st left join results as rs
on st.SID = rs.SID 

--7
select c.Cname 
from courses as c
where c.Cname not in(select a.Cname
from courses a, Condition b
where a.CID = b.CID)

--8 
select COUNT(s.DID) 'number',s.DID 
from student s
group by s.DID

--9 
select COUNT(c.DID) 'number',c.DID 
from courses c
group by c.DID

--10
select a.DID as 'danh sach'
from student a
group by a.DID
having count(a.did)>=10

-- 11
select c.CID
from courses c
group by c.CID
having count(c.CID)>=10

-- 12
select a.SID,student.Name,a.AVG
from (
      select a.SID,  AVG(a.score) as AVG
      from Results a
      group by a.SID) a
left outer join student
on student.SID=a.SID

--- 13
select max(a.avg) as Highest_avg
from ( select a.SID, AVG(a.score) as avg
      from Results a
      group by a.SID ) a
---- 14
select min(a.avg) as Lowest_avg
from ( select a.SID, AVG(a.score) as avg
      from Results a
      group by a.SID ) a
