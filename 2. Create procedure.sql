USE PosterPoss;

/* В функцию вносится стол который необходимо закрыть.
 Стол переносится в копию с сумой заказа и удаляется старый стол */
-- CALL close_table(1); 
						 
/* Удаляет определенную позицию из заказа (по id ордера)*/ 
-- CALL delete_position(2); 

/*Калькулятор. (стол расчета, сумма наличных). 
+ показывает время закрытия стола.*/
-- CALL calculator(7, 1000);  

/* Сохраняет историю закрытия стола, удаляет стол, 
Принимает в себя наличные и высчитывает сколько дать сдачи */
-- CALL transaction_pre(7, 1000); .

/* Добавление позиции на склад. (Название, ид_массы, колличество) */
-- CALL warehouse_add('Filtre Bean', 1, 20);

/* Добавление позиции в меню
-- CALL menu_add('Hot Chocolate', 350, 1);

/* Удаляет позицию из меню */
-- CALL menu_del(4);

/* Добавляем ингридиенты в меню. (создаем ТК).
-- CALL tk_add(5, 7, 210, 4);

/* Добавляет позицию в стол заказа */
-- CALL orders_add(id_sell_table_d, id_menu_d , counts)

/* Добавляет скидочные пороги */
-- CALL discount_add(порог, id_money, скидка );

/* Добавляет официантов */
-- CALL waiters_add(first_name, last_name, "birthday")

/* Удаляет официантов */
-- CALL waiters_del(id_waiter);

/* Добавляет заказ в стол заказа и вычитает необходимые ингридиенты со склада */
-- orders_add(id_table, id_menu, count)

/* Создает столы для заказов.*/
-- CALL sell_table_add(id_waiters!, id_customers(option))

/* Удаляет ингридиент со склада (warehouse) и таблицы себестоимости (price_products). */
-- CALL warehouse_del(id);

/* Процедур вносит поставку уже существующих ингридиентов.
	Добавляет колличество на склад + делает перерасчет себестоимости ингридиентов, напитков исходя из остатков и прихода. */
-- CALL add_ingridients_procedure('Name_ingridient', value, price);
 
-- Создает копию и удаляет стол
DROP PROCEDURE IF EXISTS close_table;
DELIMITER //
CREATE PROCEDURE close_table (need_id BIGINT)
BEGIN
	INSERT INTO deposid SELECT * FROM summ_one_table WHERE tables = need_id;
	DELETE FROM orders WHERE id_sell_table = need_id;
	DELETE FROM sell_table WHERE id = need_id;
END//

-- Удаляет позицию из стола заказов
DROP PROCEDURE IF EXISTS delete_position;
DELIMITER //
CREATE PROCEDURE delete_position (id_pos BIGINT)
BEGIN
	DELETE FROM orders WHERE id = id_pos;
END//

-- высчитывает сдачу
DROP PROCEDURE IF EXISTS calculator;
DELIMITER //
CREATE PROCEDURE calculator (IN id_tab BIGINT, IN money BIGINT)
BEGIN 
	SELECT money AS cash, total,  (money - total)
	AS ramains, summ_one_table.money 
	FROM summ_one_table WHERE tables = id_tab;
END//

-- Сохраняет историю закрытия стола, удаляет стол, 
-- Принимает в себя наличные и высчитывает сколько дать сдачи
DROP PROCEDURE IF EXISTS transaction_pre;
DELIMITER //
CREATE PROCEDURE transaction_pre (IN id_tab BIGINT, IN money BIGINT)
BEGIN
	SELECT money AS cash, total,  (money - total)
	AS ramains, summ_one_table.money 
	FROM summ_one_table WHERE tables = id_tab;
	INSERT INTO deposid SELECT id_waiters AS waiter , tables, total, money, times 
					FROM summ_one_table, sell_table WHERE tables = id_tab AND sell_table.id = summ_one_table.tables;
	DELETE FROM orders WHERE id_sell_table = id_tab;
	DELETE FROM sell_table WHERE id = id_tab;
END//

-- Процедура добавления ингридиентов на склад.
DROP PROCEDURE IF EXISTS warehouse_add;
DELIMITER //
CREATE PROCEDURE warehouse_add(IN name_d VARCHAR(20), IN id_massa_d BIGINT, IN value_d BIGINT, IN total_money_d FLOAT)
BEGIN 
	INSERT warehouse (name, id_massa, value)
	VALUES(name_d, id_massa_d, value_d);
	SET @price_point := total_money_d / value_d;
	SET @price_kg_l := @price_point * 1000; 
	INSERT price_products (name, price_point, price_kg_l)
	VALUES(name_d, @price_point, @price_kg_l);
END//

-- Удаление позиции со склада и таблицы себестоимости (price_products)
DROP PROCEDURE IF EXISTS warehouse_del;
DELIMITER //
CREATE PROCEDURE warehouse_del(IN id_d BIGINT)
BEGIN 
	DELETE FROM price_products WHERE name = (SELECT warehouse.name FROM warehouse WHERE id = id_d);
	DELETE FROM warehouse WHERE id = id_d;
END//

-- Процедура добавление товара в меню
DROP PROCEDURE IF EXISTS menu_add;
DELIMITER //
CREATE PROCEDURE menu_add(IN name_d VARCHAR(20), IN cost_d BIGINT, IN id_money_d BIGINT)
BEGIN 
	INSERT menu (name, cost, id_money)
	VALUES(name_d, cost_d, id_money_d);
END//

-- Процедура удаление товара из меню
DROP PROCEDURE IF EXISTS menu_del;
DELIMITER //
CREATE PROCEDURE menu_del(IN menu_id BIGINT)
BEGIN
	DELETE FROM tk WHERE id_menu = menu_id;
	DELETE FROM menu WHERE id = menu_id;
END//

-- Процедура создания ТК
DROP PROCEDURE IF EXISTS tk_add;
DELIMITER //
CREATE PROCEDURE tk_add(IN id_menu_d BIGINT, IN id_warehouse_d BIGINT, 
										IN value_d BIGINT, IN id_massa_d BIGINT)
BEGIN 
	INSERT tk (id_menu, id_warehouse, value, id_massa)
	VALUES(id_menu_d, id_warehouse_d, value_d, id_massa_d);
END//


DROP PROCEDURE IF EXISTS discount_add;
DELIMITER //
CREATE PROCEDURE discount_add(IN summ_d BIGINT, IN id_money_d BIGINT, IN disc_d BIGINT)
BEGIN 
INSERT discount (summ, id_money, disc)
values(summ_d, id_money_d, disc_d);
END//


DROP PROCEDURE IF EXISTS waiters_add;
DELIMITER //
CREATE PROCEDURE waiters_add(IN first_name_d VARCHAR(30), 
					IN last_name_d VARCHAR(30), IN birthday_d DATE)
BEGIN 
	INSERT waiters (first_name, last_name, birthday)
	VALUES(first_name_d, last_name_d, birthday_d);
END//

DROP PROCEDURE IF EXISTS waiters_del;
DELIMITER //
CREATE PROCEDURE waiters_del(IN id_waiters BIGINT)
BEGIN 
	DELETE FROM waiters WHERE id = id_waiters;
END//


DROP PROCEDURE IF EXISTS sell_table_add;
DELIMITER //
CREATE PROCEDURE sell_table_add (IN id_waiters_d BIGINT, IN id_customers_d BIGINT)
BEGIN 
	INSERT sell_table (id_waiters, id_customers)
	VALUES(id_waiters_d, id_customers_d);
END//

DROP PROCEDURE IF EXISTS sell_table_del;
DELIMITER //
CREATE PROCEDURE sell_table_del (IN id_tab BIGINT)
BEGIN 
	DELETE FROM sell_table WHERE id = id_tab;
END//

DROP PROCEDURE IF EXISTS customers_add;
DELIMITER //
CREATE PROCEDURE customers_add(IN first_name_d VARCHAR(30), IN last_name_d VARCHAR(30), IN birthday_d DATE)
BEGIN 
	INSERT customers (first_name, last_name, birthday)
VALUES(first_name_d, last_name_d, birthday_d);
END//

DROP PROCEDURE IF EXISTS customers_del;
DELIMITER //
CREATE PROCEDURE customers_del(IN id_customer BIGINT)
BEGIN 
	DELETE FROM customers WHERE id = id_customer;
END//

-- Процедура добавляет напиток в заказ (ордер) и вычитает ингридиенты со склада.
DROP PROCEDURE IF EXISTS orders_add;
DELIMITER //
CREATE PROCEDURE orders_add(IN id_sell_table_d BIGINT, 
							IN id_menu_d BIGINT, IN counts_d BIGINT)
	BEGIN 
		INSERT orders(id_sell_table, id_menu, counts)
		VALUES(id_sell_table_d, id_menu_d, counts_d);
		UPDATE tk_warehouse_menu_tables SET warehouse_value = warehouse_value - (tk_value * counts_d)
		WHERE menu = id_menu_d;
	END//

-- Процедур вносит поставку уже существующих ингридиентов.
	-- Добавляет колличество на склад + делает перерасчет себестоимости ингридиентов, напитков исходя из остатков и прихода.

DROP PROCEDURE IF EXISTS add_ingridients_procedure;
DELIMITER //
CREATE PROCEDURE add_ingridients_procedure (IN name_d VARCHAR(30), IN total_ing_d BIGINT, IN total_price_d BIGINT)
BEGIN 
	SET @val := (SELECT value FROM warehouse WHERE warehouse.name = name_d);
	UPDATE price_products SET price_point = 
	((price_point * @val + total_price_d) / (total_ing_d + @val));
	UPDATE warehouse SET value = value + total_ing_d WHERE warehouse.name = name_d;
	SET @val_p := (SELECT price_point * 1000 FROM price_products WHERE name = name_d);
	UPDATE price_products SET price_kg_l = @val_p WHERE name = name_d;
END//
