from random import randrange
from tracemalloc import start
import generator1
import codecs
import sys
import time
import datetime
from datetime import datetime, timedelta
from faker import Faker
import random

fake = Faker(['pl_PL'])

start = time.time()

second_peopleNo = 50
second_customersNo = 30
second_sessionsNo = 100
second_start_date = generator1.end_date + timedelta(seconds=1)
second_end_date = datetime.now()
second_reservationsNo = 200
second_surveysNo = 100


for i in generator1.bills_data:
    if i[2] == 0:
        if randrange(2) < 1:
            i[2] = 1
            i[3] = fake.date_time_between_dates(datetime_start = second_start_date, datetime_end = second_end_date)
            i[4] = "card" if randrange(2) < 1 else "cash"

for i in generator1.workers_data:
    randspec = randrange(3)
    
    if randrange(10) < 1:
        if i[1] == 'trainer':
            i[2] = generator1.trainerspec[randspec]
            i[0] = i[0] + round(random.uniform(-500.00, 3000.00), 2)
        elif i[1] == 'receptionist':
            i[2] = generator1.receptionistspec[randspec]
            i[0] = i[0] + round(random.uniform(-500.00, 3000.00), 2)

for i in range(int(generator1.customersNo/10)):
    randcustomer = randrange(generator1.customersNo)
    generator1.customers_data[randcustomer][0] = int(not(generator1.customers_data[randcustomer][0]))
    if generator1.customers_data[randcustomer][0] == 0:
        generator1.customers_data[randcustomer][1] = ""
    else:
        generator1.customers_data[randcustomer][1] = random.choice(generator1.prices)


generator1.people_generator(second_peopleNo)
generator1.customers_generator(second_customersNo)
generator1.sessions_generator(second_sessionsNo, second_start_date, second_end_date)
generator1.reservations_generator(second_reservationsNo, generator1.ReservationsNo, second_end_date, generator1.sessionsNo,second_customersNo, second_sessionsNo, generator1.customersNo, len(generator1.bills_data))
generator1.bills_generator(second_reservationsNo, generator1.ReservationsNo, second_end_date)
generator1.surveys_generator(second_surveysNo, second_end_date, generator1.sessionsNo, second_sessionsNo, generator1.ReservationsNo)

# WRITING TO FILE

with codecs.open('people2.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in generator1.people_data:
        print(',' + ','.join(map(str,i)))

with codecs.open('customers2.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in generator1.customers_data:
        print(',' + ','.join(map(str,i)))
    
with codecs.open('gymworkers2.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in generator1.workers_data:
        print(',' + ','.join(map(str,i)))

with codecs.open('sessiontopics2.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in generator1.topics_data:
        print(',' + ','.join(map(str,i)))

with codecs.open('sessions2.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in generator1.sessions_data:
        print(',' + ','.join(map(str,i)))

with codecs.open('reservations2.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in generator1.reservations_data:
        print(',' + ','.join(map(str,i)))

with codecs.open('bills2.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in generator1.bills_data:
        print(',' + ','.join(map(str,i)))

with codecs.open('surveys2.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in generator1.surveys_data:
        print(','.join(map(str,i)))

sys.stdout = generator1.original_stdout
end = time.time()
print(end - start)