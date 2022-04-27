
from numpy import average


average_score = ['very low', 'low', 'medium', 'high', 'very high']

for i in range(5):
    for j in range(5):
        print("INSERT INTO Junk VALUES('{a}','{b}')".format(a=i+1, b=average_score[j]))
    