# IU7_sem5_bd
Лабораторные работы МГТУ ИУ7 5 семестр БД

## Структура базы данных

```sql
Table Venues {
  id int [pk, increment]
  name text
  address text
  city text
  capacity int
  phone text
}

Table Events {
  id int [pk, increment]
  venue_id int [ref: > Venues.id]
  name text
  date date
  start_time time
  duration interval
}

Table Performers {
  id int [pk, increment]
  name text
  genre text
  country text
}

Table Event_Performers {
  event_id int [ref: > Events.id]
  performer_id int [ref: > Performers.id]
}

Table Tickets {
  id int [pk, increment]
  event_id int [ref: > Events.id]
  price decimal
  ticket_type text
  status text
}

Table Customers {
  id int [pk, increment]
  first_name text
  last_name text
  email text
  phone text
}

Table Orders {
  id int [pk, increment]
  customer_id int [ref: > Customers.id]
  order_date date
  total_amount decimal
}

Table Order_Tickets {
  order_id int [ref: > Orders.id]
  ticket_id int [ref: > Tickets.id]
  quantity int
}

```
