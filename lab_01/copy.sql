COPY Venues(name, address, city, capacity, phone)
FROM '/data/venues.csv'
DELIMITER ','
CSV HEADER;

COPY Events(venue_id, name, date, start_time, duration)
FROM '/data/events.csv'
DELIMITER ','
CSV HEADER;

COPY Performers(name, genre, country)
FROM '/data/performers.csv'
DELIMITER ','
CSV HEADER;

COPY Event_Performers(event_id, performer_id)
FROM '/data/event_performers.csv'
DELIMITER ','
CSV HEADER;

COPY Tickets(event_id, price, ticket_type, status)
FROM '/data/tickets.csv'
DELIMITER ','
CSV HEADER;

COPY Customers(first_name, last_name, email, phone)
FROM '/data/customers.csv'
DELIMITER ','
CSV HEADER;

COPY Orders(customer_id, order_date, total_amount)
FROM '/data/orders.csv'
DELIMITER ','
CSV HEADER;

COPY Order_Tickets(order_id, ticket_id, quantity)
FROM '/data/order_tickets.csv'
DELIMITER ','
CSV HEADER;
