create database storage_raw_and_material

create table provider
 (id_provider int IDENTITY(1,1) not null primary key,
 Name varchar(20) constraint name_format check (Name like '[À-ÿ A-z]%'))

insert into dbo.provider (Name) values ('Firm one');
insert into dbo.provider (Name) values ('Firm two');
insert into dbo.provider (Name) values ('Firm three');

select * from dbo.provider

create table raw_material
(id_raw_material int IDENTITY(1,1) not null primary key,
Name varchar(20) constraint row_mat_name_format check (Name like '[À-ÿ A-z]%'),
Material bit,
Raw bit)

insert into dbo.raw_material (Name,Material,Raw) values ('Silk',1,0);
insert into dbo.raw_material (Name,Material,Raw) values ('Wool',0,1);
insert into dbo.raw_material (Name,Material,Raw) values ('Paint',1,0);

select * from dbo.raw_material

create table contract
(id_contract int IDENTITY(1,1) not null primary key,
id_provider int not null foreign key (id_provider) references
dbo.provider(id_provider) on delete cascade on update no action,
Signing_date date,
Conditions text
)

insert into dbo.contract (id_provider, Signing_date,Conditions) values (1,'2010-02-15','Conditions1');
insert into dbo.contract (id_provider, Signing_date,Conditions) values (2,'2015-05-05','Conditions2');
insert into dbo.contract (id_provider, Signing_date,Conditions) values (3,'1999-11-17','Conditions3');

select * from dbo.contract

create table raw_material_by_contract
(id_raw_material int not null foreign key (id_raw_material) references
dbo.raw_material(id_raw_material) on delete cascade on update no action,
id_contract int not null foreign key (id_contract) references
dbo.contract(id_contract) on delete cascade on update no action,
Amount numeric(10,5)
)

insert into dbo.raw_material_by_contract (id_raw_material, id_contract,Amount) values (1,3,250.50);
insert into dbo.raw_material_by_contract (id_raw_material, id_contract,Amount) values (2,2,1000);
insert into dbo.raw_material_by_contract (id_raw_material, id_contract,Amount) values (3,1,535.7);

select * from dbo.raw_material_by_contract

create table earning_bill_of_lading
(id_raw_material int not null foreign key (id_raw_material) references
dbo.raw_material(id_raw_material) on delete cascade on update no action,
id_contract int not null foreign key (id_contract) references
dbo.contract(id_contract) on delete cascade on update no action,
Earning_date date,
Amount numeric(10,5)
)

insert into dbo.earning_bill_of_lading (id_raw_material, id_contract, Earning_date, Amount) values (1,3,'2018-03-03',250.50);
insert into dbo.earning_bill_of_lading (id_raw_material, id_contract, Earning_date, Amount) values (2,2,'2018-03-05',500);
insert into dbo.earning_bill_of_lading (id_raw_material, id_contract, Earning_date, Amount) values (3,1,'2018-03-10',535.7);

select * from dbo.earning_bill_of_lading

create table lending_bill_of_lading
(id_manufactury int not null foreign key (id_manufactury) references
dbo.manufactury(id_manufactury) on delete cascade on update no action,
id_raw_material int not null foreign key (id_raw_material) references
dbo.raw_material(id_raw_material) on delete cascade on update no action,
Lending_date date,
Amount numeric(10,5)
)

insert into dbo.lending_bill_of_lading (id_manufactury, id_raw_material, Lending_date, Amount) values (3,1,'2018-03-13',100);
insert into dbo.lending_bill_of_lading (id_manufactury, id_raw_material, Lending_date, Amount) values (2,2,'2018-03-14',200);
insert into dbo.lending_bill_of_lading (id_manufactury, id_raw_material, Lending_date, Amount) values (1,3,'2018-03-15',300);

select * from dbo.lending_bill_of_lading

create table manufactury
(id_manufactury int IDENTITY(1,1) not null primary key,
Name varchar(20) constraint manufactury_name_format check (Name like '[À-ÿ A-z]%')
)

insert into dbo.manufactury (Name) values ('Main');
insert into dbo.manufactury (Name) values ('Remaking');
insert into dbo.manufactury (Name) values ('Packaging');

select * from dbo.manufactury 
