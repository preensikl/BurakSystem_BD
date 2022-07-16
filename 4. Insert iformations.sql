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
-- CALL transaction_pre(7, 1000) .


/* Добавление позиции в меню
-- CALL menu_add('Hot Chocolate', 350, 1);

/* Удаляет позицию из меню */
-- CALL menu_del(4);

/* Добавляем ингридиенты в меню. (создаем ТК).
-- CALL tk_add(5, 7, 210, 4);

Добавляет позицию в стол заказа */
-- CALL orders_add(id_sell_table_d, id_menu_d , counts)

/* Добавление позиции на склад. (Название, ид_массы, колличество) */
-- CALL warehouse_add('Название', ид_массы, колличество);
CALL warehouse_add('Milk', 4, 100000, 5000 );
CALL warehouse_add('Espresso beans', 2, 20000, 20000);
CALL warehouse_add('Chocolate', 2, 5000, 3500);
CALL warehouse_add('Sugar', 2, 10000, 500);
CALL warehouse_add('Oragne', 2, 1000, 100);
CALL warehouse_add('Black tea', 2, 1000, 2500);
CALL warehouse_add('Green tea', 2, 1000, 2600);

-- Добавление позиции в меню
-- CALL menu_add('Название', цена , валюта);
CALL menu_add('Latte', 250, 1);
CALL menu_add('Cappuccino', 250, 1);
CALL menu_add('Americano', 180, 1);
CALL menu_add('Hot Chocolate', 300, 1);


SELECT * FROM warehouse w 	;

-- Добавляем ингридиенты в меню. (создаем ТК).
-- CALL tk_add(id_menu, id_warehouse, колличество, id_массы);
CALL tk_add(1, 1, 220, 1);
CALL tk_add(1, 2, 12, 1);
CALL tk_add(2, 1, 200, 1);
CALL tk_add(2, 2, 20, 1);
CALL tk_add(4, 2, 20, 1);
CALL tk_add(3, 1, 250, 1);
CALL tk_add(3, 3, 30, 1);

-- Добавляем скидки
-- CALL discount_add(порог, id_money, скидка )
CALL discount_add(3000, 1, 2);
CALL discount_add(5000, 1, 3);
CALL discount_add(10000, 1, 5);

-- Создаем персонал
CALL waiters_add('Misha', 'Korniushenko', '1997-05-28');
CALL waiters_add('Alina', 'Konovalova', '1998-06-20');

-- Добавляем постоянных гостей
CALL customers_add('Burak', 'Ayucut', '2000-01-01');
CALL customers_add('Ellis', 'Miuyk', '1980-02-02');

-- Добавляем столы
CALL sell_table_add(1, NULL);
CALL sell_table_add(2, NULL);
SELECT * FROM sell_table;
EXPLAIN SELECT * FROM menu_sebest;

CALL orders_add(1, 1, 1);
CALL orders_add(1, 1, 3);
CALL orders_add(3, 2, 1);
SELECT * FROM sell_table st ;



-- Допустим приехала новая партия молока, но уже по другой стоимости 
CALL add_ingridients_procedure('Milk', 100000, 6300);

-- Закрываем стол, высчитываем сдачу и сохраняем в историю.
CALL transaction_pre(1, 2000);


SELECT * FROM summ_one_table;