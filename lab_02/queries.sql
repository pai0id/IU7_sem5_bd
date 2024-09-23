-- task

-- Вывести всех исполнителей, битлеты на концерты которых купил покупатель 8
SELECT DISTINCT 
    p.id AS performer_id,
    p.name AS performer_name,
    p.genre,
    p.country
FROM 
    Customers c
JOIN 
    Orders o ON c.id = o.customer_id
JOIN 
    Order_Tickets ot ON o.id = ot.order_id
JOIN 
    Tickets t ON ot.ticket_id = t.id
JOIN 
    Events e ON t.event_id = e.id
JOIN 
    Event_Performers ep ON e.id = ep.event_id
JOIN 
    Performers p ON ep.performer_id = p.id
WHERE 
    c.id = 8;

-- 1

SELECT *
FROM Events
WHERE date > '2024-02-01';

SELECT *
FROM Tickets
WHERE price > 30 AND status = 'available';

-- 2

SELECT *
FROM Events
WHERE date BETWEEN '2024-02-01' AND '2024-05-31';

SELECT *
FROM Tickets
WHERE price BETWEEN 20 AND 100;

-- 3

SELECT *
FROM Customers
WHERE first_name LIKE 'J%';

SELECT *
FROM Customers
WHERE email LIKE '%.com';

-- 4

-- Найти всех исполнителей, которые выступали на конкретных событиях в конкретном периоде
SELECT *
FROM Performers
WHERE id IN (
    SELECT performer_id
    FROM Event_Performers
    WHERE event_id IN (
        SELECT id
        FROM Events
        WHERE date BETWEEN '2024-02-01' AND '2024-05-31'
    )
);

-- Получить все билеты для событий, проходящих в выбранных городах
SELECT *
FROM Tickets
WHERE event_id IN (
    SELECT id
    FROM Events
    WHERE venue_id IN (
        SELECT id
        FROM Venues
        WHERE city IN ('Timberg', 'Robinsonville')
    )
);

-- 5

-- Найти всех клиентов, которые сделали хотя бы один заказ
SELECT *
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.id
);

-- Выбрать все события, на которые были проданы билеты
SELECT *
FROM Events e
WHERE EXISTS (
    SELECT 1
    FROM Tickets t
    WHERE t.event_id = e.id AND t.status = 'sold'
);

-- 6

-- Пример: Найти все заказы больше всех заказов клиента с ID 13
SELECT *
FROM Orders o
WHERE o.customer_id != 13
AND o.total_amount > ALL (
    SELECT total_amount
    FROM Orders
    WHERE customer_id = 13
);

-- 7

-- Получить общее количество заказов и их общую сумму для каждого клиента
SELECT
    c.id AS customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM 
    Customers c
LEFT JOIN 
    Orders o ON c.id = o.customer_id
GROUP BY 
    c.id;

-- Получить общее количество проданных билетов и их суммарную выручку для каждого событи
SELECT 
    e.name AS event_name,
    COUNT(t.id) AS tickets_sold,
    SUM(t.price) AS total_revenue
FROM 
    Events e
JOIN 
    Tickets t ON e.id = t.event_id
WHERE 
    t.status = 'sold'
GROUP BY 
    e.name;

-- 8

-- Выбрать все заказы с указанием имени клиента
SELECT 
    o.id AS order_id,
    o.order_date,
    o.total_amount,
    (SELECT c.first_name || ' ' || c.last_name 
     FROM Customers c 
     WHERE c.id = o.customer_id) AS customer_name
FROM 
    Orders o;

-- 9

-- Определение типа события на основе даты
SELECT 
    id AS event_id,
    name AS event_name,
    CASE date
        WHEN '2024-03-12' THEN 'today'
        WHEN '2024-03-11' THEN 'yesterday'
        ELSE 'not today'
    END AS "event_date"
FROM 
    Events;

-- 10

SELECT 
    id AS event_id,
    name AS event_name,
    date,
    CASE 
        WHEN date < '2024-05-31' THEN 'Past Event'
        WHEN date = '2024-05-31' THEN 'Ongoing Event'
        ELSE 'Upcoming Event'
    END AS event_state
FROM 
    Events;

-- 11

CREATE TEMP TABLE temp_customers AS
SELECT 
    c.id AS customer_id,
    c.first_name,
    c.last_name,
    (SELECT COUNT(*) FROM Orders o WHERE o.customer_id = c.id) AS order_count
FROM 
    Customers c;

SELECT * FROM temp_customers;

-- 12

-- Получение событий с количеством проданных билетов для каждого события
SELECT 
    e.id AS event_id,
    e.name AS event_name,
    ticket_info.tickets_sold,
    ticket_info.total_revenue
FROM 
    Events e,
    (SELECT 
         t.event_id,
         COUNT(*) AS tickets_sold,
         SUM(t.price) AS total_revenue
     FROM 
         Tickets t
     WHERE 
         t.status = 'sold'
     GROUP BY 
         t.event_id) AS ticket_info
WHERE 
    e.id = ticket_info.event_id;

-- 13

-- Получение исполнителей с количеством их событий и статусом популярности
SELECT 
    p.id AS performer_id,
    p.name AS performer_name,
    (SELECT COUNT(*) 
     FROM Event_Performers ep 
     WHERE ep.performer_id = p.id) AS event_count,
    (SELECT 
         CASE 
             WHEN COUNT(ep.event_id) < 3 THEN 'Emerging Artist'
             WHEN COUNT(ep.event_id) BETWEEN 3 AND 10 THEN 'Regular Artist'
             ELSE 'Established Artist'
         END
     FROM Event_Performers ep 
     WHERE ep.performer_id = p.id) AS popularity_status
FROM 
    Performers p;

-- 14

-- Определение общей выручки по событиям
SELECT 
    event_id,
    SUM(price) AS total_revenue
FROM 
    Tickets
GROUP BY 
    event_id;

-- 15

-- Получение клиентов с количеством заказов более 4
SELECT 
    customer_id,
    COUNT(*) AS order_count
FROM 
    Orders
GROUP BY 
    customer_id
HAVING 
    COUNT(*) >= 5;

SELECT 
    performer_id,
    COUNT(*) AS event_count
FROM 
    Event_Performers
GROUP BY 
    performer_id
HAVING 
    COUNT(*) > 3;


-- 16

INSERT INTO Performers (name, genre, country) 
VALUES ('Refused', 'Metal', 'Sweden');

-- 17

CREATE TABLE IF NOT EXISTS High_Spending_Customers (
    customer_id SERIAL PRIMARY KEY,
    first_name text,
    last_name text,
    total_spent decimal
);

INSERT INTO High_Spending_Customers (customer_id, first_name, last_name, total_spent)
SELECT 
    c.id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_spent
FROM 
    Customers c
JOIN 
    Orders o ON c.id = o.customer_id
GROUP BY 
    c.id, c.first_name, c.last_name
HAVING 
    SUM(o.total_amount) > 500;

-- 18

UPDATE Customers
SET phone = '987-654-3210'
WHERE id = 1;

-- 19

UPDATE Orders
SET total_amount = (SELECT AVG(total_amount) FROM Orders)
WHERE customer_id = 1;

-- 20

DELETE FROM Tickets
WHERE id = 1;

-- 21

-- Удаление клиентов, у которых нет заказов
DELETE FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.id
);

-- 22

-- Получение событий с их средней ценой билетов
WITH AverageTicketPrices AS (
    SELECT 
        event_id,
        AVG(price) AS avg_price
    FROM 
        Tickets
    GROUP BY 
        event_id
)
SELECT 
    e.id,
    e.name,
    atp.avg_price
FROM 
    Events e
JOIN 
    AverageTicketPrices atp ON e.id = atp.event_id;


-- 23

-- Информация о билетах на мероприятия конкретного исполнителя
WITH RECURSIVE PerformerEvents (event_id, performer_name, venue_name, ticket_id, ticket_status) AS (
    SELECT e.id, p.name AS performer_name, v.name AS venue_name, t.id AS ticket_id, t.status AS ticket_status
    FROM Performers p
    JOIN Event_Performers ep ON p.id = ep.performer_id
    JOIN Events e ON e.id = ep.event_id
    JOIN Venues v ON e.venue_id = v.id
    JOIN Tickets t ON t.event_id = e.id
    WHERE p.id = 13
    UNION ALL
    SELECT pe.event_id, pe.performer_name, pe.venue_name, t.id, t.status
    FROM PerformerEvents pe
    JOIN Tickets t ON t.event_id = pe.event_id
)
SELECT * FROM PerformerEvents;

-- 24

SELECT 
    e.id AS event_id,
    e.name AS event_name,
    t.price AS ticket_price,
    MIN(t.price) OVER (PARTITION BY e.id) AS min_ticket_price
FROM 
    Events e
JOIN 
    Tickets t ON e.id = t.event_id;

-- 25

INSERT INTO Customers (first_name, last_name, email) VALUES
('Jonn', 'Doe', 'john.doe@example.com'),
('Jane', 'Smith', 'jane.smith@example.com'),
('Jonn', 'Doe', 'john.doe@example.com'),  -- Дубликат
('Alice', 'Johnson', 'alice.johnson@example.com'),
('Jane', 'Smith', 'jane.smith@example.com');  -- Дубликат

WITH RankedCustomers AS (
    SELECT 
        id,
        first_name,
        last_name,
        email,
        ROW_NUMBER() OVER (PARTITION BY first_name, last_name, email ORDER BY id) AS row_num
    FROM 
        Customers
)
DELETE FROM Customers
WHERE id IN (
    SELECT id
    FROM RankedCustomers
    WHERE row_num > 1
);
