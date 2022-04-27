USE GymDW
GO

If (object_id('vETLFTrainingSessions') is not null) Drop view vETLFTrainingSessions;
go


CREATE VIEW vETLFTrainingSessions
AS
SELECT
	DateOfSessionID,
	TimeOfSessionID,
	TopicID,
	GymWorkerID = SD4.GymWorkerID,
	TotalSlots,
	AvailableSlots,
	Price
FROM 
	(SELECT
		DateOfSessionID = SD1.[Date],
		TimeOfSessionID = SD2.[Time],
		TopicID = SD3.TopicID,
		TotalSlots = ST1.TotalSlots,
		AvailableSlots = ST1.AvailableSlots,
		Price = ST1.Price,
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
	) as x
JOIN dbo.GymWorkers SD4 ON SD4.NameSurname = CAST(x.FirstName + ' ' + x.Surname as varchar(50)) AND
		SD4.[Role] = x.Position AND
		SD4.Specialization = x.Specialization AND
		SD4.Gender = x.gender AND
		SD4.SalaryCat = x.SalaryCat
GO

SELECT * FROM vETLFTrainingSessions

MERGE INTO TrainingSessions as TT
	USING vETLFTrainingSessions AS ST
	ON
		TT.DateOfSessionID = ST.DateOfSessionID AND
		TT.TimeOfSessionID = ST.TimeOfSessionID AND
		TT.TopicID = ST.TopicID AND
		TT.GymWorkerID = ST.GymWorkerID
			WHEN NOT MATCHED
				THEN
					INSERT
					VALUES (
						ST.DateOfSessionID,
						ST.TimeOfSessionID,
						ST.TopicID,
						ST.GymWorkerID,
						ST.TotalSlots,
						ST.AvailableSlots,
						ST.Price
						);

DROP VIEW vETLFTrainingSessions;