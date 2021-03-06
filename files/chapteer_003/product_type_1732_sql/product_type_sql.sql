create database product_db owner evgeny;

create table type (
  id serial primary key,
  name varchar(255)
);

create table product (
  id serial primary key,
  name varchar(255),
  type_id int references type(id),
  expired_date date,
  price float
);

insert into type (name)
values ('Сыр'),
('Молоко'),
('Мороженое');

insert into product (name, type_id, expired_date, price)
values ('Вафельный стканчик мороженое', 3, current_date + interval '30 day', 65.00),
('Вафельный стканчик мороженое', 3, current_date + interval '30 day', 65.00),
('Вафельный стканчик мороженое', 3, current_date + interval '30 day', 65.00),
('Вафельный стканчик мороженое', 3, current_date + interval '30 day', 65.00),
('Вафельный стканчик мороженое', 3, current_date + interval '30 day', 65.00),
('Вафельный стканчик мороженое', 3, current_date + interval '30 day', 65.00),
('Вафельный стканчик мороженое', 3, current_date + interval '30 day', 65.00),
('Вафельный стканчик мороженое', 3, current_date + interval '30 day', 65.00),
('Щербет мороженое', 3, current_date + interval '30 day', 76.00),
('Щербет мороженое', 3, current_date + interval '30 day', 76.00),
('Щербет мороженое', 3, current_date - interval '4 day', 76.00),
('Щербет мороженое', 3, current_date - interval '2 day', 76.00),
('Щербет мороженое', 3, current_date + interval '30 day', 76.00),
('Сыр плавленный', 1, current_date + interval '5 day', 500.00),
('Сыр моцарелла', 1, current_date + interval '5 day', 720.00),
('Простоквашино молоко', 2, current_date + interval '6 day', 120.00),
('Простоквашино молоко', 2, current_date + interval '6 day', 120.00),
('Простоквашино молоко', 2, current_date + interval '6 day', 120.00),
('Простоквашино молоко', 2, current_date + interval '6 day', 120.00),
('Простоквашино молоко', 2, current_date + interval '6 day', 120.00),
('Простоквашино молоко', 2, current_date + interval '6 day', 120.00),
('Веселый молочник молоко', 2, current_date + interval '6 day', 122.00),
('Веселый молочник молоко', 2, current_date + interval '6 day', 122.00),
('Веселый молочник молоко', 2, current_date + interval '6 day', 122.00),
('Веселый молочник молоко', 2, current_date + interval '6 day', 122.00),
('Веселый молочник молоко', 2, current_date + interval '6 day', 122.00),
('Веселый молочник молоко', 2, current_date + interval '6 day', 122.00);

-- Решение:
-- 1. Написать запрос получение всех продуктов с типом "СЫР"
select p.id, p.name, p.expired_date, p.price, t.name as type_name
from product as p
join type as t
on p.type_id = t.id
where t.name = 'Сыр';
-- id |      name      | expired_date | price | type_name 
------+----------------+--------------+-------+-----------
-- 14 | Сыр плавленный | 2021-07-11   |   500 | Сыр
-- 15 | Сыр моцарелла  | 2021-07-11   |   720 | Сыр
--(2 строки)


-- 2. Написать запрос получения всех продуктов, у кого в имени есть слово "мороженое"
select *
from product
where name like '%мороженое%';
-- id |             name             | type_id | expired_date | price 
------+------------------------------+---------+--------------+-------
--  1 | Вафельный стканчик мороженое |       3 | 2021-08-05   |    65
--  2 | Вафельный стканчик мороженое |       3 | 2021-08-05   |    65
--  3 | Вафельный стканчик мороженое |       3 | 2021-08-05   |    65
--  4 | Вафельный стканчик мороженое |       3 | 2021-08-05   |    65
--  5 | Вафельный стканчик мороженое |       3 | 2021-08-05   |    65
--  6 | Вафельный стканчик мороженое |       3 | 2021-08-05   |    65
--  7 | Вафельный стканчик мороженое |       3 | 2021-08-05   |    65
--  8 | Вафельный стканчик мороженое |       3 | 2021-08-05   |    65
--  9 | Щербет мороженое             |       3 | 2021-08-05   |    76
-- 10 | Щербет мороженое             |       3 | 2021-08-05   |    76
-- 11 | Щербет мороженое             |       3 | 2021-07-02   |    76
-- 12 | Щербет мороженое             |       3 | 2021-07-04   |    76
-- 13 | Щербет мороженое             |       3 | 2021-08-05   |    76
--(13 строк)


-- 3. Написать запрос, который выводит все продукты, срок годности которых уже истек
select *
from product
where expired_date < current_date;
-- id |       name       | type_id | expired_date | price 
------+------------------+---------+--------------+-------
-- 11 | Щербет мороженое |       3 | 2021-07-02   |    76
-- 12 | Щербет мороженое |       3 | 2021-07-04   |    76
--(2 строки)


-- 4. Написать запрос, который выводит самый дорогой продукт.
select *
from product
where price = (select max(price) from product);

select * from product
order by price desc limit 1;
-- id |     name      | type_id | expired_date | price 
------+---------------+---------+--------------+-------
-- 15 | Сыр моцарелла |       1 | 2021-07-11   |   720
--(1 строка)

-- 5. Написать запрос, который выводит для каждого типа количество продуктов к нему принадлежащих. В виде имя_типа, количество
select t.name, count(t.name)
from product as p
join type as t on p.type_id = t.id
group by t.name;
--   name    | count 
-------------+-------
-- Молоко    |    12
-- Мороженое |    13
-- Сыр       |     2
--(3 строки)

-- 6. Написать запрос получение всех продуктов с типом "СЫР" и "МОЛОКО"
select p.id, p.name, p.expired_date, p.price, t.name as type_name
from product as p
join type as t on p.type_id = t.id
where t.name = 'Сыр' or t.name = 'Молоко';
-- id |          name           | expired_date | price | type_name 
------+-------------------------+--------------+-------+-----------
-- 14 | Сыр плавленный          | 2021-07-11   |   500 | Сыр
-- 15 | Сыр моцарелла           | 2021-07-11   |   720 | Сыр
-- 16 | Простоквашино молоко    | 2021-07-12   |   120 | Молоко
-- 17 | Простоквашино молоко    | 2021-07-12   |   120 | Молоко
-- 18 | Простоквашино молоко    | 2021-07-12   |   120 | Молоко
-- 19 | Простоквашино молоко    | 2021-07-12   |   120 | Молоко
-- 20 | Простоквашино молоко    | 2021-07-12   |   120 | Молоко
-- 21 | Простоквашино молоко    | 2021-07-12   |   120 | Молоко
-- 22 | Веселый молочник молоко | 2021-07-12   |   122 | Молоко
-- 23 | Веселый молочник молоко | 2021-07-12   |   122 | Молоко
-- 24 | Веселый молочник молоко | 2021-07-12   |   122 | Молоко
-- 25 | Веселый молочник молоко | 2021-07-12   |   122 | Молоко
-- 26 | Веселый молочник молоко | 2021-07-12   |   122 | Молоко
-- 27 | Веселый молочник молоко | 2021-07-12   |   122 | Молоко
--(14 строк)


-- 7. Написать запрос, который выводит тип продуктов, которых осталось меньше 10 штук. Под количеством подразумевается количество продуктов определенного типа. Например, если есть тип "СЫР" и продукты "Сыр плавленный" и "Сыр моцарелла", которые ему принадлежат, то количество продуктов типа "СЫР" будет 2. 
select t.name, count(t.name)
from product as p
join type as t on p.type_id = t.id
group by t.name
having count(t.name) < 10;
-- name | count 
--------+-------
-- Сыр  |     2
--(1 строка)

-- 8. Вывести все продукты и их тип.
select p.id, p.name, p.expired_date, p.price, t.name as type_name
from product as p
join type as t
on p.type_id = t.id;
-- id |             name             | expired_date | price | type_name 
------+------------------------------+--------------+-------+-----------
--  1 | Вафельный стканчик мороженое | 2021-08-05   |    65 | Мороженое
--  2 | Вафельный стканчик мороженое | 2021-08-05   |    65 | Мороженое
--  3 | Вафельный стканчик мороженое | 2021-08-05   |    65 | Мороженое
--  4 | Вафельный стканчик мороженое | 2021-08-05   |    65 | Мороженое
--  5 | Вафельный стканчик мороженое | 2021-08-05   |    65 | Мороженое
--  6 | Вафельный стканчик мороженое | 2021-08-05   |    65 | Мороженое
--  7 | Вафельный стканчик мороженое | 2021-08-05   |    65 | Мороженое
--  8 | Вафельный стканчик мороженое | 2021-08-05   |    65 | Мороженое
--  9 | Щербет мороженое             | 2021-08-05   |    76 | Мороженое
-- 10 | Щербет мороженое             | 2021-08-05   |    76 | Мороженое
-- 11 | Щербет мороженое             | 2021-07-02   |    76 | Мороженое
-- 12 | Щербет мороженое             | 2021-07-04   |    76 | Мороженое
-- 13 | Щербет мороженое             | 2021-08-05   |    76 | Мороженое
-- 14 | Сыр плавленный               | 2021-07-11   |   500 | Сыр
-- 15 | Сыр моцарелла                | 2021-07-11   |   720 | Сыр
-- 16 | Простоквашино молоко         | 2021-07-12   |   120 | Молоко
-- 17 | Простоквашино молоко         | 2021-07-12   |   120 | Молоко
-- 18 | Простоквашино молоко         | 2021-07-12   |   120 | Молоко
-- 19 | Простоквашино молоко         | 2021-07-12   |   120 | Молоко
-- 20 | Простоквашино молоко         | 2021-07-12   |   120 | Молоко
-- 21 | Простоквашино молоко         | 2021-07-12   |   120 | Молоко
-- 22 | Веселый молочник молоко      | 2021-07-12   |   122 | Молоко
-- 23 | Веселый молочник молоко      | 2021-07-12   |   122 | Молоко
-- 24 | Веселый молочник молоко      | 2021-07-12   |   122 | Молоко
-- 25 | Веселый молочник молоко      | 2021-07-12   |   122 | Молоко
-- 26 | Веселый молочник молоко      | 2021-07-12   |   122 | Молоко
-- 27 | Веселый молочник молоко      | 2021-07-12   |   122 | Молоко
--(27 строк)
