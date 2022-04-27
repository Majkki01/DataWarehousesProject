USE GymDW
GO

If (object_id('vETLFReservations') is not null) Drop view vETLFReservations;
go


CREATE VIEW vETLFReservations
AS
SELECT
	DateOfReservationID,
	TimeOfReservationID,
	TrainingSessionID,
	CustomerID,
	GymWorkerID = SD8.GymWorkerID,
	JunkID = SD9.JunkID,
	CustomerPESEL,
	CustomerAge,
	TrainersPerformance,
	EquipmentsQuality,
	TrainingQualitys,
	Cleanliness,
	Discount,
	ReservationNo
FROM 
	(SELECT
		DateOfReservationID = SD1.[Date],
		TimeOfReservationID = SD2.[Time],
		TrainingSessionID = SD5.TrainingSessionID,
		CustomerID = SD3.CustomerID,
		CustomerPESEL = ST3.PESEL,
		CustomerAge = DATEDIFF(YEAR, ST3.DateOfBirth, CAST(GETDATE() as date)),
		CustomerFirstName = ST3.FirstName,
		CustomerSurname = ST3.Surname,
		FirstName = ST7.FirstName,
		Surname = ST7.Surname,
		Position = ST6.Position,
		Specialization = ST6.Specialization,
		Discount = ST1.Discount,
		ReservationNo = ST1.ReservationNo,
		TrainersPerformance = ST8.trainersperformance,
		EquipmentsQuality = ST8.equipmentsquality,
		TrainingQualitys = ST8.trainingquality,
		Cleanliness = ST8.cleanliness,
		CASE
			WHEN CAST(ST8.trainingquality as varchar(10)) IS NOT NULL THEN CAST(ST8.trainingquality as varchar(10))
			ELSE 'unknown'
		END as TrainingQualityJunk,
		--TrainingQualityJunk = 'u',
		CASE
			WHEN CAST((ST8.trainersperformance + ST8.equipmentsquality + ST8.trainingquality + ST8.cleanliness) as FLOAT)/4 <= 1 THEN 'very low'
			WHEN CAST((ST8.trainersperformance + ST8.equipmentsquality + ST8.trainingquality + ST8.cleanliness) as FLOAT)/4 <= 2 THEN 'low'
			WHEN CAST((ST8.trainersperformance + ST8.equipmentsquality + ST8.trainingquality + ST8.cleanliness) as FLOAT)/4 <= 3 THEN 'medium'
			WHEN CAST((ST8.trainersperformance + ST8.equipmentsquality + ST8.trainingquality + ST8.cleanliness) as FLOAT)/4 <= 4 THEN 'high'
			WHEN CAST((ST8.trainersperformance + ST8.equipmentsquality + ST8.trainingquality + ST8.cleanliness) as FLOAT)/4 <= 5 THEN 'very high'
			ELSE 'unknown'
		END as AverageTotalScoreJunk,
		CASE
			WHEN ST7.Gender = 'man' THEN 'male'
			WHEN ST7.Gender = 'woman' THEN 'female'
			ELSE 'unknown'
		END AS gender,
		CASE
			WHEN ST6.Salary < 4000 THEN 'low salary'
			WHEN ST6.Salary < 10000 THEN 'medium salary'
			ELSE 'high salary'
		END AS SalaryCat

	FROM Gym.dbo.Reservations AS ST1
	JOIN dbo.[Date] SD1 ON SD1.[Date] = CAST(ST1.DateOfReservation as date)
	JOIN dbo.[Time] SD2 ON SD2.[Time] = CAST(ST1.DateOfReservation as time)
	JOIN Gym.dbo.Customers ST2 ON ST2.ID = ST1.CustomerID
	JOIN Gym.dbo.People ST3 ON ST3.ID = ST2.ID
	JOIN dbo.Customers SD3 ON SD3.CustomerNo = ST2.CustomerNo AND SD3.isActive = 1
	JOIN
		(SELECT
			TrainingSessionID,
			DateOfSessionID,
			TimeOfSessionID,
			TopicID,
			GymWorkerID = SD4.GymWorkerID
		FROM 
			(SELECT
				TrainingSessionID = ST1.ID,
				DateOfSessionID = SD1.[Date],
				TimeOfSessionID = SD2.[Time],
				TopicID = SD3.TopicID,
				FirstName = ST4.FirstName,
				Surname = ST4.Surname,
				Position = ST3.Position,
				Specialization = ST3.Specialization,
				CASE
					WHEN ST4.Gender = 'man' THEN 'male'
					WHEN ST4.Gender = 'woman' THEN 'female'
					ELSE 'unknown'
				END AS gender,
				CASE
					WHEN ST3.Salary < 4000 THEN 'low salary'
					WHEN ST3.Salary < 10000 THEN 'medium salary'
					ELSE 'high salary'
				END AS SalaryCat

			FROM Gym.dbo.TrainingSessions AS ST1
			JOIN dbo.[Date] SD1 ON SD1.[Date] = CAST(ST1.DateOfSession as date)
			JOIN dbo.[Time] SD2 ON SD2.[Time] = CAST(ST1.DateOfSession as time)
			JOIN Gym.dbo.SessionTopics ST2 ON ST2.ID = ST1.TopicID
			JOIN dbo.SessionTopics SD3 ON SD3.[Name] = ST2.Tname AND SD3.[Type] = ST2.TType
			JOIN Gym.dbo.GymWorkers ST3 ON ST3.ID = ST1.TrainerID
			JOIN Gym.dbo.People ST4 ON ST4.ID = ST3.ID
			) as z
		JOIN dbo.GymWorkers SD4 ON SD4.NameSurname = CAST(z.FirstName + ' ' + z.Surname as varchar(50)) AND
			SD4.[Role] = z.Position AND
			SD4.Specialization = z.Specialization AND
			SD4.Gender = z.gender AND
			SD4.SalaryCat = z.SalaryCat
		) as y ON y.TrainingSessionID = ST1.SessionID
	JOIN dbo.TrainingSessions SD5 ON SD5.TopicID = y.TopicID AND
		SD5.DateOfSessionID = y.DateOfSessionID AND
		SD5.TimeOfSessionID = y.TimeOfSessionID AND
		SD5.GymWorkerID = y.GymWorkerID
	JOIN Gym.dbo.GymWorkers ST6 ON ST6.ID = ST1.ReceptionistID
	JOIN Gym.dbo.People ST7 ON ST7.ID = ST6.ID
	LEFT JOIN Auxiliary.dbo.AfterSessionSurveys ST8 ON ST8.ReservationNo = ST1.ReservationNo	
	) as x
JOIN dbo.GymWorkers SD8 ON SD8.NameSurname = CAST(x.FirstName + ' ' + x.Surname as varchar(50)) AND
	SD8.[Role] = x.Position AND
	SD8.Specialization = x.Specialization AND
	SD8.Gender = x.gender AND
	SD8.SalaryCat = x.SalaryCat
JOIN dbo.Junk SD9 ON SD9.TrainingQuality = x.TrainingQualityJunk AND
	 SD9.AverageTotalScore = x.AverageTotalScoreJunk
GO

SELECT * from vETLFReservations ORDER BY JunkID DESC

MERGE INTO Reservations as TT
	USING vETLFReservations AS ST
	ON
		TT.ReservationNo = ST.ReservationNo
			WHEN NOT MATCHED
				THEN
					INSERT
					VALUES (
							ST.DateOfReservationID,
							ST.TimeOfReservationID,
							ST.TrainingSessionID,
							ST.CustomerID,
							ST.GymWorkerID,
							ST.JunkID,
							ST.CustomerPESEL,
							ST.CustomerAge,
							ST.TrainersPerformance,
							ST.EquipmentsQuality,
							ST.TrainingQualitys,
							ST.Cleanliness,
							ST.Discount,
							ST.ReservationNo
						);

DROP VIEW vETLFReservations;

