USE GymDW
GO

DECLARE @StartHour TIME
DECLARE @EndHour TIME

SELECT @StartHour = '00:00', @EndHour = '23:59';

DECLARE @HourInProcess TIME = @StartHour;

WHILE @HourInProcess < @EndHour
	BEGIN
		INSERT INTO [Time]
			VALUES (
				@HourInProcess,
				DATEPART(hour, @HourInProcess),
				DATEPART(MINUTE, @HourInProcess),
				CASE
					WHEN DATEPART(hour, @HourInProcess) <= 11 THEN 'morning'
					WHEN DATEPART(hour, @HourInProcess) >= 12 AND DATEPART(hour, @HourInProcess) <= 17 THEN 'afternoon'
					ELSE 'evening'
				END
			);
		SET @HourInProcess = DATEADD(minute, 1, @HourInProcess);
	END

INSERT INTO [Time] VALUES ('23:59', 23, 59, 'evening')
GO