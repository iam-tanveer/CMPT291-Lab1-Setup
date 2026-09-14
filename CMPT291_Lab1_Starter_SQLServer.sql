-- ============================================================================
-- CMPT 291 - Fall 2026
-- Lab 1 Starter SQL: SQL Server Environment Setup and Verification
--
-- IMPORTANT:
--   1. Run Section A while connected to your SQL Server instance in SSMS.
--   2. Execute one section at a time and read the comments.
--   3. Section B resets dbo.StudentTest so the starter can be re-run safely.
--   4. The INSERT in Section E is SUPPOSED TO FAIL. That error proves that
--      the CHECK constraint is being enforced.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- SECTION A - VERIFY SQL SERVER AND CREATE THE LAB DATABASE
-- ---------------------------------------------------------------------------

-- A1. Verify the SQL Server instance, login, edition, and version.
SELECT
    @@SERVERNAME AS server_name,
    SUSER_SNAME() AS login_name,
    CAST(SERVERPROPERTY('Edition') AS nvarchar(128)) AS edition,
    CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(128)) AS product_version,
    CAST(SERVERPROPERTY('ProductLevel') AS nvarchar(128)) AS product_level;

-- A2. Create the Lab 1 database if it does not already exist.
IF DB_ID(N'CMPT291_Lab1') IS NULL
BEGIN
    CREATE DATABASE CMPT291_Lab1;
END;
GO

-- A3. Switch this query window to the Lab 1 database.
USE CMPT291_Lab1;
GO

-- A4. Confirm the active database and login.
SELECT
    DB_NAME() AS database_name,
    SUSER_SNAME() AS login_name;
GO


-- ---------------------------------------------------------------------------
-- SECTION B - CREATE A TEST TABLE
-- ---------------------------------------------------------------------------

-- Reset the table if you are repeating the lab.
IF OBJECT_ID(N'dbo.StudentTest', N'U') IS NOT NULL
    DROP TABLE dbo.StudentTest;
GO

CREATE TABLE dbo.StudentTest
(
    StudentID   int IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_StudentTest PRIMARY KEY,
    StudentName nvarchar(100) NOT NULL,
    Program     nvarchar(100) NOT NULL,
    YearLevel   tinyint NOT NULL
        CONSTRAINT CK_StudentTest_YearLevel
        CHECK (YearLevel BETWEEN 1 AND 4)
);
GO


-- ---------------------------------------------------------------------------
-- SECTION C - INSERT SAMPLE DATA
-- ---------------------------------------------------------------------------

INSERT INTO dbo.StudentTest (StudentName, Program, YearLevel)
VALUES
    (N'Amina Rahman', N'Computer Science', 2),
    (N'Daniel Kim', N'Data Science', 3),
    (N'Maria Lopez', N'Computer Science', 1),
    (N'Noah Wilson', N'Information Systems', 4);
GO


-- ---------------------------------------------------------------------------
-- SECTION D - TEST BASIC QUERIES
-- ---------------------------------------------------------------------------

-- D1. Display every row.
SELECT *
FROM dbo.StudentTest;
GO

-- D2. Sort students alphabetically.
SELECT
    StudentID,
    StudentName,
    Program,
    YearLevel
FROM dbo.StudentTest
ORDER BY StudentName;
GO

-- D3. Filter for Computer Science students.
SELECT
    StudentName,
    Program
FROM dbo.StudentTest
WHERE Program = N'Computer Science';
GO

-- D4. Count the rows.
SELECT COUNT(*) AS total_students
FROM dbo.StudentTest;
GO


-- ---------------------------------------------------------------------------
-- SECTION E - TEST A DATABASE CONSTRAINT
-- ---------------------------------------------------------------------------

-- This INSERT is SUPPOSED TO FAIL because YearLevel = 7 violates the
-- CHECK constraint that permits only values 1 through 4.
INSERT INTO dbo.StudentTest (StudentName, Program, YearLevel)
VALUES (N'Test Student', N'Computer Science', 7);
GO

-- Verify that the invalid row was not added. The result should still be 4.
SELECT COUNT(*) AS total_students
FROM dbo.StudentTest;
GO


-- ---------------------------------------------------------------------------
-- SECTION F - FINAL SCREENSHOT QUERIES
-- ---------------------------------------------------------------------------

-- Screenshot query 1: database/login/SQL Server verification.
SELECT
    DB_NAME() AS database_name,
    SUSER_SNAME() AS login_name,
    CAST(SERVERPROPERTY('Edition') AS nvarchar(128)) AS sql_server_edition,
    CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(128)) AS sql_server_version;
GO

-- Screenshot query 2: final table contents.
SELECT
    StudentID,
    StudentName,
    Program,
    YearLevel
FROM dbo.StudentTest
ORDER BY StudentID;
GO

-- Screenshot query 3: final row count.
SELECT COUNT(*) AS total_students
FROM dbo.StudentTest;
GO

-- Expected final result: exactly 4 valid rows.
-- ============================================================================
