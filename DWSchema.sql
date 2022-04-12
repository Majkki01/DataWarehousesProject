USE GymDW

CREATE TABLE [Date] (
    [Date] DATE PRIMARY KEY,
    [Year] INTEGER,
    MonthNo INTEGER,
    [Day] INTEGER,
    DayWeek VARCHAR(10),
    Season VARCHAR(10),
    Holiday VARCHAR(50),
    MonthName VARCHAR(10),
    WeekNo INTEGER,
    DayWeekNo INTEGER
)

CREATE TABLE [Time] (
    [Time] Time PRIMARY KEY,
    Hour INTEGER,
    Minute INTEGER,
    TimeOfDay VARCHAR(10)
)

CREATE TABLE Customers (
	CustomerID INTEGER IDENTITY(1,1) PRIMARY KEY,
	IsClubMember varchar(18),
	NameSurname varchar(50),
    Gender varchar(7),
    CustomerNo INTEGER,
    isActive BIT
)

CREATE TABLE GymWorkers (
	GymWorkerID INTEGER IDENTITY(1,1) PRIMARY KEY,
	SalaryCat varchar(10),
    Role varchar(20),
	Specialization varchar(20),
    NameSurname varchar(50),
    Gender varchar(7)
)

CREATE TABLE SessionTopics (
	TopicID INTEGER IDENTITY(1,1) PRIMARY KEY,
	Type varchar(10),
	Name varchar(30)
)

CREATE TABLE TrainingSessions (
	TrainingSessionID INTEGER IDENTITY(1,1) PRIMARY KEY,
	DateOfSessionID Date FOREIGN KEY REFERENCES [Date]([Date]),
    TimeOfSessionID Time FOREIGN KEY REFERENCES [Time]([Time]),
    TopicID INTEGER FOREIGN KEY REFERENCES SessionTopics(TopicID),
    GymWorkerID INTEGER FOREIGN KEY REFERENCES GymWorkers(GymWorkerID),
	TotalSlots INTEGER,
	AvailableSlots INTEGER,
	Price DECIMAL(5,2)
)

CREATE TABLE Junk (
    JunkID INTEGER IDENTITY(1,1) PRIMARY KEY,
    TrainingQuality CHAR(1),
    AverageTotalScore VARCHAR(10)
)

CREATE TABLE Reservations (
	DateOfReservationID DATE FOREIGN KEY REFERENCES [Date]([Date]),
    TimeOfReservationID TIME FOREIGN KEY REFERENCES [Time]([Time]),
    TrainingSessionID INTEGER REFERENCES TrainingSessions,
    CustomerID INTEGER FOREIGN KEY REFERENCES Customers(CustomerID),
    GymWorkerID INTEGER FOREIGN KEY REFERENCES GymWorkers(GymWorkerID),
    JunkID INTEGER FOREIGN KEY REFERENCES Junk(JunkID),
    CustomerPESEL CHAR(11),
    CustomerAge INTEGER,
    TrainersPerformance INTEGER,
    EquipmentsQuality INTEGER,
    TrainingQuality INTEGER,
    Cleanliness INTEGER,
	Discount DECIMAL(5,2)
)

ALTER TABLE Reservations
ADD CONSTRAINT CheckSurveys CHECK (
    TrainersPerformance > 0 AND 
    TrainersPerformance < 6 AND 
    EquipmentsQuality > 0 AND 
    EquipmentsQuality < 6 AND 
    TrainingQuality > 0 AND 
    TrainingQuality < 6 AND 
    Cleanliness > 0 AND 
    Cleanliness < 6
)

ALTER TABLE GymWorkers
ADD CONSTRAINT CheckGymWorkers CHECK (
    SalaryCat IN ('low salary', 'medium salary', 'high salary') AND
    [Role] IN ('trainer', 'receptionist', 'receptionist') AND
    Specialization IN ('cardio', 'strength training', 'dietetics', 'accounting', 'cleaning', 'marketing') AND
    Gender IN ('male', 'female', 'unknown')
)

ALTER TABLE [Time]
ADD CONSTRAINT CheckTime CHECK (
    Hour >= 0 AND Hour < 24 AND
    Minute >= 0 AND Minute < 60 AND
    TimeOfDay IN ('morning', 'afternoon', 'evening') 
)

ALTER TABLE Junk
ADD CONSTRAINT CheckJunk CHECK (
    TrainingQuality IN ('1', '2', '3', '4', '5') AND
    AverageTotalScore IN ('very low', 'low', 'medium', 'high', 'very high')
)

ALTER TABLE SessionTopics
ADD CONSTRAINT CheckTopics CHECK (
    Name IN ('Cardio Boost','Strength Boost','Mixed work-out','Dietetic consultancy','Work-out consultancy','Beginner Boxing','Intermediate Boxing','Profiled stretching','Zumba classes','Slim thighs','Aerobic','Group stretching','Group cardio','Boxing sparring','Group barbells','Trampolines','Groupb Yoga') AND
    Type IN ('individual', 'group')
)

ALTER TABLE Customers
ADD CONSTRAINT CheckCustomers CHECK (
    IsClubMember IN ('Is club member', 'Is not club member') AND
    Gender IN ('male', 'female', 'unknown')
)

ALTER TABLE [Date]
ADD CONSTRAINT CheckDate CHECK (
    [Year] > 999 AND [Year] < 10000 AND
    [Day] > 0 AND [Day] < 32 AND
    MonthNo > 0 AND MonthNo < 13 AND
    DayWeek IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') AND
    Season IN ('Spring', 'Summer', 'Autumn', 'Winter') AND
    Holiday IN ('New year', 'Epiphany', 'Easter', 'Easter Monday', 'international labor day', 'Constitution Day May 3', 'Pentecost', 'Corpus Christi', 'Assumption of the Blessed Virgin Mary', 'All the saints', 'National Independence Day', 'Christmas (first day)', 'Christmas (second day)') AND
    MonthName IN ('Januray', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'December')
)

