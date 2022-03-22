from asyncio.windows_events import NULL
from multiprocessing import managers
from faker import Faker
import sys
from random import randrange
import datetime
import codecs
import random
from datetime import datetime, timedelta

fake = Faker(['pl_PL'])

peopleNo = 10
customersNo = 10
workersNo = 20
sessionsNo = 10
ReservationsNo = 20
BillsNo = 10
original_stdout = sys.stdout


#PEOPLE GENERATOR
people_data = []

for i in range(peopleNo):

    x = randrange(100)
    if x < 45:
        gender = "man"
    elif x < 90:
        gender = "woman"
    else:
        gender = "unknown"

    if gender == "man":
        name = fake.first_name_male()
        surname = fake.last_name_male()
    elif gender == "woman":
        name = fake.first_name_female()
        surname = fake.last_name_female()
    else:
        name = fake.first_name_nonbinary()
        surname = fake.last_name_nonbinary()

    people_data.append([name, surname, fake.date_between_dates(date_start='-80y', date_end='-18y'), fake.msisdn()[4:], gender])


#CUSTOMERS GENERATOR
customers_data = []
prices = [59.99, 79.99, 99.99, 119.99, 139.99]

for i in range(customersNo):

    isClubMember = randrange(10)

    if isClubMember < 7:
        clubMember = 1
        price = prices[randrange(5)]
    else:
        clubMember = 0
        price = ""
    
    hasIBAN = randrange(10)
    if hasIBAN < 7:
        iban = fake.iban()
    else:
        iban = ""

    customers_data.append([clubMember, price, iban])


#GYM WORKERS GENERATOR
workers_data = []
trainerspec = ["cardio", "strength training", "dietetics"]
receptionistspec = ["accounting", "cleaning", "marketing"]
managerspec = ["human Resources", "finance", "PR management"]

for i in range(workersNo):

    salary = round(random.uniform(3000.10, 15000.00), 2)
    randomrole = randrange(20)

    if randomrole < 14:
        role = "trainer"
        specialization = trainerspec[randrange(3)]
    elif randomrole < 18:
        role = "receptionist"
        specialization = receptionistspec[randrange(3)]
    else:
        role = "manager"
        specialization = managerspec[randrange(3)]

    workers_data.append([salary, role, specialization])


#SESSION TOPICS GENERATOR
topics_data = []

topics_data.append(["Cardio Boost", "Individual", "Training endurance and endurance with the use of stationary gym machines"])
topics_data.append(["Strength Boost", "Individual", "General training session focused on increasing muscle volume"])
topics_data.append(["Mixed work-out", "Individual", "Combining strength and endurance to increase physical fitness"])
topics_data.append(["Dietetic consultancy", "Individual", "Creating and anaylyzing nutritional plan with the best specialists + training"])
topics_data.append(["Work-out consultancy", "Individual", "Creating and analyzing weekly training plans with the best specilists + training"])
topics_data.append(["Beginner Boxing", "Individual", "Classes aimed at learning some basics of boxing with experienced trainer"])
topics_data.append(["Intermediate Boxing", "Individual", "Classes aimed at improving boxing technique and increasing its effectiveness + endurance"])
topics_data.append(["Profiled stretching", "Individual", "Classes which focues on improving posture and the degree of stretching and muscle relaxation"])
topics_data.append(["Zumba classes", "Group", "Keeping in shape together with learning some aspects of zumba"])
topics_data.append(["Slim thighs", "Group", "Group classes focued on increases physical effort and fat loss"])
topics_data.append(["Aerobic", "Group", "Combining physcial and development exercises with rhytmic music"])
topics_data.append(["Group stretching", "Group", "Stretching all body parts in group with good astosphere"])
topics_data.append(["Group cardio", "Group", "Synchronously improve your endurance on stationary bikes and other equipment"])
topics_data.append(["Boxing sparring", "Group", "Test your abilities and compare yourself in boxing sparrings with other participants"])
topics_data.append(["Group barbells", "Group", "Lifting different types of weights in a form of integrating group classes"])
topics_data.append(["Trampolines", "Group", "Here you can lose weight quickly by jumping on trampolines (improving condition and balance"])
topics_data.append(["Group Yoga", "Group", "Classes which teach basics of yoga with relaxation and stretching"])


# TRAINING SESSIONS GENERATOR
sessions_data = []
rooms = ["A01", "A02", "A03", "A11", "A12", "B01", "B02", "B03", "B11", "B12"]
resPrices = ["40.99", "50.99", "60.99", "70.99"]

for i in range(sessionsNo):

    day = str(fake.date_between_dates(date_start='-1y', date_end='+14d'))

    hour = str(random.randint(7,21))
    minrand = randrange(2)
    if minrand == 0:
        minute = "00"
    else:
        minute = "30"

    date = day + " " + hour + ":" + minute + ":00"

    topic = randrange(len(topics_data))

    if topics_data[topic][1] == "Individual":
        total_slots = 1
    else:
        total_slots = random.randint(5,25)


    trainer = randrange(workersNo)

    while workers_data[trainer][1] != "trainer":
        trainer = randrange(workersNo)

    sessions_data.append([date, total_slots, total_slots, random.choice(rooms), random.choice(resPrices), topic + 1, trainer + 1])


# RESERVATIONS GENERATOR
reservations_data = []

for i in range(ReservationsNo):
    if i < customersNo:
        customer = i
    else:
        customer = randrange(customersNo)

    session = randrange(sessionsNo)

    while sessions_data[session][2] == 0:
        session = randrange(sessionsNo)

    session_date = datetime.strptime(sessions_data[session][0], '%Y-%m-%d %H:%M:%S')

    max_reservation_date = min(session_date, datetime.now())

    reservation_date = fake.date_time_between_dates(datetime_start = session_date - timedelta(days=31), datetime_end = max_reservation_date)

    sessions_data[session][2] = sessions_data[session][2] - 1
    
    if session_date - reservation_date >= timedelta(days=14):
        discount = round(0.15 * float(sessions_data[session][4]),2)
    else:
        discount = 0

    reservation_type_rand = randrange(10)
    if(reservation_type_rand > 6 and customers_data[customer][2] != ""):
        reservation_type = "online"
    else:
        reservation_type = "offline"

    receptionist = randrange(workersNo)
    while workers_data[receptionist][1] != "receptionist":
        receptionist = randrange(workersNo)

    reservations_data.append([reservation_date, discount, reservation_type, customer+workersNo+1, receptionist+1, session+1, i+1])

# BILLS GENERATOR
bills_data = []

for i in range(ReservationsNo):

    value = round(float(sessions_data[reservations_data[i][5]-1][4]) - reservations_data[i][1],2)
    
    due_date = reservations_data[i][0] + timedelta(days=7)
    
    is_paid_rand = randrange(10)
    if is_paid_rand < 8:
        is_paid = 1
    else:
        is_paid = 0

    max_date = min(due_date, datetime.now())

    if is_paid:
        date_of_payment = fake.date_time_between_dates(datetime_start = reservations_data[i][0], datetime_end = max_date)
    else:
        date_of_payment = ""

    if reservations_data[i][2] == "online":
        payment_method = "online"
    else:
        if randrange(2) < 1:
            payment_method = "cash"
        else:
            payment_method = "card"

    bills_data.append([value, due_date, is_paid, date_of_payment, payment_method, reservations_data[i][3]])

# WRITING TO FILE

with codecs.open('people.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in people_data:
        print(',' + ','.join(map(str,i)))

with codecs.open('customers.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in customers_data:
        print(',' + ','.join(map(str,i)))
    
with codecs.open('gymworkers.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in workers_data:
        print(',' + ','.join(map(str,i)))

with codecs.open('sessiontopics.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in topics_data:
        print(',' + ','.join(map(str,i)))

with codecs.open('sessions.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in sessions_data:
        print(',' + ','.join(map(str,i)))

with codecs.open('reservations.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in reservations_data:
        print(',' + ','.join(map(str,i)))

with codecs.open('bills.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in bills_data:
        print(',' + ','.join(map(str,i)))
