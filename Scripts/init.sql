CREATE DATABASE community_db;
GO

USE community_db;
GO

-- USERS TABLE
CREATE TABLE Users (
    UserId SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE NOT NULL,
    IsOrganization BOOLEAN DEFAULT FALSE,
    CreatedAt TIMESTAMP DEFAULT NOW()
);

-- ORGANIZATIONS TABLE (extends Users)
CREATE TABLE Organizations (
    OrgId INT PRIMARY KEY REFERENCES Users(UserId),
    Description TEXT,
    Website VARCHAR(200)
);

-- CATEGORIES TABLE
CREATE TABLE Categories (
    CategoryId SERIAL PRIMARY KEY,
    Name VARCHAR(50) UNIQUE
);

-- LOCATIONS TABLE
CREATE TABLE Locations (
    LocationId SERIAL PRIMARY KEY,
    Name VARCHAR(100) UNIQUE
);

-- LISTINGS TABLE
CREATE TABLE Listings (
    ListingId SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Description TEXT,
    CategoryId INT REFERENCES Categories(CategoryId),
    LocationId INT REFERENCES Locations(LocationId),
    CreatorId INT REFERENCES Users(UserId),
    DatePosted TIMESTAMP DEFAULT NOW()
);
