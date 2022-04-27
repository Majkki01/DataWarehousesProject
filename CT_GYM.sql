USE Gym

CREATE TABLE People (
	ID INTEGER IDENTITY(1,1) PRIMARY KEY,
	FirstName varchar(20),
	Surname varchar(20),
	DateOfBirth DATE,
	PhoneNumber varchar(9),
	Gender varchar(7),
	PESEL char(11)
)

CREATE TABLE Customers (
	ID INTEGER IDENTITY(21,1) REFERENCES People PRIMARY KEY,
	IsClubMember BIT,
	PassPrice DECIMAL(5,2),
	IBAN varchar(28),
	CustomerNo char(36)
)

CREATE TABLE GymWorkers (
	ID INTEGER IDENTITY(1,1) REFERENCES People PRIMARY KEY,
	Salary DECIMAL(7,2),
	Position varchar(20),
	Specialization varchar(20)
)

CREATE TABLE SessionTopics (
	ID INTEGER IDENTITY(1,1) PRIMARY KEY,
	Tname varchar(30),
	TType varchar(10),
	TDescription varchar(100)
)

CREATE TABLE TrainingSessions (
	ID INTEGER IDENTITY(1,1) PRIMARY KEY,
	DateOfSession smalldatetime,
	TotalSlots INTEGER,
	AvailableSlots INTEGER,
	RoomNo varchar(3),
	Price DECIMAL(5,2),
	TopicID INTEGER REFERENCES SessionTopics,
	TrainerID INTEGER REFERENCES GymWorkers
)

CREATE TABLE Bills (
	ID INTEGER IDENTITY(1,1) PRIMARY KEY,
	BValue DECIMAL (6,2),
	DueDate smalldatetime,
	IsPaid BIT,
	DateOfPayment smalldatetime,
	PaymentMethod varchar(6),
	CustomerID INTEGER REFERENCES Customers,
)

CREATE TABLE Reservations (
	ID INTEGER IDENTITY(1,1) PRIMARY KEY,
	DateOfReservation smalldatetime,
	Discount DECIMAL(5,2),
	RType varchar(7),
	CustomerID INTEGER REFERENCES Customers,
	ReceptionistID INTEGER REFERENCES GymWorkers,
	SessionID INTEGER REFERENCES TrainingSessions,
	ReservationNo char(36),
	BillID INTEGER REFERENCES Bills
)