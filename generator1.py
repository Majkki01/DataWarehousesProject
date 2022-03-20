from asyncio.windows_events import NULL
from multiprocessing import managers
from faker import Faker
import sys
from random import randrange
import datetime
import codecs

fake = Faker(['pl_PL'])
fake_data = []

#PEOPLE GENERATOR
for i in range(10):
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

    fake_data.append([name, surname, fake.date_between_dates(date_start='-80y', date_end='-18y'), fake.msisdn()[4:], gender])

original_stdout = sys.stdout

with codecs.open('people.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in fake_data:
        print(','.join(map(str,i)))
    sys.stdout = original_stdout


#CUSTOMERS GENERATOR
fake_data = []

for i in range(10):

    isClubMember = randrange(10)
    prices = [59.99, 79.99, 99.99, 119.99, 139.99]
    if isClubMember < 7:
        clubMember = 1
        price = prices[randrange(5)]
    else:
        clubMember = 0
        price = "NULL"
    
    hasIBAN = randrange(10)
    if hasIBAN < 7:
        iban = fake.iban()
    else:
        iban = "NULL"

    fake_data.append([clubMember, price, iban])

with codecs.open('customers.bulk', 'w', "utf-8") as f:
    sys.stdout = f
    for i in fake_data:
        print(','.join(map(str,i)))
    sys.stdout = original_stdout