USE Gym


BULK INSERT dbo.People FROM 'C:\Users\micha\OneDrive\Pulpit\uczelnia\semIV\DataWarehousesProject\people.bulk' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0A', KEEPNULLS)
BULK INSERT dbo.Customers FROM 'C:\Users\micha\OneDrive\Pulpit\uczelnia\semIV\DataWarehousesProject\customers.bulk' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0A', KEEPNULLS)
BULK INSERT dbo.GymWorkers FROM 'C:\Users\micha\OneDrive\Pulpit\uczelnia\semIV\DataWarehousesProject\gymworkers.bulk' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0A', KEEPNULLS)
BULK INSERT dbo.SessionTopics FROM 'C:\Users\micha\OneDrive\Pulpit\uczelnia\semIV\DataWarehousesProject\sessiontopics.bulk' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0A', KEEPNULLS)
BULK INSERT dbo.TrainingSessions FROM 'C:\Users\micha\OneDrive\Pulpit\uczelnia\semIV\DataWarehousesProject\sessions.bulk' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0A', KEEPNULLS)
BULK INSERT dbo.Bills FROM 'C:\Users\micha\OneDrive\Pulpit\uczelnia\semIV\DataWarehousesProject\bills.bulk' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0A', KEEPNULLS)
BULK INSERT dbo.Reservations FROM 'C:\Users\micha\OneDrive\Pulpit\uczelnia\semIV\DataWarehousesProject\reservations.bulk' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0A', KEEPNULLS)

