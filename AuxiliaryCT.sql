USE Auxiliary

CREATE TABLE Holidays (
 dateid date primary key,
 holiday varchar(40)
)

CREATE TABLE AfterSessionSurveys (
	surveydate date,
	topicname varchar(100),
	namesurname varchar(100),
	trainersperformance INTEGER,
	equipmentsquality INTEGER,
	trainingquality INTEGER,
	cleanliness INTEGER,
	ReservationNo char(36)
)

