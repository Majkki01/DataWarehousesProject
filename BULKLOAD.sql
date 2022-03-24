USE Gym


BULK INSERT dbo.People FROM 'C:\Users\micha\OneDrive\Pulpit\uczelnia\semIV\DataWarehousesProject\people2.bulk' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0A', KEEPNULLS)
BULK INSERT dbo.Customers FROM 'C:\Users\micha\OneDrive\Pulpit\uczelnia\semIV\DataWarehousesProject\customers2.bulk' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0A', KEEPNULLS)
BULK INSERT dbo.GymWorkers FROM 'C:\Users\micha\OneDrive\Pulpit\uczelnia\semIV\DataWarehousesProject\gymworkers2.bulk' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0A', KEEPNULLS)
BULK INSERT dbo.SessionTopics FROM 'C:\Users\micha\OneDrive\Pulpit\uczelnia\semIV\DataWarehousesProject\sessiontopics2.bulk' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0A', KEEPNULLS)
BULK INSERT dbo.TrainingSessions FROM 'C:\Users\micha\OneDrive\Pulpit\uczelnia\semIV\DataWarehousesProject\sessions2.bulk' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0A', KEEPNULLS)
BULK INSERT dbo.Bills FROM 'C:\Users\micha\OneDrive\Pulpit\uczelnia\semIV\DataWarehousesProject\bills2.bulk' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0A', KEEPNULLS)
BULK INSERT dbo.Reservations FROM 'C:\Users\micha\OneDrive\Pulpit\uczelnia\semIV\DataWarehousesProject\reservations2.bulk' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0A', KEEPNULLS)

