alter table Events add foreign key (venue_id) references Venues(id);

alter table Event_Performers add foreign key (event_id) references Events(id);

alter table Event_Performers add foreign key (performer_id) references Performers(id);

alter table Tickets add foreign key (event_id) references Events(id);

alter table Orders add foreign key (customer_id) references Customers(id);

alter table Order_Tickets add foreign key (order_id) references Orders(id);

alter table Order_Tickets add foreign key (ticket_id) references Tickets(id);

alter table Venues drop constraint if exists capacity_pos_constraint;
alter table Venues add constraint capacity_pos_constraint check(capacity > 0);
-- alter table Events drop constraint if exists time_constraint;
-- alter table Events add constraint time_constraint check(start_time < end_time);
alter table Tickets drop constraint if exists price_pos_constraint;
alter table Tickets add constraint price_pos_constraint check(price > 0);
alter table Orders drop constraint if exists total_amount_pos_constraint;
alter table Orders add constraint total_amount_pos_constraint check(total_amount > 0);
alter table Order_Tickets drop constraint if exists quantity_pos_constraint;
alter table Order_Tickets add constraint quantity_pos_constraint check(quantity > 0);
