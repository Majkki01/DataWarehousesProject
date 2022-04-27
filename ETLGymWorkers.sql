USE GymDW
GO

If (object_id('vETLDimGymWorkers') is not null) Drop View vETLDimGymWorkers;
go
CREATE VIEW vETLDimGymWorkers
AS
SELECT DISTINCT
	CASE
		WHEN Gym.dbo.GymWorkers.Salary < 4000 THEN 'low salary'
		WHEN Gym.dbo.GymWorkers.Salary < 10000 THEN 'medium salary'
		ELSE 'high salary'
	END as SalaryCat,
	Gym.dbo.GymWorkers.Position AS [Role],
	Gym.dbo.GymWorkers.Specialization AS Specialization,
	Gym.dbo.People.FirstName + ' ' + Gym.dbo.People.Surname as NameSurname,
	CASE
		WHEN Gym.dbo.People.Gender LIKE 'man' THEN 'male'
		WHEN Gym.dbo.People.Gender LIKE 'woman' THEN 'female'
		ELSE 'unknown'
	END as Gender
FROM Gym.dbo.GymWorkers JOIN Gym.dbo.People ON Gym.dbo.GymWorkers.ID = Gym.dbo.People.ID
;
GO

MERGE INTO GymWorkers as TT
	USING vETLDimGymWorkers as ST
		ON TT.SalaryCat = ST.SalaryCat AND 
		TT.[Role] = ST.[Role] AND 
		TT.Specialization = ST.Specialization AND 
		TT.NameSurname = ST.NameSurname AND 
		TT.Gender = ST.Gender
			WHEN Not Matched
				THEN
					INSERT
					VALUES (
					ST.SalaryCat,
					ST.[Role],
					ST.Specialization,
					ST.NameSurname,
					ST.Gender
					)
			WHEN Matched AND (ST.SalaryCat <> TT.SalaryCat OR ST.Specialization <> TT.Specialization OR ST.[Role] <> TT.[Role])
				THEN
					UPDATE
					SET TT.SalaryCat = ST.SalaryCat, TT.Specialization = ST.Specialization, TT.[Role] = ST.[Role]
;
GO

DROP VIEW vETLDimGymWorkers;
