use AnimalFarm
go

--Procedure to fill tables with dummy data
create procedure Fill_Tables
as
begin
	insert into City (CityName,PostCode) values
	('Valby','2500'),
	('København Ø','2100')
	
	insert into Owner (CVR, FirstName, LastName, StreetName, StreetNo, City, Email) values
	('105689','Per','Olsson','Søndre Alle', 14, 1,'Per78@Hotmail.com'),
	('576324','Karin','Nilsson','Lyngbyvej', 150, 2,'Karin53@gmail.com')
	
	insert into Phone (PhoneNo, CVR) values
	('22334455','105689'),
	('98765432','576324')
	
	insert into Farm (PNumber, Name, StreetName, StreetNo, City) values
	('1122','Sunny Hills','Æblevej', 35, 1),
	('9999','Cloudy Meadow','Kongsgade', 4, 1),
	('4567','Rainy Marsh','Stortåvej', 16, 2)
	
	insert into ChrNo (ChrNo, Farm) values
	('0011','1122'),
	('0022','9999'),
	('0033','9999'),
	('0044','4567')	
	
	insert into OwnerFarm (Owner, Farm) values
	('105689','1122'),
	('105689','9999'),
	('576324','4567')
	
	insert into Stall (Farm) values
	('1122'),
	('4567'),
	('9999'),
	('9999'),
	('4567')
	
	insert into BoxType (Type) values
	('Small'),
	('Medium'),
	('Large')
	
	insert into Box (Outdoor, Type, Stall) values
	(0,1,1),
	(1,3,1),
	(1,2,1),
	(0,1,2),
	(1,1,2),
	(0,3,2),
	(0,2,3),
	(0,2,3),
	(1,1,3),
	(1,3,3),
	(0,2,4),
	(1,1,4),
	(1,2,5),
	(0,3,5)
	
	insert into SmartUnitType (Type) values
	('Temperature'),
	('Happiness')
	
	insert into SmartUnit (SerialNumber, IpAddress, MacAddress, Type) values
	('10011','192.168.1.25','ABC001', 1),
	('10022','192.168.1.26','LUV002', 2)
	insert into State (Severity) values
	('OK'),
	('BAD')
	
	insert into SmartunitState (Serial, State, Time) values
	('10011',1,GETDATE()),
	('10022',2,GETDATE())
	
	insert into BoxSmartunit (Value, Time, Box, SmartUnit) values
	('25',GETDATE(), 1,'10011'),
	('<3',GETDATE(), 3,'10022')
	
	insert into AnimalEarmark (ChrNo, Color) values
	('0011','White'),
	('0022','Yellow'),
	('0044','Red'),
	('0033','White')
	insert into AnimalType (Type) values
	('Cattle'),
	('Pig'),
	('Sheep'),
	('Goat')
	insert into AnimalSex (Sex) values
	('Male'),
	('Female')
	insert into Animal (Earmark, Sex, Type, Birth, Death, Is_Parent_Of) values
	(1,1,3,DATEADD(Month,-4,GETDATE()),NULL,NULL),
	(2,2,2,DATEADD(Year,-3,GETDATE()),NULL,NULL),
	(3,1,1,DATEADD(Year,-8,GETDATE()),GETDATE(),NULL),
	(4,1,3,DATEADD(Year,-4,GETDATE()),NULL,1)
	
	insert into AnimalBox (MoveIntTime, MoveOutTime, Box, Animal) values
	(GETDATE(),NULL,1,1),
	(GETDATE(),NULL,4,3),
	(GETDATE(),NULL,9,2),
	(GETDATE(),NULL,12,4)
end
go


--selects animals based on an owner's first name
create procedure Select_Animals_By_Owner @OwnerName varchar(50)
as
begin
	select
	
	AnimalEarmark.ChrNo,
	AnimalEarmark.Color,
	
	AnimalType.Type,
	AnimalSex.Sex,
	
	Animal.Birth,
	Animal.Death,
	Animal.Is_Parent_Of,
	
	Box.BoxNo,
	BoxType.Type,
	AnimalBox.MoveIntTime,
	AnimalBox.MoveOutTime,
	Stall.StallNo,
	Farm.Name as Farm,
	
	Owner.FirstName as Owner,
	Owner.Email
	
	from AnimalEarmark
	
	join Animal on Animal.Earmark = AnimalEarmark.Id
	join AnimalType on AnimalType.Id = Animal.Type
	join AnimalSex on AnimalSex.Id = Animal.Sex
	join AnimalBox on AnimalBox.Animal = Animal.Earmark
	join Box on AnimalBox.Box = Box.BoxNo
	join BoxType on Box.Type = BoxType.Id
	join Stall on Stall.StallNo = Box.Stall
	--join ChrNo on AnimalEarmark.ChrNo = ChrNo.ChrNo
	--join Farm on Farm.PNumber = ChrNo.Farm
	join Farm on Farm.PNumber = Stall.Farm
	join OwnerFarm on Farm.PNumber = OwnerFarm.Farm
	join Owner on Owner.CVR = OwnerFarm.Owner
	
	where Owner.FirstName = @OwnerName
end
go

--select smartunit based on box number
create procedure Select_Smartunit_By_Box @BoxNumber int
as
begin
	select 
	SmartUnit.SerialNumber,
	SmartUnitType.Type,
	SmartUnit.IpAddress,
	SmartUnit.MacAddress,
	
	SmartunitState.Time,
	State.Severity,
	
	BoxSmartunit.Value,
	BoxSmartunit.Time,
	
	Box.BoxNo,
	Stall.StallNo,
	Farm.Name
	
	from SmartUnit
	
	join SmartUnitType on SmartUnit.Type = SmartUnitType.Id
	join SmartunitState on SmartUnit.SerialNumber = SmartunitState.Serial
	join State on SmartunitState.State = State.Id
	join BoxSmartunit on SmartUnit.SerialNumber = BoxSmartunit.SmartUnit
	join Box on BoxSmartunit.Box = Box.BoxNo
	join Stall on Stall.StallNo = Box.Stall
	join Farm on Farm.PNumber = Stall.Farm
	
	where Box.BoxNo = @BoxNumber
end
go

exec Fill_Tables
exec Select_Animals_By_Owner 'Per'
exec Select_Smartunit_By_Box 1