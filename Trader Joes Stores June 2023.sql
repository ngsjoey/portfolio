-- =============================================
-- Author: Joey Ng
-- Create date: 6/16/23
-- Description: Practicing SQL with the Trader Joe's Store Dataset I created to analyze the store locations in the US. 
-- =============================================

-- Looking at the table
SELECT *
FROM TraderJoesProject.dbo.CleanedData

-- Removing the Last three columns because they are all null values
SELECT *
FROM TraderJoesProject.dbo.CleanedData
ALTER TABLE TraderJoesProject.dbo.CleanedData
DROP COLUMN F9,F10,F11;

-- Checking to see if the columns are dropped and it did
SELECT *
FROM TraderJoesProject.dbo.CleanedData

-- Looking at how many stores there are in the US
SELECT COUNT(Store_Name) AS NumberofStores
FROM TraderJoesProject.dbo.CleanedData

-- Looking at how many stores in each state
SELECT State, COUNT(Store_name) AS Numberofstores
FROM TraderJoesProject.dbo.CleanedData
WHERE State IS NOT NULL
GROUP BY State
ORDER BY Numberofstores DESC;

-- Looking at how many stores in each city
SELECT City, COUNT(Store_name) AS Numberofstores
FROM TraderJoesProject.dbo.CleanedData
WHERE State IS NOT NULL
GROUP BY City
ORDER BY Numberofstores DESC;