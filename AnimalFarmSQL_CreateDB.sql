use master
go

/*
*
* KILL ALL DATABASE CONNECTIONS
*
*/
DECLARE @DatabaseName nvarchar(50)
SET @DatabaseName = N'AnimalFarm'

DECLARE @SQL varchar(max)

SELECT @SQL = COALESCE(@SQL,'') + 'Kill ' + Convert(varchar, SPId) + ';'
FROM MASTER..SysProcesses
WHERE DBId = DB_ID(@DatabaseName) AND SPId <> @@SPId

--SELECT @SQL 
EXEC(@SQL)
GO

drop database if exists AnimalFarm
go

create database AnimalFarm
go
use AnimalFarm
go


create table City(
Id int identity primary key,
CityName varchar(50) not null,
PostCode varchar(50) not null
)

create table Owner(
CVR varchar(50) primary key,
FirstName varchar(50) not null,
LastName varchar(50) not null,
StreetName varchar(50) not null,
StreetNo int not null,
City int foreign key references City(Id),
Email varchar(50) unique
)
create table Phone(
PhoneNo varchar(50) primary key,
CVR varchar(50) foreign key references Owner(CVR)
)

create table Farm(
PNumber varchar(50) primary key,
Name varchar(50) not null,
StreetName varchar(50) not null,
StreetNo int not null,
City int foreign key references City(Id)
)
create table ChrNo(
ChrNo varchar(50) primary key,
Farm varchar(50) foreign key references Farm(PNumber)
)

create table OwnerFarm(
Id int identity primary key,
Owner varchar(50) foreign key references Owner(CVR),
Farm varchar(50) foreign key references Farm(PNumber)
)

create table AnimalType(
Id int identity primary key,
Type varchar(50) not null
)
create table AnimalSex(
Id int identity primary key,
Sex varchar(50) not null
)
create table AnimalEarmark(
Id int identity primary key,
ChrNo varchar(50) foreign key references ChrNo(ChrNo),
Color varchar(50) not null
)

create table Animal(
Earmark int primary key foreign key references AnimalEarmark(Id),
Sex int foreign key references AnimalSex(Id),
Type int foreign key references AnimalType(Id),
Birth Date not null,
Death Date,
Is_Parent_Of int foreign key references Animal(Earmark)
)

create table SmartUnitType(
Id int identity primary key,
Type varchar(50) not null
)
create table SmartUnit(
SerialNumber varchar(50) primary key,
IpAddress varchar(50) not null,
MacAddress varchar(50) not null,
Type int foreign key references SmartUnitType(Id)
)

create table State(
Id int identity primary key,
Severity varchar(50) not null
)

create table Stall(
StallNo int identity primary key,
Farm varchar(50) foreign key references Farm(PNumber)
)

create table BoxType(
Id int identity primary key,
Type varchar(50) not null
)
create table Box(
BoxNo int identity primary key,
Outdoor bit not null,
Type int foreign key references BoxType(Id),
Stall int foreign key references Stall(StallNo),
)

create table AnimalBox(
Id int identity primary key,
MoveIntTime date not null,
MoveOutTime date,
Box int foreign key references Box(BoxNo),
Animal int foreign key references Animal(Earmark)
)

create table BoxSmartunit(
Id int identity primary key,
Value varchar(50) not null,
Time date not null,
Box int foreign key references Box(BoxNo),
SmartUnit varchar(50) foreign key references SmartUnit(SerialNumber)
)

create table StallSmartunit(
Id int identity primary key,
SmartUnit varchar(50) foreign key references SmartUnit(SerialNumber),
Stall int foreign key references Stall(StallNo)
)

create table SmartunitState(
Id int identity primary key,
Serial varchar(50) foreign key references SmartUnit(SerialNumber),
State int foreign key references State(Id),
Time date
)


