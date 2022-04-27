USE GymDW
GO

set datefirst 1;
GO

CREATE VIEW vETLAuxHolidays 
AS
SELECT *
FROM Auxiliary.dbo.Holidays
GO

DECLARE @StartDate date; 
DECLARE @EndDate date;

SELECT @StartDate = '2018-01-01', @EndDate = '2022-12-31';

DECLARE @DateInProcess datetime = @StartDate;

WHILE @DateInProcess <= @EndDate
	BEGIN
		INSERT INTO Date
		VALUES ( 
		  @DateInProcess,
		  YEAR(@DateInProcess),
		  MONTH(@DateInProcess),
		  DAY(@DateInProcess),
		  DATENAME(WEEKDAY, @DateInProcess),
		  CASE
			WHEN (MONTH(@DateInProcess) >= 12 AND DAY(@DateInProcess) >= 22) OR (MONTH(@DateInProcess) <= 3 AND DAY(@DateInProcess) < 21) OR (MONTH(@DateInProcess) < 3) THEN 'Winter'
			WHEN (MONTH(@DateInProcess) < 6) OR (MONTH(@DateInProcess) <= 6 AND DAY(@DateInProcess) < 22) THEN 'Spring'
			WHEN (MONTH(@DateInProcess) < 9) OR (MONTH(@DateInProcess) <= 9 AND DAY(@DateInProcess) < 23) THEN 'Summer'
			ELSE 'Autumn'
		  END,
		  NULL,
		  DATENAME(month, @DateInProcess),
		  DATEPART(WEEK, @DateInProcess),
		  DATEPART(WEEKDAY, @DateInProcess)
		  )
		Set @DateInProcess = DateAdd(d, 1, @DateInProcess);
	End
go

MERGE INTO Date as TT
	USING vETLAuxHolidays as ST
		ON TT.[date] = ST.dateid
			WHEN Matched
			THEN
				UPDATE
				SET TT.Holiday = ST.holiday		
;
go

DROP VIEW vETLAuxHolidays