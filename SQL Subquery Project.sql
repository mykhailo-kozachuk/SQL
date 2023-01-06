create database SQL_Assignment2
create table studies
(pname varchar(25),institute varchar(20), course varchar(15),course_fee int
)
select * from studies
insert into studies values('anand','sabhari','pgdca',4500),('altaf','coit','dca',7200),('juliana','bdps','mca',22000),('kamala','pragathi','dca',5000),
						   ('mary','sabhari','pgdca',4500),('nelson','pragathi','dap',6200),('patrick','pragathi','dcap',5200),('qadir','apple','hdca',14000),
						   ('ramesh','sabhari','pgdca',4500),('rebecca','brilliant','dcap',11000),('remitha','bdps','dcs',6000),('revathi','sabhari','dap',5000),
						   ('vijaya','bdps','dca',48000)

create table software
(
pname varchar(20),title varchar(15),developin varchar(20),scost int,dcost int,sold int
)
insert into software values('Mary','readme','cpp',300,1200,84),('anand','parachutes','basic',399.95,6000,43),('anand','video titling','pascal',7500,16000,9),
							('juliana','inventory','cobol',3000,3500,0),('kammala','payroll pkg','dbase',9000,20000,7),('mary','financial accnt','oracle',18000,85000,4),
							('mary','code generator','c',4500,20000,23),('patrick','readme','cpp',300,1200,84),('qadir','bombs away','assembly',750,3000,11),
							('qadir','vaccines','c',1900,3100,21),('ramesh','hotel mgmt','d base',13000,35000,4),('ramesh','dead lee','pascal',599.95,4500,73),
							('remitha','pc utilities','c',725,5000,51),('remitha','tsr help pkg','assembly',2500,6000,7),('revathi','hsptl mgmt','pascal',1100,75000,2),
							('vijaya','tsr editor','c',900,700,6)

create table programmer
(
pname varchar(15),dob date,doj date,gender varchar(10), prof1 varchar(15),prof2 varchar(15),salary int
)
insert into programmer values('anand','1966/04/12','1992/04/21','m','pascal','basic',3200),('altaf','1964/07/02','1990/11/13','m','clipper','cobol',2800),
							 ('juliana','1960/01/31','1990/04/21','f','cobol','dbase',3000),('kamala','1968/10/30','1992/01/02','f','c','dbase',2900),
							 ('mary','1970/06/24','1991/02/01','f','cpp','oracle',4500),('nelson','1985/09/11','1989/10/11','m','cobol','dbase',2500),
							 ('pattrick','1965/11/10','1990/04/21','m','pascal','clipper',2800),('qadir','1965/08/31','1991/04/21','m','assembly','c',3000),
							 ('ramesh','1967/05/03','1991/02/28','m','pascal','dbase',3200),('rebecaa','1967/01/01','1990/12/01','f','basic','cobol',2500),
							 ('remitha','1970/04/19','1993/04/20','f','c','assembly',3600),('revathi','1969/12/02','1992/01/02','f','pascal','basic',3700),
							 ('vijaya','1965/12/14','1992/05/02','f','foxpro','c',3500)
select * from studies

--1. Names and Ages of all Programmers. 
Select pname, year(doj)-YEAR(dob) as age
from programmer
Select pname, DATEDIFF(YY,dob,GETDATE()) as age
from programmer
--2. How much revenue has been earned through sales of Packages Developed in C.
Select sum(scost*sold-dcost) as revenue
from software
where developin = 'c'
--3. Details of the Software Developed by Ramesh. 
Select title
from software
where pname = 'Ramesh'
--4. How many Programmers Studied at Sabhari? 
select count(pname)
from studies
where institute ='sabhari'
--5. How old is the Oldest Male Programmer?
Select max(DATEDIFF(yy,dob,getdate())) as age
from programmer
select max(year(getdate())-year(dob)) as oldest_m_p from programmer
--6. What is the AVG age of Female Programmers? 
Select avg(datediff(YY,dob,GETDATE())) as avg_age 
from programmer
where gender = 'F'
--7. Experience in Years for each Programmer and Display with their names in Descending order. 
Select pname, datediff(yy,doj,getdate())as experience
from programmer
order by experience desc
--8. Programmers who celebrate their Birthday’s During the Current
--Month? 
Select pname, dob
from programmer
where month(dob) = MONTH(getdate())
--9. Languages studied by Male Programmers. 
Select distinct prof1 from programmer where gender='m'
union select distinct prof2 from programmer where gender='m'
--10. Details of those who don’t know Clipper, COBOL or PASCAL. 
Select *
from programmer
where prof1 not in ('clipper','COBOL','PASCAL') and  prof2 not in ('clipper','COBOL','PASCAL')
--11. Sales cost of the packages Developed by each Programmer Language wise. 
Select developin, sum(scost)
from software
group by developin
--12. Number of Packages in Each Language for which Development Cost is
--less than 1000.
Select developin, count(title) packagesNumber
from software
where dcost < 1000
group by developin
--- 13. Which course has been done by the most of the Students? 
select * from studies
select distinct course from studies
where course=(select max(course) from studies)
--14. Which Language is known by only one Programmer? 
select prof1 from programmer
group by prof1
having prof1 not in(select prof2 from programmer)
and count(prof1)=1
union
select prof2 from programmer
group by prof2
having prof2 not in(select prof1 from programmer)
and count(prof2)=1

--15. Who is the Youngest Programmer knowing DBASE? 
Select pname, min(DATEDIFF(yy,dob,getdate())) as age
from programmer
where 'dbase' in (prof1,prof2)
group  by pname
order by age asc
--16. How many copies of package that has the least difference between 
--development and selling cost where sold. 
Create table #copies (titl nvarchar(15) , cdiff int)
alter table #copies add sold int

Insert into #copies
select title, (dcost - scost), sold from software

Select titl, cdiff, sold
from #copies
where cdiff = (select MIN(cdiff) from #copies)
--17. Which language was used to develop the most number of Packages. 
create table #langCount (lang nvarchar(15), ct int)
insert into #langCount 
select developin,COUNT(title) from software group by developin

select lang, ct
from #langCount
where ct=(select MAX(ct) from #langCount)
--18. Which is the costliest package developed in PASCAL. 
select * from software
select  title, dcost
from software
where developin ='pascal' and dcost= (select MAX(dcost) from software where developin='pascal')
--19. Display the programmer Name and the cheapest packages developed by them in
--each language.
Create view minPackage as
Select pname, developin, MIN(dcost) minPack 
from software
group by pname, developin

select * from minPackage

---20. Programmer Name, year of experience and number of sold packages
Select s.pname, datediff(yy,p.doj,getdate())as experience, sum(s.sold) as countSold,sum(s.scost*s.sold-s.dcost) as revenue
from software as S
join programmer as p on S.pname=p.pname
group by S.pname, datediff(yy,p.doj,getdate())
 