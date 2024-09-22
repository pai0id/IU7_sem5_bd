CREATE TABLE IF NOT EXISTS Venues (
    id SERIAL PRIMARY KEY,
    name TEXT,
    address TEXT,
    city TEXT,
    capacity INTEGER,
    phone TEXT
);

CREATE TABLE IF NOT EXISTS Events (
    id SERIAL PRIMARY KEY,
    venue_id INTEGER,
    name TEXT,
    date DATE,
    start_time TIME,
    duration INTERVAL
);

CREATE TABLE IF NOT EXISTS Performers (
    id SERIAL PRIMARY KEY,
    name TEXT,
    genre TEXT,
    country TEXT
);

CREATE TABLE IF NOT EXISTS Event_Performers (
    event_id INTEGER,
    performer_id INTEGER
);

DROP TYPE IF EXISTS ticket_status CASCADE;
CREATE TYPE ticket_status AS ENUM ('available', 'sold', 'reserved');

CREATE TABLE IF NOT EXISTS Tickets (
    id SERIAL PRIMARY KEY,
    event_id INTEGER,
    price DECIMAL,
    ticket_type TEXT,
    status ticket_status
);

CREATE TABLE IF NOT EXISTS Customers (
    id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone TEXT
);

CREATE TABLE IF NOT EXISTS Orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    total_amount DECIMAL
);

CREATE TABLE IF NOT EXISTS Order_Tickets (
    order_id INTEGER,
    ticket_id INTEGER,
    quantity INTEGER
);