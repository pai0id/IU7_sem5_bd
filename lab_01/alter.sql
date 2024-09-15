alter table Events add foreign key (venue_id) references Venues(id);

alter table Event_Performers add foreign key (event_id) references Events(id);

alter table Event_Performers add foreign key (performer_id) references Performers(id);

alter table Tickets add foreign key (event_id) references Events(id);

alter table Orders add foreign key (customer_id) references Customers(id);

alter table Order_Tickets add foreign key (order_id) references Orders(id);

alter table Order_Tickets add foreign key (ticket_id) references Tickets(id);
