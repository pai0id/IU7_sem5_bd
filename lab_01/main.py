import csv
import random
from faker import Faker
from datetime import timedelta, datetime
import os

fake = Faker()

def get_rnd_duration():
    if random.randint(0, 6) == 1:
        days = random.randint(1, 7)
    else:
        days = 0
    
    hours = random.randint(0, 23)
    minutes = random.randint(0, 59)
    seconds = 0

    interval_str = f"{days} {hours:02d}:{minutes:02d}:{seconds:02d}"

    return interval_str

def generate_venues(num_venues):
    venues = []
    for _ in range(num_venues):
        venues.append([
            fake.company(),
            fake.address(),
            fake.city(),
            random.randint(100, 5000),
            fake.phone_number()
        ])
    return venues

def generate_events(num_events, num_venues):
    events = []
    for _ in range(num_events):
        start_time = fake.time()
        duration = random.randint(1, 3)
        duration = get_rnd_duration()
        events.append([
            random.randint(1, num_venues),
            fake.catch_phrase(),
            fake.date_this_year(),
            start_time,
            duration
        ])
    return events

def generate_performers(num_performers):
    performers = []
    for _ in range(num_performers):
        performers.append([
            fake.name(),
            fake.name(),
            fake.country()
        ])
    return performers

def generate_event_performers(num_events, num_performers):
    event_performers = []
    for _ in range(num_events):
        event_id = random.randint(1, num_events)
        performer_id = random.randint(1, num_performers)
        event_performers.append([event_id, performer_id])
    return event_performers

def generate_tickets(num_tickets, num_events):
    ticket_status_options = ['available', 'sold', 'reserved']
    tickets = []
    for _ in range(num_tickets):
        tickets.append([
            random.randint(1, num_events),
            round(random.uniform(10, 100), 2),
            fake.word(ext_word_list=['VIP', 'Standard', 'Economy']),
            random.choice(ticket_status_options)
        ])
    return tickets

def generate_customers(num_customers):
    customers = []
    for _ in range(num_customers):
        customers.append([
            fake.first_name(),
            fake.last_name(),
            fake.email(),
            fake.phone_number()
        ])
    return customers

def generate_orders(num_orders, num_customers):
    orders = []
    for _ in range(num_orders):
        orders.append([
            random.randint(1, num_customers),
            fake.date_this_year(),
            round(random.uniform(50, 500), 2)
        ])
    return orders

def generate_order_tickets(num_orders, num_tickets):
    order_tickets = []
    for _ in range(num_orders):
        order_id = random.randint(1, num_orders)
        ticket_id = random.randint(1, num_tickets)
        quantity = random.randint(1, 5)
        order_tickets.append([order_id, ticket_id, quantity])
    return order_tickets

def write_to_csv(filename, data, headers):
    with open(filename, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(headers)
        writer.writerows(data)

num_venues = 100
num_events = 500
num_performers = 300
num_tickets = 200000
num_customers = 1000
num_orders = 1500

try:
    os.mkdir("data")
except Exception:
    print("data exists")
write_to_csv('data/venues.csv', generate_venues(num_venues), ['name', 'address', 'city', 'capacity', 'phone'])
write_to_csv('data/events.csv', generate_events(num_events, num_venues), ['venue_id', 'name', 'date', 'start_time', 'end_time'])
write_to_csv('data/performers.csv', generate_performers(num_performers), ['name', 'genre', 'country'])
write_to_csv('data/event_performers.csv', generate_event_performers(num_events, num_performers), ['event_id', 'performer_id'])
write_to_csv('data/tickets.csv', generate_tickets(num_tickets, num_events), ['event_id', 'price', 'ticket_type', 'status'])
write_to_csv('data/customers.csv', generate_customers(num_customers), ['first_name', 'last_name', 'email', 'phone'])
write_to_csv('data/orders.csv', generate_orders(num_orders, num_customers), ['customer_id', 'order_date', 'total_amount'])
write_to_csv('data/order_tickets.csv', generate_order_tickets(num_orders, num_tickets), ['order_id', 'ticket_id', 'quantity'])

print("Data generation complete. CSV files created.")
