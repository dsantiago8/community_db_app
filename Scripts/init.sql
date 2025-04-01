CREATE DATABASE CommunityDB;
GO

USE CommunityDB;
GO

CREATE TABLE Listings (
    Id INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(100),
    Description NVARCHAR(MAX),
    Category NVARCHAR(50),
    Location NVARCHAR(100),
    DatePosted DATETIME DEFAULT GETDATE()
);

INSERT INTO Listings (Title, Description, Category, Location)
VALUES ('Farmers Market', 'Local produce and crafts.', 'Event', 'Eagle Rock');
