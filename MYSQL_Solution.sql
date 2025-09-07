-- Create and use database
CREATE DATABASE IF NOT EXISTS MARKETING;
USE MARKETING;

-- View all data
SELECT * FROM marketing;



-- Key Questions (for reference)
-- 1. Best campaign channels/types for conversion?
-- 2. Does AdSpend/TimeOnSite affect conversion?
-- 3. Which demographics respond better?
-- 4. Can we segment users based on engagement/spending?
-- 5. Key predictors of conversion?

-- Distinct campaign channels and platforms
SELECT DISTINCT CampaignChannel FROM marketing;
SELECT DISTINCT AdvertisingPlatform FROM marketing;

-- Preview structure
SELECT * FROM marketing LIMIT 10;

-- Drop unneeded columns
ALTER TABLE marketing
DROP COLUMN AdvertisingPlatform,
DROP COLUMN AdvertisingTool;

-- Check NULLs
SELECT * FROM marketing WHERE Age IS NULL;

-- Check all numeric columns for NULLs
SELECT
  SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Null_Age,
  SUM(CASE WHEN Income IS NULL THEN 1 ELSE 0 END) AS Null_Income,
  SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Null_Gender,
  SUM(CASE WHEN AdSpend IS NULL THEN 1 ELSE 0 END) AS Null_AdSpend
FROM marketing;

-- Add AgeGroup column
ALTER TABLE marketing ADD AgeGroup VARCHAR(20);

-- Update AgeGroup values
UPDATE marketing
SET AgeGroup = CASE 
  WHEN Age < 25 THEN '18-24'
  WHEN Age BETWEEN 25 AND 34 THEN '25-34'
  WHEN Age BETWEEN 35 AND 44 THEN '35-44'
  WHEN Age BETWEEN 45 AND 54 THEN '45-54'
  WHEN Age BETWEEN 55 AND 64 THEN '55-64'
  ELSE '65+'
END;

-- Total conversions
SELECT SUM(CAST(Conversion AS UNSIGNED)) FROM marketing;

-- Overall conversion rate
SELECT SUM(CAST(Conversion AS UNSIGNED)) * 100 / COUNT(*) AS ConversionRate FROM marketing;

-- Best campaign channel
SELECT CampaignChannel,
  SUM(CAST(Conversion AS UNSIGNED)) * 100 / COUNT(*) AS ConversionRate
FROM marketing
GROUP BY CampaignChannel;

-- Best campaign type
SELECT CampaignType,
  COUNT(*) AS Total,
  SUM(CAST(Conversion AS UNSIGNED)) AS TotalConverted,
  ROUND(SUM(CAST(Conversion AS UNSIGNED)) * 100.0 / COUNT(*), 2) AS ConversionRate
FROM marketing
GROUP BY CampaignType
ORDER BY ConversionRate DESC;

-- Conversion rate by demographics
SELECT AgeGroup, Gender,
  COUNT(*) AS Total,
  SUM(CAST(Conversion AS UNSIGNED)) AS TotalConverted,
  ROUND(SUM(CAST(Conversion AS UNSIGNED)) * 100.0 / COUNT(*), 2) AS ConversionRate
FROM marketing
GROUP BY AgeGroup, Gender
ORDER BY ConversionRate DESC;

-- AdSpend Summary
SELECT AVG(AdSpend) AS AverageAdSpend,
  MIN(AdSpend) AS MinSpend,
  MAX(AdSpend) AS MaxSpend
FROM marketing;

-- Add SpendGroup column
ALTER TABLE marketing ADD SpendGroup VARCHAR(100);

-- Update SpendGroup
UPDATE marketing
SET SpendGroup = CASE
  WHEN AdSpend < 2000 THEN 'LowSpend'
  WHEN AdSpend >= 2000 AND AdSpend < 6000 THEN 'MediumSpend'
  ELSE 'HighSpend'
END;

-- View updated data
SELECT * FROM marketing LIMIT 10;

-- Conversion rate by SpendGroup
SELECT SpendGroup,
  COUNT(*) AS Total,
  SUM(CAST(Conversion AS UNSIGNED)) AS TotalConverted,
  ROUND(SUM(CAST(Conversion AS UNSIGNED)) * 100.0 / COUNT(*), 2) AS ConversionRate
FROM marketing
GROUP BY SpendGroup
ORDER BY ConversionRate DESC;

-- Engagement metrics and conversion rate
SELECT 
  AVG(PagesPerVisit) AS AvgPages,
  AVG(TimeOnSite) AS AvgTime,
  ROUND(SUM(CAST(Conversion AS UNSIGNED)) * 100.0 / COUNT(*), 2) AS AvgConversionRate
FROM marketing;


