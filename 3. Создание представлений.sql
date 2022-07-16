USE PosterPoss;

/*
-- Тут собраны различные представления и все можно акуратненько посмотреть ^__^
SELECT * FROM show_warehouse; 		-- Колличество ингридиентов на складе
SELECT * FROM show_pf; 				-- Состав п/ф (Полуфабрикаты)
SELECT * FROM show_menu; 			-- Меню и цены 
SELECT * FROM show_tk; 				-- Состав ТК (Технологическая карта)
SELECT * FROM show_discount;		-- Скидочна система.
SELECT * FROM show_waiters_tables;	-- Посмотреть какие столы обслуживают официанты
SELECT * FROM summ_count;			-- Посмотреть что сейчас продается и в каком колличестве.
SELECT * FROM summ_one_table;		-- Посмотреть суммы денег по столам.
SELECT * FROM tk_warehouse_menu_tables; - -- Специальное представление для реализации вычитания
SELECT * FROM menu_sebest;			-- Показывает себестоимость напитков.
*/

-- Создаем представление для легкого просмотра состояния склада.
DROP VIEW IF EXISTS show_warehouse;
CREATE OR REPLACE VIEW show_warehouse (ingridient, total, value )
AS SELECT warehouse.name, warehouse.value, massa.name 
FROM warehouse, massa WHERE warehouse.id_massa = massa.id;

-- Создаем представление, что бы посмотреть какие пф у нас существуюют.
DROP VIEW IF EXISTS show_pf;
CREATE OR REPLACE VIEW show_pf (name_pf, ingridients, value, massa) AS 
SELECT pf.name, warehouse.name, pf_massa.value, massa.name  
FROM pf, warehouse, pf_massa, massa
WHERE pf.id = pf_massa.id_pf AND warehouse.id = pf_massa.id_warehouse
AND pf_massa.id_massa = massa.id;

-- Создаем представление для удобного просмотра меню
DROP VIEW IF EXISTS show_menu;
CREATE OR REPLACE VIEW show_menu (name, price, money) AS 
SELECT menu.name, menu.cost, money.name 
FROM menu, money 
WHERE menu.id_money = money.id;

-- Создаем представление для удобного просмотра ТК
DROP VIEW IF EXISTS show_tk;
CREATE OR REPLACE VIEW show_tk (name, ingridients, value, massa) AS
SELECT menu.name, warehouse.name, tk.value, massa.name
FROM menu, warehouse, massa, tk
WHERE tk.id_menu = menu.id 
	AND tk.id_warehouse = warehouse.id
	AND tk.id_massa = massa.id;
	
-- Создаем представление для удобного просмотра скидочных порогов
DROP VIEW IF EXISTS show_discount;
CREATE OR REPLACE VIEW show_discount (min_summa, money, procent_discount) AS
SELECT discount.summ, money.name, discount.disc 
FROM discount, money
WHERE discount.id_money = money.id;

-- Создаем предсталвение для просмотра существующих столов и их официантов.
DROP VIEW IF EXISTS show_waiters_tables;
CREATE OR REPLACE VIEW show_waiters_tables (Number_Table, Waiter, Time_Create) AS 
SELECT sell_table.id, waiters.first_name, sell_table.time_create
FROM waiters, sell_table
WHERE waiters.id = sell_table.id_waiters;

-- Создаем представление для просмотра всех заказов и столов.
DROP VIEW IF EXISTS show_orders;
CREATE OR REPLACE VIEW show_orders (Tables, Food_or_drinks, Cost, Money, counts)  AS 
SELECT sell_table.id, menu.name, menu.cost, money.name, orders.counts 
FROM sell_table, menu, money, orders
WHERE sell_table.id = orders.id_sell_table 
	AND menu.id = orders.id_menu
	AND money.id = menu.id_money;
	
-- Создаем представления для удобного просмотра столов с подсчетом сумм.
DROP VIEW IF EXISTS summ_count;
CREATE OR REPLACE VIEW summ_count AS 
SELECT *, show_orders.cost * show_orders.counts AS summ
FROM show_orders;

-- Создаем представление для удобного подсчета общей суммы по отдельным столам.
DROP VIEW IF EXISTS summ_one_table;
CREATE OR REPLACE VIEW summ_one_table (tables, total, money, times) AS 
SELECT summ_count.Tables, sum(summ), Money, CURRENT_TIMESTAMP()
FROM summ_count GROUP BY Tables;

-- Специальное представление для реализации вычитания
DROP VIEW IF EXISTS tk_warehouse_menu_tables;
CREATE OR REPLACE VIEW tk_warehouse_menu_tables (menu, name, id_warehouse, tk_value, warehouse_id, warehouse_value)
AS
SELECT tk.id_menu, name, tk.id_warehouse, tk.value, warehouse.id, warehouse.value  
FROM tk, warehouse WHERE tk.id_warehouse = warehouse.id;

-- Представление показывающее себестоимость напитков.  ---------------------------
DROP VIEW IF EXISTS price_sebest;
CREATE OR REPLACE VIEW price_sebest (menu, name, ingridients_id, coast) AS
	SELECT menu, price_products.name, id_warehouse, (tk_value * price_point)
	FROM price_products, tk_warehouse_menu_tables
	WHERE tk_warehouse_menu_tables.name = price_products.name;

DROP VIEW IF EXISTS menu_sebest;
CREATE OR REPLACE VIEW menu_sebest AS 
	SELECT menu, menu.name, sum(coast) FROM price_sebest, menu 
	WHERE menu.id = price_sebest.menu GROUP BY menu;
-- --------------------------------------------------------------------------------