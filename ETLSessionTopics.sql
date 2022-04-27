USE GymDW
GO

If (object_id('vETLDimSessionTopics') is not null) Drop View vETLDimSessionTopics;
go
CREATE VIEW vETLDimSessionTopics
AS
SELECT DISTINCT
	[TType] as [Type],
	[Tname] as [Name]
FROM Gym.dbo.SessionTopics
;
go

MERGE INTO SessionTopics as TT
	USING vETLDimSessionTopics as ST
		ON TT.[Type] = ST.[Type] AND TT.[Name] = ST.[Name]
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.[Type],
					ST.[Name]
					)
;

Drop View vETLDimSessionTopics;