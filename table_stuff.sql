CREATE DATABASE iowa_moves;

USE iowa_moves;

select * from train;
select * from user_id;

load data local infile 'C:/Users/Admin/Documents/IowaMoves/train.csv'
into table train
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

delete from train; 

drop table train;

update train
set LotFrontage = NULL
where LotFrontage = 0;

update train
set GarageYrBuilt = NULL
where GarageYrBuilt = 0;

update train
set MasVnrArea = NULL
where Id = 235;
-- show variables like "secure_file_priv";

alter table train
add column user_id INT NOT NULL
first;

alter table train
add foreign key (user_id) references user_id(id);

update train
set user_id = 1;

alter table train
drop column user_id;

insert into user_id(id, name)
values ('1', 'Sinead');