---ТРИГГЕРИ---

---Можна додавати лише унікальні значення в сировину/матеріал
--create trigger checkRowMatUnic
--on raw_material
--instead of insert
--as
--declare @raw_mat varchar(20)
--	if @@ROWCOUNT >= 1
--	begin
--		select @raw_mat = Name FROM inserted
--			begin 
--				if (select count(*) from raw_material
--				where raw_material.Name like @raw_mat)=0
--					begin
--						insert into raw_material(Name,Material,Raw)
--						select Name, Material, Raw from inserted
--					print 'Матеріл/сировину додано!'
--					end 
--				else
--					begin
--						print 'Матеріл/сировина уже існує!'
--					end 
--			end
--	end;

--select * from raw_material

--insert into raw_material(Name,Material,Raw) values ('wood',1,0)

---Якщо контракт додається без вказання дати то ставиться поточна
--alter trigger editContractDate
--on contract
--after insert
--as
--declare @currDate date = getdate()
--	if @@ROWCOUNT >= 1
--	begin 
--		if (select Signing_date from inserted) is null
--			begin
--				update contract set Signing_date = @currDate where id_provider = (select id_provider from inserted)
--				print 'Датою вказано поточну!'
--			end 
--	end;

--select * from provider

--select * from contract

--insert into contract(id_provider, Signing_date, Conditions) values (4, '2017-05-05', 'Contibute 1 kg of something')
 

-----Коли видаляється цех, то виводиться сумарна кількість матеріалів що він видав і ці записи видаляються
--alter trigger deleteManufactury
--on manufactury
--instead of delete
--as
--declare @summ numeric
--	begin
--		select @summ= SUM(lending_bill_of_lading.Amount) FROM lending_bill_of_lading where id_manufactury = (select id_manufactury from deleted)
--		begin
--			print ('Цех закрито, але ми завжди памятатимемо ті ' +cast(@summ as varchar(10)) +' кг матеріалів які він нам подарував')
--		end
--		delete lending_bill_of_lading WHERE id_manufactury like (select id_manufactury from deleted)
--	end;

--select * from lending_bill_of_lading
--select  * from manufactury

--delete manufactury where id_manufactury=18

--insert into manufactury(Name) values ('Main')

--insert into lending_bill_of_lading(id_manufactury, id_raw_material, Lending_date, Amount) values (18,1,'2015-05-05',300)
--insert into lending_bill_of_lading(id_manufactury, id_raw_material, Lending_date, Amount) values (18,1,'2015-05-05',220)


---ПРОЦЕДУРИ---

---1---Постачальники(назва) які мають поставити товару набільшу суму ніж...
--create proc moreContributions
--@summ numeric
--as
--begin
--	select provider.*, raw_material_by_contract.*
--	from provider 
--	inner join contract on contract.id_provider = provider.id_provider
--	inner join raw_material_by_contract on raw_material_by_contract.id_contract = contract.id_contract
--	where raw_material_by_contract.Amount>=@summ
--	order by provider.Name
--end

--exec moreContributions 100


---2---Вся сировина/матеріал видана з певного цеху
--create proc raw_matByManufac
--@manId int
--as
--begin
--	select manufactury.*, lending_bill_of_lading.*, raw_material.Name
--	from manufactury 
--	inner join lending_bill_of_lading on lending_bill_of_lading.id_manufactury = manufactury.id_manufactury
--	inner join raw_material on raw_material.id_raw_material = lending_bill_of_lading.id_raw_material
--	where manufactury.id_manufactury = @manId
--end

--exec raw_matByManufac 3


---3---Назви постачальників що поставили по n видів товарів на певному проміжку часу
--create proc providersIn
--@cnt int , @fromDate date, @toDate date
--as
--begin
--	select provider.Name, COUNT(earning_bill_of_lading.id_contract) as EarnCount
--	from provider 
--	inner join contract on contract.id_provider = provider.id_provider
--	inner join earning_bill_of_lading on earning_bill_of_lading.id_contract = contract.id_contract
--	where earning_bill_of_lading.Earning_date between @fromDate and @toDate
--	group by provider.Name
--	having COUNT(earning_bill_of_lading.id_contract)=@cnt
--end

--exec providersIn 2, '2000-01-01', '2018-05-05'

---Перевірка при постачанні кількості за контрактом

alter trigger checkProviderLeft
on earning_bill_of_lading
after insert
as
declare @summ numeric
	begin
		select @summ= SUM(earning_bill_of_lading.Amount) FROM earning_bill_of_lading where id_contract = (select id_contract from inserted)
		if(@summ>=(select raw_material_by_contract.Amount from raw_material_by_contract where id_contract = (select id_contract from inserted)))
			begin
				print 'Постачальник виконав свій план'
				delete earning_bill_of_lading WHERE id_contract = (select id_contract from inserted)
				delete contract WHERE id_contract = (select id_contract from inserted)
				delete raw_material_by_contract WHERE id_contract = (select id_contract from inserted)
			end
		else
			begin
				print('Постачальник ще не виконав свій план')
			end
	end;


select * from earning_bill_of_lading
select * from raw_material_by_contract
select * from contract

delete earning_bill_of_lading where id_contract = 1

insert into earning_bill_of_lading(id_raw_material, id_contract,Earning_date, Amount) values (1,11,'2018-03-03',100)

insert into earning_bill_of_lading(id_raw_material, id_contract,Earning_date, Amount) values (1,11,'2018-03-03',500)

--insert into contract(id_provider, Signing_date,Conditions) values (3,'2018-03-03','Bla bla')
--delete raw_material_by_contract where id_contract = 11

insert into raw_material_by_contract(id_raw_material,id_contract,Amount) values (1,11,500)

