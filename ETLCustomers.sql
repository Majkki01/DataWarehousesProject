USE GymDW
GO

If (object_id('vETLDimCustomers') is not null) Drop View vETLDimCustomers;
go
CREATE VIEW vETLDimCustomers
AS
SELECT DISTINCT
	CASE
		WHEN Gym.dbo.Customers.IsClubMember = 0 THEN 'Is club member'
		ELSE 'Is not club member'
	END as IsClubMember,
	Gym.dbo.People.FirstName + ' ' + Gym.dbo.People.Surname as NameSurname,
	CASE
		WHEN Gym.dbo.People.Gender LIKE 'man' THEN 'male'
		WHEN Gym.dbo.People.Gender LIKE 'woman' THEN 'female'
		ELSE 'unknown'
	END as Gender,
	Gym.dbo.Customers.CustomerNo as CustomerNo
FROM Gym.dbo.Customers JOIN Gym.dbo.People ON Gym.dbo.Customers.ID = Gym.dbo.People.ID
;
GO

MERGE INTO Customers as TT
	USING vETLDimCustomers as ST
		ON TT.CustomerNo = ST.CustomerNo
			WHEN Not Matched
				THEN
					INSERT
					VALUES (
					ST.IsClubMember,
					ST.NameSurname,
					ST.Gender,
					ST.CustomerNo,
					1
					)
			WHEN Matched AND ST.IsClubMember <> TT.IsClubMember
				THEN
					UPDATE
					SET TT.isActive = 0
			WHEN Not Matched BY Source
				THEN
					UPDATE
					SET TT.isActive = 0
;
GO

INSERT INTO Customers
	SELECT IsClubMember, NameSurname, Gender, CustomerNo, 1 FROM vETLDimCustomers
	EXCEPT
	SELECT IsClubMember, NameSurname, Gender, CustomerNo, 1 FROM Customers

DROP VIEW vETLDimCustomers;
