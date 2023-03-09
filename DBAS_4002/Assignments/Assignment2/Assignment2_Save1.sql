--1.	A new table called RecordLogging will be added. See ERD below.
USE Chinook
DROP TABLE IF EXISTS RecordLogging;
GO
CREATE TABLE RecordLogging (
	LogID int identity(1,1),
	TableName VARCHAR(30),
	RecordID int,
	ActionType VARCHAR(30) NOT NULL,
	IsError bit NOT NULL,
	ErrorNum int, 
	LogDate DATETIME NOT NULL,
	PRIMARY KEY(LogID)
);


--2.	A new stored procedure called uspAddRecordLog 
GO
CREATE OR ALTER PROC uspAddRecordLog 
	@tableName VARCHAR(30),
	@actionType CHAR(6),
	@isError bit,
	@recordID int = -1,
	@errorNum int = 0
AS 
	INSERT INTO RecordLogging(TableName, RecordID, ActionType, IsError, ErrorNum, LogDate)
	VALUES (@tableName, @recordID, @actionType, @isError, @errorNum, GETDATE());
;

GO
-- Working Test Call--
EXEC uspAddRecordLog @tableName = 'TestWorking', @actionType = 'INSERT', @isError = 0;

--Error Test Call--
EXEC uspAddRecordLog @tableName = 'TesstError', @actionType = 'INSERT', @isError = 1;
	

--3.	For each of the five tables (Tracks, Artists, Albums, Genres and Mediatypes), add a new stored procedure called usp<TableName>_Insert.

--//==========================================Tracks table insert proc==========================================\\--
GO
CREATE OR ALTER PROC uspTracks_Insert(
	@name VARCHAR(200),
	@mediaType int,
	@milliseonds int,
	@unitPrice numeric(10,2),
	@albumID int = NULL,
	@genreID int = NULL,
	@composer VARCHAR(220) = NULL,
	@bytes int = NULL,
	@trkRecordID int = NULL OUTPUT
)
AS
	BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO Track(Name, MediaTypeId, Milliseconds, UnitPrice, AlbumId, GenreId, Composer, Bytes)
			VALUES (@name, @mediaType, @milliseonds, @unitPrice, @albumID, @genreID, @composer, @bytes);


			SET @trkRecordID = ISNULL(NULL, SCOPE_IDENTITY());
			EXEC uspAddRecordLog @tableName = 'Track', @actionType = 'INSERT', @isError = 0, @recordID = @trkRecordID;
		END TRY

		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK

			DECLARE @trkErrorNum int = ERROR_NUMBER();
			EXEC uspAddRecordLog @tableName = 'Track', @actionType = 'INSERT', @isError = 1, @errorNum = @trkErrorNum;
		END CATCH

	IF @@TRANCOUNT > 0
		COMMIT
;

GO
-- Track Working Inserts --
EXEC uspTracks_Insert @name = 'TestTrackSuccess', @mediaType = 1, @milliseonds = 1029385, @unitPrice = 0.99, @albumID = 1;
EXEC uspTracks_Insert @name = 'TestTrackSuccess', @mediaType = 1, @milliseonds = 1029385, @unitPrice = 0.99, @albumID = 1, @genreID = 1;
EXEC uspTracks_Insert @name = 'TestTrackSuccess', @mediaType = 1, @milliseonds = 1029385, @unitPrice = 0.99, @albumID = 1, @genreID = 1, @composer = 'Talented Person';
EXEC uspTracks_Insert @name = 'TestTrackSuccess', @mediaType = 1, @milliseonds = 1029385, @unitPrice = 0.99, @albumID = 1, @genreID = 1, @composer = 'Talented Person', @bytes = 1029385;

-- Track Error Inserts --
EXEC uspTracks_Insert @name = 'TestTrackError', @mediaType = 6, @milliseonds = 1029385, @unitPrice = 0.99; -- MediaTypeId doesn't exist (breaking PK to FK constraint)
EXEC uspTracks_Insert @name = NULL, @mediaType = 1, @milliseonds = 1029385, @unitPrice = 0.99; -- Nulled Name field
EXEC uspTracks_Insert @name = 'TestTrackError', @mediaType = NULL, @milliseonds = 1029385, @unitPrice = 0.99; -- Nulled MediaTypeID field
EXEC uspTracks_Insert @name = 'TestTrackError', @mediaType = 1, @milliseonds = NULL, @unitPrice = 0.99; -- Nulled Milliseconds field
EXEC uspTracks_Insert @name = 'TestTrackError', @mediaType = 1, @milliseonds = 1029385, @unitPrice = NULL; -- Nulled UnitPrice field

--//==========================================Artists table insert proc==========================================\\--
GO
CREATE OR ALTER PROC uspArtists_Insert(
	@name VARCHAR(120),
	@artRecordID int = NULL OUTPUT
)
AS
	BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO Artist(Name)
			VALUES (@name);


			SET @artRecordID = ISNULL(NULL, SCOPE_IDENTITY());
			EXEC uspAddRecordLog @tableName = 'Artist', @actionType = 'INSERT', @isError = 0, @recordID = @artRecordID;
		END TRY

		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK;
				
			DECLARE @artErrorNum int = ERROR_NUMBER();
			EXEC uspAddRecordLog @tableName = 'Artist', @actionType = 'INSERT', @isError = 1, @errorNum = @artErrorNum;
		END CATCH

	IF @@TRANCOUNT > 0
		COMMIT;
;

GO
-- Artist Working Insert --
EXEC uspArtists_Insert @name = 'ArtistTestNameSuccess';


--//==========================================Albums table insert proc==========================================\\--
GO
CREATE OR ALTER PROC uspAlbums_Insert(
	@title VARCHAR(160),
	@artistID int,
	@albRecordID int = NULL OUTPUT
)
AS
	BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO Album(Title, ArtistId)
			VALUES (@title, @artistID);


			SET @albRecordID = ISNULL(NULL, SCOPE_IDENTITY());
			EXEC uspAddRecordLog @tableName = 'Album', @actionType = 'INSERT', @isError = 0, @recordID = @albRecordID;
		END TRY

		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK;

			DECLARE @albErrorNum int = ERROR_NUMBER();
			EXEC uspAddRecordLog @tableName = 'Album', @actionType = 'INSERT', @isError = 1, @errorNum = @albErrorNum;
		END CATCH

	IF @@TRANCOUNT > 0
		COMMIT;
;

GO
-- Artist Working Insert --
EXEC uspAlbums_Insert @title = 'AlbumTestInsertSuccess', @artistID = 1;

-- Artist Error Inserts --
EXEC uspAlbums_Insert @title = 'AlbumTestInsertError', @artistID = 300; -- ArtistId PK doesn't exist in Artist table (breaking PK to FK constraint)
EXEC uspAlbums_Insert @title = NULL, @artistID = 1; -- Nulled Title field
EXEC uspAlbums_Insert @title = 'AlbumTestInsertError', @artistID = NULL; -- Nulled ArtistId field


--//==========================================Genres table insert proc==========================================\\--
GO
CREATE OR ALTER PROC uspGenres_Insert(
	@name VARCHAR(120) = NULL,
	@genRecordID int = NULL OUTPUT 
)
AS
	BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO Genre(Name)
			VALUES (@name);


			SET @genRecordID = ISNULL(NULL, SCOPE_IDENTITY());
			EXEC uspAddRecordLog @tableName = 'Genre', @actionType = 'INSERT', @isError = 0, @recordID = @genRecordID;
		END TRY

		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK;

			DECLARE @trkErrorNum int = ERROR_NUMBER();
			EXEC uspAddRecordLog @tableName = 'Genre', @actionType = 'INSERT', @isError = 1, @errorNum = @trkErrorNum;
		END CATCH

	IF @@TRANCOUNT > 0
		COMMIT;
;

GO
-- Genre Working Inserts --
EXEC uspGenres_Insert; -- All fields are Nullable
EXEC uspGenres_Insert @name = 'GenreTestInsertSuccess';


--//==========================================MediaTypes table insert proc==========================================\\--
GO
CREATE OR ALTER PROC uspMediaTypes_Insert(
	@name VARCHAR(120) = NULL,
	@medRecordID int = NULL OUTPUT 
)
AS
	BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO MediaType(Name)
			VALUES (@name);


			SET @medRecordID = ISNULL(NULL, SCOPE_IDENTITY());
			EXEC uspAddRecordLog @tableName = 'MediaType', @actionType = 'INSERT', @isError = 0, @recordID = @medRecordID;
		END TRY

		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK;

			DECLARE @trkErrorNum int = ERROR_NUMBER();
			EXEC uspAddRecordLog @tableName = 'MediaType', @actionType = 'INSERT', @isError = 1, @errorNum = @trkErrorNum;
		END CATCH

	IF @@TRANCOUNT > 0
		COMMIT;
;

GO
-- MediaType Working Inserts --
EXEC uspMediaTypes_Insert; -- All fields are Nullable
EXEC uspMediaTypes_Insert @name = 'MediaTypeTestInsertSuccess';

	
--4. 4.	For each of the five tables (Tracks, Artists, Albums, Genres and Mediatypes), add a new stored procedure called usp<TableName>_DeleteByID

--//==================================Tracks Delete Procedure==================================\\--
GO
CREATE OR ALTER PROC uspTracks_DeleteByID(
	@trackID int
)
AS
	BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM Track WHERE TrackId = @trackID;

			EXEC uspAddRecordLog @tableName = 'Track', @actionType = 'DELETE', @isError = 0, @recordID = @trackID;
		END TRY

		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK;

			DECLARE @trkErrorNum int = ERROR_NUMBER();
			EXEC uspAddRecordLog @tableName = 'Track', @actionType = 'DELETE', @isError = 1, @errorNum = @trkErrorNum;
		END CATCH

	IF @@TRANCOUNT > 0
		COMMIT;
;

GO
EXEC uspTracks_DeleteByID @trackID = 3542; --working test
EXEC uspTracks_DeleteByID @trackID = 1; --error test (Breaks PK to FK constraint)


--//==================================Artists Delete Procedure==================================\\--
GO
CREATE OR ALTER PROC uspArtists_DeleteByID(
	@artistID int
)
AS
	BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM Artist WHERE ArtistId = @artistID;

			EXEC uspAddRecordLog @tableName = 'Artist', @actionType = 'DELETE', @isError = 0, @recordID = @artistID;
		END TRY

		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK;

			DECLARE @trkErrorNum int = ERROR_NUMBER();
			EXEC uspAddRecordLog @tableName = 'Artist', @actionType = 'DELETE', @isError = 1, @errorNum = @trkErrorNum;
		END CATCH

	IF @@TRANCOUNT > 0
		COMMIT
;

GO
EXEC uspArtists_DeleteByID @artistID = 277; -- working test (ID created by previous insert statement)
EXEC uspArtists_DeleteByID @artistID = 1; -- error test (Breaks PK to FK constraint)


--//==================================Albums Delete Procedure==================================\\--
GO
CREATE OR ALTER PROC uspAlbums_DeleteByID(
	@albumID int
)
AS
	BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM Album WHERE AlbumId = @albumID;

			EXEC uspAddRecordLog @tableName = 'Album', @actionType = 'DELETE', @isError = 0, @recordID = @albumID;
		END TRY

		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK;

			DECLARE @trkErrorNum int = ERROR_NUMBER();
			EXEC uspAddRecordLog @tableName = 'Album', @actionType = 'DELETE', @isError = 1, @errorNum = @trkErrorNum;
		END CATCH

	IF @@TRANCOUNT > 0
		COMMIT;
;

GO
EXEC uspAlbums_DeleteByID @albumID = 348; -- working test (ID created by previous insert statement)
EXEC uspAlbums_DeleteByID @albumID = 1; -- error test (Breaks PK to FK constraint)


--//==================================Genres Delete Procedure==================================\\--
GO
CREATE OR ALTER PROC uspGenres_DeleteByID(
	@genreID int
)
AS
	BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM Genre WHERE GenreId = @genreID;

			EXEC uspAddRecordLog @tableName = 'Genre', @actionType = 'DELETE', @isError = 0, @recordID = @genreID;
		END TRY

		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK

			DECLARE @trkErrorNum int = ERROR_NUMBER();
			EXEC uspAddRecordLog @tableName = 'Genre', @actionType = 'DELETE', @isError = 1, @errorNum = @trkErrorNum;
		END CATCH

	IF @@TRANCOUNT > 0
		COMMIT
;
GO
EXEC uspGenres_DeleteByID @genreID = 26; -- working test (ID created by previous insert statement)
EXEC uspGenres_DeleteByID @genreID = 1; -- error test (Breaks PK to FK constraint)
 

--//==================================MediaTypes Delete Procedure==================================\\--
GO
CREATE OR ALTER PROC uspMediaTypes_DeleteByID(
	@mediaTypeID int
)
AS
	BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM MediaType WHERE MediaTypeId = @mediaTypeID;

			EXEC uspAddRecordLog @tableName = 'MediaType', @actionType = 'DELETE', @isError = 0, @recordID = @mediaTypeID;
		END TRY

		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK;

			DECLARE @trkErrorNum int = ERROR_NUMBER();
			EXEC uspAddRecordLog @tableName = 'MediaType', @actionType = 'DELETE', @isError = 1, @errorNum = @trkErrorNum;
		END CATCH

	IF @@TRANCOUNT > 0
		COMMIT;
;

GO
EXEC uspMediaTypes_DeleteByID @mediaTypeID = 6; -- working test (ID created by previous insert statement)
EXEC uspMediaTypes_DeleteByID @mediaTypeID = 1; -- error test (Breaks PK to FK constraint)

-- Remove Potential Remaining Records From Effected Tables --
DELETE FROM Track WHERE Name = 'TestTrackSuccess'
DELETE FROM Artist WHERE Name = 'ArtistTestNameSuccess'
DELETE FROM Album WHERE Title = 'AlbumTestInsertSuccess'
DELETE FROM Genre WHERE Name = 'GenreTestInsertSuccess'
DELETE FROM MediaType WHERE Name = 'MediaTypeTestInsertSuccess'
