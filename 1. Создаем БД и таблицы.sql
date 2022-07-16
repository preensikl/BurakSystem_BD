DROP DATABASE IF EXISTS PosterPoss;
CREATE DATABASE PosterPoss;
USE PosterPoss;

-- Создаем таблицу еденицы измерений
DROP TABLE IF EXISTS massa;
CREATE TABLE massa(
id SERIAL PRIMARY KEY,
name VARCHAR(100),
CONSTRAINT UNIQUE (name)
);
SELECT * FROM massa;
INSERT massa (name)
VALUES('kg'), ('g'), ('litre'), ('ml');

-- Создаем название п/ф (ингрдиниеты собственного производства)
DROP TABLE IF EXISTS pf;
CREATE TABLE pf(
id SERIAL PRIMARY KEY,
name VARCHAR(100),
CONSTRAINT UNIQUE (name)
);
SELECT * FROM PF;

-- Создаем склад, где хранятся ингридиенты для напитков
-- + добавляем привязку к таблице П/Ф (это своего производства)
DROP TABLE IF EXISTS warehouse;
CREATE TABLE warehouse(
id SERIAL PRIMARY KEY,
name VARCHAR(100),
id_massa BIGINT UNSIGNED,
value FLOAT,
id_pf BIGINT UNSIGNED,
CONSTRAINT UNIQUE (name),
FOREIGN KEY (id_massa) REFERENCES massa (id) 
);
SELECT * FROM warehouse;

-- Создаем состав п/ф
DROP TABLE IF EXISTS pf_massa;
CREATE TABLE pf_massa(
id SERIAL PRIMARY KEY,
id_pf BIGINT UNSIGNED,
id_warehouse BIGINT UNSIGNED,
id_massa BIGINT UNSIGNED,
value FLOAT,
CONSTRAINT UNIQUE(id_pf, id_warehouse),
FOREIGN KEY (id_pf) REFERENCES pf (id),
FOREIGN KEY (id_warehouse) REFERENCES warehouse(id),
FOREIGN KEY (id_massa) REFERENCES massa(id)
);
SELECT * FROM pf_massa;

-- Создаем таблицу валюты. (В случае масштабирования компании 
-- 	в другие страны, можно будет менять валюту.)
DROP TABLE IF EXISTS money;
CREATE TABLE money(
id SERIAL PRIMARY KEY,
name VARCHAR(10)
);
-- Добавляем валюту
INSERT money (name)
VALUES('RUB'), ('USD'), ('EUR'), ('TL');

-- Создаем меню
DROP TABLE IF EXISTS menu;
CREATE TABLE menu(
id SERIAL PRIMARY KEY,
name VARCHAR(100),
cost BIGINT,
id_money BIGINT UNSIGNED,
CONSTRAINT UNIQUE (name),
FOREIGN KEY (id_money) REFERENCES money(id)
);
SELECT * FROM menu;

-- Создаем состав Меню
DROP TABLE IF EXISTS tk;
CREATE TABLE tk(
id SERIAL PRIMARY KEY,
id_menu BIGINT UNSIGNED,
id_warehouse BIGINT UNSIGNED,
value BIGINT,
id_massa BIGINT UNSIGNED,
CONSTRAINT UNIQUE (id_menu, id_warehouse),
FOREIGN KEY (id_menu) REFERENCES menu (id),
FOREIGN KEY (id_massa) REFERENCES massa (id),
FOREIGN KEY (id_warehouse) REFERENCES warehouse (id)
);
SELECT * FROM tk;

-- Создаем официанта. В будующем по нему можно будет смотреть статистику
DROP TABLE IF EXISTS waiters;
CREATE TABLE waiters(
id SERIAL PRIMARY KEY,
first_name VARCHAR(100),
last_name VARCHAR (100),
birthday date,
CONSTRAINT UNIQUE(last_name)
);
SELECT * FROM waiters;

-- Создаем клиента. В будующем по нему можно будет смотреть статистику.
DROP TABLE IF EXISTS customers;
CREATE TABLE customers(
id SERIAL PRIMARY KEY,
first_name VARCHAR(100),
last_name VARCHAR (100),
birthday date,
CONSTRAINT UNIQUE(first_name, last_name)
);

-- Создаем стол заказов.
DROP TABLE IF EXISTS sell_table;
CREATE TABLE sell_table(
id SERIAL PRIMARY KEY,
id_waiters BIGINT UNSIGNED NOT NULL,
id_customers BIGINT UNSIGNED,
time_create DATETIME DEFAULT CURRENT_TIMESTAMP(),
CONSTRAINT UNIQUE (id_waiters, id_customers),
FOREIGN KEY (id_waiters) REFERENCES waiters (id),
FOREIGN KEY (id_customers) REFERENCES customers (id)
);
SELECT * FROM sell_table;

-- Создаем таблицу наполнения стола заказов.
DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
id SERIAL PRIMARY KEY,
id_sell_table BIGINT UNSIGNED,
id_menu BIGINT UNSIGNED,
counts BIGINT NOT NULL,
FOREIGN KEY (id_sell_table) REFERENCES sell_table(id),
FOREIGN KEY (id_menu) REFERENCES menu(id)
);
SELECT * FROM orders;

-- Создаем скидочную систему
DROP TABLE IF EXISTS discount;
CREATE TABLE discount(
id SERIAL PRIMARY KEY,
summ BIGINT,
id_money BIGINT UNSIGNED,
disc BIGINT,
CONSTRAINT UNIQUE (summ),
FOREIGN KEY (id_money) REFERENCES money (id)
);
SELECT * FROM discount;

DROP TABLE IF EXISTS deposid;
CREATE TABLE deposid(
waiter BIGINT,
tables BIGINT,
total BIGINT,
money varchar(30),
times DATETIME
);

DROP TABLE IF EXISTS price_products;
CREATE TABLE price_products(
name varchar(30),
price_point FLOAT,
price_kg_l FLOAT,
CONSTRAINT UNIQUE (name)
);